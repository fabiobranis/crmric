#include 'protheus.ch'

/*/{Protheus.doc} ZAEPropFilial
(long_description)
@author fabiobranis
@since 27/04/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class ZAEPropFilial 

	data filial
	data numprc
	data filprp
	data propos
	data deleta

	method new(numprc,filprp,propos) constructor
	method setProperties(numprc,filprp,propos)

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
method new(numprc,filprp,propos) class ZAEPropFilial
	
	default propos := GetCodADY(filprp)
	
	::filial := xFilial("ZAE")
	::deleta := .F.
	
	if !::setProperties(numprc,filprp,propos)
		::numprc  := numprc
		::filprp  := filprp
		::propos  := propos
	endif
	
return ::self

method setProperties(numprc,filprp,propos) class ZAEPropFilial

	ZAE->(dbsetorder(1))
	if ZAE->(dbseek(xFilial("ZAE") + numprc + filprp + propos))
		::numprc  := ZAE->ZAE_NUMPRC
		::filprp  := ZAE->ZAE_FILPRP
		::propos  := ZAE->ZAE_PROPOS
		return.T.

	endif

return .F.

static function GetCodADY(cFilProp)
	
	Local aAreaADY	:= ADY->(GetArea())
	Local cCodNovo  := StrZero(1,TamSx3("ADY_PROPOS")[1])
	
	ADY->(dbsetorder(1))
	while ADY->(dbseek(cFilProp + cCodNovo))
		
		cCodNovo := soma1(cCodNovo)
	enddo
	RestArea(aAreaADY)
	
return cCodNovo