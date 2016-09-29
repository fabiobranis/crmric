#include 'protheus.ch'

/*/{Protheus.doc} ZA9Forma
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class ZA9Forma 
	
	data filial
	data codigo
	data tempex
	data fator
	
	method new(filial,codigo,tempex,fator) constructor 
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
method new(filial,codigo,tempex,fator) class ZA9Forma
	
	::filial	:= filial
	::codigo 	:= codigo
	::tempex 	:= tempex
	::fator		:= fator
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class ZA9Forma

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"ZA9_CODIGO", "ZA9_TEMPEX", "ZA9_FATOR"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"filial")
		cWhere += " AND ZA9_FILIAL = '" + oJsonParam:filial + "' "
	endif
	
	if AttIsMemberOf(oJsonParam,"codigo")
		cWhere += " AND ZA9_CODIGO LIKE '%" + oJsonParam:codigo + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"tempex")
		cWhere += " AND ZA9_TEMPEX = " + cValToChar(oJsonParam:tempex)
	endif
	
	if AttIsMemberOf(oJsonParam,"fator")
		cWhere += " AND ZA9_FATOR = " + cValToChar(oJsonParam:fator) 
	endif
	
	cQuery +=  "SELECT ZA9_FILIAL, ZA9_CODIGO, ZA9_TEMPEX, ZA9_FATOR FROM "+ RetSqlName("ZA9") +" ZA9 "
	cQuery +=  "WHERE ZA9.D_E_L_E_T_ = '' "
	//cQuery +=  " AND ZA9_FILIAL = '"+ xFilial("ZA9")+"' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,ZA9Forma():New((cAliQry)->ZA9_FILIAL,(cAliQry)->ZA9_CODIGO,(cAliQry)->ZA9_TEMPEX, (cAliQry)->ZA9_FATOR))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet