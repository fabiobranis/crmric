#include 'protheus.ch'

/*/{Protheus.doc} CRMContratoSite
(long_description)
@author fabio
@since 08/09/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMContratoSite 

	data attr
		
	method new() constructor 
	method HasData(oProposta)

endclass

/*/{Protheus.doc} new
Metodo construtor
@author fabio
@since 08/09/2016 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method new() class CRMContratoSite
	attr := {}
return

method HasData(oProposta) class CRMContratoSite
	
	Local aAreaADZ	:= ADZ->(GetArea())
	Local lRet		:= .T.
	
	ADZ->(dbsetorder(1))
	lRet := ADZ->(dbseek(xFilial("ADZ") + padr(oProposta:propos,TamSx3("ADZ_PROPOS")[1],"")))
	
	RestArea(aAreaADZ)
	
return lRet