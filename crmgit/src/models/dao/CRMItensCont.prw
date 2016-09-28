#include 'protheus.ch'

/*/{Protheus.doc} CRMItensCont
(long_description)
@author fabio
@since 08/09/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMItensCont 
	
	data codprod
	data produto
	data xforma
	data xcolun
	data xaltur
	data xpagina
	data ins
	data iadom
	data iaind
	data tlpsatin
	data grp
	data prctab
	data descont
	data prcunneg
	data prctottab
	data totalneg
	data aveicula
	
	method new(item,propos) constructor 

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
method new(item,propos) class CRMItensCont
	
	ADZ->(dbsetorder(1))
	if ADZ->(dbseek(xFilial("ADZ") + item + propos))
		::codprod   := ADZ->ADZ_PRODUT
		::produto   := Posicione("SB1",1,xFilial("SB1") + ADZ->ADZ_PRODUT,"B1_DESC")
		::xforma    := ADZ->ADZ_XFORMA
		::xcolun	:= ADZ->ADZ_XCOLUN
		::xaltur	:= ADZ->ADZ_XALTUR
		::xpagina	:= ADZ->ADZ_XPAGIN
		::ins       := 0
		::iadom     := Posicione("DA1",1,xFilial("DA1") + ADZ->ADZ_XTABPR + ADZ->ADZ_PRODUT,"DA1_XIADOM")
		::iaind		:= Posicione("DA1",1,xFilial("DA1") + ADZ->ADZ_XTABPR + ADZ->ADZ_PRODUT,"DA1_XSHRDO")
		::tlpsatin  := 0
		::grp       := 0
		::prctab    := ADZ->ADZ_PRCTAB
		::descont   := ADZ->ADZ_TOTAL * (ADZ->ADZ_DESCON/100) //ADZ->ADZ_VALDES
		::prcunneg  := ADZ->ADZ_PRCVEN
		::prctottab := ADZ->ADZ_PRCTAB * ADZ->ADZ_QTDVEN
		::totalneg  := ADZ->ADZ_TOTAL
		::aveicula	:= {}
		ZAA->(dbsetorder(1))
		if ZAA->(dbseek(xFilial("ZAA") + ADZ->(ADZ_PROPOS + ADZ_ITEM)))
			while ZAA->(!eof()) .and. ZAA->(ZAA_FILIAL + ZAA_PROPOS + ZAA_ITPROP) == ADZ->(ADZ_FILIAL + ADZ_PROPOS + ADZ_ITEM)
				aadd(::aveicula,CRMVeiculaCont():New(ZAA->ZAA_PROPOS,ZAA->ZAA_ITPROP,ZAA->ZAA_DTEXIB))
				ZAA->(dbskip())
			enddo
		endif
	else
		::codprod   := ""
		::produto   := ""
		::xforma    := 0
		::xcolun	:= 0
		::xaltur	:= 0
		::xpagina	:= 0
		::ins       := 0
		::iadom     := 0
		::iaind		:= 0
		::tlpsatin  := 0
		::grp       := 0
		::prctab    := 0
		::descont   := 0
		::prcunneg  := 0
		::prctottab := 0
		::totalneg  := 0
		::aveicula  := {}
	endif
return