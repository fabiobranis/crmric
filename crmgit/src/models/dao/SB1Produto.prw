#include 'protheus.ch'

/*/{Protheus.doc} SB1Produto
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SB1Produto 
	
	data cod
	data desc
	
	method new(cod,desc) constructor 
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
method new(cod,desc) class SB1Produto
	
	::cod 	:= cod
	::desc 	:= desc
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class SB1Produto

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"B1_COD", "B1_DESC"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"cod")
		cWhere += "AND B1_COD LIKE '%" + oJsonParam:cod + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"desc")
		cWhere += "AND B1_DESC LIKE '%" + oJsonParam:desc + "%' "
	endif
	
	cQuery +=  "SELECT B1_COD, B1_DESC FROM "+ RetSqlName("SB1") +" SB1 "
	cQuery +=  "WHERE SB1.D_E_L_E_T_ = '' "
	cQuery +=  " AND B1_FILIAL = '"+ xFilial("SB1")+"' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,SB1Produto():New((cAliQry)->B1_COD,(cAliQry)->B1_DESC))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet