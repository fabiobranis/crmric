#include 'protheus.ch'
#include 'parmtype.ch'
#include "RESTFUL.CH"

#define STR001 "Serviço de Processamentos auxiliares das Propostas do CRM Ric [ERP Protheus]"
#define STR002 "Método que realiza o processamento desejado de acordo com os parâmetros"

/*/{Protheus.doc} crmpropbus
Classe Rest com os métodos relacionados ao serviço de login dos usuários do portal CRM
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
	case alltrim(::aURLParms[1]) == "precotabela" //retorna o preço de tabela limpo de acordo com o prd e filial
		cRet := oPropostaBus:getPrcTab(cFilPrd,cTabPrc,cPrdProp)
	case alltrim(::aURLParms[1]) == "precocalc" // retorna o preço calculado de acordo com as regras, prd e filial
	 	cRet := oPropostaBus:getCalcPrc(cFilPrd,cTabPrc,cPrdProp,nDesc,nQtde,nForma,nAltura,nColun,nPagin)
	endcase
	
	cResp := '{"status": 200, "body" : { '+cRet+' }}'
	
	// defino a resposta
	::SetResponse(cResp)
	
return .T.