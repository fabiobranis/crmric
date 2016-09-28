#include 'protheus.ch'

/*/{Protheus.doc} ZAACalendario
(long_description)
@author fabiobranis
@since 27/04/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class ZAACalendario 

	data filial
	data itprop
	data propos
	data dtexib
	data qtde
	data deleta

	method new(propos,itprop,dtexib) constructor
	method setProperties(propos,itprop,dtexib)

endclass

/*/{Protheus.doc} new
Metodo construtor
@author fabiobranis
@since 27/04/2016 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method new(propos,itprop,dtexib) class ZAACalendario
	
	default dtexib := ctod("")
	default propos := ""
	default itprop := ""
	
	::filial := xFilial("ZAA")
	::deleta := .F.
	
	if !::setProperties(propos,itprop,dtexib)
		::itprop  := itprop
		::propos  := propos
		::dtexib  := dtexib
		::qtde	  := 0
	endif
	
return ::self

method setProperties(propos,itprop,dtexib) class ZAACalendario

	ZAA->(dbsetorder(1))
	if ZAA->(dbseek(xFilial("ZAA") + propos + itprop + dtos(dtexib)))
		::itprop  := ZAA->ZAA_ITPROP
		::propos  := ZAA->ZAA_PROPOS
		::dtexib  := ZAA->ZAA_DTEXIB
		::qtde	  := ZAA->ZAA_QTDE
		return.T.

	endif

return .F.