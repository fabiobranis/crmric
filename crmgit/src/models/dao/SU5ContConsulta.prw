#include 'protheus.ch'

/*/{Protheus.doc} SU5ContConsulta
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SU5ContConsulta 
	
	data codcont
	data contat
	data cpf
	data est
	data mun
	data fone
	data email
	
	method new(codcont,contat,cpf,est,mun,fone,email) constructor 
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
method new(codcont,contat,cpf,est,mun,fone,email) class SU5ContConsulta
	
	::codcont 	:= codcont
	::contat 	:= contat
	::cpf		:= cpf
	::est		:= est
	::mun		:= mun
	::fone		:= fone
	::email		:= email
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class SU5ContConsulta

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"U5_CODCONT", "U5_CONTAT", "U5_CPF","U5_EST","U5_MUN","U5_FONE","U5_EMAIL"}
	local aRet			:= {}
	local cWhere		:= ""
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
	
	if AttIsMemberOf(oJsonParam,"est")
		cWhere += "AND U5_EST LIKE '%" + oJsonParam:est + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"mun")
		cWhere += "AND U5_MUN LIKE '%" + oJsonParam:mun + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"fone")
		cWhere += "AND U5_FONE LIKE '%" + oJsonParam:fone + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"email")
		cWhere += "AND U5_EMAIL LIKE '%" + oJsonParam:email + "%' "
	endif
	
	cQuery +=  "SELECT U5_CODCONT, U5_CONTAT, U5_CPF,U5_EST,U5_MUN,U5_FONE,U5_EMAIL FROM "+ RetSqlName("SU5") +" SU5 "
	cQuery +=  "WHERE SU5.D_E_L_E_T_ = '' "
	cQUery += cWhere
	cQuery +=  " AND U5_FILIAL = '"+ xFilial("SU5")+"' "
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	while (cAliQry)->(!(eof()))
		
		aadd(aRet,SU5ContConsulta():New((cAliQry)->U5_CODCONT,(cAliQry)->U5_CONTAT,(cAliQry)->U5_CPF,(cAliQry)->U5_EST,(cAliQry)->U5_MUN,(cAliQry)->U5_FONE,(cAliQry)->U5_EMAIL))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet