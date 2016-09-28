#include 'protheus.ch'

/*/{Protheus.doc} SX5Nivel
(long_description)
@author Fabio
@since 15/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SX5Nivel 
	
	data nivel
	data descri
		
	method new(nivel) constructor 
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
method new(nivel) class SX5Nivel
	
	Local aAreaSX5	:= SX5->(GetArea())
	default nivel := ""	
	
	::nivel := nivel
	::descri := ""
	
	SX5->(dbsetorder(1))
	if SX5->(dbseek(xFilial("SX5") + "T6" + nivel))
		::nivel 	:= SX5->X5_CHAVE
		::descri 	:= SX5->X5_DESCRI
	endif
	
	RestArea(aAreaSX5)
	
return

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class SX5Nivel

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
	
	if AttIsMemberOf(oJsonParam,"nivel")
		cWhere += "AND X5_CHAVE LIKE '%" + oJsonParam:nivel + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"descri")
		cWhere += "AND X5_DESCRI LIKE '%" + oJsonParam:descri + "%' "
	endif
	
	cQuery +=  "SELECT X5_CHAVE, X5_DESCRI FROM "+ RetSqlName("SX5") +" SX5 "
	cQuery +=  "WHERE SX5.D_E_L_E_T_ = '' "
	cQuery +=  " AND X5_TABELA = 'T6' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,SX5Nivel():New((cAliQry)->X5_CHAVE))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet