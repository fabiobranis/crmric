#include 'protheus.ch'

/*/{Protheus.doc} SE4CondPagto
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SE4CondPagto 
	
	data codigo
	data descri
	
	method new(codigo,descri) constructor 
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
method new(codigo,descri) class SE4CondPagto
	
	::codigo 	:= codigo
	::descri 	:= descri
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class SE4CondPagto

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"E4_CODIGO", "E4_DESCRI"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"codigo")
		cWhere += "AND E4_CODIGO LIKE '%" + oJsonParam:codigo + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"descri")
		cWhere += "AND E4_DESCRI LIKE '%" + oJsonParam:descri + "%' "
	endif
	
	cQuery +=  "SELECT E4_CODIGO, E4_DESCRI FROM "+ RetSqlName("SE4") +" SE4 "
	cQuery +=  "WHERE SE4.D_E_L_E_T_ = '' "
	cQuery +=  " AND E4_FILIAL = '"+ xFilial("SE4")+"' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,SE4CondPagto():New((cAliQry)->E4_CODIGO,(cAliQry)->E4_DESCRI))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet