#include 'protheus.ch'

/*/{Protheus.doc} SX5Estados
(long_description)
@author Fabio
@since 15/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SX5Estados 
	
	data uf
	data nome
		
	method new(uf) constructor 
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
method new(uf) class SX5Estados
	
	Local aAreaSX5	:= SX5->(GetArea())
	default uf := ""	
	
	::uf := uf
	::nome := ""
	
	SX5->(dbsetorder(1))
	if SX5->(dbseek(xFilial("SX5") + "12" + uf))
		::uf 	:= SX5->X5_CHAVE
		::nome 	:= SX5->X5_DESCRI
	endif
	
	RestArea(aAreaSX5)
	
return

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class SX5Estados

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
	
	if AttIsMemberOf(oJsonParam,"est")
		cWhere += "AND X5_CHAVE LIKE '%" + oJsonParam:est + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"nome")
		cWhere += "AND X5_DESCRI LIKE '%" + oJsonParam:nome + "%' "
	endif
	
	cQuery +=  "SELECT X5_CHAVE, X5_DESCRI FROM "+ RetSqlName("SX5") +" SX5 "
	cQuery +=  "WHERE SX5.D_E_L_E_T_ = '' "
	cQuery +=  " AND X5_TABELA = '12' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,SX5Estados():New((cAliQry)->X5_CHAVE))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet