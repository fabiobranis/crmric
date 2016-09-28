#include 'protheus.ch'

/*/{Protheus.doc} SA1CliConsulta
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SA1CliConsulta 
	
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
method new(cod,loja,nreduz,cgc) class SA1CliConsulta
	
	::cod 		:= cod
	::loja 		:= loja
	::nreduz	:= nreduz
	::cgc		:= cgc
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class SA1CliConsulta

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"A1_COD, A1_LOJA", "A1_NREDUZ, A1_CGC"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"cod")
		cWhere += "AND A1_COD LIKE '%" + oJsonParam:cod + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"loja")
		cWhere += "AND A1_LOJA LIKE '%" + oJsonParam:loja + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"nreduz")
		cWhere += "AND A1_NREDUZ LIKE '%" + oJsonParam:nreduz + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"cgc")
		cWhere += "AND A1_CGC LIKE '%" + oJsonParam:cgc + "%' "
	endif
	
	
	cQuery +=  "SELECT A1_COD, A1_LOJA, A1_NREDUZ, A1_CGC FROM "+ RetSqlName("SA1") +" SA1 "
	cQuery +=  "WHERE SA1.D_E_L_E_T_ = '' "
	cQUery += cWhere
	cQuery +=  " AND A1_FILIAL = '"+ xFilial("SA1")+"' "
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,SA1CliConsulta():New((cAliQry)->A1_COD,(cAliQry)->A1_LOJA,(cAliQry)->A1_NREDUZ,(cAliQry)->A1_CGC))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet