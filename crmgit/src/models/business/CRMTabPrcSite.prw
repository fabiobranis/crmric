#include 'protheus.ch'

/*/{Protheus.doc} CRMTabPrcSite
(long_description)
@author fabio
@since 13/06/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMTabPrcSite 

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
method new() class CRMTabPrcSite

	::attr 		:= {}
	::erroAuto 	:= ""
	::nFilteredRegs := 0
	::nTotRegs	:= 0
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class CRMTabPrcSite

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"DA0_CODTAB", "DA0_DESCRI"}
	local aRet			:= {}
	local cWhere		:= ""
	local cCliCod		:= ""
	local cFilFil		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"filial")
		cWhere += "AND DA0_FILIAL = '" + oJsonParam:filial + "' "
		cFilFil := " DA0_FILIAL = '" + oJsonParam:filial + "' "
	else
		cWhere += "AND DA0_FILIAL = '" + xFilial("DA0") + "' "
		cFilFil := " DA0_FILIAL = '" + xFilial("DA0") + "' "
	endif
	
	if AttIsMemberOf(oJsonParam,"codtab")
		cWhere += "AND DA0_CODTAB LIKE '%" + oJsonParam:codtab + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"descri")
		cWhere += "AND DA0_DESCRI LIKE '%" + oJsonParam:descri + "%' "
	endif
		
	cQuery +=  " SELECT "
	cQuery +=  " (SELECT COUNT(*) FROM "+ RetSqlName("DA0") +"  TOT WHERE " + cFilFil + " AND TOT.D_E_L_E_T_ = '') AS TOT_RECS,"
	cQuery +=  " (SELECT COUNT(*) FROM "+ RetSqlName("DA0") +"  TOT WHERE TOT.D_E_L_E_T_ = '' " + cWhere + "  ) AS TOT_FILTER, "
	cQuery +=  " DA0_FILIAL, DA0_CODTAB, DA0_DESCRI FROM "+ RetSqlName("DA0") +" DA0 "
	cQuery +=  "WHERE DA0.D_E_L_E_T_ = '' "
	cQuery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	::nTotRegs := (cAliQry)->TOT_RECS
	::nFilteredRegs := (cAliQry)->TOT_RECS
	while (cAliQry)->(!(eof()))

		aadd(aRet,DA0TabelaPreco():New((cAliQry)->DA0_FILIAL, (cAliQry)->DA0_CODTAB,(cAliQry)->DA0_DESCRI))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet