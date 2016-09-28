#include "TOTVS.CH"
#include "RESTFUL.CH"

/**
* Definições de constantes
*/

#define STR001 "Serviço de Propostas do CRM Ric [ERP Protheus]"
#define STR002 "Método de inclusão/Alteração"
#define STR003 "Método de exclusão"
#define STR004 "Método que retorna uma proposta pesquisada"

/*/{Protheus.doc} crmproposta
Classe Rest com os métodos relacionados ao serviço de login dos usuários do portal CRM
@author fabiobranis
@since 21/04/2016
@version 1.0
/*/
wsrestful crmproposta description STR001

wsdata codusu as string
wsdata token as string
wsdata propos as string

wsmethod post description STR002 wssyntax "/crmproposta/{option}"
wsmethod delete description STR003 wssyntax "/crmproposta/{option}"
wsmethod get description STR004 wssyntax "/crmproposta/{option}"

end wsrestful

// método que grava e altera
wsmethod post wsreceive codusu, token wsservice crmproposta

	Local cContent	:= ""
	Local oJson		:= nil
	Local oUser		:= nil
	Local oLogin	:= nil
	Local oVend		:= nil
	Local oProposta	:= nil
	Local oPropostaBus	:= nil
	Local oItem	:= nil
	Local oCalend	:= nil
	Local oFilProp	:= nil
	Local cResp		:= ""
	Local cOper		:= ""
	Local cPropos	:= nil
	Local ni		:= 0
	Local lAltera	:= .F.
	Local nPosAux	:= 0
	Local cCodAux	:= nil
	Local aFilItens	:= {}

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

	oPropostaBus := CRMPropostaSite():New()

	// transformo em objeto
	if !FwJsonDeserialize(cContent,@oJson)
		// se não chegaram os parâmetros
		SetRestFault(401, "Erro interno")
		return .F.
	endif

	do case
		case alltrim(::aURLParms[1]) == "incluir"

			if AttIsMemberOf(oJson:proposta,"propos")
				SetRestFault(401, "Atributo propos não deve ser enviado numa inclusão")
				return .F.
			endif
			cPropos := nil
			cOper := "Incluída"
		case alltrim(::aURLParms[1]) == "alterar"

			if AttIsMemberOf(oJson:proposta,"propos")
				cPropos := oJson:proposta:propos
			else
				SetRestFault(401, "Defina o atributo propos para alteração")
				return .F.
			endif
			cOper := "Alterada"
			lAltera := .T.
		case alltrim(::aURLParms[1]) == "excluir"

			if AttIsMemberOf(oJson,"propos")
				cPropos := oJson:propos
			else
				SetRestFault(401, "Defina o atributo propos para exclusão")
				return .F.
			endif
			cOper := "Excluída"
		otherwise
			SetRestFault(401,"Operação inválida")
			return .F.
	endcase

	oVend := SA3Vendedor():New(oUser:iderp)

	oProposta := ADYProposta():New(cPropos)

	if alltrim(::aURLParms[1]) == "alterar" .or. alltrim(::aURLParms[1]) == "incluir"

		oPropostaBus:setCabFromJson(oJson:proposta,@oProposta)

		// valido o conteúdo enviado
		if !(oPropostaBus:valJson(cContent,oProposta))
			SetRestFault(401,oPropostaBus:erroAuto)
			return .F.
		endif

		// valido o cabeçalho do contato
		if !oPropostaBus:valCabec(oProposta)
			SetRestFault(401, oPropostaBus:erroAuto)
			return .F.
		endif

		// processamento do endereço do contato
		if AttIsMemberOf(oJson,"item")
			// valido se é array
			if valtype(oJson:item) == "A"

				// percorro o conteúdo do array do json
				for ni := 1 to len(oJson:item)

					// verifico se existe o atributo código e se é alteração
					if AttIsMemberOf(oJson:item[ni],"item") .and. lAltera
						cCodAux := oJson:item[ni]:item
					else
						cPropos := oProposta:propos
						cCodAux := oJson:item[ni]:item
					endif

					// crio a instância da classe
					oItem := ADZItemProp():new(cPropos,cCodAux)

					// verifico se é exclusão
					if AttIsMemberOf(oJson:item[ni],"deleta") .and. lAltera
						oItem:deleta := oJson:item[ni]:deleta
					endif

					// seto a partir do Json
					oPropostaBus:setItemFromJson(oJson:item[ni],@oItem)

					// valido o endereço
					if !oPropostaBus:valItem(oItem,ni)
						SetRestFault(401, oPropostaBus:erroAuto)
						return .F.
					endif

					// busco a posição na propriedade do contato, se existir eu altero senão incluo um novo
					nPosAux := oProposta:getItemPos(oItem:item,oItem:propos)
					if nPosAux > 0
						oProposta:altItemByPos(nPosAux,oItem)
					else
						oProposta:aaddItemProp(oItem)
					endif
					
					if ascan(aFilItens,{|x|alltrim(x) == oItem:xfilpv}) == 0 .and. oItem:xfilpv <> cFilAnt
						aadd(aFilItens,oItem:xfilpv)
					endif
				next
			
			endif
			
			// filiais da proposta - Inclusão de registros na Inclusão ou alteração de propostas
			for ni := 1 to len(aFilItens)
				
				// se for a mesma filial - não vai para o objeto
				if aFilItens[ni] == cFilAnt
					loop
				endif
				// se no objeto proposta já houver a filial definida, eu ignoro
				if oProposta:getFilPos(oProposta:propos,aFilItens[ni]) == 0
					oFilProp := ZAEPropFilial():New(oProposta:propos,aFilItens[ni])
					oProposta:aaddFilProp(oFilProp)
				endif
			
			next
		endif

		// processamento da aba telefones
		if AttIsMemberOf(oJson,"calend")

			// valido se é array
			if valtype(oJson:calend) == "A"

				// percorro o array do json
				for ni := 1 to len(oJson:calend)

					// verifico se tem o código e é alteração
					if AttIsMemberOf(oJson:calend[ni],"itprop") .and. lAltera
						cCodAux := oJson:calend[ni]:itprop
					else
						cPropos := oProposta:propos
						cCodAux := oJson:calend[ni]:itprop
					endif

					// crio a instância da classe
					oCalend := ZAACalendario():new(cPropos,cCodAux,ctod(oJson:calend[ni]:dtexib))

					// verifico se é para deletar
					if AttIsMemberOf(oJson:calend[ni],"deleta") .and. lAltera
						oCalend:deleta := oJson:calend[ni]:deleta
					endif

					// seto a partir do json
					oPropostaBus:setCalendFromJson(oJson:calend[ni],@oCalend)

					// valido o telefone
					if !oPropostaBus:valCalend(oCalend,ni)
						SetRestFault(401, oPropostaBus:erroAuto)
						return .F.
					endif

					// procuro pela posição no atributo do contato, se tiver eu altero, senão incluo
					nPosAux := oProposta:getCalendPos(oCalend:dtexib,oCalend:itprop,oCalend:propos)
					if nPosAux > 0
						oProposta:altCaleByPos(nPosAux,oCalend)
					else
						oProposta:aaddCalendario(oCalend)
					endif

				next
			endif
		endif

		// salvo o contato
		if !oPropostaBus:save(oProposta)
			SetRestFault(401, oPropostaBus:erroAuto)
			return .F.
		endif
	else
		// verifico se o prospect existe na base de dados
		if oPropostaBus:isInclui(oProposta)
			SetRestFault(401, "Proposta não econtrada")
			return .F.
		endif

		if !oPropostaBus:delReg(oProposta)
			SetRestFault(401, oPropostaBus:erroAuto)
			return .F.
		endif
	endif

	cResp := '{"status": 200, "body" : { "message": "Proposta '+cOper+' com sucesso"}}'
	LogCRM(oUser:iderp,::aURLParms[1])
	// defino a resposta
	::SetResponse(cResp)

return .T.

// método que retorna o prospect
wsmethod get wsreceive codusu, token, propos wsservice crmproposta

	Local cContent	:= ""
	Local oJson		:= nil
	Local oUser		:= nil
	Local oLogin	:= nil
	Local oVend		:= nil
	Local oProposta	:= nil
	Local oPropostaBus	:= nil
	Local cResp		:= ""
	Local cOper		:= ""
	Local aArrayForm	:= {"proposta"}
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

	oPropostaBus := CRMPropostaSite():New()

	oVend := SA3Vendedor():New(oUser:iderp)

	do case
		case alltrim(::aURLParms[1]) == "visualizar"

			// valido os atributos para exclusão - chaves de busca
			if empty(::propos)
				SetRestFault(401, "Atributo propos é mandatório")
				return .F.
			endif
			oProposta := ADYProposta():New(::propos)
	
			aObjArr := ClassDataArr(oProposta)
			aAttrClass := {}
			for ni := 1 to len(aObjArr)
				aadd(aAttrClass,lower(aObjArr[ni][1]))
			next
			oPropostaBus:attr := aAttrClass
			// verifico se o prospect existe na base de dados
			if oPropostaBus:isInclui(oProposta)
				SetRestFault(401, "Proposta não econtrada")
				return .F.
			endif
		
			oResp := CRMResp():New(200,oPropostaBus:attr,aArrayForm)
			oResp:addBody(aArrayForm[1],oProposta)
			//oResp:addProperties(oPropostaBus:attr)
		
			cResp := oResp:toJson()
		
			// defino a resposta
			::SetResponse(cResp)
		
		case alltrim(::aURLParms[1]) == "contrato"
			
			oPropostaBus := nil
			oPropostaBus := CRMContratoSite():New()
			// valido os atributos para exclusão - chaves de busca
			if empty(::propos)
				SetRestFault(401, "Atributo propos é mandatório")
				return .F.
			endif
			oProposta := CRMContrato():New(::propos)
	
			aObjArr := ClassDataArr(oProposta)
			aAttrClass := {}
			for ni := 1 to len(aObjArr)
				aadd(aAttrClass,lower(aObjArr[ni][1]))
			next
			oPropostaBus:attr := aAttrClass
			
			// verifico se o prospect existe na base de dados
			if !(oPropostaBus:HasData(oProposta))
				SetRestFault(401, "Proposta não econtrada")
				return .F.
			endif
		
			oResp := CRMResp():New(200,oPropostaBus:attr,aArrayForm)
			oResp:addBody(aArrayForm[1],oProposta)
			//oResp:addProperties(oPropostaBus:attr)
		
			cResp := oResp:toJson()
		
			// defino a resposta
			::SetResponse(cResp)
			
		otherwise
			SetRestFault(401,"Operação inválida")
			return .F.
	endcase

return .T.

static function LogCRM(cCodUser,cOpera)
	
	local aDataInc	:= {}
	local cOperRot	:= iif(cOpera == "incluir","I",iif(cOpera == "alterar","A","E"))
	
	aadd(aDataInc,{"ZAF_ROTINA","CRMPROSPECT"})
	aadd(aDataInc,{"ZAF_USERID",cCodUser})
	aadd(aDataInc,{"ZAF_UNAME",UsrRetName(cCodUser)})
	aadd(aDataInc,{"ZAF_DATA",dDataBase})
	aadd(aDataInc,{"ZAF_ENTIDA","ADY"})
	aadd(aDataInc,{"ZAF_CODIGO",ADY->ADY_PROPOS})
	aadd(aDataInc,{"ZAF_OPERA",cOperRot})
	
	U_R73A3INC(aDataInc)
	
return