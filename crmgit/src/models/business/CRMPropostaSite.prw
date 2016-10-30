#include 'protheus.ch'

/*/{Protheus.doc} CRMPropostaSite
(long_description)
@author fabio
@since 13/06/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMPropostaSite 

	data erroAuto
	data attr
	data nFilteredRegs
	data nTotRegs
	
	method new() constructor 
	method valJson(cJson)
	method setCabFromJson(oJson,oPropostaCab)
	method setItemFromJson(oJson,oItemProposta)
	method setCalendFromJson(oJson,oCalendario)
	method valCabec(oPropostaCab)
	method valItem(oItemProposta,nLin)
	method valCalend(oCalendario,nLin)
	method isInclui(oProposta)
	method valExclui(oProposta)
	method save(oProposta)
	method delReg(oProposta)
	method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection)
	method getPrcTab(cFilPrd,cTabPrc,cPrdProp)
	method getCalcPrc(cFilPrd,cTabPrc,cPrdProp,nDesc,nQtde,nForma,nAltura,nColun,nPagin)

endclass

/*/{Protheus.doc} new
Metodo construtor
@author fabio
@since 13/06/2016 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method new() class CRMPropostaSite

	::attr 		:= {}
	::erroAuto 	:= ""
	::nFilteredRegs := 0
	::nTotRegs	:= 0
return self

method valJson(cJson) class CRMPropostaSite
	
	Local ni		:= 0
	Local aAttrMand	:= {"propos","entida","codigo","loja","datprop","condpg"}
	
	// percorro o array de atributos mandatórios
	for ni := 1 to len(aAttrMand)

		if !(aAttrMand[ni] $ cJson)
			::erroAuto := "Atributo "+aAttrMand[ni]+ " é mandatório"
			return .F.
		endif
	next

return .T.

method setCabFromJson(oJson,oPropostaCab) class CRMPropostaSite
	
	if AttIsMemberOf(oJson,"propos")
		oPropostaCab:propos := oJson:propos
	endif
	
	if AttIsMemberOf(oJson,"entida")
		oPropostaCab:entida := oJson:entida
	endif
	
	if AttIsMemberOf(oJson,"codigo")
		oPropostaCab:codigo := oJson:codigo
	endif
	
	if AttIsMemberOf(oJson,"loja")
		oPropostaCab:loja := oJson:loja
	endif
	
	if AttIsMemberOf(oJson,"orcame")
		oPropostaCab:orcame := oJson:orcame
	endif
	
	if AttIsMemberOf(oJson,"status")
		oPropostaCab:status := oJson:status
	endif
	
	if AttIsMemberOf(oJson,"datprop")
		oPropostaCab:datprop := ctod(oJson:datprop)
	endif
	
	if AttIsMemberOf(oJson,"previs")
		oPropostaCab:previs := oJson:previs
	endif
	
	if AttIsMemberOf(oJson,"vend")
		oPropostaCab:vend := oJson:vend
	endif
	
	if AttIsMemberOf(oJson,"xnumpi")
		oPropostaCab:xnumpi := oJson:xnumpi
	endif
	
	if AttIsMemberOf(oJson,"xmater")
		oPropostaCab:xmater := oJson:xmater
	endif
	
	if AttIsMemberOf(oJson,"xtpfat")
		oPropostaCab:xtpfat := oJson:xtpfat
	endif
	
	if AttIsMemberOf(oJson,"dtrevi")
		oPropostaCab:dtrevi := ctod(oJson:dtrevi)
	endif
	
	if AttIsMemberOf(oJson,"condpg")
		oPropostaCab:condpg := oJson:condpg
	endif
	
	if AttIsMemberOf(oJson,"xagenc")
		oPropostaCab:xagenc := oJson:xagenc
	endif
	
	if AttIsMemberOf(oJson,"client")
		oPropostaCab:client := oJson:client
	endif
	
	if AttIsMemberOf(oJson,"lojent")
		oPropostaCab:lojent := oJson:lojent
	endif
	
return

method setItemFromJson(oJson,oItemProposta) class CRMPropostaSite
	
	if AttIsMemberOf(oJson,"item")
		oItemProposta:item := oJson:item
	endif
		
	if AttIsMemberOf(oJson,"produto")
		oItemProposta:produto := oJson:produto
	endif
	
	if AttIsMemberOf(oJson,"qtdven")
		oItemProposta:qtdven := oJson:qtdven
	endif
	
	if AttIsMemberOf(oJson,"prcven")
		oItemProposta:prcven := oJson:prcven
	endif
	
	if AttIsMemberOf(oJson,"prctab")
		oItemProposta:prctab := oJson:prctab
	endif
	
	if AttIsMemberOf(oJson,"xprcve")
		oItemProposta:xprcve := oJson:xprcve
	endif
	
	if AttIsMemberOf(oJson,"total")
		oItemProposta:total := oJson:total
	endif
	
	if AttIsMemberOf(oJson,"descon")
		oItemProposta:descon := oJson:descon
	endif
	
	if AttIsMemberOf(oJson,"xforma")
		oItemProposta:xforma := oJson:xforma
	endif
	
	if AttIsMemberOf(oJson,"xaltur")
		oItemProposta:xaltur := oJson:xaltur
	endif
	
	if AttIsMemberOf(oJson,"xcolun")
		oItemProposta:xcolun := oJson:xcolun
	endif
	
	if AttIsMemberOf(oJson,"xpagin")
		oItemProposta:xpagin := oJson:xpagin
	endif
	if AttIsMemberOf(oJson,"xtpvei")
		oItemProposta:xtpvei := oJson:xtpvei
	endif
	
	if AttIsMemberOf(oJson,"xpraca")
		oItemProposta:xpraca := oJson:xpraca
	endif
	
	if AttIsMemberOf(oJson,"xfilpv")
		oItemProposta:xfilpv := oJson:xfilpv
	endif
	
	if AttIsMemberOf(oJson,"xmesex")
		oItemProposta:xmesex := oJson:xmesex
	endif
	
	if AttIsMemberOf(oJson,"xdeter")
		oItemProposta:xdeter := oJson:xdeter
	endif
	if AttIsMemberOf(oJson,"tes")
		oItemProposta:tes := oJson:tes
	endif
	
	if AttIsMemberOf(oJson,"condpg")
		oItemProposta:condpg := oJson:condpg
	endif
	
	if AttIsMemberOf(oJson,"moeda")
		oItemProposta:moeda := oJson:moeda
	endif
	
	if AttIsMemberOf(oJson,"valdes")
		oItemProposta:valdes := oJson:valdes
	endif
	
	if AttIsMemberOf(oJson,"comp")
		oItemProposta:comp := oJson:comp
	endif
	
	if AttIsMemberOf(oJson,"dt1ven")
		oItemProposta:dt1ven := ctod(oJson:dt1ven)
	endif
	
	if AttIsMemberOf(oJson,"orcame")
		oItemProposta:orcame := oJson:orcame
	endif

	if AttIsMemberOf(oJson,"revisa")
		oItemProposta:revisa := oJson:revisa
	endif
	
	if AttIsMemberOf(oJson,"um")
		oItemProposta:um := oJson:um
	endif
	
	if AttIsMemberOf(oJson,"xprctb")
		oItemProposta:xprctb := oJson:xprctb
	endif
	
	if AttIsMemberOf(oJson,"xtabpr")
		oItemProposta:xtabpr := oJson:xtabpr
	endif
	
	if AttIsMemberOf(oJson,"xprfat")
		oItemProposta:xprfat := oJson:xprfat
	endif
	
	if AttIsMemberOf(oJson,"xfilfa")
		oItemProposta:xfilfa := oJson:xfilfa
	endif

return
method setCalendFromJson(oJson,oCalendario) class CRMPropostaSite
	
	if AttIsMemberOf(oJson,"itprop")
		oCalendario:itprop := oJson:itprop
	endif
	
	if AttIsMemberOf(oJson,"dtexib")
		oCalendario:dtexib := ctod(oJson:dtexib)
	endif
	
	if AttIsMemberOf(oJson,"qtde")
		oCalendario:qtde := oJson:qtde
	endif

return
method valCabec(oPropostaCab) class CRMPropostaSite
	
	if empty(oPropostaCab:entida)
		::erroAuto := "Tipo de entidade deve ser preenchido"
		return .F.
	endif
	
	if empty(oPropostaCab:loja)
		::erroAuto := "Loja da entidade deve ser preenchida"
		return .F.
	endif
	
	if empty(oPropostaCab:datprop)
		::erroAuto := "Data da proposta deve ser preenchida"
		return .F.
	endif
	
	if !(empty(oPropostaCab:codigo))
		SA1->(dbsetorder(1))
		if !(SA1->(dbseek(xFilial("SA1") + oPropostaCab:codigo + oPropostaCab:loja))) 
			::erroAuto := "Entidade não cadastrada no sistema, verifique a consulta de entidades (Clientes ou Prospects)"
			return .F.
		endif
	else
		::erroAuto := "Código da Entidade deve ser preenchido"
		return .F.
	endif
	
	if !(empty(oPropostaCab:vend))
		SA3->(dbsetorder(1))
		if !(SA3->(dbseek(xFilial("SA3") + oPropostaCab:vend))) 
			::erroAuto := "Vendedor não cadastrado no sistema, verifique a consulta de vendedores"
			return .F.
		endif
	else
		::erroAuto := "Código do vendedor deve ser preenchido"
		return .F.
	endif
	
	if !(empty(oPropostaCab:condpg))
		SE4->(dbsetorder(1))
		if !(SE4->(dbseek(xFilial("SE4") + oPropostaCab:condpg))) 
			::erroAuto := "Condição de pagamento não cadastrada no sistema, verifique a consulta de Condição de pagamento."
			return .F.
		endif
	else
		::erroAuto := "Condição de pagamento deve ser preenchida"
		return .F.
	endif

return .T.

method valItem(oItemProposta,nLin) class CRMPropostaSite
	
	if empty(oItemProposta:item)
		::erroAuto := "Item da proposta deve ser preenchido. Linha " + cValToChar(nLin)
		return .F.
	endif
	
	/*if empty(oItemProposta:xmesex)
		::erroAuto := "Mes da exibição deve ser preenchido. Linha " + cValToChar(nLin)
		return .F.
	endif*/
	
	if !(empty(oItemProposta:produto))
		SB1->(dbsetorder(1))
		if !(SB1->(dbseek(xFilial("SB1") + oItemProposta:produto))) 
			::erroAuto := "Produto não cadastrado no sistema, verifique a consulta de produtos. Linha " + cValToChar(nLin)
			return .F.
		endif
	else
		::erroAuto := "Código do produto deve ser preenchido Linha " + cValToChar(nLin)
		return .F.
	endif
	
	if oItemProposta:qtdven <= 0
		::erroAuto := "Quantidade vendida deve ser maior que 0. Linha " + cValToChar(nLin)
		return .F.
	endif
	
	if oItemProposta:prcven <= 0
		::erroAuto := "Preço de venda deve ser maior que 0. Linha " + cValToChar(nLin)
		return .F.
	endif
	
	if oItemProposta:prctab <= 0
		::erroAuto := "Preço de tabela deve ser maior que 0. Linha " + cValToChar(nLin)
		return .F.
	endif
	
	if oItemProposta:xprcve <= 0
		::erroAuto := "Preço calculado referente a tabela deve ser maior que 0. Linha " + cValToChar(nLin)
		return .F.
	endif
	
	if oItemProposta:total <= 0
		::erroAuto := "Preço total do item deve ser maior que 0. Linha " + cValToChar(nLin)
		return .F.
	endif
	
	if !(empty(oItemProposta:xtabpr))
		DA0->(dbsetorder(1))
		if !(DA0->(dbseek(oItemProposta:xfilpv + oItemProposta:xtabpr))) 
			::erroAuto := "Tabela de preço não cadastrada no sistema, verifique a consulta de tabelas de preço. Linha " + cValToChar(nLin)
			return .F.
		endif
	else
		::erroAuto := "Tabela de preço deve ser preenchida Linha " + cValToChar(nLin)
		return .F.
	endif
	
	if !(empty(oItemProposta:tes))
		SF4->(dbsetorder(1))
		if !(SF4->(dbseek(xFilial("SF4") + oItemProposta:tes))) 
			::erroAuto := "TES não cadastrada no sistema, verifique a consulta de TES. Linha " + cValToChar(nLin)
			return .F.
		endif
	else
		::erroAuto := "TES deve ser preenchida Linha " + cValToChar(nLin)
		return .F.
	endif
	
	/*if !(empty(oItemProposta:condpg))
		SE4->(dbsetorder(1))
		if !(SE4->(dbseek(xFilial("SE4") + oItemProposta:condpg))) 
			::erroAuto := "Condição de pagamento não cadastrada no sistema, verifique a consulta de TES. Linha " + cValToChar(nLin)
			return .F.
		endif
	else
		::erroAuto := "Condição de pagamento deve ser preenchida Linha " + cValToChar(nLin)
		return .F.
	endif*/

return .T.
method valCalend(oCalendario,nLin) class CRMPropostaSite

	if empty(oCalendario:itprop)
		::erroAuto := "Item da proposta deve ser preenchido. Linha " + cValToChar(nLin)
		return .F.
	endif
	
	if empty(oCalendario:propos)
		::erroAuto := "Número da proposta deve ser preenchido. Linha " + cValToChar(nLin)
		return .F.
	endif
	
	if empty(oCalendario:dtexib)
		::erroAuto := "Data da exibição deve ser preenchida. Linha " + cValToChar(nLin)
		return .F.
	endif
	
	if oCalendario:qtde <= 0
		::erroAuto := "Número de exibições deve ser maior que 0. Linha " + cValToChar(nLin)
		return .F.
	endif

return .T.

/*/{Protheus.doc} isInclui
Verifica através de uma busca no banco de dados se é inclusão de registros
@author Fabio
@since 01/06/2016
@version undefined
@param oProposta, object, Objeto DAO
@return boolena, se é inclusão = .T.
/*/
method isInclui(oProposta) class CRMPropostaSite
	
	Local aAreaADZ	:= ADZ->(GetArea())
	Local lRet		:= .T.
	
	ADZ->(dbsetorder(1))
	lRet := !ADZ->(dbseek(xFilial("ADZ") + padr(oProposta:propos,TamSx3("ADZ_PROPOS")[1],"")))
	
	RestArea(aAreaADZ)
	
return lRet

/*/{Protheus.doc} valExclui
Valida se pode excluir a proposta
@author Fabio
@since 01/06/2016
@version undefined
@param oProposta, object, Objeto DAO
@return boolena, se puder excluir = .T.
/*/
method valExclui(oProposta) class CRMPropostaSite
	
	Local lRet		:= .T.
	
	// verificar as regras para implementar
	
	if !lRet
		::erroAuto := "Contato não pode ser excluído. Tem vínculo com cliente"
		return .F.
	endif
	
return .T.


method save(oProposta) class CRMPropostaSite
	::erroAuto := oProposta:save() 
return empty(::erroAuto)
method delReg(oProposta) class CRMPropostaSite
	::erroAuto := oProposta:delReg()
return empty(::erroAuto)

method getPrcTab(cFilPrd,cTabPrc,cPrdProp) class CRMPropostaSite
	Local cRet := '"preco" :  ' + cValToChar(u_Tabprc(cFilPrd,cTabPrc,cPrdProp))
	
return cRet

method getCalcPrc(cFilPrd,cTabPrc,cPrdProp,nDesc,nQtde,nForma,nAltura,nColun,nPagin) class CRMPropostaSite
	
	local aRet	:= {0,0,0,0}
	local cRet	:= ""
	default	nDesc := 0
	default nForma := 0
	default nAltura := 0
	default nColun := 0
	default nPagin := 0
	
	do case
	case nForma > 0
		aRet[1]	:= cValToChar(u_GatTv(nDesc,nForma,cFilPrd,cTabPrc,cPrdProp))
		aRet[2]	:= cValToChar(u_GatTv1(nForma,cFilPrd,cTabPrc,cPrdProp))
		aRet[3]	:= cValToChar(u_GatTv2(nDesc,nQtde,nForma,cFilPrd,cTabPrc,cPrdProp))
		aRet[4]	:= cValToChar(u_GatTv3(nQtde,nForma,cFilPrd,cTabPrc,cPrdProp))
	case nAltura > 0 .and. nColun > 0
		aRet[1]	:= cValToChar(u_GatJnd(nDesc,nColun,nAltura,cFilPrd,cTabPrc,cPrdProp))
		aRet[2]	:= cValToChar(u_GatJnd1(nColun,nAltura,cFilPrd,cTabPrc,cPrdProp))
		aRet[3]	:= cValToChar(u_GatJnd2(nDesc,nQtde,nColun,nAltura,cFilPrd,cTabPrc,cPrdProp))
		aRet[4]	:= cValToChar(u_GatJnd3(nQtde,nColun,nAltura,cFilPrd,cTabPrc,cPrdProp))
	case nPagin > 0
		aRet[1]	:= cValToChar(u_GatInt(nDesc,nPagin,cFilPrd,cTabPrc,cPrdProp))
		aRet[2]	:= cValToChar(u_GatInt1(nPagin,cFilPrd,cTabPrc,cPrdProp))
		aRet[3]	:= cValToChar(u_GatInt2(nDesc,nQtde,nPagin,cFilPrd,cTabPrc,cPrdProp))
		aRet[4]	:= cValToChar(u_GatInt3(nQtde,nPagin,cFilPrd,cTabPrc,cPrdProp))
	endcase
	
	cRet := '"unitneg" : ' +aRet[1]	+ ', '
	cRet += '"unittab" : ' +aRet[2]	+ ', '
	cRet += '"totneg" : ' +aRet[3] + ', '	
	cRet += '"tottab" : ' +aRet[4] + ''	
	
return cRet


method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class CRMPropostaSite

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"ADY_PROPOS", "ADY_CODIGO", "ADY_VEND"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"propos")
		cWhere += "AND ADY_PROPOS LIKE '%" + oJsonParam:propos + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"codigo")
		cWhere += "AND ADY_CODIGO LIKE '%" + oJsonParam:codigo + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"vend")
		cWhere += "AND ADY_VEND LIKE '%" + oJsonParam:vend + "%' "
	endif
	
	cQuery +=  " SELECT "
	cQuery +=  " (SELECT COUNT(*) FROM "+ RetSqlName("ADY") +"  TOT WHERE TOT.ADY_FILIAL = '" + xFilial("ADY") + "' AND TOT.D_E_L_E_T_ = '') AS TOT_RECS, "
	cQuery +=  " (SELECT COUNT(*) FROM "+ RetSqlName("ADY") +"  TOT WHERE TOT.ADY_FILIAL = '" + xFilial("ADY") +"' " + cWhere + " AND TOT.D_E_L_E_T_ = '') AS TOT_FILTER, "
	cQuery +=  " ADY_PROPOS FROM "+ RetSqlName("ADY") +" ADY "
	cQuery +=  "WHERE ADY.D_E_L_E_T_ = '' "
	cQuery +=  " AND ADY_FILIAL = '" + xFilial("ADY") + "' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	::nTotRegs		:= (cAliQry)->TOT_RECS
	::nFilteredRegs := (cAliQry)->TOT_FILTER
	while (cAliQry)->(!(eof()))

		aadd(aRet,ADYProposta():New((cAliQry)->ADY_PROPOS,.T.))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet