#include "TOTVS.CH"
#include "RESTFUL.CH"

/**
* Defini��es de constantes
*/

#define STR001 "Servi�o de Clientes do CRM Ric [ERP Protheus]"
#define STR004 "M�todo que retorna um cliente pesquisado"
#define STR005 "M�todo de inclus�o, altera��o, exclus�o, transforma um prospect em cliente e vincula contatos ao cliente"

/*/{Protheus.doc} crmlogin
Classe Rest com os m�todos relacionados ao servi�o de login dos usu�rios do portal CRM
@author fabiobranis
@since 21/04/2016
@version 1.0
/*/
wsrestful crmcliente description STR001

wsdata codusu as string
wsdata token as string
wsdata cod as string
wsdata loja as string

wsmethod get description STR004 wssyntax "/crmcliente/{option}"
wsmethod post description STR005 wssyntax "/crmcliente/{option}"

end wsrestful

// m�todo que retorna o prospect
wsmethod get wsreceive codusu, token, cod, loja wsservice crmcliente

	Local cContent	:= ""
	Local oJson		:= nil
	Local oUser		:= nil
	Local oLogin	:= nil
	Local oVend		:= nil
	Local oCli	:= nil
	Local oClienteBus	:= nil
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

	oClienteBus := CRMClienteSite():New()

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

	oCli := SA1Clientes():New(::cod,::loja)

	aObjArr := ClassDataArr(oCli)
	aAttrClass := {}
	for ni := 1 to len(aObjArr)
		aadd(aAttrClass,lower(aObjArr[ni][1]))
	next
	oClienteBus:attr := aAttrClass
	// verifico se o prospect existe na base de dados
	if oClienteBus:isInclui(oCli)
		SetRestFault(401, "Cliente n�o econtrado")
		return .F.
	endif

	oResp := CRMResp():New(200,oClienteBus:attr,aArrayForm) 
	oResp:addBody(aArrayForm[1],oCli)
	//oResp:addProperties(oClienteBus:attr)

	cResp := oResp:toJson()

	// defino a resposta
	::SetResponse(cResp)

return .T.

