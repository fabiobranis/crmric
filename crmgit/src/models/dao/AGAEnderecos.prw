#include 'protheus.ch'

/*/{Protheus.doc} AGAEnderecos
(long_description)
@author fabiobranis
@since 27/04/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class AGAEnderecos 

	data filial
	data codigo
	data entida
	data codent
	data tipo
	data padrao
	data ender
	data cep
	data bairro
	data mundes
	data est
	data mun
	data pais
	data comp
	data deleta

	method new(codent,codigo) constructor
	method setProperties(codent,codigo)

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
method new(codent,codigo) class AGAEnderecos

	Local aArea		:= AGA->(GetArea())
	default codigo := GetCodAGA(GetSxeNum("AGA","AGA_CODIGO"))
	
	if empty(codigo)
		codigo := GetCodAGA(GetSxeNum("AGA","AGA_CODIGO"))
	endif
	
	::filial := xFilial("AGA")
	::deleta := .F.
	
	if !::setProperties(codent,codigo)
		::entida  	:= "SU5"
		::codent 	:= codent
		::codigo	:= codigo
		::tipo		:= ""
		::padrao	:= ""
		::ender		:= ""
		::cep		:= ""
		::bairro	:= ""
		::mundes	:= ""
		::est		:= ""
		::mun		:= ""
		::pais		:= ""
		::comp		:= ""
	endif
	
	RestArea(aArea)
	
return ::self

method setProperties(codent,codigo) class AGAEnderecos

	AGA->(dbordernickname("CRMEND"))
	if AGA->(dbseek(xFilial("AGA") + "SU5" + padr(codent,TamSx3("AGA_CODENT")[1],"") + codigo))
		
		::codent	:= AGA->AGA_CODENT
		::entida	:= AGA->AGA_ENTIDA
		::codigo	:= AGA->AGA_CODIGO
		::tipo		:= AGA->AGA_TIPO
		::padrao	:= AGA->AGA_PADRAO
		::ender		:= AGA->AGA_END
		::cep		:= AGA->AGA_CEP	
		::bairro	:= AGA->AGA_BAIRRO
		::mundes	:= AGA->AGA_MUNDES
		::est		:= AGA->AGA_EST
		::mun		:= AGA->AGA_MUN
		::pais		:= AGA->AGA_PAIS
		::comp		:= AGA->AGA_COMP

		return.T.

	endif

return .F.

static function GetCodAGA(cCodAGA)
	
	Local aAreaAGA	:= AGA->(GetArea())
	Local cCodNovo  := cCodAGA
	
	AGA->(dbsetorder(2))
	while AGA->(dbseek(xFilial("AGA") + cCodNovo))
		
		cCodNovo := soma1(cCodNovo)
	enddo
	RestArea(aAreaAGA)
	
return cCodNovo