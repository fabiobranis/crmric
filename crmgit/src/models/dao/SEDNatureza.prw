#include 'protheus.ch'

/*/{Protheus.doc} SEDNatureza
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SEDNatureza 
	
	data codigo
	data descric
	
	method new(codigo,descric) constructor 
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
method new(codigo,descric) class SEDNatureza
	
	::codigo 	:= codigo
	::descric 	:= descric
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class SEDNatureza

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"ED_CODIGO, ED_DESCRIC"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"codigo")
		cWhere += "AND ED_CODIGO LIKE '%" + oJsonParam:codigo + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"descric")
		cWhere += "AND ED_DESCRIC LIKE '%" + oJsonParam:descric + "%' "
	endif
	
	cQuery +=  "SELECT ED_CODIGO, ED_DESCRIC FROM "+ RetSqlName("SED") +" SED "
	cQuery +=  "WHERE SED.D_E_L_E_T_ = '' "
	cQuery +=  " AND ED_FILIAL = '"+ xFilial("SED")+"' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,SEDNatureza():New((cAliQry)->ED_CODIGO,(cAliQry)->ED_DESCRIC))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet