#include 'protheus.ch'

/*/{Protheus.doc} ADYProposta
(long_description)
@author fabiobranis
@since 24/04/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class ADYProposta 
	
	data filial
	data propos
	data entida
	data codigo
	data loja
	data orcame
	data status
	data datprop
	data previs
	data vend
	data xnumpi
	data xmater
	data xtpfat
	data dtrevi
	data condpg
	data xagenc
	data client
	data lojent

	// atributos ded associação simples com os objetos que irão compor os contatos
	data aItemProposta
	data aCalendario
	data aFilialProp
	
	method new(codcont) constructor 
	method setProperties(codcont)
	
	// adiciona os contatos
	method aaddItemProp(oADZItemProp)
	method aaddCalendario(oZAACalendario)
	method aaddFilProp(oZAEFilProp)
	method getItemPos(cItem,cPropos)
	method getCalendPos(dDataExib,cItem,cPropos)
	method getFilPos(cNumPrc,cFilProp)
	method altItemByPos(nPosItem,oADZItemProp) 
	method altCaleByPos(nPosCale,oZAACalendario) 
	method altFilPropByPos(nPosFil,oZAEFilProp) 

	// retornam uma coleção dos objetos - array
	method getItemProp()
	method getCalendario()
	method getFilProp()
	
	method save()
	method delReg() 

endclass



/*/{Protheus.doc} new
Metodo construtor
@author fabiobranis
@since 24/04/2016 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method new(propos,lIsList) class ADYProposta
	
	default propos := GetCodADY(GetSxeNum("ADY","ADY_PROPOS"))
	default lIsList	:= .F.
	
	::aCalendario := {}
	::aItemProposta := {}
	::aFilialProp := {}
	::filial 	:= xFilial("ADY")
	
	if !::setProperties(propos,lIsList)
		::propos   := propos
		::entida   := "1"
		::codigo   := ""
		::loja     := ""
		::orcame   := ""
		::status   := ""
		::datprop  := ctod("")
		::previs   := ""
		::vend     := ""
		::xnumpi   := ""
		::xmater   := ""
		::xtpfat   := ""
		::dtrevi   := ctod("")
		::condpg   := "002"
		::xagenc   := ""
		::client   := ""
		::lojent   := ""
		
	endif

return ::self

/*/{Protheus.doc} setProperties
Método que define as propriedades da classe com base nos dados do banco
@author fabio
@since 27/09/2016
@version undefined
@param propos, string, código da proposta
@param lIsList, boolean, define se é listagem
/*/
method setProperties(propos,lIsList) class ADYProposta

	local oAux	:= nil
	local oModel := FWLoadModel("RIC73A01")
	local ni	:= 0
	local nj	:= 0
	
	private aItRef	:= {}
    private nPosIt	:= 0

	ADY->(dbsetorder(1))
	ADZ->(dbsetorder(2))
	ZAA->(dbsetorder(1))
	ZAE->(dbsetorder(1))
	
	if ADY->(dbseek(xFilial("ADY") + propos))
		
		// seto as propriedades pelo objeto modelo do MVC
		oModel:SetOperation(4)
		oModel:Activate()
		
		// cabeçalho
		::propos   := oModel:GetModel("ADYMASTER"):GetValue("ADY_PROPOS")
		::entida   := oModel:GetModel("ADYMASTER"):GetValue("ADY_ENTIDA")
		::codigo   := oModel:GetModel("ADYMASTER"):GetValue("ADY_CODIGO")
		::loja     := oModel:GetModel("ADYMASTER"):GetValue("ADY_LOJA")
		::orcame   := oModel:GetModel("ADYMASTER"):GetValue("ADY_ORCAME")
		::status   := oModel:GetModel("ADYMASTER"):GetValue("ADY_STATUS")
		::datprop  := oModel:GetModel("ADYMASTER"):GetValue("ADY_DATA")
		::previs   := oModel:GetModel("ADYMASTER"):GetValue("ADY_PREVIS")
		::vend     := oModel:GetModel("ADYMASTER"):GetValue("ADY_VEND")
		::xnumpi   := oModel:GetModel("ADYMASTER"):GetValue("ADY_XNUMPI")
		::xmater   := oModel:GetModel("ADYMASTER"):GetValue("ADY_XMATER")
		::xtpfat   := oModel:GetModel("ADYMASTER"):GetValue("ADY_XTPFAT")
		::dtrevi   := oModel:GetModel("ADYMASTER"):GetValue("ADY_DTREVI")
		::condpg   := oModel:GetModel("ADYMASTER"):GetValue("ADY_CONDPG")
		::xagenc   := oModel:GetModel("ADYMASTER"):GetValue("ADY_XAGENC")
		::client   := oModel:GetModel("ADYMASTER"):GetValue("ADY_CLIENT")
		::lojent   := oModel:GetModel("ADYMASTER"):GetValue("ADY_LOJENT")
		
		// itens
		for ni := 1 to oModel:GetModel("ADZDETAIL"):Length()
			oModel:GetModel("ADZDETAIL"):GoLine(ni)
			oAux := nil
			oAux := ADZItemProp():new()
			oAux:item    := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_ITEM")
			oAux:produto := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_PRODUT")
			oAux:qtdven  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_QTDVEN")
			oAux:prcven  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_PRCVEN")
			oAux:prctab  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_PRCTAB")
			oAux:xprcve  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_XPRCVE")
			oAux:total   := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_TOTAL")
			oAux:descon  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_DESCON")
			oAux:xforma  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_XFORMA")
			oAux:xaltur  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_XALTUR")
			oAux:xcolun  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_XCOLUN")
			oAux:xpagin  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_XPAGIN")
			oAux:xtpvei  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_XTPVEI")
			oAux:xpraca  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_XPRACA")
			oAux:xfilpv  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_XFILPV")
			oAux:xmesex  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_XMESEX")
			oAux:xdeter  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_XDETER")
			oAux:tes     := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_TES")
			oAux:condpg  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_CONDPG")
			oAux:moeda   := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_MOEDA")
			oAux:valdes  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_VALDES")
			oAux:dt1ven  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_DT1VEN")
			oAux:orcame  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_ORCAME")
			oAux:propos  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_PROPOS")
			oAux:revisa  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_REVISA")
			oAux:um      := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_UM")
			oAux:xprctb  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_XPRCTB")
			oAux:xtabpr  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_XTABPR")
			oAux:xprfat  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_XPRFAT")
			oAux:xfilfa  := oModel:GetModel("ADZDETAIL"):GetValue("ADZ_XFILFA")
			::aaddItemProp(oAux)
			
			// calendário de veiculação
			for nj := 1 to oModel:GetModel("ZAADETAIL"):Length()
				oModel:GetModel("ZAADETAIL"):GoLine(nj)
				oAux := nil
				oAux := ZAACalendario():new()
				oAux:itprop := oModel:GetModel("ZAADETAIL"):GetValue("ZAA_ITPROP")
				oAux:propos	:= oModel:GetModel("ZAADETAIL"):GetValue("ZAA_PROPOS")
				oAux:dtexib	:= oModel:GetModel("ZAADETAIL"):GetValue("ZAA_DTEXIB")
				oAux:qtde	:= oModel:GetModel("ZAADETAIL"):GetValue("ZAA_QTDE")
				::aaddCalendario(oAux)
			next
			
		next
		
		// desativo pois a classe já cumpriu seu papel
		oModel:DeActivate()
		aItRef	:= {}
		nPosIt	:= 0
		
		return .T.
	endif
	
return .F.

/*/{Protheus.doc} save
Método que persiste a proposta no banco
@author fabio
@since 27/09/2016
@version undefined
/*/
method save() class ADYProposta

	local cStrErro 	:= ""
	local oModel 	:= FWLoadModel("RIC73A01")
	local nOper		:= iif(dbseek(xFilial("ADY") + ::propos),4,3) 
	local oAux
	local ni		:= 0
	local aErro		:= {}	
	local nLinCal	:= 0
	local cItAux	:= ""
	
	Private aItRef	:= {}
    Private nPosIt	:= 0
	
	ZAA->(dbsetorder(1))
	
	// define se inclusão, alteração ou exclusão 
	oModel:SetOperation(nOper)
	
	// ativo o mode
	oModel:Activate()
	
	oModel:SetValue("ADYMASTER","ADY_FILIAL",::filial)
	oModel:SetValue("ADYMASTER","ADY_PROPOS",::propos)
	oModel:SetValue("ADYMASTER","ADY_ENTIDA",::entida)
	oModel:SetValue("ADYMASTER","ADY_CODIGO",::codigo)
	oModel:SetValue("ADYMASTER","ADY_LOJA",::loja)
	oModel:SetValue("ADYMASTER","ADY_ORCAME",::orcame)
	oModel:SetValue("ADYMASTER","ADY_STATUS",::status)
	oModel:SetValue("ADYMASTER","ADY_DATA",::datprop)
	oModel:SetValue("ADYMASTER","ADY_PREVIS",::previs)
	oModel:SetValue("ADYMASTER","ADY_VEND",::vend)
	oModel:SetValue("ADYMASTER","ADY_XMATER",::xmater)
	oModel:SetValue("ADYMASTER","ADY_XTPFAT",::xtpfat)
	oModel:SetValue("ADYMASTER","ADY_DTREVI",::dtrevi)
	oModel:SetValue("ADYMASTER","ADY_CLIENT",::client)
	oModel:SetValue("ADYMASTER","ADY_LOJENT",::lojent)
	oModel:SetValue("ADYMASTER","ADY_XAGENC",::xagenc)
	oModel:SetValue("ADYMASTER","ADY_CONDPG",::condpg)
	oModel:SetValue("ADYMASTER","ADY_TABELA",::aItemProposta[1]:xtabpr)
	
	oAux := oModel:GetModel("ADZDETAIL")
	
	for ni := 1 to len(::aItemProposta)
		if ni > oModel:GetModel("ADZDETAIL"):Length()
			oModel:GetModel("ADZDETAIL"):AddLine()
		endif
		oModel:GetModel("ADZDETAIL"):GoLine(ni)
		oModel:SetValue("ADZDETAIL","ADZ_FILIAL",::aItemProposta[ni]:filial)
		oModel:SetValue("ADZDETAIL","ADZ_ITEM",::aItemProposta[ni]:item)
		oModel:SetValue("ADZDETAIL","ADZ_XTABPR",::aItemProposta[ni]:xtabpr)
		oModel:SetValue("ADZDETAIL","ADZ_XPRACA",::aItemProposta[ni]:xpraca)
		oModel:SetValue("ADZDETAIL","ADZ_XFILPV",::aItemProposta[ni]:xfilpv)
		oModel:SetValue("ADZDETAIL","ADZ_PRODUT",::aItemProposta[ni]:produto)
		oModel:SetValue("ADZDETAIL","ADZ_XFORMA",::aItemProposta[ni]:xforma)
		oModel:SetValue("ADZDETAIL","ADZ_XALTUR",::aItemProposta[ni]:xaltur)
		oModel:SetValue("ADZDETAIL","ADZ_XCOLUN",::aItemProposta[ni]:xcolun)
		oModel:SetValue("ADZDETAIL","ADZ_XPAGIN",::aItemProposta[ni]:xpagin)
		oModel:SetValue("ADZDETAIL","ADZ_QTDVEN",::aItemProposta[ni]:qtdven)
		oModel:LoadValue("ADZDETAIL","ADZ_PRCTAB",::aItemProposta[ni]:prctab)
		oModel:SetValue("ADZDETAIL","ADZ_DESCON",::aItemProposta[ni]:descon)
		oModel:SetValue("ADZDETAIL","ADZ_MOEDA",::aItemProposta[ni]:moeda)
		oModel:SetValue("ADZDETAIL","ADZ_XTPVEI",::aItemProposta[ni]:xtpvei)
		oModel:SetValue("ADZDETAIL","ADZ_XMESEX",::aItemProposta[ni]:xmesex)
		oModel:SetValue("ADZDETAIL","ADZ_XDETER",::aItemProposta[ni]:xdeter)
		oModel:SetValue("ADZDETAIL","ADZ_TES",::aItemProposta[ni]:tes)
		oModel:SetValue("ADZDETAIL","ADZ_CONDPG",::condpg)
		oModel:SetValue("ADZDETAIL","ADZ_VALDES",::aItemProposta[ni]:valdes)
		oModel:SetValue("ADZDETAIL","ADZ_XTPVEI",::aItemProposta[ni]:xtpvei)
		oModel:SetValue("ADZDETAIL","ADZ_DT1VEN",::aItemProposta[ni]:dt1ven)
		oModel:SetValue("ADZDETAIL","ADZ_ORCAME",::aItemProposta[ni]:orcame)
		oModel:SetValue("ADZDETAIL","ADZ_PROPOS",::aItemProposta[ni]:propos)
		oModel:SetValue("ADZDETAIL","ADZ_REVISA",::aItemProposta[ni]:revisa)
		oModel:SetValue("ADZDETAIL","ADZ_XPRFAT",::aItemProposta[ni]:xprfat)
		oModel:SetValue("ADZDETAIL","ADZ_XFILFA",::aItemProposta[ni]:xfilfa)
		
	next
	
	oAux := oModel:GetModel("ZAADETAIL")
	for ni := 1 to len(::aCalendario)
		oModel:GetModel("ADZDETAIL"):SeekLine({{"ADZ_ITEM",::aCalendario[ni]:itprop}})
		if cItAux <> ::aCalendario[ni]:itprop
			cItAux := ::aCalendario[ni]:itprop
			nLinCal := 0
		endif
		nLinCal++
		if nLinCal > oModel:GetModel("ZAADETAIL"):Length()
			oModel:GetModel("ZAADETAIL"):AddLine()
		endif
		oModel:GetModel("ZAADETAIL"):GoLine(nLinCal)
		oModel:SetValue("ZAADETAIL","ZAA_FILIAL",::aCalendario[ni]:filial)
		oModel:SetValue("ZAADETAIL","ZAA_ITPROP",::aCalendario[ni]:itprop)
		oModel:SetValue("ZAADETAIL","ZAA_PROPOS",::aCalendario[ni]:propos)
		oModel:SetValue("ZAADETAIL","ZAA_DTEXIB",::aCalendario[ni]:dtexib)
		oModel:SetValue("ZAADETAIL","ZAA_QTDE",::aCalendario[ni]:qtde)
		
	next

	if oModel:VldData()
		oModel:CommitData()
		//U_RicCommit(oModel)
		//FWFormCommit(oModel,{||.T.}, {||.T.}, {||.T.},{||}, {|oModel|u_R73A1ATS(oModel)}, {||})
	else
		aErro := oModel:GetErrorMessage()
		for ni := 1 to len(aErro)
			if valtype(aErro[ni]) == "C"
				cStrErro += aErro[ni] + CRLF
			endif
		next
	endif
	oModel:DeActivate()
	
	aItRef	:= {}
    nPosIt	:= 0
	
return cStrErro

method delReg() class ADYProposta
	
	local cStrErro		:= ""
	local nOper		:= iif(dbseek(xFilial("ADY") + ::propos),5,0) 
	local oModel    := FWLoadModel('RIC73A01')
	
	Private aItRef	:= {}
    Private nPosIt	:= 0
	
	if nOper == 0
		cStrErro := "Proposta não encontrada"
		return cStrErro
	endif
	
	if nOper == 5	
		oModel:SetOperation(nOper)
		oModel:Activate()
		oModel:CommitData()
		oModel:DeActivate()
	endif
	
	aItRef	:= {}
    nPosIt	:= 0
	
return cStrErro

method aaddItemProp(oADZItemProp) class ADYProposta
	aadd(::aItemProposta,oADZItemProp)
return
method aaddCalendario(oZAACalendario) class ADYProposta
	aadd(::aCalendario,oZAACalendario)
return
method aaddFilProp(oZAEFilProp) class ADYProposta	
	aadd(::aFilialProp,oZAEFilProp)
return
method getItemProp() class ADYProposta
return ::aItemProposta

method getCalendario() class ADYProposta
return ::aCalendario

method getFilProp() class ADYProposta
return ::aFilialProp

method getItemPos(cItem,cPropos) class ADYProposta
	
	Local nPosRet	:= 0
	Local ni		:= 0
	
	for ni := 1 to len(::aItemProposta)
		if alltrim(::aItemProposta[ni]:item) == alltrim(cItem) .and. alltrim(::aItemProposta[ni]:propos) == alltrim(cPropos) 
			nPosRet := ni
		endif
	next
	
return nPosRet

method getCalendPos(dDataExib,cItem,cPropos) class ADYProposta
	
	Local nPosRet	:= 0
	Local ni		:= 0
	
	for ni := 1 to len(::aCalendario)
		if ::aCalendario[ni]:dtexib == dDataExib .and. alltrim(::aCalendario[ni]:itprop) == alltrim(cItem) .and. alltrim(::aCalendario[ni]:propos) == alltrim(cPropos)
			nPosRet := ni
		endif
	next
	
return nPosRet

method getFilPos(cNumPrc,cFilProp) class ADYProposta
	
	Local nPosRet	:= 0
	Local ni		:= 0
	
	for ni := 1 to len(::aFilialProp)
		if alltrim(::aFilialProp[ni]:numprc) == alltrim(cNumPrc) .and. alltrim(::aFilialProp[ni]:filprp) == alltrim(cFilProp) 
			nPosRet := ni
		endif
	next
	
return nPosRet

method altItemByPos(nPosItem,oADZItemProp) class ADYProposta
	
	if nPosItem <= 0
		return .F.
	endif
	
	::aItemProposta[nPosItem] := oADZItemProp
	
return .T.

method altCaleByPos(nPosCale,oZAACalendario) class ADYProposta
	
	if nPosCale <= 0
		return .F.
	endif
	
	::aCalendario[nPosCale] := oZAACalendario
	
return .T.

method altFilPropByPos(nPosFil,oZAEFilProp) class ADYProposta

	if nPosFil <= 0
		return .F.
	endif
	
	::aFilialProp[nPosFil] := oZAEFilProp
	
return .T.

static function GetCodADY(cCodADY)
	
	Local aAreaADY	:= ADY->(GetArea())
	Local cCodNovo  := cCodADY
	
	ADY->(dbsetorder(1))
	while ADY->(dbseek(xFilial("ADY") + cCodNovo))
		
		cCodNovo := soma1(cCodNovo)
	enddo
	RestArea(aAreaADY)
	
return cCodNovo