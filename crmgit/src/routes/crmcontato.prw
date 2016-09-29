#include "TOTVS.CH"
#include "RESTFUL.CH"

/**
* Defini��es de constantes
*/

#define STR001 "Servi�o de Contatos do CRM Ric [ERP Protheus]"
#define STR002 "M�todo de inclus�o/Altera��o"
#define STR003 "M�todo de exclus�o"
#define STR004 "M�todo que retorna um contato pesquisado"

/*/{Protheus.doc} crmlogin
Classe Rest com os m�todos relacionados ao servi�o de login dos usu�rios do portal CRM
@author fabiobranis
@since 21/04/2016
@version 1.0
/*/
wsrestful crmcontato description STR001

wsdata codusu as string
wsdata token as string
wsdata codcont as string

wsmethod post description STR002 wssyntax "/crmcontato/{option}"
wsmethod delete description STR003 wssyntax "/crmcontato/{option}"
wsmethod get description STR004 wssyntax "/crmcontato/{option}"

end wsrestful

// m�todo que grava e altera
wsmethod post wsreceive codusu, token wsservice crmcontato

	Local cContent	:= ""
	Local oJson		:= nil
	Local oUser		:= nil
	Local oLogin	:= nil
	Local oVend		:= nil
	Local oContato	:= nil
	Local oContatoBus	:= nil
	Local oEndCont	:= nil
	Local oTelCont	:= nil
	Local cResp		:= ""
	Local cOper		:= ""
	Local cCodCont	:= nil
	Local ni		:= 0
	Local lAltera	:= .F.
	Local nPosAux	:= 0
	Local cCodAux	:= nil

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

	oContatoBus := CRMContatoSite():New()

	// transformo em objeto
	if !FwJsonDeserialize(cContent,@oJson)
		// se n�o chegaram os par�metros
		SetRestFault(401, "Erro interno")
		return .F.
	endif

	do case
		case alltrim(::aURLParms[1]) == "incluir"

			if AttIsMemberOf(oJson:contato,"codcont")
				SetRestFault(401, "Atributo codcont n�o deve ser enviado numa inclus�o")
				return .F.
			endif
			cCodCont := nil
			cOper := "Inclu�do"
			case alltrim(::aURLParms[1]) == "alterar"
	
			if AttIsMemberOf(oJson:contato,"codcont")
				cCodCont := oJson:contato:codcont
			else
				SetRestFault(401, "Defina o atributo codcont para altera��o")
				return .F.
			endif
			cOper := "Alterado"
			lAltera := .T.
		case alltrim(::aURLParms[1]) == "excluir"

			if AttIsMemberOf(oJson,"codcont")
				cCodCont := oJson:codcont
			else
				SetRestFault(401, "Defina o atributo codcont para exclus�o")
				return .F.
			endif
			cOper := "Exclu�do"
		otherwise
			SetRestFault(401,"Opera��o inv�lida")
			return .F.
	endcase

	oVend := SA3Vendedor():New(oUser:iderp)

	oContato := SU5Contatos():New(cCodCont)

	if alltrim(::aURLParms[1]) == "alterar" .or. alltrim(::aURLParms[1]) == "incluir"

		oContatoBus:setCabFromJson(oJson:contato,@oContato)

		// valido o conte�do enviado
		if !(oContatoBus:valJson(cContent,oContato))
			SetRestFault(401,oContatoBus:erroAuto)
			return .F.
		endif

		// valido o cabe�alho do contato
		if !oContatoBus:valCabec(oContato)
			SetRestFault(401, oContatoBus:erroAuto)
			return .F.
		endif

		// processamento do endere�o do contato
		if AttIsMemberOf(oJson,"endcont")
			// valido se � array
			if valtype(oJson:endcont) == "A"

				// percorro o conte�do do array do json
				for ni := 1 to len(oJson:endcont)
					
					cCodAux := ""
					// verifico se existe o atributo c�digo e se � altera��o
					if AttIsMemberOf(oJson:endcont[ni],"codigo") .and. lAltera
						cCodAux := oJson:endcont[ni]:codigo
					endif
					
					// crio a inst�ncia da classe
					oEndCont := AGAEnderecos():new(cCodCont,cCodAux)

					// verifico se � exclus�o
					if AttIsMemberOf(oJson:endcont[ni],"deleta") .and. lAltera
						if valtype(oJson:endcont[ni]:deleta) <> "L"
							SetRestFault(401, "Atributo deleta deve ser l�gico. Verificar documenta��o W3C para maiores detalhes.")
							return .F.
						endif
						oEndCont:deleta := oJson:endcont[ni]:deleta
					endif

					// seto a partir do Json
					oContatoBus:setEndFromJson(oJson:endcont[ni],@oEndCont)

					// valido o endere�o
					if !oContatoBus:valEnd(oEndCont,ni)
						SetRestFault(401, oContatoBus:erroAuto)
						return .F.
					endif

					// busco a posi��o na propriedade do contato, se existir eu altero sen�o incluo um novo
					nPosAux := oContato:getEndPos(oEndCont:codigo,oEndCont:entida,oEndCont:codent,oEndCont:tipo)
					if nPosAux > 0
						oContato:altEndByPos(nPosAux,oEndCont)
					else
						oContato:aaddEndCont(oEndCont)
					endif
				next
			endif
		endif

		// processamento da aba telefones
		if AttIsMemberOf(oJson,"telcont")
			
			cCodAux := ""
			
			// valido se � array
			if valtype(oJson:telcont) == "A"

				// percorro o array do json
				for ni := 1 to len(oJson:telcont)

					// verifico se tem o c�digo e � altera��o
					if AttIsMemberOf(oJson:telcont[ni],"codigo") .and. lAltera
						cCodAux := oJson:telcont[ni]:codigo
					endif

					// crio a inst�ncia da classe
					oTelCont := AGBTelefones():new(cCodCont,cCodAux)

					// verifico se � para deletar
					if AttIsMemberOf(oJson:telcont[ni],"deleta") .and. lAltera
						if valtype(oJson:telcont[ni]:deleta) <> "L"
							SetRestFault(401, "Atributo deleta deve ser l�gico. Verificar documenta��o W3C para maiores detalhes.")
							return .F.
						endif
						oTelCont:deleta := oJson:telcont[ni]:deleta
					endif

					// seto a partir do json
					oContatoBus:setTelFromJson(oJson:telcont[ni],@oTelCont)

					// valido o telefone
					if !oContatoBus:valTel(oTelCont,ni)
						SetRestFault(401, oContatoBus:erroAuto)
						return .F.
					endif

					// procuro pela posi��o no atributo do contato, se tiver eu altero, sen�o incluo
					nPosAux := oContato:getTelPos(oTelCont:codigo,oTelCont:entida,oTelCont:codent,oTelCont:tipo)
					if nPosAux > 0
						oContato:altTelByPos(nPosAux,oTelCont)
					else
						oContato:aaddTelCont(oTelCont)
					endif

				next
			endif
		endif

		// salvo o contato
		if !oContatoBus:save(oContato)
			SetRestFault(401, oContatoBus:erroAuto)
			return .F.
		endif
	else
		// verifico se o prospect existe na base de dados
		if oContatoBus:isInclui(oContato)
			SetRestFault(401, "Contato n�o econtrado")
			return .F.
		endif
		// valido antes de excluir
		if !(oContatoBus:valExclui(oContato))
			SetRestFault(401, oContatoBus:erroAuto)
			return .F.
		endif
		if !oContatoBus:delReg(oContato)
			SetRestFault(401, oContatoBus:erroAuto)
			return .F.
		endif
	endif

	cResp := '{"status": 200, "body" : { "message": "Contato '+cOper+' com sucesso"}}'
	LogCRM(oUser:iderp,::aURLParms[1])
	// defino a resposta
	::SetResponse(cResp)

return .T.

// m�todo que deleta
wsmethod delete wsreceive codusu, token wsservice crmcontato

	Local cContent	:= ""
	Local oJson		:= nil
	Local oUser		:= nil
	Local oLogin	:= nil
	Local oVend		:= nil
	Local oContato	:= nil
	Local oContatoBus	:= nil
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

	oContatoBus := CRMContatoSite():New()

	// transformo em objeto
	if !FwJsonDeserialize(cContent,@oJson)
		// se n�o chegaram os par�metros
		SetRestFault(401, "Erro interno")
		return .F.
	endif

	do case
		case alltrim(::aURLParms[1]) == "excluir"

		if AttIsMemberOf(oJson,"codcont")
			cCodCont := oJson:codcont
		else
			SetRestFault(401, "Defina o atributo codcont para exclus�o")
			return .F.
		endif

		otherwise
		SetRestFault(401,"Opera��o inv�lida")
		return .F.
	endcase

	oVend := SA3Vendedor():New(oUser:iderp)

	oContato := SU5Contatos():New(oJson:codcont)

	if !(oContatoBus:valExclui(oContato))
		SetRestFault(401, oContatoBus:erroAuto)
		return .F.
	endif

	// verifico se o prospect existe na base de dados
	if oContatoBus:isInclui(oContato)
		SetRestFault(401, "Contato n�o econtrado")
		return .F.
	endif

	if !oContatoBus:delReg(oContato)
		SetRestFault(401, oContatoBus:erroAuto)
		return .F.
	endif

	cResp := '{"status": 200, "body" : {"message": "Contato exclu�do com sucesso"} }'

	// defino a resposta
	::SetResponse(cResp)

return .T.

// m�todo que retorna o prospect
wsmethod get wsreceive codusu, token, codcont wsservice crmcontato

	Local cContent	:= ""
	Local oJson		:= nil
	Local oUser		:= nil
	Local oLogin	:= nil
	Local oVend		:= nil
	Local oContato	:= nil
	Local oContatoBus	:= nil
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

	oContatoBus := CRMContatoSite():New()

	oVend := SA3Vendedor():New(oUser:iderp)

	do case
		case alltrim(::aURLParms[1]) == "visualizar"

		// valido os atributos para exclus�o - chaves de busca
		if empty(::codcont)
			SetRestFault(401, "Atributo codcont � mandat�rio")
			return .F.
		endif

		otherwise
		SetRestFault(401,"Opera��o inv�lida")
		return .F.
	endcase

	oContato := SU5Contatos():New(::codcont)

	aObjArr := ClassDataArr(oContato)
	aAttrClass := {}
	for ni := 1 to len(aObjArr)
		aadd(aAttrClass,lower(aObjArr[ni][1]))
	next
	oContatoBus:attr := aAttrClass
	// verifico se o prospect existe na base de dados
	if oContatoBus:isInclui(oContato)
		SetRestFault(401, "Contato n�o econtrado")
		return .F.
	endif

	oResp := CRMResp():New(200,oContatoBus:attr,aArrayForm)
	oResp:addBody(aArrayForm[1],oContato)
	//oResp:addProperties(oContatoBus:attr)

	cResp := oResp:toJson()

	// defino a resposta
	::SetResponse(cResp)

return .T.

static function LogCRM(cCodUser,cOpera)
	
	local aDataInc	:= {}
	local cOperRot	:= iif(cOpera == "incluir","I",iif(cOpera == "alterar","A","E"))
	
	aadd(aDataInc,{"ZAF_ROTINA","CRMCONTATO"})
	aadd(aDataInc,{"ZAF_USERID",cCodUser})
	aadd(aDataInc,{"ZAF_UNAME",UsrRetName(cCodUser)})
	aadd(aDataInc,{"ZAF_DATA",dDataBase})
	aadd(aDataInc,{"ZAF_ENTIDA","SU5"})
	aadd(aDataInc,{"ZAF_CODIGO",SU5->U5_CODCONT})
	aadd(aDataInc,{"ZAF_OPERA",cOperRot})
	
	U_R73A3INC(aDataInc)
	
return