// m�todo que deleta
wsmethod post wsreceive codusu, token wsservice crmcliente

	Local cContent	:= ""
	Local oJson		:= nil
	Local oUser		:= nil
	Local oLogin	:= nil
	Local oVend		:= nil
	Local oCli		:= nil
	Local oProspect	:= nil
	Local oContato	:= nil
	Local oClienteBus	:= nil
	Local oProspectBus	:= nil
	Local oContatBus	:= nil
	Local oContSU5		:= nil
	Local cResp		:= ""
	Local cOper		:= ""
	Local cCodCli	:= nil
	Local cLojCli	:= nil
	Local ni		:= 0

	if len(::aURLParms) == 0

		SetRestFault(401,"Informe a opera��o (prosptocli ou vinccontato)")
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



	// transformo em objeto
	if !FwJsonDeserialize(cContent,@oJson)
		// se n�o chegaram os par�metros
		SetRestFault(401, "Erro interno")
		return .F.
	endif

	oVend := SA3Vendedor():New(oUser:iderp)
	oClienteBus := CRMClienteSite():New()

	do case
	case alltrim(::aURLParms[1]) == "prosptocli"
	
		// valido os atributos para exclus�o - chaves de busca
		if !AttIsMemberOf(oJson,"codprosp")
			SetRestFault(401, "Atributo codprosp � mandat�rio")
			return .F.
		endif

		if !AttIsMemberOf(oJson,"lojaprosp")
			SetRestFault(401, "Atributo lojaprosp � mandat�rio")
			return .F.
		endif

		oProspectBus := CRMProspectSite():New()
		oCli := SA1Clientes():New()
		oProspect := SUSProspectsPortal():New(oJson:codprosp,oJson:lojaprosp)

		// verifico se o prospect existe na base de dados
		if oProspectBus:isInclui(oProspect)
			SetRestFault(401, "Prospect n�o econtrado")
			return .F.
		endif

		// verifico se o prospect existe na base de dados
		if oProspectBus:isCliente(oProspect)
			SetRestFault(401, "Prospect j� � cliente")
			return .F.
		endif

		oClienteBus:setFromProsp(oProspect,oJson,@oCli)

		if !oClienteBus:valCli(oCli)
			SetRestFault(401, oClienteBus:erroAuto)
			return .F.
		endif

		if !oClienteBus:save(oCli)
			SetRestFault(401, oClienteBus:erroAuto)
			return .F.
		endif

		oProspectBus:vincCli(oProspect,oCli)
		cOper := "Prospect vinclulado ao cliente " + oCli:cod + " - " + oCli:loja
		LogCRM(oUser:iderp,::aURLParms[1],oCli:cod)
	case alltrim(::aURLParms[1]) == "vinccontato" .or. alltrim(::aURLParms[1]) == "remcontato"
		
		if !AttIsMemberOf(oJson,"cliente")
			SetRestFault(401, "Objeto cliente � obrigat�rio para esta opera��o")
			return .F.
		endif
		
		if !AttIsMemberOf(oJson:cliente,"cod")
			SetRestFault(401, "Atributo cod do objeto cliente � obrigat�rio para esta opera��o")
			return .F.
		endif

		if !AttIsMemberOf(oJson:cliente,"loja")
			SetRestFault(401, "Atributo loja do objeto cliente � obrigat�rio para esta opera��o")
			return .F.
		endif
		
		if !AttIsMemberOf(oJson,"contatos")
			SetRestFault(401, "Objeto contatos � obrigat�rio para esta opera��o")
			return .F.
		endif
		
		if valtype(oJson:contatos) <> "A"
			SetRestFault(401, "Objeto contatos deve ser um array")
			return .F.
		endif
		
		oContatBus := CRMContatoSite():New()
		// aqui eu valido os contatos enviados
		for ni := 1 to len(oJson:contatos)
			
			if !AttIsMemberOf(oJson:contatos[ni],"codcon")
				SetRestFault(401, "Atributo codcon � obrigat�rio em todos os objetos do array de contatos")
				return .F.
			endif
			
			oContSU5 := nil
			oContSU5 := SU5Contatos():New(oJson:contatos[ni]:codcon)
			
			if oContatBus:isInclui(oContSU5)
				SetRestFault(401, "Todos os contatos da lista de contatos devem estar na base de dados")
				return .F.
			endif
			
			if alltrim(::aURLParms[1]) == "vinccontato"
			 	if !oContatBus:valVinculo(oContSU5)
					SetRestFault(401, oContatBus:erroAuto)
					return .F.
				endif
			endif
			
		next
		
		oCli := SA1Clientes():New(oJson:cliente:cod,oJson:cliente:loja)
		
		if oClienteBus:isInclui(oCli)
			SetRestFault(401, "Cliente n�o existe na base de dados")
			return .F.
		endif
	
		// aqui eu valido os contatos enviados
		for ni := 1 to len(oJson:contatos)
			
			oContato := nil
			oContato := AC8ContCli():New(oJson:cliente:cod + space(1) + oJson:cliente:loja,oJson:contatos[ni]:codcon)
			
			if alltrim(::aURLParms[1]) == "vinccontato"
				oContato:save()
				cOper := "Contatos vinculados ao cliente com sucesso"
			elseif alltrim(::aURLParms[1]) == "remcontato"
				oContato:delReg()
				cOper := "Contatos desvinculados do cliente com sucesso"
			endif
			if !(empty(cOper))
				LogCRM(oUser:iderp,::aURLParms[1],oCli:cod)
			endif
		next
		
	case alltrim(::aURLParms[1]) == "incluir"
		if AttIsMemberOf(oJson,"cod")
			SetRestFault(401, "Atributo cod n�o deve ser enviado numa inclus�o")
			return .F.
		endif

		if AttIsMemberOf(oJson,"loja")
			SetRestFault(401, "Atributo loja n�o deve ser enviado numa inclus�o")
			return .F.
		endif
		cOper := "Cliente inclu�do com sucesso"
	case alltrim(::aURLParms[1]) == "alterar"
		if AttIsMemberOf(oJson,"cod")
			cCodCli := oJson:cod
		else
			SetRestFault(401, "Defina o atributo cod para altera��o")
			return .F.
		endif

		if AttIsMemberOf(oJson,"loja")
			cLojCli := oJson:loja
		else
			SetRestFault(401, "Defina o atributo loja para altera��o")
			return .F.
		endif
		cOper := "Cliente alterado com sucesso"
	case alltrim(::aURLParms[1]) == "excluir"
		if AttIsMemberOf(oJson,"cod")
			cCodCli := oJson:cod
		else
			SetRestFault(401, "Defina o atributo cod para exclus�o")
			return .F.
		endif

		if AttIsMemberOf(oJson,"loja")
			cLojCli := oJson:loja
		else
			SetRestFault(401, "Defina o atributo loja para exclus�o")
			return .F.
		endif
		cOper := "Cliente exclu�do com sucesso"
	otherwise
		SetRestFault(401,"Opera��o inv�lida")
		return .F.
	endcase
	
	oCli := SA1Clientes():New(cCodCli,cLojCli)
	
	if alltrim(::aURLParms[1]) == "incluir" .or. alltrim(::aURLParms[1]) == "alterar" 
		// valido o conte�do enviado
		if !(oClienteBus:valJson(cContent,oCli))
			SetRestFault(401,oClienteBus:erroAuto)
			return .F.
		endif
		
		oClienteBus:setFromJson(oJson,@oCli)
	
		if !oClienteBus:valCli(oCli)
			SetRestFault(401, oClienteBus:erroAuto)
			return .F.
		endif
	endif
	
	if alltrim(::aURLParms[1]) == "alterar" .or. alltrim(::aURLParms[1]) == "excluir"
		// verifico se o prospect existe na base de dados
		if oClienteBus:isInclui(oCli)
			SetRestFault(401, "Cliente n�o econtrado")
			return .F.
		endif
	endif
	
	if alltrim(::aURLParms[1]) == "excluir"
		if !oClienteBus:delReg(oCli)
			SetRestFault(401, oClienteBus:erroAuto)
			return .F.
		endif
		LogCRM(oUser:iderp,::aURLParms[1],oCli:cod)
	endif
	
	if alltrim(::aURLParms[1]) == "incluir" .or. alltrim(::aURLParms[1]) == "alterar"
		if !oClienteBus:save(oCli)
			SetRestFault(401, oClienteBus:erroAuto)
			return .F.
		endif
		LogCRM(oUser:iderp,::aURLParms[1],oCli:cod)
	endif
	
	cResp := '{"status": 200, "body" : {"message": "' + cOper + '"} }'
	
	// defino a resposta
	::SetResponse(cResp)

return .T.

static function LogCRM(cCodUser,cOpera,cCodCli)
	
	local aDataInc	:= {}
	local cOperRot	:= iif(cOpera == "incluir","I",iif(cOpera == "alterar","A",iif(cOpera == "vinccontato","V",iif(cOpera == "remcontato","R",iif(cOpera == "prosptocli","P","E")))))
	
	aadd(aDataInc,{"ZAF_ROTINA","CRMCLIENTE"})
	aadd(aDataInc,{"ZAF_USERID",cCodUser})
	aadd(aDataInc,{"ZAF_UNAME",UsrRetName(cCodUser)})
	aadd(aDataInc,{"ZAF_DATA",dDataBase})
	aadd(aDataInc,{"ZAF_ENTIDA","SA1"})
	aadd(aDataInc,{"ZAF_CODIGO",cCodCli})
	aadd(aDataInc,{"ZAF_OPERA",cOperRot})
	
	U_R73A3INC(aDataInc)
	
return