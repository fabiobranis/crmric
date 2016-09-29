#include "TOTVS.CH"
#include "RESTFUL.CH"

/**
* Definições de constantes
*/

#define STR001 "Serviço de Contatos do CRM Ric [ERP Protheus]"
#define STR002 "Método de inclusão/Alteração"
#define STR003 "Método de exclusão"
#define STR004 "Método que retorna um contato pesquisado"

/*/{Protheus.doc} crmlogin
Classe Rest com os métodos relacionados ao serviço de login dos usuários do portal CRM
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

// método que grava e altera
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

		SetRestFault(401,"Informe a operação (incluir ou alterar)")
		return .F.
	endif

	if ::codusu == nil .or. ::token == nil
		SetRestFault(401,"Informe os parâmetros de autenticação")
		return .F.
	endif

	// define o tipo de retorno do método
	::SetContentType("application/json")

	// pego o conteúdo enviado
	cContent := ::GetContent()

	// instância da classe DAO usuário (model)
	oUser := ZADUserPortal():New(,::codusu)

	// instância da classe de negócios (model)
	oLogin := CRMLoginSite():New()

	// faço o login
	if !oLogin:valToken(oUser,::token)
		// se houver falha no logins
		SetRestFault(401,"Token Inválido")
		return .F.
	endif

	// verifico se a sessão não expirou
	if !oLogin:valSession(oUser)
		SetRestFault(401,"Sessão expirada")
		return .F.
	endif

	if !oLogin:valEmpFil(oUser)
		SetRestFault(401,"Empresa/Filial inválida para a sessão ativa")
		return .F.
	endif

	oContatoBus := CRMContatoSite():New()

	// transformo em objeto
	if !FwJsonDeserialize(cContent,@oJson)
		// se não chegaram os parâmetros
		SetRestFault(401, "Erro interno")
		return .F.
	endif

	do case
		case alltrim(::aURLParms[1]) == "incluir"

			if AttIsMemberOf(oJson:contato,"codcont")
				SetRestFault(401, "Atributo codcont não deve ser enviado numa inclusão")
				return .F.
			endif
			cCodCont := nil
			cOper := "Incluído"
			case alltrim(::aURLParms[1]) == "alterar"
	
			if AttIsMemberOf(oJson:contato,"codcont")
				cCodCont := oJson:contato:codcont
			else
				SetRestFault(401, "Defina o atributo codcont para alteração")
				return .F.
			endif
			cOper := "Alterado"
			lAltera := .T.
		case alltrim(::aURLParms[1]) == "excluir"

			if AttIsMemberOf(oJson,"codcont")
				cCodCont := oJson:codcont
			else
				SetRestFault(401, "Defina o atributo codcont para exclusão")
				return .F.
			endif
			cOper := "Excluído"
		otherwise
			SetRestFault(401,"Operação inválida")
			return .F.
	endcase

	oVend := SA3Vendedor():New(oUser:iderp)

	oContato := SU5Contatos():New(cCodCont)

	if alltrim(::aURLParms[1]) == "alterar" .or. alltrim(::aURLParms[1]) == "incluir"

		oContatoBus:setCabFromJson(oJson:contato,@oContato)

		// valido o conteúdo enviado
		if !(oContatoBus:valJson(cContent,oContato))
			SetRestFault(401,oContatoBus:erroAuto)
			return .F.
		endif

		// valido o cabeçalho do contato
		if !oContatoBus:valCabec(oContato)
			SetRestFault(401, oContatoBus:erroAuto)
			return .F.
		endif

		// processamento do endereço do contato
		if AttIsMemberOf(oJson,"endcont")
			// valido se é array
			if valtype(oJson:endcont) == "A"

				// percorro o conteúdo do array do json
				for ni := 1 to len(oJson:endcont)
					
					cCodAux := ""
					// verifico se existe o atributo código e se é alteração
					if AttIsMemberOf(oJson:endcont[ni],"codigo") .and. lAltera
						cCodAux := oJson:endcont[ni]:codigo
					endif
					
					// crio a instância da classe
					oEndCont := AGAEnderecos():new(cCodCont,cCodAux)

					// verifico se é exclusão
					if AttIsMemberOf(oJson:endcont[ni],"deleta") .and. lAltera
						if valtype(oJson:endcont[ni]:deleta) <> "L"
							SetRestFault(401, "Atributo deleta deve ser lógico. Verificar documentação W3C para maiores detalhes.")
							return .F.
						endif
						oEndCont:deleta := oJson:endcont[ni]:deleta
					endif

					// seto a partir do Json
					oContatoBus:setEndFromJson(oJson:endcont[ni],@oEndCont)

					// valido o endereço
					if !oContatoBus:valEnd(oEndCont,ni)
						SetRestFault(401, oContatoBus:erroAuto)
						return .F.
					endif

					// busco a posição na propriedade do contato, se existir eu altero senão incluo um novo
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
			
			// valido se é array
			if valtype(oJson:telcont) == "A"

				// percorro o array do json
				for ni := 1 to len(oJson:telcont)

					// verifico se tem o código e é alteração
					if AttIsMemberOf(oJson:telcont[ni],"codigo") .and. lAltera
						cCodAux := oJson:telcont[ni]:codigo
					endif

					// crio a instância da classe
					oTelCont := AGBTelefones():new(cCodCont,cCodAux)

					// verifico se é para deletar
					if AttIsMemberOf(oJson:telcont[ni],"deleta") .and. lAltera
						if valtype(oJson:telcont[ni]:deleta) <> "L"
							SetRestFault(401, "Atributo deleta deve ser lógico. Verificar documentação W3C para maiores detalhes.")
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

					// procuro pela posição no atributo do contato, se tiver eu altero, senão incluo
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
			SetRestFault(401, "Contato não econtrado")
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

// método que deleta
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

		SetRestFault(401,"Informe a operação (excluir)")
		return .F.
	endif

	if ::codusu == nil .or. ::token == nil
		SetRestFault(401,"Informe os parâmetros de autenticação")
		return .F.
	endif

	// define o tipo de retorno do método
	::SetContentType("application/json")

	// pego o conteúdo enviado
	cContent := ::GetContent()

	// instância da classe DAO usuário (model)
	oUser := ZADUserPortal():New(,::codusu)

	// instância da classe de negócios (model)
	oLogin := CRMLoginSite():New()

	// faço o login
	if !oLogin:valToken(oUser,::token)
		// se houver falha no logins
		SetRestFault(401,"Token Inválido")
		return .F.
	endif

	// verifico se a sessão não expirou
	if !oLogin:valSession(oUser)
		SetRestFault(401,"Sessão expirada")
		return .F.
	endif

	if !oLogin:valEmpFil(oUser)
		SetRestFault(401,"Empresa/Filial inválida para a sessão ativa")
		return .F.
	endif

	oContatoBus := CRMContatoSite():New()

	// transformo em objeto
	if !FwJsonDeserialize(cContent,@oJson)
		// se não chegaram os parâmetros
		SetRestFault(401, "Erro interno")
		return .F.
	endif

	do case
		case alltrim(::aURLParms[1]) == "excluir"

		if AttIsMemberOf(oJson,"codcont")
			cCodCont := oJson:codcont
		else
			SetRestFault(401, "Defina o atributo codcont para exclusão")
			return .F.
		endif

		otherwise
		SetRestFault(401,"Operação inválida")
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
		SetRestFault(401, "Contato não econtrado")
		return .F.
	endif

	if !oContatoBus:delReg(oContato)
		SetRestFault(401, oContatoBus:erroAuto)
		return .F.
	endif

	cResp := '{"status": 200, "body" : {"message": "Contato excluído com sucesso"} }'

	// defino a resposta
	::SetResponse(cResp)

return .T.

// método que retorna o prospect
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

		SetRestFault(401,"Informe a operação (visualizar)")
		return .F.
	endif

	if ::codusu == nil .or. ::token == nil
		SetRestFault(401,"Informe os parâmetros de autenticação")
		return .F.
	endif

	// define o tipo de retorno do método
	::SetContentType("application/json")

	// pego o conteúdo enviado
	cContent := ::GetContent()

	// instância da classe DAO usuário (model)
	oUser := ZADUserPortal():New(,::codusu)

	// instância da classe de negócios (model)
	oLogin := CRMLoginSite():New()

	// faço o login
	if !oLogin:valToken(oUser,::token)
		// se houver falha no logins
		SetRestFault(401,oLogin:erroAuto)
		return .F.
	endif

	// verifico se a sessão não expirou
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

		// valido os atributos para exclusão - chaves de busca
		if empty(::codcont)
			SetRestFault(401, "Atributo codcont é mandatório")
			return .F.
		endif

		otherwise
		SetRestFault(401,"Operação inválida")
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
		SetRestFault(401, "Contato não econtrado")
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