#include 'protheus.ch'

/*/{Protheus.doc} ADYPropConsulta
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class ADYPropConsulta 
	
	data propos
	data codigo
	data nome
	
	method new(propos,codigo,nome) constructor 
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
method new(propos,codigo,nome) class ADYPropConsulta
	
	::propos 	:= propos
	::codigo 	:= codigo
	::nome		:= nome

return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class ADYPropConsulta

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"ADY_PROPOS", "ADY_CODIGO", "A1_NOME"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"propos")
		cWhere += "AND ADY_PROPOS LIKE '%" + oJsonParam:propos + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"codigo")
		cWhere += "AND ADY_CODIGO LIKE '%" + oJsonParam:codigo + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"nome")
		cWhere += "AND A1_NOME LIKE '%" + oJsonParam:nome + "%' "
	endif
	
	cQuery +=  "SELECT ADY_PROPOS, ADY_CODIGO, A1_NOME FROM "+ RetSqlName("ADY") +" ADY "
	cQuery += " INNER JOIN "+ RetSqlName("SA1") +" SA1 "
	cQuery += " ON A1_FILIAL = '"+ xFilial("SA1")+"' "
	cQuery += " AND A1_COD = ADY_CODIGO "
	cQuery += " AND A1_LOJA = ADY_LOJA "
	cQuery +=  "AND SA1.D_E_L_E_T_ = '' "
	cQuery +=  "WHERE ADY.D_E_L_E_T_ = '' "
	cQUery += cWhere
	cQuery +=  " AND ADY_FILIAL = '"+ xFilial("ADY")+"' "
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,ADYPropConsulta():New((cAliQry)->ADY_PROPOS,(cAliQry)->ADY_CODIGO,(cAliQry)->A1_NOME))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet