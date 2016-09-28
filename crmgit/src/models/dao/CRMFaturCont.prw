#include 'protheus.ch'

/*/{Protheus.doc} CRMFaturCont
(long_description)
@author fabio
@since 11/09/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMFaturCont 
	
	data parcela
	data valor
	data vencto
	
	method new(parcela,valor,vencto) constructor 

endclass

/*/{Protheus.doc} new
Metodo construtor
@author fabio
@since 11/09/2016 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method new(parcela,valor,vencto) class CRMFaturCont
	::parcela 	:= parcela
	::valor		:= valor
	::vencto	:= vencto
return self