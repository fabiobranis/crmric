#include 'protheus.ch'

/*/{Protheus.doc} AGBTelefones
(long_description)
@author fabiobranis
@since 27/04/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class AGBTelefones 

	data filial as string
	data codigo
	data entida
	data codent
	data tipo
	data padrao
	data ddd
	data telefo
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
method new(codent,codigo) class AGBTelefones
	
	Local aArea		:= AGB->(GetArea())
	default codigo := GetCodAGB(GetSxeNum("AGB","AGB_CODIGO"))
	
	if empty(codigo)
		codigo := GetCodAGB(GetSxeNum("AGB","AGB_CODIGO"))
	endif
	
	::filial := xFilial("AGB")
	::deleta := .F.
	
	if !::setProperties(codent,codigo)
		::entida 	:= "SU5"
		::codent 	:= codent
		::codigo 	:= codigo
		::tipo		:= ""
		::padrao	:= ""
		::ddd		:= ""	
		::telefo	:= ""
		::comp		:= ""
	endif
	RestArea(aArea)
	
return ::self

method setProperties(codent,codigo) class AGBTelefones

	AGB->(dbordernickname("CRMTEL"))
	if AGB->(dbseek(xFilial("AGB") + "SU5" + padr(codent,TamSx3("AGB_CODENT")[1],"") + codigo))
		::codent	:= AGB->AGB_CODENT
		::entida	:= AGB->AGB_ENTIDA
		::codigo 	:= AGB->AGB_CODIGO
		::tipo		:= AGB->AGB_TIPO
		::padrao	:= AGB->AGB_PADRAO
		::ddd		:= AGB->AGB_DDD	
		::telefo	:= AGB->AGB_TELEFO
		::comp		:= AGB->AGB_COMP
		
		return .T.
		
	endif

return .F.

static function GetCodAGB(cCodAGB)
	
	Local aAreaAGB	:= AGB->(GetArea())
	Local cCodNovo  := cCodAGB
	
	AGB->(dbsetorder(2))
	while AGB->(dbseek(xFilial("AGB") + cCodNovo))
		
		cCodNovo := soma1(cCodNovo)
	enddo
	RestArea(aAreaAGB)
	
return cCodNovo