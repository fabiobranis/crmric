#include 'protheus.ch'

/*/{Protheus.doc} new_advpl_class
(long_description)
@author Fabio
@since 09/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SA3Vendedor

	method new(idusr) constructor 
	method isVend()
	data filial
	data idusr
	data cod
	data nome
	data email

endclass

/*/{Protheus.doc} new
Metodo construtor
@author Fabio
@since 09/05/2016 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method new(idusr) class SA3Vendedor
	
	SA3->(dbsetorder(7))
	if SA3->(dbseek(xFilial("SA3") + idusr))
		
		::filial  	:= xFilial("SA3")
		::idusr		:= SA3->A3_CODUSR
		::cod		:= SA3->A3_COD
		::nome		:= SA3->A3_NOME
		::email		:= SA3->A3_EMAIL
		
	endif
	
return self

method isVend() class SA3Vendedor

return !empty(::idusr)