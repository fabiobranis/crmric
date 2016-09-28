#include 'protheus.ch'

/*/{Protheus.doc} CRMTabItSite
(long_description)
@author fabio
@since 13/06/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMTabItSite 

	data erroAuto
	data attr
	data nFilteredRegs
	data nTotRegs
	
	method new() constructor 
	method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection)

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
method new() class CRMTabItSite

	::attr 		:= {}
	::erroAuto 	:= ""
	::nFilteredRegs := 0
	::nTotRegs	:= 0
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class CRMTabItSite

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"DA1_ITEM","DA1_CODPRO", "B1_DESC", "DA1_ESTADO"}
	local aRet			:= {}
	local cWhere		:= ""
	local cCliCod		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"codtab")
		cWhere += "AND DA1_CODTAB LIKE '%" + oJsonParam:codtab + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"item")
		cWhere += "AND DA1_ITEM LIKE '%" + oJsonParam:item + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"codpro")
		cWhere += "AND DA1_CODPRO LIKE '%" + oJsonParam:codpro + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"desc")
		cWhere += "AND B1_DESC LIKE '%" + oJsonParam:desc + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"estado")
		cWhere += "AND DA1_ESTADO LIKE '%" + oJsonParam:estado + "%' "
	endif
		
	cQuery +=  " SELECT "
	cQuery +=  " (SELECT COUNT(*) FROM "+ RetSqlName("DA1") +"  TOT WHERE TOT.DA1_FILIAL = '" + xFilial("DA1") + "' AND TOT.D_E_L_E_T_ = '') AS TOT_RECS,"
	cQuery +=  " (SELECT COUNT(*) FROM "+ RetSqlName("DA1") + " TOT "
	cQuery +=  " INNER JOIN "+ RetSqlName("SB1") +" SB1 "
	cQuery +=  " ON B1_FILIAL = '"+ xFilial("SB1")+"' "
	cQuery +=  " AND B1_COD = DA1_CODPRO "
	cQuery +=  " AND SB1.D_E_L_E_T_ = '' "
	cQuery +=  " WHERE TOT.DA1_FILIAL = '" + xFilial("DA1") + "' " + cWhere + " AND TOT.D_E_L_E_T_ = '') AS TOT_FILTER, "
	cQuery +=  " DA1_ITEM, DA1_CODTAB, DA1_CODPRO, B1_DESC, DA1_PRCVEN, DA1_VLRDES, DA1_GRUPO, DA1_REFGRD, DA1_PERDES, DA1_ATIVO, DA1_ESTADO, DA1_TPOPER, DA1_QTDLOT, DA1_INDLOT ,DA1_MOEDA, DA1_PRCMAX FROM "+ RetSqlName("DA1") +" DA1 "
	cQuery +=  " INNER JOIN "+ RetSqlName("SB1") +" SB1 "
	cQuery +=  " ON B1_FILIAL = '"+ xFilial("SB1")+"' "
	cQuery +=  " AND B1_COD = DA1_CODPRO "
	cQuery +=  " AND SB1.D_E_L_E_T_ = '' "
	cQuery +=  "WHERE DA1.D_E_L_E_T_ = '' "
	cQUery += cWhere
	cQuery +=  " AND DA1_FILIAL = '"+ xFilial("DA1")+"' "
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	::nTotRegs := (cAliQry)->TOT_RECS
	::nFilteredRegs := (cAliQry)->TOT_RECS
	while (cAliQry)->(!(eof()))

		aadd(aRet,DA1TabPrecoItem():New(cAliQry))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet