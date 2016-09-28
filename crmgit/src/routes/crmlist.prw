#include "TOTVS.CH"
#include "RESTFUL.CH"

/**
* Defini��es de constantes
*/

#define STR001 "Servi�o de listagem de entidades do CRM[ERP Protheus]"
#define STR002 "M�todo de consulta"

/*/{Protheus.doc} crmlogin
Classe Rest com os m�todos relacionados ao servi�o de login dos usu�rios do portal CRM
@author fabiobranis
@since 21/04/2016
@version 1.0
/*/
wsrestful crmlist description STR001

wsdata codusu as string
wsdata token as string

wsmethod post description STR002 wssyntax "/crmlist/{entidade}"

end wsrestful

// m�todo de login
wsmethod post wsreceive token,codusu wsservice crmlist

	Local cResp			:= ""
	Local cContent		:= ""
	Local oJson			:= nil
	Local oUser			:= nil
	Local oLogin		:= nil
	Local oBusiness		:= nil
	Local oEntidade		:= nil
	Local oResp			:= nil
	Local nPagina		:= 1
	Local nPageLength	:= 10
	Local nOrder		:= 1
	Local cDirection	:= "ASC"
	Local cResp			:= ""
	Local aArrayForm	:= {}
	Local aAttrClass	:= {}
	Local aObjArr		:= {}
	Local ni			:= 0
	
	// define o tipo de retorno do m�todo
	::SetContentType("application/json")

	// pego o conte�do enviado
	cContent := ::GetContent()
	if len(::aURLParms) == 0
		cResp := '"param": '+::aURLParms[1]
		SetRestFault(401,"Informe a entidade a fazer a busca")
	endif
	// transformo em objeto
	
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
	
	if AttIsMemberOf(oJson,"page")
		nPagina := oJson:page
	endif
	
	if AttIsMemberOf(oJson,"pagelength")
		nPageLength := oJson:pagelength
	endif
	
	if AttIsMemberOf(oJson,"order")
		nOrder := oJson:order
	endif
	
	if AttIsMemberOf(oJson,"direction")
		cDirection := oJson:direction
	endif
	
	oVend := SA3Vendedor():New(oUser:iderp)
	
	do case
	case alltrim(::aURLParms[1]) == "prospect"
		
		oBusiness := CRMProspectSite():New()
		oEntidade := SUSProspectsPortal():New()
		aadd(aArrayForm,"prospects")
	case alltrim(::aURLParms[1]) == "cliente"
		
		oBusiness := CRMClienteSite():New()
		oEntidade := SA1Clientes():New()
		aadd(aArrayForm,"cliente")
	case alltrim(::aURLParms[1]) == "contato"
		
		oBusiness := CRMContatoSite():New()
		oEntidade := SU5Contatos():New()
		aadd(aArrayForm,"contato")
	case alltrim(::aURLParms[1]) == "contcliente"	
		
		if !AttIsMemberOf(oJson,"cod")
			SetRestFault(401,"Atributo cod � obrigat�rio para esta consulta")
			return .F.
		endif
		  
		if !AttIsMemberOf(oJson,"loja")
			SetRestFault(401,"Atributo loja � obrigat�rio para esta consulta")
			return .F.
		endif
		
		oBusiness := CRMContCliSite():New()
		oEntidade := SU5Contatos():New()
		aadd(aArrayForm,"contato")
	case alltrim(::aURLParms[1]) == "tabprc"
		
		oBusiness := CRMTabPrcSite():New()
		oEntidade := DA0TabelaPreco():New()
		aadd(aArrayForm,"contato")
	case alltrim(::aURLParms[1]) == "ittabprc"
	
		if !AttIsMemberOf(oJson,"codtab")
			SetRestFault(401,"Para consultar os itens da tabela de pre�os o atributo codtab � obrigat�rio")
			return .F.
		endif
		oBusiness := CRMTabItSite():New()
		oEntidade := DA1TabPrecoItem():New()
		aadd(aArrayForm,"ittabprc")
	case alltrim(::aURLParms[1]) == "proposta"
		oBusiness := CRMPropostaSite():New()
		oEntidade := ADYProposta():New()
		aadd(aArrayForm,"proposta")
	otherwise
		SetRestFault(401,"Entidade n�o existe neste modo de consulta")
		return .F.
	endcase
	
	aObjArr := ClassDataArr(oEntidade)
	aAttrClass := {}
	for ni := 1 to len(aObjArr)
		aadd(aAttrClass,lower(aObjArr[ni][1]))
	next
	oBusiness:attr := aAttrClass
	oResp	:= CRMResp():New(200,oBusiness:attr,aArrayForm,.T.)
	aDataEnt := oBusiness:getList(oJson,nPagina,nPageLength,nOrder,cDirection)
	oResp:nFiltered  := oBusiness:nFilteredRegs
	oResp:nRegs  := oBusiness:nTotRegs
	oResp:nPageLength := nPageLength
	oResp:nPage := nPagina
	
	for ni := 1 to len(aDataEnt)
		oResp:addBody(aArrayForm[1],aDataEnt[ni])
	next
	
	if len(aDataEnt) == 0
		cResp := '{"status": 200, "body" : { "message": "Sem dados para os par�metros informados"}}'
	else
		cResp := oResp:toJson()
	endif
	
	// defino a resposta
	::SetResponse(cResp)
	
	FreeObj(oResp)
	FreeObj(oLogin)
	FreeObj(oVend)
	FreeObj(oUser)
	FreeObj(oJson)
	FreeObj(oBusiness)
	FreeObj(oEntidade)
	
return .T.