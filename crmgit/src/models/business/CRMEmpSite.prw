#include 'protheus.ch'

/*/{Protheus.doc} CRMEmpSite
(long_description)
@author Fabio
@since 10/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMEmpSite 
	
	data codemp
	data nomeemp
	data codfil
	data nomefil
	
	method new(codemp,nomeemp,codfil,nomefil) constructor 
	
endclass

/*/{Protheus.doc} new
Metodo construtor
@author Fabio
@since 10/05/2016 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method new(codemp,nomeemp,codfil,nomefil) class CRMEmpSite
	
	::codemp 	:= codemp
	::nomeemp	:= nomeemp
	::codfil	:= codfil
	::nomefil	:= nomefil
	
return self