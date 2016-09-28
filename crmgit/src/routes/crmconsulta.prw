#include "TOTVS.CH"
#include "RESTFUL.CH"

/**
* Defini��es de constantes
*/

#define STR001 "Servi�o de consulta padr�o do CRM[ERP Protheus]"
#define STR002 "M�todo de consulta"

/*/{Protheus.doc} crmlogin
Classe Rest com os m�todos relacionados ao servi�o de login dos usu�rios do portal CRM
@author fabiobranis
@since 21/04/2016
@version 1.0
/*/
wsrestful crmconsulta description STR001

wsdata codusu as string
wsdata token as string

wsmethod post description STR002 wssyntax "/crmconsulta/{entidade}"

end wsrestful

// m�todo de login
wsmethod post wsreceive token,codusu wsservice crmconsulta

	Local cResp			:= ""
	Local cContent		:= ""
	Local oJson			:= nil
	Local oUser			:= nil
	Local oLogin		:= nil
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
	case alltrim(::aURLParms[1]) == "est"
		
		oEntidade := SX5Estados():New()
		aadd(aArrayForm,"estados")
	case alltrim(::aURLParms[1]) == "mun"
		oEntidade := CC2Municipios():New()
		aadd(aArrayForm,"municipios")
	case alltrim(::aURLParms[1]) == "bacen"
		oEntidade := CCHBacen():New()
		aadd(aArrayForm,"bacen")
	case alltrim(::aURLParms[1]) == "pais"
		oEntidade := SYAPaises():New()
		aadd(aArrayForm,"pais")
	case alltrim(::aURLParms[1]) == "ddi"
		oEntidade := ACJDDI():New()
		aadd(aArrayForm,"ddi")
	case alltrim(::aURLParms[1]) == "vend"
		oEntidade := SA3VendConsulta():New()
		aadd(aArrayForm,"vend")
	case alltrim(::aURLParms[1]) == "prosp"
		oEntidade := SUSProspConsulta():New()
		aadd(aArrayForm,"prosp")
	case alltrim(::aURLParms[1]) == "cli"
		oEntidade := SA1CliConsulta():New()
		aadd(aArrayForm,"cli")
	case alltrim(::aURLParms[1]) == "natureza"
		oEntidade := SEDNatureza():New()
		aadd(aArrayForm,"natureza")
	case alltrim(::aURLParms[1]) == "nivel"
		oEntidade := SX5Nivel():New()
		aadd(aArrayForm,"nivel")
	case alltrim(::aURLParms[1]) == "trata"
		oEntidade := SX5Trata():New()
		aadd(aArrayForm,"trata")
	case alltrim(::aURLParms[1]) == "funcao"
		oEntidade := SUMFuncao():New()
		aadd(aArrayForm,"funcao")
	case alltrim(::aURLParms[1]) == "animal"
		oEntidade := ZA2Animal():New()
		aadd(aArrayForm,"animal")
	case alltrim(::aURLParms[1]) == "contato"
		oEntidade := SU5ContConsulta():New()
		aadd(aArrayForm,"contato")
	case alltrim(::aURLParms[1]) == "emp"
		oEntidade := SM0EmpConsulta():New()
		aadd(aArrayForm,"emp")
	case alltrim(::aURLParms[1]) == "material"
		oEntidade := ZABMaterial():New()
		aadd(aArrayForm,"material")
	case alltrim(::aURLParms[1]) == "tpfat"
		oEntidade := ZACTipoFat():New()
		aadd(aArrayForm,"tpfat")
	case alltrim(::aURLParms[1]) == "forma"
		oEntidade := ZA9Forma():New()
		aadd(aArrayForm,"forma")
	case alltrim(::aURLParms[1]) == "tes"
		oEntidade := SF4Tes():New()
		aadd(aArrayForm,"tes")
	case alltrim(::aURLParms[1]) == "condpagto"
		oEntidade := SE4CondPagto():New()
		aadd(aArrayForm,"condpagto")
	case alltrim(::aURLParms[1]) == "prod"
		oEntidade := SB1Produto():New()
		aadd(aArrayForm,"prod")
	case alltrim(::aURLParms[1]) == "tabprc"
		oEntidade := DA0TabelaPreco():New()
		aadd(aArrayForm,"tabprc")
	case alltrim(::aURLParms[1]) == "ittabprc"
	
		if !AttIsMemberOf(oJson,"codtab")
			SetRestFault(401,"Para consultar os itens da tabela de pre�os o atributo codtab � obrigat�rio")
			return .F.
		endif
	
		oEntidade := DA1TabPrecoItem():New()
		aadd(aArrayForm,"ittabprc")
	case alltrim(::aURLParms[1]) == "proposta"
		oEntidade := ADYPropConsulta():New()
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

	oResp	:= CRMResp():New(200,aAttrClass,aArrayForm)
	aDataEnt := oEntidade:getList(oJson,nPagina,nPageLength,nOrder,cDirection)
	
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
return .T.