#include 'protheus.ch'

/*/{Protheus.doc} ACJDDI
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class ACJDDI 
	
	data ddi
	data pais
	
	method new(ddi,pais) constructor 
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
method new(ddi,pais) class ACJDDI
	
	::ddi	:= ddi
	::pais 	:= pais

	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class ACJDDI

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"ACJ_DDI, ACJ_PAIS"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"ddi")
		cWhere += "AND ACJ_DDI LIKE '%" + oJsonParam:ddi + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"pais")
		cWhere += "AND ACJ_PAIS LIKE '%" + oJsonParam:pais + "%' "
	endif
	
	cQuery +=  "SELECT ACJ_DDI, ACJ_PAIS FROM "+ RetSqlName("ACJ") +" ACJ "
	cQuery +=  "WHERE ACJ.D_E_L_E_T_ = '' "
	cQuery +=  " AND ACJ_FILIAL = '"+ xFilial("ACJ")+"' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,ACJDDI():New((cAliQry)->ACJ_DDI,(cAliQry)->ACJ_PAIS))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet