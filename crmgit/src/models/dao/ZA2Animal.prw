#include 'protheus.ch'

/*/{Protheus.doc} ZA2Animal
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class ZA2Animal 
	
	data codigo
	data nome
	
	method new(codigo,nome) constructor 
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
method new(codigo,nome) class ZA2Animal
	
	::codigo 	:= codigo
	::nome 		:= nome
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class ZA2Animal

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"ZA2_CODIGO, ZA2_NOME"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"codigo")
		cWhere += "AND ZA2_CODIGO LIKE '%" + oJsonParam:codigo + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"nome")
		cWhere += "AND ZA2_NOME LIKE '%" + oJsonParam:nome + "%' "
	endif
	
	cQuery +=  "SELECT ZA2_CODIGO, ZA2_NOME FROM "+ RetSqlName("ZA2") +" ZA2 "
	cQuery +=  "WHERE ZA2.D_E_L_E_T_ = '' "
	cQuery +=  " AND ZA2_FILIAL = '"+ xFilial("ZA2")+"' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,ZA2Animal():New((cAliQry)->ZA2_CODIGO,(cAliQry)->ZA2_NOME))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet