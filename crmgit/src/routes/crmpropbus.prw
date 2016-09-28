#include 'protheus.ch'
#include 'parmtype.ch'
#include "RESTFUL.CH"

#define STR001 "Servi�o de Processamentos auxiliares das Propostas do CRM Ric [ERP Protheus]"
#define STR002 "M�todo que realiza o processamento desejado de acordo com os par�metros"

/*/{Protheus.doc} crmpropbus
Classe Rest com os m�todos relacionados ao servi�o de login dos usu�rios do portal CRM
@author fabiobranis
@since 21/04/2016
@version 1.0
/*/
wsrestful crmpropbus description STR001

	wsdata codusu as string
	wsdata token as string

	wsmethod post description STR002 wssyntax "/crmpropbus/{option}"

end wsrestful

wsmethod post wsreceive codusu, token wsservice crmpropbus
	
	Local cContent	:= ""
	Local oJson		:= nil
	Local oUser		:= nil
	Local oLogin	:= nil
	Local oVend		:= nil
	Local oPropostaBus	:= nil
	Local cRet		:= ""
	Local cResp		:= ""
	Local cFilPrd	:= ""
	Local cTabPrc	:= ""
	Local cPrdProp	:= ""
	Local nDesc		:= 0
	Local nQtde		:= 0
	Local nForma	:= 0
	Local nAltura	:= 0
	Local nColun	:= 0
	Local nPagin	:= 0
	
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
	
	oPropostaBus := CRMPropostaSite():New()

	// transformo em objeto
	if !FwJsonDeserialize(cContent,@oJson)
		// se n�o chegaram os par�metros
		SetRestFault(401, "Erro interno")
		return .F.
	endif
	
	if AttIsMemberOf(oJson,"filial")
		cFilPrd := oJson:filial
	endif
	
	if AttIsMemberOf(oJson,"tabela")
		cTabPrc := oJson:tabela
	endif
	
	if AttIsMemberOf(oJson,"produto")
		cPrdProp := oJson:produto
	endif
	
	if AttIsMemberOf(oJson,"desconto")
		nDesc:= oJson:desconto
	endif
	
	if AttIsMemberOf(oJson,"quantidade")
		nQtde := oJson:quantidade
	endif
	
	if AttIsMemberOf(oJson,"forma")
		nForma := oJson:forma
	endif
	
	if AttIsMemberOf(oJson,"altura")
		nAltura := oJson:altura
	endif
	
	if AttIsMemberOf(oJson,"coluna")
		nColun := oJson:coluna
	endif
	
	if AttIsMemberOf(oJson,"pagina")
		nPagin := oJson:pagina
	endif
	
	do case
	case alltrim(::aURLParms[1]) == "precotabela" //retorna o pre�o de tabela limpo de acordo com o prd e filial
		cRet := oPropostaBus:getPrcTab(cFilPrd,cTabPrc,cPrdProp)
	case alltrim(::aURLParms[1]) == "precocalc" // retorna o pre�o calculado de acordo com as regras, prd e filial
	 	cRet := oPropostaBus:getCalcPrc(cFilPrd,cTabPrc,cPrdProp,nDesc,nQtde,nForma,nAltura,nColun,nPagin)
	endcase
	
	cResp := '{"status": 200, "body" : { '+cRet+' }}'
	
	// defino a resposta
	::SetResponse(cResp)
	
return .T.