#include 'protheus.ch'

/*/{Protheus.doc} CRMVeiculaCont
(long_description)
@author fabio
@since 11/09/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMVeiculaCont 
	
	data propos
	data itemprop
	data dtveic
	data diaveic
	data quantveic
	
	method new(cNumPropos,cItem,dDataVeic) constructor 

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
method new(cNumPropos,cItem,dDataVeic) class CRMVeiculaCont
	
	ZAA->(dbsetorder(1))
	if ZAA->(dbseek(xFilial("ZAA") + cNumPropos + cItem + dtos(dDataVeic)))
		::propos	:= ZAA->ZAA_PROPOS
		::itemprop	:= ZAA->ZAA_ITPROP
		::dtveic	:= ZAA->ZAA_DTEXIB
		::diaveic	:= day(ZAA->ZAA_DTEXIB)
		::quantveic	:= ZAA->ZAA_QTDE
	endif
return self