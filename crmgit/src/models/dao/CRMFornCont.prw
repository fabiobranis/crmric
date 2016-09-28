#include 'protheus.ch'

/*/{Protheus.doc} CRMFornCont
(long_description)
@author fabio
@since 11/09/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMFornCont 
	
	data empname
	data empender
	data empbairro
	data empfone
	data empcep
	data empmun
	data empuf
	data empcnpj
	data empinscr
	
	method new() constructor 

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
method new() class CRMFornCont
	
	::empname   := SM0->M0_NOMECOM
	::empender  := SM0->M0_ENDCOB
	::empbairro := SM0->M0_BAIRCOB
	::empfone   := SM0->M0_TEL
	::empcep    := SM0->M0_CEPCOB
	::empmun    := SM0->M0_CIDCOB
	::empuf     := SM0->M0_ESTCOB
	::empcnpj   := SM0->M0_CGC
	::empinscr  := SM0->M0_INSC		
	
return