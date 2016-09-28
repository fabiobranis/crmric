#include 'protheus.ch'

/*/{Protheus.doc} CRMCliCont
(long_description)
@author fabio
@since 11/09/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMCliCont 
	
	data codigo
	data clinome
	data cliender
	data climun
	data cliuf
	data clicep
	data cliinscr
	data clicnpj
	data clitel
	data cliddd
	data clirespctr
	
	method new(codigo) constructor 

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
method new(codigo) class CRMCliCont
	
	SA1->(dbsetorder(1))
	if SA1->(dbseek(xFilial("SA1") + codigo))
		::codigo     := SA1->A1_COD
		::clinome    := SA1->A1_NOME
		::cliender   := SA1->A1_END
		::climun     := SA1->A1_MUN
		::cliuf      := SA1->A1_EST
		::clicep     := SA1->A1_CEP
		::cliinscr   := SA1->A1_INSCR
		::clicnpj    := SA1->A1_CGC
		::cliddd	 := SA1->A1_DDD
		::clitel     := SA1->A1_TEL
		::clirespctr := SA1->A1_CONTATO
	else
		::codigo     := ""
		::clinome    := ""
		::cliender   := ""
		::climun     := ""
		::cliuf      := ""
		::clicep     := ""
		::cliinscr   := ""
		::clicnpj    := ""
		::cliddd	 := ""
		::clitel     := ""
		::clirespctr := ""
	endif
return