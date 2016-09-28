#include 'protheus.ch'

/*/{Protheus.doc} CRMAgenCont
(long_description)
@author fabio
@since 11/09/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMAgenCont 
	
	data razaosoc
	data codigo
	data endereco
	data cidade
	data uf
	data cep	
	data cnpj
	data inscr
	data atcomerc
	data ddd	
	data telefone	
	
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
method new(codigo) class CRMAgenCont

	SA3->(dbsetorder(1))
	if SA3->(dbseek(xFilial("SA3") + codigo))
		::razaosoc := SA3->A3_NREDUZ
		::codigo   := SA3->A3_COD
		::endereco := SA3->A3_END 
		::cidade   := SA3->A3_MUN
		::uf       := SA3->A3_EST
		::cep	   := SA3->A3_CEP
		::cnpj     := SA3->A3_CGC
		::inscr    := SA3->A3_INSCR
		::atcomerc := SA3->A3_NREDUZ
		::ddd	   := SA3->A3_DDD
		::telefone := SA3->A3_TEL
	else
		::razaosoc := ""
		::codigo   := ""
		::endereco := ""
		::cidade   := ""
		::uf       := ""
		::cep	   := ""
		::cnpj     := ""
		::inscr    := ""
		::atcomerc := ""
		::ddd	   := ""
		::telefone := ""
	endif
return