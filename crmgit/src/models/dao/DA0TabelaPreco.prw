#include 'protheus.ch'

/*/{Protheus.doc} DA0TabelaPreco
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class DA0TabelaPreco 
	
	data filial
	data codtab
	data descri

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
method new(filial,codtab,descri) class DA0TabelaPreco
	
	::filial	:= filial
	::codtab 	:= codtab
	::descri 	:= descri
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class DA0TabelaPreco

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"DA0_CODTAB", "DA0_DESCRI"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"filial")
		cWhere += "AND DA0_FILIAL = '" + oJsonParam:filial + "' "
	else
		cWhere += "AND DA0_FILIAL = '" + xFilial("DA0") + "' "
	endif
	
	if AttIsMemberOf(oJsonParam,"codtab")
		cWhere += "AND DA0_CODTAB LIKE '%" + oJsonParam:codtab + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"descri")
		cWhere += "AND DA0_DESCRI LIKE '%" + oJsonParam:descri + "%' "
	endif
	
	cQuery +=  "SELECT DA0_FILIAL, DA0_CODTAB, DA0_DESCRI FROM "+ RetSqlName("DA0") +" DA0 "
	cQuery +=  "WHERE DA0.D_E_L_E_T_ = '' "
	cQuery += cWhere
	//cQuery +=  " AND DA0_FILIAL = '"+ xFilial("DA0")+"' "
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,DA0TabelaPreco():New((cAliQry)->DA0_FILIAL,(cAliQry)->DA0_CODTAB,(cAliQry)->DA0_DESCRI))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet