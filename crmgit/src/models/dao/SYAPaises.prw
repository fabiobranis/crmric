#include 'protheus.ch'

/*/{Protheus.doc} SYAPaises
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SYAPaises 
	
	data codgi
	data descr
	
	method new(codgi,descr) constructor 
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
method new(codgi,descr) class SYAPaises
	
	::codgi 	:= codgi
	::descr 	:= descr
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class SYAPaises

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"YA_CODGI, YA_DESCR"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"codgi")
		cWhere += "AND YA_CODGI LIKE '%" + oJsonParam:codgi + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"descr")
		cWhere += "AND YA_DESCR LIKE '%" + oJsonParam:descr + "%' "
	endif
	
	cQuery +=  "SELECT YA_CODGI, YA_DESCR FROM "+ RetSqlName("SYA") +" SYA "
	cQuery +=  "WHERE SYA.D_E_L_E_T_ = '' "
	cQuery +=  " AND YA_FILIAL = '"+ xFilial("SYA")+"' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,SYAPaises():New((cAliQry)->YA_CODGI,(cAliQry)->YA_DESCR))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet