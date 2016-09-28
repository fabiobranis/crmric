#include 'protheus.ch'

/*/{Protheus.doc} ZABMaterial
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class ZABMaterial 
	
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
method new(codigo,descri) class ZABMaterial
	
	::codigo 	:= codigo
	::descri 	:= descri
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class ZABMaterial

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"ZAB_CODIGO", "ZAB_DESCRI"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"codigo")
		cWhere += "AND ZAB_CODIGO LIKE '%" + oJsonParam:codigo + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"descri")
		cWhere += "AND ZAB_DESCRI LIKE '%" + oJsonParam:descri + "%' "
	endif
	
	cQuery +=  "SELECT ZAB_CODIGO, ZAB_DESCRI FROM "+ RetSqlName("ZAB") +" ZAB "
	cQuery +=  "WHERE ZAB.D_E_L_E_T_ = '' "
	cQuery +=  " AND ZAB_FILIAL = '"+ xFilial("ZAB")+"' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,ZABMaterial():New((cAliQry)->ZAB_CODIGO,(cAliQry)->ZAB_DESCRI))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet