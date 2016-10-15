#include 'protheus.ch'

/*/{Protheus.doc} DA1TabPrecoItem
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class DA1TabPrecoItem 
	
	data filial
	data item
	data codtab
	data codpro
	data desc
	data prcven
	data vlrdes
	data grupo
	data prcbas
	data refgrd
	data perdes
	data ativo
	data estado
	data tpoper
	data qtdlot
	data indlot
	data moeda
	data prcmax
	
	method new(cAliasTab) constructor 
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
method new(cAliasTab) class DA1TabPrecoItem
	if !(empty(cAliasTab))
		::filial := (cAliasTab)->DA1_FILIAL
		::item   := (cAliasTab)->DA1_ITEM	
		::codtab := (cAliasTab)->DA1_CODTAB 	
		::codpro := (cAliasTab)->DA1_CODPRO 	
		::desc   := (cAliasTab)->B1_DESC 	
		::prcven := (cAliasTab)->DA1_PRCVEN 	
		::vlrdes := (cAliasTab)->DA1_VLRDES
		::grupo  := (cAliasTab)->DA1_GRUPO
		::refgrd := (cAliasTab)->DA1_REFGRD
		::perdes := (cAliasTab)->DA1_PERDES
		::ativo  := (cAliasTab)->DA1_ATIVO
		::estado := (cAliasTab)->DA1_ESTADO
		::tpoper := (cAliasTab)->DA1_TPOPER
		::qtdlot := (cAliasTab)->DA1_QTDLOT
		::indlot := (cAliasTab)->DA1_INDLOT
		::moeda  := (cAliasTab)->DA1_MOEDA
		::prcmax := (cAliasTab)->DA1_PRCMAX
	endif
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class DA1TabPrecoItem

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"DA1_ITEM","DA1_CODPRO", "B1_DESC", "DA1_ESTADO"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"filial")
		cWhere += "AND DA1_FILIAL = '" + oJsonParam:filial + "' "
	endif
	
	if AttIsMemberOf(oJsonParam,"codtab")
		cWhere += "AND DA1_CODTAB LIKE '%" + oJsonParam:codtab + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"item")
		cWhere += "AND DA1_ITEM LIKE '%" + oJsonParam:item + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"codpro")
		cWhere += "AND DA1_CODPRO LIKE '%" + oJsonParam:codpro + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"desc")
		cWhere += "AND B1_DESC LIKE '%" + oJsonParam:desc + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"estado")
		cWhere += "AND DA1_ESTADO LIKE '%" + oJsonParam:estado + "%' "
	endif
	
	cQuery +=  "SELECT DA1_FILIAL, DA1_ITEM, DA1_CODTAB, DA1_CODPRO, B1_DESC, DA1_PRCVEN, DA1_VLRDES, DA1_GRUPO, DA1_REFGRD, DA1_PERDES, DA1_ATIVO, DA1_ESTADO, DA1_TPOPER, DA1_QTDLOT, DA1_INDLOT ,DA1_MOEDA, DA1_PRCMAX FROM "+ RetSqlName("DA1") +" DA1 "
	cQuery +=  " INNER JOIN "+ RetSqlName("SB1") +" SB1 "
	cQuery +=  " ON B1_FILIAL = '"+ xFilial("SB1")+"' "
	cQuery +=  " AND B1_COD = DA1_CODPRO "
	cQuery +=  " AND SB1.D_E_L_E_T_ = '' "
	cQuery +=  "WHERE DA1.D_E_L_E_T_ = '' "
	cQUery += cWhere
	//cQuery +=  " AND DA1_FILIAL = '"+ xFilial("DA1")+"' "
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,DA1TabPrecoItem():New(cAliQry))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet