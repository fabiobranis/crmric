#include 'protheus.ch'

/*/{Protheus.doc} SX5Trata
(long_description)
@author Fabio
@since 15/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SX5Trata 
	
	data trata
	data descri
		
	method new(trata) constructor 
	method getList(oJsonParam,nPage,nPageLength,nOrder)

endclass

/*/{Protheus.doc} new
Metodo construtor
@author Fabio
@since 15/05/2016 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method new(trata) class SX5Trata
	
	Local aAreaSX5	:= SX5->(GetArea())
	default trata := ""	
	
	::trata := trata
	::descri := ""
	
	SX5->(dbsetorder(1))
	if SX5->(dbseek(xFilial("SX5") + "AX" + trata))
		::trata 	:= SX5->X5_CHAVE
		::descri 	:= SX5->X5_DESCRI
	endif
	
	RestArea(aAreaSX5)
	
return

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class SX5Trata

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"X5_CHAVE", "X5_DESCRI"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"trata")
		cWhere += "AND X5_CHAVE LIKE '%" + oJsonParam:trata + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"descri")
		cWhere += "AND X5_DESCRI LIKE '%" + oJsonParam:descri + "%' "
	endif
	
	cQuery +=  "SELECT X5_CHAVE, X5_DESCRI FROM "+ RetSqlName("SX5") +" SX5 "
	cQuery +=  "WHERE SX5.D_E_L_E_T_ = '' "
	cQuery +=  " AND X5_TABELA = 'AX' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,SX5Trata():New((cAliQry)->X5_CHAVE))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet