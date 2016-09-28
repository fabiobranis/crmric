#include 'protheus.ch'

/*/{Protheus.doc} SF4Tes
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SF4Tes 
	
	data codigo
	data finalid
	
	method new(codigo,finalid) constructor 
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
method new(codigo,finalid) class SF4Tes
	
	::codigo 	:= codigo
	::finalid 	:= finalid
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class SF4Tes

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"F4_CODIGO", "F4_FINALID"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"codigo")
		cWhere += "AND F4_CODIGO LIKE '%" + oJsonParam:codigo + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"finalid")
		cWhere += "AND F4_FINALID LIKE '%" + oJsonParam:finalid + "%' "
	endif
	
	cQuery +=  "SELECT F4_CODIGO, F4_FINALID FROM "+ RetSqlName("SF4") +" SF4 "
	cQuery +=  "WHERE SF4.D_E_L_E_T_ = '' "
	cQuery +=  " AND F4_FILIAL = '"+ xFilial("SF4")+"' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,SF4Tes():New((cAliQry)->F4_CODIGO,(cAliQry)->F4_FINALID))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet