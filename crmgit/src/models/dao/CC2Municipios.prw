#include 'protheus.ch'

/*/{Protheus.doc} CC2Municipios
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CC2Municipios 
	
	data uf
	data codmun
	data mun
	
	method new(uf,codmun,mun) constructor 
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
method new(uf,codmun,mun) class CC2Municipios
	
	::uf 		:= uf
	::codmun 	:= codmun
	::mun		:= mun
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class CC2Municipios

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"CC2_EST, CC2_MUN", "CC2_EST, CC2_CODMUN"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"uf")
		cWhere += "AND CC2_EST LIKE '%" + oJsonParam:uf + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"codmun")
		cWhere += "AND CC2_CODMUN LIKE '%" + oJsonParam:codmun + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"mun")
		cWhere += "AND CC2_MUN LIKE '%" + oJsonParam:mun + "%' "
	endif
	
	cQuery +=  "SELECT CC2_EST, CC2_MUN, CC2_CODMUN FROM "+ RetSqlName("CC2") +" CC2 "
	cQuery +=  "WHERE CC2.D_E_L_E_T_ = '' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,CC2Municipios():New((cAliQry)->CC2_EST,(cAliQry)->CC2_MUN,(cAliQry)->CC2_CODMUN))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet