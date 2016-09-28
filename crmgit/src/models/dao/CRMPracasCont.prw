#include 'protheus.ch'

/*/{Protheus.doc} CRMPracasCont
(long_description)
@author fabio
@since 08/09/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMPracasCont 
	
	data filial
	data propos
	data pracanome
	data periodo
	data numpi
	data identmater
	data tpfaturam
	
	method new(cFilCod,cNumPropos) constructor 

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
method new(cFilCod,cNumPropos) class CRMPracasCont
	
	local aAreaADY		:= ADY->(GetArea())
	local aAreaSM0		:= SM0->(GetArea())
	
	SM0->(dbsetorder(1))
	SM0->(dbseek(SM0->M0_CODIGO + cFilCod))
	
	ADY->(dbsetorder(1))
	if ADY->(dbseek(cFilCod + cNumPropos))
		::filial	 := cFilCod
		::propos	 := cNumPropos
		::pracanome	 := SM0->M0_NOMECOM
		::periodo	 := ctod("")
		::numpi		 := ADY->ADY_XNUMPI
		::identmater := ADY->ADY_XMATER
		::tpfaturam	 := ADY->ADY_XTPFAT
	endif
	
	RestArea(aAreaADY)
	RestArea(aAreaSM0)
	
return self