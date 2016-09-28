#include 'protheus.ch'

/*/{Protheus.doc} SM0EmpConsulta
(long_description)
@author Fabio
@since 19/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SM0EmpConsulta 
	
	data codemp
	data nomeemp
	data codfil
	data nomefil
	
	method new(codemp,nomeemp,codfil,nomefil) constructor 
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
method new(codemp,nomeemp,codfil,nomefil) class SM0EmpConsulta
	
	::codemp 	:= codemp
	::nomeemp	:= nomeemp
	::codfil	:= codfil
	::nomefil	:= nomefil
	
return self

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class SM0EmpConsulta

	Local aEmprRet		:= FWLoadSM0()
	Local aSortedRet	:= {}
	Local aFilteredRet	:= {}
	Local aEmpData		:= {}
	Local ni			:= 0
	Local bOrder		:= nil
	Local nTotalRegs	:= 0
	Local aRet			:= {}
	Local cTerm			:= ""
	Local cPropName		:= ""
	Local aProps		:= {"codemp","nomeemp","codfil","nomefil"}
	Local nTermFilt		:= 0
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	bOrder := iif(cDirection == "ASC",{|x,y| x[nOrder] < y[nOrder]}, {|x,y| x[nOrder] > y[nOrder]})
	
	if AttIsMemberOf(oJsonParam,"codfil")
		cPropName := "codfil"
		cTerm := oJsonParam:codfil
	endif
	if AttIsMemberOf(oJsonParam,"nomefil")
		cPropName := "nomefil"
		cTerm := oJsonParam:nomefil
	endif
	
	nTermFilt := ascan(aProps,cPropName)
	
	for ni := 1 to len(aEmprRet)
		aadd(aEmpData,{aEmprRet[ni][3],aEmprRet[ni][6],aEmprRet[ni][2],aEmprRet[ni][7]})
	next
	
	aSortedRet := asort(aEmpData,,,bOrder)
	
	if nTermFilt > 0
		for ni := 1 to len(aSortedRet)
			if cTerm $ aSortedRet[ni][nTermFilt]
				aadd(aFilteredRet,aSortedRet[ni])
			endif
		next
	else
		aFilteredRet := aClone(aSortedRet)
	endif
	
	nTotalRegs := len(aSortedRet)
	
	for ni := 1 to nPageLength
		if ni <= len(aFilteredRet)
			aadd(aRet,SM0EmpConsulta():New(aFilteredRet[ni][1],aFilteredRet[ni][2],aFilteredRet[ni][3],aFilteredRet[ni][4]))
		endif
	next
	
return aRet