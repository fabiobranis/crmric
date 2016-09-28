#include 'protheus.ch'

/*/{Protheus.doc} CRMContCliSite
(long_description)
@author fabio
@since 13/06/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMContCliSite 

	data erroAuto
	data attr
	data nFilteredRegs
	data nTotRegs
	
	method new() constructor 
	method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection)

endclass

/*/{Protheus.doc} new
Metodo construtor
@author fabio
@since 13/06/2016 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method new() class CRMContCliSite

	::attr 		:= {}
	::erroAuto 	:= ""
	::nFilteredRegs := 0
	::nTotRegs	:= 0
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class CRMContCliSite

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"U5_CODCONT", "U5_CONTAT", "U5_CPF"}
	local aRet			:= {}
	local cWhere		:= ""
	local cCliCod		:= ""
	local nFilter		:= 0
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"codcont")
		cWhere += "AND U5_CODCONT LIKE '%" + oJsonParam:codcont + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"contat")
		cWhere += "AND U5_CONTAT LIKE '%" + oJsonParam:contat + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"cpf")
		cWhere += "AND U5_CPF LIKE '%" + oJsonParam:cpf + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"cod") .and. AttIsMemberOf(oJsonParam,"loja")
		cCliCod := oJsonParam:cod + space(1) + oJsonParam:loja
	endif
	
	cQuery +=  " SELECT "
	cQuery +=  " (SELECT COUNT(*) FROM "+ RetSqlName("AC8") +"  TOT WHERE TOT.AC8_CODENT = '" + cCliCod + "' AND TOT.D_E_L_E_T_ = '') AS TOT_RECS,"
	cQuery +=  " U5_CODCONT, U5_CONTAT, U5_CPF FROM "+ RetSqlName("SU5") +" SU5 "
	cQuery +=  " INNER JOIN "+ RetSqlName("AC8") +" AC8 "
	cQuery +=  " ON AC8_CODCON = U5_CODCONT "
	cQuery +=  " AND AC8_FILIAL = '" + xFilial("AC8") + "' "
	cQuery +=  " AND AC8_ENTIDA = 'SA1' "
	cQuery +=  " AND AC8_CODENT = '" + cCliCod + "' "
	cQuery +=  " AND AC8.D_E_L_E_T_ = '' "
	cQuery +=  " WHERE U5_FILIAL = '" + xFilial("SU5") + "' "
	cQuery +=  " AND SU5.D_E_L_E_T_ = '' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	::nTotRegs := (cAliQry)->TOT_RECS
	//::nFilteredRegs := (cAliQry)->TOT_RECS
	while (cAliQry)->(!(eof()))
		nFilter++
		aadd(aRet,SU5Contatos():New((cAliQry)->U5_CODCONT,.T.))
		(cAliQry)->(dbskip())
	enddo
	::nFilteredRegs := nFilter
	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet