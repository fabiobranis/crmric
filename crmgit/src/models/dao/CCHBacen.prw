#include 'protheus.ch'

/*/{Protheus.doc} CCHBacen
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CCHBacen 
	
	data codigo
	data pais
	
	method new(codigo,pais) constructor 
	method getList(oJsonParam,nPage,nPageLength,nOrder)
	
endclass

/*/{Protheus.doc} new
Metodo construtor
@author Fabio
@since 19/05/2016 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method new(codigo,pais) class CCHBacen
	
	::codigo	:= codigo
	::pais 		:= pais
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class CCHBacen

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"CCH_CODIGO, CCH_PAIS"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"codigo")
		cWhere += "AND CCH_CODIGO LIKE '%" + oJsonParam:codigo + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"pais")
		cWhere += "AND CCH_PAIS LIKE '%" + oJsonParam:pais + "%' "
	endif
	
	cQuery +=  "SELECT CCH_CODIGO, CCH_PAIS FROM "+ RetSqlName("CCH") +" CCH "
	cQuery +=  "WHERE CCH.D_E_L_E_T_ = '' "
	cQUery += cWhere
	cQuery +=  " AND CCH_FILIAL = '"+ xFilial("CCH")+"' "
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,CCHBacen():New((cAliQry)->CCH_CODIGO,(cAliQry)->CCH_PAIS))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet