#include 'protheus.ch'

/*/{Protheus.doc} SUSProspConsulta
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SUSProspConsulta 
	
	data cod
	data loja
	data nreduz
	data cgc
	
	method new(cod,loja,nreduz,cgc) constructor 
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
method new(cod,loja,nreduz,cgc) class SUSProspConsulta
	
	::cod 	:= cod
	::loja 	:= loja
	::nreduz	:= nreduz
	::cgc	:= cgc
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class SUSProspConsulta

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"US_COD, US_LOJA", "US_NREDUZ, US_CGC"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"cod")
		cWhere += "AND US_COD LIKE '%" + oJsonParam:cod + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"loja")
		cWhere += "AND US_LOJA LIKE '%" + oJsonParam:loja + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"nreduz")
		cWhere += "AND US_NREDUZ LIKE '%" + oJsonParam:nreduz + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"cgc")
		cWhere += "AND US_CGC LIKE '%" + oJsonParam:cgc + "%' "
	endif
	
	
	cQuery +=  "SELECT US_COD, US_LOJA, US_NREDUZ, US_CGC FROM "+ RetSqlName("SUS") +" SUS "
	cQuery +=  "WHERE SUS.D_E_L_E_T_ = '' "
	cQUery += cWhere
	cQuery +=  " AND US_FILIAL = '"+ xFilial("SUS")+"' "
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,SUSProspConsulta():New((cAliQry)->US_COD,(cAliQry)->US_LOJA,(cAliQry)->US_NREDUZ,(cAliQry)->US_CGC))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet