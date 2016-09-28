#include "TOTVS.CH"
#include "RESTFUL.CH"

/**
* Defini��es de constantes
*/

#define STR001 "Servi�o de Prospects do CRM Ric [ERP Protheus]"
#define STR002 "M�todo de inclus�o, altera��o e exclus�o"
#define STR004 "M�todo que retorna um prospect pesquisado"

/*/{Protheus.doc} crmlogin
Classe Rest com os m�todos relacionados ao servi�o de login dos usu�rios do portal CRM
@author fabiobranis
@since 21/04/2016
@version 1.0
/*/
wsrestful crmprospect description STR001

wsdata codusu as string
wsdata token as string
wsdata cod as string
wsdata loja as string

wsmethod post description STR002 wssyntax "/crmprospect/{option}"
wsmethod get description STR004 wssyntax "/crmprospect/{option}"

end wsrestful

// m�todo que grava e altera
wsmethod post wsreceive codusu, token wsservice crmprospect

	Local cContent	:= ""
	Local oJson		:= nil
	Local oUser		:= nil
	Local oLogin	:= nil
	Local oVend		:= nil
	Local oProspect	:= nil
	Local oProspectBus	:= nil
	Local cResp		:= ""
	Local cOper		:= ""
	Local cCodPros	:= nil
	Local cLojPros	:= nil
	
	if len(::aURLParms) == 0
		
		SetRestFault(401,"Informe a opera��o (incluir ou alterar)")
		return .F.
	endif
	
	if ::codusu == nil .or. ::token == nil
		SetRestFault(401,"Informe os par�metros de autentica��o")
		return .F.
	endif
	
	// define o tipo de retorno do m�todo
	::SetContentType("application/json")

	// pego o conte�do enviado
	cContent := ::GetContent()
	
	// inst�ncia da classe DAO usu�rio (model)
	oUser := ZADUserPortal():New(,::codusu)

	// inst�ncia da classe de neg�cios (model)
	oLogin := CRMLoginSite():New()

	// fa�o o login
	if !oLogin:valToken(oUser,::token)
		// se houver falha no logins
		SetRestFault(401,"Token Inv�lido")
		return .F.
	endif
	
	// verifico se a sess�o n�o expirou
	if !oLogin:valSession(oUser)
		SetRestFault(401,"Sess�o expirada")
		return .F.
	endif
	
	if !oLogin:valEmpFil(oUser)
		SetRestFault(401,"Empresa/Filial inv�lida para a sess�o ativa")
		return .F.
	endif
	
	oProspectBus := CRMProspectSite():New()
	
	// transformo em objeto
	if !FwJsonDeserialize(cContent,@oJson)
		// se n�o chegaram os par�metros
		SetRestFault(401, "Erro interno")
		return .F.
	endif
	
	do case
	case alltrim(::aURLParms[1]) == "incluir"
		
		if AttIsMemberOf(oJson,"cod")
			SetRestFault(401, "Atributo cod n�o deve ser enviado numa inclus�o")
			return .F.
		endif
		
		if AttIsMemberOf(oJson,"loja")
			SetRestFault(401, "Atributo loja n�o deve ser enviado numa inclus�o")
			return .F.
		endif
		cOper := "Inclu�do"
	case alltrim(::aURLParms[1]) == "alterar"
		
		if AttIsMemberOf(oJson,"cod")
			cCodPros := oJson:cod
		else
			SetRestFault(401, "Defina o atributo cod para altera��o")
			return .F.
		endif
		
		if AttIsMemberOf(oJson,"loja")
			cLojPros := oJson:loja
		else
			SetRestFault(401, "Defina o atributo loja para altera��o")
			return .F.
		endif
		cOper := "Alterado"
	case alltrim(::aURLParms[1]) == "excluir"
		
		if AttIsMemberOf(oJson,"cod")
			cCodPros := oJson:cod
		else
			SetRestFault(401, "Defina o atributo cod para exclus�o")
			return .F.
		endif
		
		if AttIsMemberOf(oJson,"loja")
			cLojPros := oJson:loja
		else
			SetRestFault(401, "Defina o atributo loja para exclus�o")
			return .F.
		endif	
		cOper := "Exclu�do"
	otherwise
		SetRestFault(401,"Opera��o inv�lida")
		return .F.
	endcase
	
	
	oVend := SA3Vendedor():New(oUser:iderp)
	
	oProspect := SUSProspectsPortal():New(cCodPros,cLojPros)
	
	if alltrim(::aURLParms[1]) != "excluir"
		// valido o conte�do enviado
		if !(oProspectBus:valJson(cContent,oProspect))
			SetRestFault(401,oProspectBus:erroAuto)
			return .F.
		endif
		
		oProspectBus:setFromJson(oJson,@oProspect)
		
		if !oProspectBus:valProsp(oProspect)
			SetRestFault(401, oProspectBus:erroAuto)
			return .F.
		endif
	endif
	
	if alltrim(::aURLParms[1]) == "alterar" .or. alltrim(::aURLParms[1]) == "excluir"
		// verifico se o prospect existe na base de dados
		if oProspectBus:isInclui(oProspect)
			SetRestFault(401, "Prospect n�o econtrado")
			return .F.
		endif
	endif
	
	if alltrim(::aURLParms[1]) == "excluir"
		if !oProspectBus:delReg(oProspect)
			SetRestFault(401, oProspectBus:erroAuto)
			return .F.
		endif
	else
		if !oProspectBus:save(oProspect)
			SetRestFault(401, oProspectBus:erroAuto)
			return .F.
		endif
	endif
	cResp := '{"status": 200, "body" : { "message": "Prospect '+cOper+' com sucesso", "cod" : "'+oProspect:cod+'" , "loja" : "'+oProspect:loja+'" }}'
	
	// alimento o log de opera��es
	LogCRM(oUser:iderp,::aURLParms[1],oProspect:cod)
	
	// defino a resposta
	::SetResponse(cResp)

return .T.

// m�todo que deleta
/*
wsmethod delete wsreceive codusu, token wsservice crmprospect

	Local cContent	:= ""
	Local oJson		:= nil
	Local oUser		:= nil
	Local oLogin	:= nil
	Local oVend		:= nil
	Local oProspect	:= nil
	Local oProspectBus	:= nil
	Local cResp		:= ""
	
	if len(::aURLParms) == 0
		
		SetRestFault(401,"Informe a opera��o (excluir)")
		return .F.
	endif
	
	if ::codusu == nil .or. ::token == nil
		SetRestFault(401,"Informe os par�metros de autentica��o")
		return .F.
	endif
	
	// define o tipo de retorno do m�todo
	::SetContentType("application/json")

	// pego o conte�do enviado
	cContent := ::GetContent()
	
	// inst�ncia da classe DAO usu�rio (model)
	oUser := ZADUserPortal():New(,::codusu)

	// inst�ncia da classe de neg�cios (model)
	oLogin := CRMLoginSite():New()

	// fa�o o login
	if !oLogin:valToken(oUser,::token)
		// se houver falha no logins
		SetRestFault(401,"Token Inv�lido")
		return .F.
	endif
	
	// verifico se a sess�o n�o expirou
	if !oLogin:valSession(oUser)
		SetRestFault(401,"Sess�o expirada")
		return .F.
	endif
	
	if !oLogin:valEmpFil(oUser)
		SetRestFault(401,"Empresa/Filial inv�lida para a sess�o ativa")
		return .F.
	endif
	
	oProspectBus := CRMProspectSite():New()
	
	// transformo em objeto
	if !FwJsonDeserialize(cContent,@oJson)
		// se n�o chegaram os par�metros
		SetRestFault(401, "Erro interno")
		return .F.
	endif
	
	do case
	case alltrim(::aURLParms[1]) == "excluir"
		
		if AttIsMemberOf(oJson,"cod")
			cCodPros := oJson:cod
		else
			SetRestFault(401, "Defina o atributo cod para exclus�o")
			return .F.
		endif
		
		if AttIsMemberOf(oJson,"loja")
			cLojPros := oJson:loja
		else
			SetRestFault(401, "Defina o atributo loja para exclus�o")
			return .F.
		endif
		
	otherwise
		SetRestFault(401,"Opera��o inv�lida")
		return .F.
	endcase
	
	oVend := SA3Vendedor():New(oUser:iderp)
		
	oProspect := SUSProspectsPortal():New(oJson:cod,oJson:loja)
	
	// verifico se o prospect existe na base de dados
	if oProspectBus:isInclui(oProspect)
		SetRestFault(401, "Prospect n�o econtrado")
		return .F.
	endif
	
	if !oProspectBus:delReg(oProspect)
		SetRestFault(401, oProspectBus:erroAuto)
		return .F.
	endif
	
	cResp := '{"status": 200, "body" : {"message": "Prospect exclu�do com sucesso"} }'
	
	// defino a resposta
	::SetResponse(cResp)

return .T.
*/
// m�todo que retorna o prospect
wsmethod get wsreceive codusu, token, cod, loja wsservice crmprospect

	Local cContent	:= ""
	Local oJson		:= nil
	Local oUser		:= nil
	Local oLogin	:= nil
	Local oVend		:= nil
	Local oProspect	:= nil
	Local oProspectBus	:= nil
	Local cResp		:= ""
	Local cOper		:= ""
	Local aArrayForm	:= {"prospect"}
	Local aObjArr		:= {}
	Local aAttrClass	:= {}
	Local ni			:= 0
	
	if len(::aURLParms) == 0
		
		SetRestFault(401,"Informe a opera��o (visualizar)")
		return .F.
	endif
	
	if ::codusu == nil .or. ::token == nil
		SetRestFault(401,"Informe os par�metros de autentica��o")
		return .F.
	endif
	
	// define o tipo de retorno do m�todo
	::SetContentType("application/json")

	// pego o conte�do enviado
	cContent := ::GetContent()
	
	// inst�ncia da classe DAO usu�rio (model)
	oUser := ZADUserPortal():New(,::codusu)

	// inst�ncia da classe de neg�cios (model)
	oLogin := CRMLoginSite():New()

	// fa�o o login
	if !oLogin:valToken(oUser,::token)
		// se houver falha no logins
		SetRestFault(401,oLogin:erroAuto)
		return .F.
	endif
	
	// verifico se a sess�o n�o expirou
	if !oLogin:valSession(oUser)
		SetRestFault(401,oLogin:erroAuto)
		return .F.
	endif
	
	if !oLogin:valEmpFil(oUser)
		SetRestFault(401,oLogin:erroAuto)
		return .F.
	endif
	
	oProspectBus := CRMProspectSite():New()
	
	oVend := SA3Vendedor():New(oUser:iderp)
	
	do case
	case alltrim(::aURLParms[1]) == "visualizar"
		
		// valido os atributos para exclus�o - chaves de busca
		if empty(::cod)
			SetRestFault(401, "Atributo cod � mandat�rio")
			return .F.
		endif
		
		if empty(::loja)
			SetRestFault(401, "Atributo loja � mandat�rio")
			return .F.
		endif
		
	otherwise
		SetRestFault(401,"Opera��o inv�lida")
		return .F.
	endcase
	
	oProspect := SUSProspectsPortal():New(::cod,::loja)
	
	aObjArr := ClassDataArr(oProspect)
	aAttrClass := {}
	for ni := 1 to len(aObjArr)
		aadd(aAttrClass,lower(aObjArr[ni][1]))
	next
	oProspectBus:attr := aAttrClass
	// verifico se o prospect existe na base de dados
	if oProspectBus:isInclui(oProspect)
		SetRestFault(401, "Prospect n�o econtrado")
		return .F.
	endif
	
	oResp := CRMResp():New(200,oProspectBus:attr,aArrayForm) 
	oResp:addBody(aArrayForm[1],oProspect)
	//oResp:addProperties(oProspectBus:attr)
	
	cResp := oResp:toJson()
	
	// defino a resposta
	::SetResponse(cResp)

return .T.

static function LogCRM(cCodUser,cOpera,cCodInc)
	
	local aDataInc	:= {}
	local cOperRot	:= iif(cOpera == "incluir","I",iif(cOpera == "alterar","A","E"))
	
	aadd(aDataInc,{"ZAF_ROTINA","CRMPROSPECT"})
	aadd(aDataInc,{"ZAF_USERID",cCodUser})
	aadd(aDataInc,{"ZAF_UNAME",UsrRetName(cCodUser)})
	aadd(aDataInc,{"ZAF_DATA",dDataBase})
	aadd(aDataInc,{"ZAF_ENTIDA","SUS"})
	aadd(aDataInc,{"ZAF_CODIGO",cCodInc})
	aadd(aDataInc,{"ZAF_OPERA",cOperRot})
	
	U_R73A3INC(aDataInc)
	
return