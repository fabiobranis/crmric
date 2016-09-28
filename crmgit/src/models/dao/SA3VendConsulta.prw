#include 'protheus.ch'

/*/{Protheus.doc} SA3VendConsulta
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SA3VendConsulta 
	
	data cod
	data loja
	data nome
	data cgc
	
	method new(cod,loja,nome,cgc) constructor 
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
method new(cod,loja,nome,cgc) class SA3VendConsulta
	
	::cod 	:= cod
	::loja 	:= loja
	::nome	:= nome
	::cgc	:= cgc
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class SA3VendConsulta

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"A3_COD, A3_LOJA", "A3_NOME, A3_CGC"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"cod")
		cWhere += "AND A3_COD LIKE '%" + oJsonParam:cod + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"loja")
		cWhere += "AND A3_LOJA LIKE '%" + oJsonParam:loja + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"nome")
		cWhere += "AND A3_NOME LIKE '%" + oJsonParam:nome + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"cgc")
		cWhere += "AND A3_CGC LIKE '%" + oJsonParam:cgc + "%' "
	endif
	
	cQuery +=  "SELECT A3_COD, A3_LOJA, A3_NOME, A3_CGC FROM "+ RetSqlName("SA3") +" SA3 "
	cQuery +=  "WHERE SA3.D_E_L_E_T_ = '' "
	cQUery += cWhere
	cQuery +=  " AND A3_FILIAL = '"+ xFilial("SA3")+"' "
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,SA3VendConsulta():New((cAliQry)->A3_COD,(cAliQry)->A3_LOJA,(cAliQry)->A3_NOME,(cAliQry)->A3_CGC))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet