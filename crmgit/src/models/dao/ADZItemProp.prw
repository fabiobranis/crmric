#include 'protheus.ch'

/*/{Protheus.doc} ADZItemProp
(long_description)
@author fabiobranis
@since 27/04/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class ADZItemProp 

	data filial
	data item
	data produto
	data qtdven
	data prcven
	data prctab
	data xprcve
	data total
	data descon
	data xforma
	data xaltur
	data xcolun
	data xpagin
	data xtpvei
	data xpraca
	data xfilpv
	data xmesex
	data xdeter
	data tes
	data condpg
	data moeda
	data valdes
	data dt1ven
	data orcame
	data propos
	data revisa
	data um
	data xprctb
	data xtabpr
	data deleta

	method new(propos,item) constructor
	method setProperties(propos,item)

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
method new(propos,item) class ADZItemProp
	
	default propos := ""
	default item := ""
	
	::filial := xFilial("ADZ")
	::deleta := .F.
	
	if !::setProperties(propos,item)
		::item    := item
		::produto := ""
		::qtdven  := 0
		::prcven  := 0
		::prctab  := 0
		::xprcve  := 0
		::total   := 0
		::descon  := 0
		::xforma  := 0
		::xaltur  := 0
		::xcolun  := 0
		::xpagin  := ""
		::xtpvei  := ""
		::xpraca  := ""
		::xfilpv  := ""
		::xmesex  := ""
		::xdeter  := ""
		::tes     := ""
		::condpg  := ""
		::moeda   := "1"
		::valdes  := 0
		::dt1ven  := ctod("")
		::orcame  := ""
		::propos  := propos
		::revisa  := ""
		::um      := ""
		::xprctb  := 0
		::xtabpr  := ""
	endif
	
return ::self

method setProperties(propos,item) class ADZItemProp

	ADZ->(dbsetorder(2))
	if ADZ->(dbseek(xFilial("ADZ") + propos + item))
		::item    := ADZ->ADZ_ITEM
		::produto := ADZ->ADZ_PRODUT
		::qtdven  := ADZ->ADZ_QTDVEN
		::prcven  := ADZ->ADZ_PRCVEN
		::prctab  := ADZ->ADZ_PRCTAB
		::xprcve  := ADZ->ADZ_XPRCVE
		::total   := ADZ->ADZ_TOTAL
		::descon  := ADZ->ADZ_DESCON
		::xforma  := ADZ->ADZ_XFORMA
		::xaltur  := ADZ->ADZ_XALTUR
		::xcolun  := ADZ->ADZ_XCOLUN
		::xpagin  := ADZ->ADZ_XPAGIN
		::xtpvei  := ADZ->ADZ_XTPVEI
		::xpraca  := ADZ->ADZ_XPRACA
		::xfilpv  := ADZ->ADZ_XFILPV
		::xmesex  := ADZ->ADZ_XMESEX
		::xdeter  := ADZ->ADZ_XDETER
		::tes     := ADZ->ADZ_TES
		::condpg  := ADZ->ADZ_CONDPG
		::moeda   := ADZ->ADZ_MOEDA
		::valdes  := ADZ->ADZ_VALDES
		::dt1ven  := ADZ->ADZ_DT1VEN
		::orcame  := ADZ->ADZ_ORCAME
		::propos  := ADZ->ADZ_PROPOS
		::revisa  := ADZ->ADZ_REVISA
		::um      := ADZ->ADZ_UM
		::xprctb  := ADZ->ADZ_XPRCTB
		::xtabpr  := ADZ->ADZ_XTABPR

		return.T.

	endif

return .F.