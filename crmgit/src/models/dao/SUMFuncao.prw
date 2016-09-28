#include 'protheus.ch'

/*/{Protheus.doc} SUMFuncao
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SUMFuncao 
	
	data cargo
	data desc
	
	method new(cargo,desc) constructor 
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
method new(cargo,desc) class SUMFuncao
	
	::cargo 	:= cargo
	::desc 		:= desc
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class SUMFuncao

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"UM_CARGO, UM_DESC"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"cargo")
		cWhere += "AND UM_CARGO LIKE '%" + oJsonParam:cargo + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"desc")
		cWhere += "AND UM_DESC LIKE '%" + oJsonParam:desc + "%' "
	endif
	
	cQuery +=  "SELECT UM_CARGO, UM_DESC FROM "+ RetSqlName("SUM") +" SUN "
	cQuery +=  "WHERE SUN.D_E_L_E_T_ = '' "
	cQuery +=  " AND UM_FILIAL = '"+ xFilial("SUM")+"' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,SUMFuncao():New((cAliQry)->UM_CARGO,(cAliQry)->UM_DESC))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet