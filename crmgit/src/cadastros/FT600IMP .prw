#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#define DMPAPER_A4 9
// A4 210 x 297 mm
//largura máxima: 3325
// Programa responsável pela emissão do Contrato de Veiculação de Publicidade

User Function FT600IMP()

local cTexto 	:= ""
Local cPerg		:= "FT600IMP"

cTexto := "Este programa tem o objetivo de realizar a impressão do CONTRATO DE VEICULAÇÃO DE PUBLICIDADE. "  + CHR(13) + CHR(10)

If Aviso("Emissão de Relatório",cTexto,{"Continuar","Sair"})==1
	AjustaSx1(cPerg)
	Pergunte(cPerg,.T.,"Contrato de Veiculação de Publicidade")
	RCSMS011()
endif


Return()

//-----------------------------------------------------------------------------------------------------------------------------
Static Function AjustaSX1(cPergX1)

PutSx1(cPergX1,"01","Selecionar mídia:","Selecionar mídia:","Selecionar mídia:","mv_ch01","N",01,0,0,"C","",""		,"","","mv_par01","TV","TV","TV","","JORNAL","JORNAL","JORNAL","","","","","","","","","")

Return()

 //-------------------------------------------------------------------------------------------------------------------------------

Static Function RCSMS011()

Local nlin 			:= 0

Private oPrn

// Fontes
Private oFont06		:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
Private oFont07		:= TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)
Private oFont08		:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
Private oFont08n	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
Private oFont09		:= TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
Private oFont09n	:= TFont():New("Arial",09,09,,.T.,,,,.T.,.F.)
Private oFont10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
Private oFont10n	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
Private oFont11		:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
Private oFont12		:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
Private oFont12n	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
Private oFont13		:= TFont():New("Arial",13,13,,.F.,,,,.T.,.F.)
Private oFont14		:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
Private oFont14n	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
Private oFont14a	:= TFont():New("Arial",18,14,,.F.,,,,.T.,.F.)
Private oFont16n	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
Private oFont24n	:= TFont():New("Arial",24,24,,.T.,,,,.T.,.F.)

// Cores
Private oHGray		:= TBrush():New( , CLR_HGRAY )
Private oYellow		:= TBrush():New( , CLR_YELLOW )
Private oBlack		:= TBrush():New( , CLR_BLACK )
Private oBlue		:= TBrush():New( , CLR_BLUE )
Private oGreen		:= TBrush():New( , CLR_GREEN )
Private oCyan		:= TBrush():New( , CLR_CYAN )
Private oRed		:= TBrush():New( , CLR_RED )
Private oMagenta	:= TBrush():New( , CLR_MAGENTA )
Private oBrown		:= TBrush():New( , CLR_BROWN )
Private oGray		:= TBrush():New( , CLR_GRAY )
Private oHBlue		:= TBrush():New( , CLR_HBLUE )
Private oHGreen		:= TBrush():New( , CLR_HGREEN )
Private oHCyan		:= TBrush():New( , CLR_HCYAN )
Private oHRed		:= TBrush():New( , CLR_HRED )
Private oHMagenta	:= TBrush():New( , CLR_HMAGENTA )
Private oWhite		:= TBrush():New( , CLR_WHITE )

// Tabela

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Mapa                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


oPrn:= tMSPrinter():New()
oPrn:SetLandscape() 	// formato de paisagem
oPrn:StartPage()      	// Inicia uma nova pagina
oPrn:setPaperSize(9)
//Grid(oPrn,oFont08,.T.)   // Monta Grid com Cordenadas

// impressão do cabeçalho
nLin := ImpCabec()
nLin := ImpProgr(nLin)

// Impressão do Corpo
nLin := ImpDet(nLin)

// Impressão do Faturamento
nLin := ImpFat(nLin)

// Impressão de Mensagens
nLin := ImpMens(nLin)

// impressão do Rodapé
ImpRodaPe(nLin)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a Impressao                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrn:EndPage()
oPrn:Preview()        // Visualiza antes de imprimir

return(.T.)

//-----------------------------------------------------------------------------------------------------------------------------
// Funçao de impressão do cabeçalho

Static Function IMPCABEC(lCabItem)

Local nLinCb		:= 100
Local nLinCb2		:= nLinCb + 25
Local nLinCb3		:= 0
Local nLinCb4		:= 0
Local nLinCb5		:= 0
local nTam			:= 0
Local lRet          := .T.     //Retorno
Local cBitMap       := ""
Local cStartPath 	:= GetSrvProfString("StartPath","")
Local cQuery 		:= ""
local _cAlias		:= ""
local cRazao		:= ""
local cCod			:= ""
local cEnder		:= ""
local cCidade		:= ""
local cEstado		:= ""
local cCep			:= ""
local cCnpj			:= ""
local cIest			:= ""
local cResp			:= ""
local cTel			:= ""
local cRazao2		:= ""
local cCod2			:= ""
local cEnder2		:= ""
local cCidade2		:= ""
local cEstado2		:= ""
local cCep2			:= ""
local cCnpj2		:= ""
local cIest2		:= ""
local cResp2		:= ""
local cTel2			:= ""

public xTipFat

DEFAULT lCabItem	:= .T.

// Cabeçalho - CONTRATO DO VEICULAÇÃO DE PUBLICIDADE

oPrn:FillRect( {nLinCb,0100,nLinCb2,3325}, oBlack )
oPrn:Say(nLinCb,0120, "CONTRATADA",oFont06,100,CLR_WHITE)

nLinCb 	:= nLinCb2 + 25
nLinCb2	:= nLinCb + 75

// Logotipo

if MV_PAR01 = 1 // TV
	cBitmap := cStartPath + "TV.BMP"
	oPrn:SayBitmap(nLinCb + 10,100,cBitMap,500,300)
else
	cBitmap := cStartPath + "JORNAL.BMP"
	oPrn:SayBitmap(nLinCb + 10,70,cBitMap,600,300)
endif

// CONTRATO DE VEICULAÇÃO DE PUBLICIDADE
oPrn:Box(nLinCb,0700,nLinCb2,2500)
oPrn:Say(nLinCb,0710, "CONTRATO DE VEICULAÇÃO DE PUBLICIDADE",oFont12n,100)


//Data
cData := dToC(dDataBase)
oPrn:Box(nLinCb,2500,nLinCb2,2915)
oPrn:Say(nLinCb,2520, "DATA: " + cData,oFont08n,100)

// Número
cNum := alltrim(ADY->ADY_PROPOS)
oPrn:Box(nLinCb,2915,nLinCb2,3325)
oPrn:Say(nLinCb,2935, "N° " + cNum,oFont08n,100)

nLinCb := nLinCb2
nLinCb2 := nLinCb + 250


// Dados Contratada

cNome := alltrim(SM0->M0_NOMECOM)
cEndereco := alltrim(SM0->M0_ENDCOB) + " - " + alltrim(SM0->M0_BAIRCOB) + " - Fone/Fax: " + alltrim(SM0->M0_TEL) + " / " + alltrim(SM0->M0_FAX)
cComplem := "CEP: " + alltrim(SM0->M0_CEPCOB) + " - " + alltrim(SM0->M0_CIDCOB) + " - " + alltrim(SM0->M0_ESTCOB) + " - "
cComplem += "CNPJ " + alltrim(TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99")) + " - Inscrição Estadual: " + alltrim(SM0->M0_INSC)

oPrn:Box(nLinCb,0700,nLinCb2,3325)
nLinCb := nLinCb + 50
oPrn:Say(nLinCb,0710, cNome,oFont10n,100)
nLinCb := nLinCb + 50
oPrn:Say(nLinCb,0710, cEndereco,oFont10n,100)
nLinCb := nLinCb + 50
oPrn:Say(nLinCb,0710, cComplem,oFont10n,100)

nLinCb := nLinCb + 150
nLinCb2 := nLinCb + 25

// CONTRATANTE
oPrn:FillRect( {nLinCb,0100,nLinCb2,1699}, oBlack )
oPrn:Say(nLinCb,0125, "CONTRATANTE",oFont06,100,CLR_WHITE)

// AGENCIA
oPrn:FillRect( {nLinCb,1700,nLinCb2,3325}, oBlack )
oPrn:Say(nLinCb,1725, "AGENCIA",oFont06,100,CLR_WHITE)

nLinCb := nLinCb + 25
nLinCb2 := nLinCb + 50

// Cliente
_cAlias := getNextAlias()
cQuery := "select A1_COD, A1_NREDUZ, A1_END ,A1_MUN, A1_EST, A1_CGC, A1_INSCR, A1_CONTATO, A1_DDD, A1_TEL, A1_CEP"
cQuery += " from " + RetSqlName("SA1") + " SA1 "
cQuery += " where SA1.D_E_L_E_T_ = '' "
cQuery += " and A1_COD = '" + alltrim(ADY->ADY_CODIGO) + "' "
cQuery += " and A1_LOJA = '" + alltrim(ADY->ADY_LOJA) + "' "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),_cAlias,.T.,.F.)

While (_cAlias)->(!EoF())

	cRazao 	:= (_cAlias)->A1_NREDUZ
	cCod 	:= (_cAlias)->A1_COD
	cEnder 	:= (_cAlias)->A1_END
	cCidade := (_cAlias)->A1_MUN
	cEstado := (_cAlias)->A1_EST
	cCep 	:= (_cAlias)->A1_CEP
	cCnpj 	:= alltrim(TRANSFORM((_cAlias)->A1_CGC,"@R 99.999.999/9999-99"))
	cIest 	:= (_cAlias)->A1_INSCR
	cResp 	:= (_cAlias)->A1_CONTATO
	cTel 	:= "(" + (_cAlias)->A1_DDD  +") " + alltrim(TRANSFORM((_cAlias)->A1_TEL,"@R 9999-9999"))

	(_cAlias)->(DbSkip())

EndDo

If Select(_cAlias) > 0
	DbSelectArea(_cAlias)
	DbCloseArea()
EndIf

// Agência
_cAlias := getNextAlias()
cQuery := "select A3_COD, A3_NREDUZ, A3_END ,A3_MUN, A3_EST, A3_CGC, A3_INSCR, A3_DDD, A3_TEL, A3_CEP"
cQuery += " from " + RetSqlName("SA3") + " SA3 "
cQuery += " where SA3.D_E_L_E_T_ = '' "
//cQuery += " and A3_COD = '" + alltrim(ADY->ADY_XAGENC) + "' "
cQuery += " and A3_COD = '000001' " // TADEU 
//cQuery += " and A3_COD =  '" + alltrim(ADY->ADY_VEND) + "' "" // TADEU

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),_cAlias,.T.,.F.)

While (_cAlias)->(!EoF())

	cRazao2 	:= (_cAlias)->A3_NREDUZ
	cCod2 		:= (_cAlias)->A3_COD
	cEnder2 	:= (_cAlias)->A3_END
	cCidade2 	:= (_cAlias)->A3_MUN
	cEstado2 	:= (_cAlias)->A3_EST
	cCep2 		:= (_cAlias)->A3_CEP
	cCnpj2 		:= alltrim(TRANSFORM((_cAlias)->A3_CGC,"@R 99.999.999/9999-99"))
	cIest2 		:= (_cAlias)->A3_INSCR
	cResp2 		:= ADY->ADY_VEND   
	cNom2       := POSICIONE("SA3",1,xFilial("SA3")+ ADY->ADY_VEND,"A3_NREDUZ") 
	cTel2 		:= "(" + (_cAlias)->A3_DDD  +") " + alltrim(TRANSFORM((_cAlias)->A3_TEL,"@R 9999-9999"))

	(_cAlias)->(DbSkip())

EndDo

If Select(_cAlias) > 0
	DbSelectArea(_cAlias)
	DbCloseArea()
EndIf

// Razão Social Contratante
oPrn:Box(nLinCb,0100,nLinCb2,1400)
oPrn:Say(nLinCb,0125, "Razão Social: ",oFont08n,100)
oPrn:Say(nLinCb,0325, cRazao,oFont08,100)

// Código Contratante
oPrn:Box(nLinCb,1400,nLinCb2,1700)
oPrn:Say(nLinCb,1425, "Cód: ",oFont08n,100)
oPrn:Say(nLinCb,1525, cCod,oFont08,100)

// Razão Social Agencia
oPrn:Box(nLinCb,1700,nLinCb2,3100)
oPrn:Say(nLinCb,1725, "Razão Social: ",oFont08n,100)
oPrn:Say(nLinCb,1925, cRazao2,oFont08,100)

// Código Agência
oPrn:Box(nLinCb,3100,nLinCb2,3325)
oPrn:Say(nLinCb,3125, "Cód: ",oFont08n,100)
oPrn:Say(nLinCb,3200, cCod2,oFont08,100)

nLincb := nLinCb2
nLinCb2 := nLinCb + 50

// Endereço Contratante
oPrn:Box(nLinCb,0100,nLinCb2,1700)
oPrn:Say(nLinCb,0125, "Endereço: ",oFont08n,100)
oPrn:Say(nLinCb,0275, cEnder,oFont08,100)

// Endereço Agencia
oPrn:Box(nLinCb,1700,nLinCb2,3325)
oPrn:Say(nLinCb,1725, "Endereço: ",oFont08n,100)
oPrn:Say(nLinCb,1875, cEnder2,oFont08,100)

nLincb := nLinCb2
nLinCb2 := nLinCb + 50

// Cidade Contratante
oPrn:Box(nLinCb,0100,nLinCb2,750)
oPrn:Say(nLinCb,0125, "Cidade: ",oFont08n,100)
oPrn:Say(nLinCb,0250, cCidade,oFont08,100)

// Estado Contratante
oPrn:Box(nLinCb,0750,nLinCb2,1000)
oPrn:Say(nLinCb,0775, "Estado: ",oFont08n,100)
oPrn:Say(nLinCb,0925, cEstado,oFont08,100)

// CEP Contratante
oPrn:Box(nLinCb,1000,nLinCb2,1700)
oPrn:Say(nLinCb,1025, "CEP: ",oFont08n,100)
oPrn:Say(nLinCb,1125, cCep,oFont08,100)

// Cidade Agencia
oPrn:Box(nLinCb,1700,nLinCb2,2375)
oPrn:Say(nLinCb,1725, "Cidade: ",oFont08n,100)
oPrn:Say(nLinCb,1850, cCidade2,oFont08,100)

// Estado Agencia
oPrn:Box(nLinCb,2375,nLinCb2,2625)
oPrn:Say(nLinCb,2400, "Estado: ",oFont08n,100)
oPrn:Say(nLinCb,2550, cEstado2,oFont08,100)

// CEP Agencia
oPrn:Box(nLinCb,2625,nLinCb2,3325)
oPrn:Say(nLinCb,2650, "CEP: ",oFont08n,100)
oPrn:Say(nLinCb,2725, cCep2,oFont08,100)

nLincb := nLinCb2
nLinCb2 := nLinCb + 50

// CNPJ Contratante
oPrn:Box(nLinCb,0100,nLinCb2,750)
oPrn:Say(nLinCb,0125, "CNPJ: ",oFont08n,100)
oPrn:Say(nLinCb,0225, cCnpj,oFont08,100)

// Inscrição Estadual Contratante
oPrn:Box(nLinCb,0750,nLinCb2,1700)
oPrn:Say(nLinCb,0775, "Inscrição Estadual: ",oFont08n,100)
oPrn:Say(nLinCb,1075, cIest,oFont08,100)

// CNPJ Agencia
oPrn:Box(nLinCb,1700,nLinCb2,2375)
oPrn:Say(nLinCb,1725, "CNPJ: ",oFont08n,100)
oPrn:Say(nLinCb,1825, cCnpj2,oFont08,100)

// Inscrição Estadual Agencia
oPrn:Box(nLinCb,2375,nLinCb2,3325)
oPrn:Say(nLinCb,2395, "Inscrição Estadual: ",oFont08n,100)
oPrn:Say(nLinCb,2675, cIest2,oFont08,100)

nLincb := nLinCb2
nLinCb2 := nLinCb + 50

// Resp pelo contrato Contratante
oPrn:Box(nLinCb,0100,nLinCb2,750)
oPrn:Say(nLinCb,0125, "Resp. pelo Contrato: ",oFont08n,100)
oPrn:Say(nLinCb,0425, cResp,oFont08,100)

// Telefone Contratante
oPrn:Box(nLinCb,0750,nLinCb2,1700)
oPrn:Say(nLinCb,0775, "Tel: ",oFont08n,100)
oPrn:Say(nLinCb,0850, cTel,oFont08,100)

// Resp pelo contrato Agência
oPrn:Box(nLinCb,1700,nLinCb2,2625)
oPrn:Say(nLinCb,1725, "Atendimento Comercial: ",oFont08n,100)
oPrn:Say(nLinCb,2050, cResp2+" / "+cNom2,oFont08,100)

// Telefone Agência
oPrn:Box(nLinCb,2625,nLinCb2,3325)
oPrn:Say(nLinCb,2635, "Tel: ",oFont08n,100)
oPrn:Say(nLinCb,2685, cTel2,oFont08,100)

//if MV_PAR01 = 1 // TV

	_cAlias := getNextAlias()
	cQuery := "select ADZ_XPRACA, ADZ_XMESEX, ADY_XNUMPI, ADY_XMATER, ADY_XTPFAT, ADZ_REVISA, ADZ_PROPOS, ADZ_ITEM "
	cQuery += " from " + retSqlName("ADZ") + " ADZ, " + retSqlName("ADY") + " ADY "
	cQuery += " where ADZ.D_E_L_E_T_ = '' "
	cQuery += " and ADY.D_E_L_E_T_ = '' "
	cQuery += " and ADY_FILIAL = '" + xFilial("ADY") + "'"
	cQuery += " and ADZ_FILIAL = '" + xFilial("ADZ") + "'"
	cQuery += " and ADZ_PROPOS = '" + ADY->ADY_PROPOS + "' "   
	cQuery += " and ADZ_REVISA = (SELECT MAX(CNXX.ADZ_REVISA)FROM ADZ010 CNXX WHERE ADZ_PROPOS=CNXX.ADZ_PROPOS AND ADZ_REVISA=CNXX.ADZ_REVISA AND ADZ_ITEM=CNXX.ADZ_ITEM AND CNXX.D_E_L_E_T_ = '') "  

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),_cAlias,.T.,.F.)

 	XPraca := (_cAlias)->ADZ_XPRACA
   	cMesEx := (_cAlias)->ADZ_XMESEX 
   	xMesEx := mesextenso(cMesEx)
	xNumPi := ADY->ADY_XNUMPI
	xIdMat := ADY->ADY_XMATER
	xTipFat := ADY->ADY_XTPFAT


	If Select(_cAlias) > 0
		DbSelectArea(_cAlias)
		DbCloseArea()
	EndIf

	nLincb := nLinCb2 + 25
	nLinCb2 := nLinCb + 50

	// Praça de Veiculação:
	oPrn:Box(nLinCb,0100,nLinCb2,400)
	oPrn:Say(nLinCb,0120, "Praça de Veiculação",oFont08n,100)

	// Praça de Veiculação - valor
	oPrn:Box(nLinCb,0400,nLinCb2,1000)
	oPrn:Say(nLinCb,0423, xPraca,oFont08,100)

	//nLincb := nLinCb2
	//nLinCb2 := nLinCb + 50

	// Período
	oPrn:Box(nLinCb,1000,nLinCb2,1180)
	oPrn:Say(nLinCb,1020, "Período",oFont08n,100)

	// Período - valor
	oPrn:Box(nLinCb,1180,nLinCb2,1525)
	oPrn:Say(nLinCb,1200, xMesEx,oFont08,100)


	// Número PI
	oPrn:Box(nLinCb,1525,nLinCb2,1700)
	oPrn:Say(nLinCb,1545, "Número PI",oFont08n,100)

	// Número PI - valor
	oPrn:Box(nLinCb,1700,nLinCb2,1925)
	oPrn:Say(nLinCb,1720, ConvType(xNumPi),oFont08,100)


	// Identificação do Material
	oPrn:Box(nLinCb,1925,nLinCb2,2230)
	oPrn:Say(nLinCb,1930, "Identif. do Material",oFont08n,100)

	// Identificação do Material - valor
	oPrn:Box(nLinCb,2230,nLinCb2,2750)
	oPrn:Say(nLinCb,2260, xIdMat,oFont08,100)
	
	
	// Tipo de Faturamento:
	oPrn:Box(nLinCb,2750,nLinCb2,2925)
	oPrn:Say(nLinCb,2755, "Faturamento",oFont08n,100)

	// Tipo de Faturamento - valor
	oPrn:Box(nLinCb,2925,nLinCb2,3325)
	oPrn:Say(nLinCb,2950, xTipFat,oFont08,100)

//endif

nLinCb := nLinCb2 + 25

return(nLinCb)

//--------------------------------------------------------------------------------------------------------------------------
Static Function ImpProgr(nLinCb)

local nLinCb2 := 0

nLinCb2 := nLinCb + 25

// PROGRAMAÇÃO
oPrn:FillRect( {nLinCb,0100,nLinCb2,3325}, oBlack )
oPrn:Say(nLinCb,0125, "PROGRAMAÇÃO",oFont06,100,CLR_WHITE)

nLinCb := nLinCb2
if MV_PAR01 = 1 // TV
	nLinCb2 := nLinCb + 70
else
	nLinCb2 := nLinCb + 50
endif
nLinCb3 := nLinCb + 25
nLinCb4	:= nLinCb3 + 25
nLinCb5	:= nLinCb4 + 25

if MV_PAR01 = 1 // TV
	nPosA := 350
	nPosB := 350
	nPosC := nPosA + 10
else
	nPosA := 750
	nPosB := 750
	nPosC := nPosA + 10
endif

// PROGRAMAÇÃO - verificar altura do conteudo
oPrn:Box(nLinCb,0100,nLinCb2,nPosB)
oPrn:Say(nLinCb3,0110, "PROGRAMAÇÃO",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

if MV_PAR01 = 1 // TV
	// SE
	oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
	oPrn:Say(nLinCb3,nPosA, "SE",oFont08n,100)
	nPosA := nPosB
	nPosB := nPosB + 50
	nPosC := nPosA + 10
endif
// dia 01
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "01",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 02
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "02",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 03
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "03",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 04
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "04",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 05
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "05",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 06
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "06",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 07
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "07",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 08
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "08",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 09
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "09",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 10
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "10",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 11
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "11",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 12
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "12",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 13
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "13",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 14
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "14",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 15
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "15",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 16
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "16",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 17
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "17",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 18
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "18",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 19
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "19",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 20
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "20",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 21
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "21",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 22
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "22",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 23
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "23",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 24
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "24",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 25
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "25",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 26
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "26",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 27
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "27",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 28
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "28",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 29
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "29",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 30
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "30",oFont08n,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 31
oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
oPrn:Say(nLinCb3,nPosC, "31",oFont08n,100)
nPosA := nPosB
nPosC := nPosA + 10

if MV_PAR01 = 1 // TV
	nPosB := nPosB + 100

	// INS. 100
	oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
	oPrn:Say(nLinCb3,nPosC, "INS.",oFont08n,100)
	nPosA := nPosB
	nPosB := nPosB + 100
	nPosC := nPosA + 10

	// IA. DOM 100  
	oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
	oPrn:Say(nLinCb + 2 ,nPosC, "IA.",oFont08n,100)
	oPrn:Say(nLinCb3 + 1 ,nPosC, "DOM.",oFont08n,100)
	nPosA := nPosB
	nPosB := nPosB + 100
	nPosC := nPosA + 10 
	
	// SHR DOM. 150 - ALTERADO
	oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
	oPrn:Say(nLinCb + 2,nPosC, "SHR",oFont08n,100)
	oPrn:Say(nLinCb3 + 1,nPosC, "DOM.",oFont08n,100)
	nPosA := nPosB
	nPosB := nPosB + 150
	nPosC := nPosA + 10 
	
	// TELESP ATING
	oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
	oPrn:Say(nLinCb + 2,nPosC, "TLSP",oFont08n,100)
	oPrn:Say(nLinCb3 + 1,nPosC, "ATINGID.",oFont08n,100)
	nPosA := nPosB
	nPosB := nPosB + 100
	nPosC := nPosA + 10

	// GRP. 100
	oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
	oPrn:Say(nLinCb3,nPosC, "GRP",oFont08n,100)
	nPosA := nPosB
	nPosB := nPosB + 100
	nPosC := nPosA + 10

	//UN. TAB	
	oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
	oPrn:Say(nLinCb + 2,nPosC, "UN.",oFont08n,100)
	oPrn:Say(nLinCb3 + 1,nPosC, "TAB",oFont08n,100)
	nPosA := nPosB
	nPosB := nPosB + 150
	nPosC := nPosA + 10

	
	//DESCONTO
	oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
   	oPrn:Say(nLinCb3 ,nPosC, "DESCON",oFont08n,100)
	nPosA := nPosB
	nPosB := nPosB + 150
	nPosC := nPosA + 10


	// UN. Neg 150
	oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
   	oPrn:Say(nLinCb3 ,nPosC, "UN. NEG",oFont08n,100)
	nPosA := nPosB
	nPosB := nPosB + 200
	nPosC := nPosA + 10

	// Total Tabela 150
	oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
	oPrn:Say(nLinCb + 2,nPosC, "TOTAL",oFont08n,100)
	oPrn:Say(nLinCb3 + 1,nPosC, "TABELA",oFont08n,100)
	nPosA := nPosB
	nPosB := nPosB + 200
	nPosC := nPosA + 10

	// Total Neg 125
	oPrn:Box(nLinCb ,nPosA,nLinCb2,nPosB)
	oPrn:Say(nLinCb + 2,nPosC, "TOTAL",oFont08n,100)
	oPrn:Say(nLinCb3 + 1 ,nPosC, "NEG.",oFont08n,100)


ELSE

	nPosB := nPosB + 335

	// TOTAL
	oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
	oPrn:Say(nLinCb3,nPosC, "TOTAL",oFont08n,100)
	nPosA := nPosB
	nPosB := nPosB + 335
	nPosC := nPosA + 10

	// VLR UNITARIO
	oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
	oPrn:Say(nLinCb3,nPosC, "VLR UNITARIO",oFont08n,100)
	nPosA := nPosB
	nPosB := 3325
	nPosC := nPosA + 10

	// VLR TOTAL
	oPrn:Box(nLinCb,nPosA,nLinCb2,nPosB)
	oPrn:Say(nLinCb3,nPosC, "VLR TOTAL",oFont08n,100)

ENDIF

nLinCb := nLinCb2

return(nLinCb)

//------------------------------------------------------------------------------------------------------------------------------
// função responsável pelo calculo do corpo do relatório

Static Function IMPDET(nLinCor)

Local cQuery := ""
local _cAliasAdz := getNextAlias()
local _cAliasDa1 := getNextAlias()
local _cAliasZaa := getNextAlias()
local _n := 1
local _n1:= 0
local aProp	:= {}

Public a600 := {}
Public aTotal := array(49)

// Selecionar os itens da proposta
cQuery := "select "
cQuery += " ADZ_PROPOS, ADZ_ITEM,ADZ_PRODUT, ADZ_XFORMA, ADZ_VALDES, ADZ_TOTAL, ADZ_XCOLUN, ADZ_XALTUR, ADZ_QTDVEN,"  
cQuery += " ADZ_CONDPG, ADZ_PRODUT, ADZ_DT1VEN, ADZ_PRCTAB, ADZ_REVISA, ADZ_PRCVEN " 
cQuery += " from "
cQuery +=  + RetSqlName("ADZ") + " ADZ "
//cQuery += "ADZ0101 ADZ" //tadeu
cQuery += " where "
cQuery += " ADZ.D_E_L_E_T_ = '' "
cQuery += " and ADZ_FILIAL = '" + xFilial("ADZ") + "' "
cQuery += " and ADZ_PROPOS = '" + ADY->ADY_PROPOS + "' " 
cQuery += " and ADZ_REVISA = (SELECT MAX(CNXX.ADZ_REVISA)FROM ADZ010 CNXX WHERE '" + ADY->ADY_PROPOS + "' =CNXX.ADZ_PROPOS AND ADZ_REVISA=CNXX.ADZ_REVISA AND ADZ_ITEM=CNXX.ADZ_ITEM AND CNXX.D_E_L_E_T_ = '') "  
//cQuery += "  and ADZ_PROPOS = '000034' " // tadeu

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),_cAliasAdz,.T.,.F.)

//selecionar dados da tabela de preço
cQuery := "select "
cQuery += " DA1_CODPRO ,DA1_XIADOM, DA1_XSHRDO, DA1_XTELES"
cQuery += " from "
cQuery +=  + RetSqlName("DA1") + " DA1 "
//cQuery += "ADZ0101 ADZ" //tadeu
cQuery += " where "
cQuery += " DA1.D_E_L_E_T_ = '' "
cQuery += " and DA1_FILIAL = '" + xFilial("DA1") + "' "
cQuery += " and DA1_CODTAB = '" + ADY->ADY_TABELA + "' " 
cQuery += " and DA1_CODPRO = '" + (_cAliasAdz)->ADZ_PRODUT + "' "
//cQuery += "  and ADZ_PROPOS = '000034' " // tadeu

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),_cAliasDa1,.T.,.F.)
                                                                  

aTotal[40] 	:= "TOTAL"
aTotal[42]	:= 0
aTotal[43]	:= 0
aTotal[45]	:= 0
aTotal[46]	:= 0
aTotal[41]	:= 0

for _x := 1 to 39
	aTotal[_x]	:= 0
next _x


While (_cAliasAdz)->(!EoF())

	aadd(aProp,array(49))
	aProp[_n][32] := (_cAliasAdz)->ADZ_PROPOS 	// PROPOSTA
	aProp[_n][33] := (_cAliasAdz)->ADZ_ITEM 	// ITEM
	aProp[_n][34] := (_cAliasAdz)->ADZ_XFORMA 	// TE
	aProp[_n][35] := (_cAliasDa1)->DA1_XIADOM 	// IA DOM
	aProp[_n][42] := (_cAliasDa1)->DA1_XSHRDO	// IA IND
	aProp[_n][37] := (_cAliasAdz)->ADZ_VALDES 	// DESCONTO
	aProp[_n][38] := (_cAliasAdz)->ADZ_PRCTAB	// PRECO VENDA
	aProp[_n][39] := (_cAliasAdz)->ADZ_PRCVEN	// VALOR DO DESCONTO // tadeu 
	cDesc := POSICIONE("SB1", 1, xFilial("SB1") + (_cAliasAdz)->ADZ_PRODUT, "B1_DESC")
	aProp[_n][40] := cDesc 						// PRODUTO
	aProp[_n][36] := 0 							// GRP
	aProp[_n][41] := 0							//INS
	aProp[_n][43] := (_cAliasDa1)->DA1_XTELES	//TARP
	aProp[_n][44] := 0							//UN NEG
	aProp[_n][45] := 0							//TOTAL TAB
	aProp[_n][46] := 0							//TOTAL NEG 
	cQtde:= (_cAliasAdz)->ADZ_QTDVEN

	// selecionar o número de exibições dos itens da proposta
	cQuery := "select "
	cQuery += " ZAA_DTEXIB, ZAA_QTDE "
	cQuery += " FROM "
	//cQuery += " ZAA0101 ZAA" // tadeu
	cQuery +=  + RetSqlName("ZAA") + " ZAA "
	cQuery += " where "
	cQuery += " ZAA.D_E_L_E_T_ = '' "
	cQuery += " and ZAA_FILIAL = '" + xFilial("ZAA") + "' " // tadeu
	cQuery += " and ZAA_PROPOS = '" + (_cAliasAdz)->ADZ_PROPOS + "' "
	cQuery += " and ZAA_ITPROP = '" + (_cAliasAdz)->ADZ_ITEM + "' "

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),_cAliasZaa,.T.,.F.)

	While (_cAliasZaa)->(!EoF())
		_n1 := val(substr((_cAliasZaa)->ZAA_DTEXIB,7,2)) 
		cMes:= (_cAliasZaa)->ZAA_DTEXIB
		//cMes:= mesextenso(stod(nMes))  
		aProp[_n][_n1] 	:= (_cAliasZaa)->ZAA_QTDE 	// PROPOSTA
		aProp[_n][41] 	:= aProp[_n][_n1] // INS
		aTotal[_n1]		:= aTotal[_n1] + aProp[_n][_n1] // total da linha
		aTotal[41]		:= aTotal[41] + aProp[_n][_n1]
		(_cAliasZaa)->(dbSkip())
	enddo

	If Select(_cAliasZaa) > 0
		DbSelectArea(_cAliasZaa)
		DbCloseArea()
	EndIf

	// GRP
	aProp[_n][36] := cQtde * aProp[_n][35]
	//TARP
   //	aProp[_n][43] := aProp[_n][41] * aProp[_n][42]
	//TOTAL TAB
   aProp[_n][45]  := cQtde * aProp[_n][38]
	//TOTAL NEG
	aProp[_n][46] := cQtde * aProp[_n][39] 
	//Programacao
	if MV_PAR01 = 2 // JORNAL 
	cColuna:= (_cAliasAdz)->ADZ_XCOLUN
	cAltura:= (_cAliasAdz)->ADZ_XALTUR
	aProp[_n][40] := aProp[_n][40] + alltrim(cvaltochar(cColuna))+ ' X ' + alltrim(cvaltochar(cAltura)) //+ alltrim(xMesEx)
	EndIf

	aTotal[34]	:= aTotal[34] + aProp[_n][34]
	aTotal[35]	:= aTotal[35] + aProp[_n][35]
	aTotal[36]	:= aTotal[36] + aProp[_n][36]
	aTotal[37]	:= aTotal[37] + aProp[_n][37]
	aTotal[38]	:= ""
	aTotal[39]	:= aTotal[39] + aProp[_n][39]
	aTotal[42]	:= aTotal[42] + aProp[_n][42]
	aTotal[43]	:= aTotal[43] + aProp[_n][43]
	aTotal[45]	:= aTotal[45] + aProp[_n][45]
	aTotal[46]	:= aTotal[46] + aProp[_n][46]
	aTotal[47] 	:= 0
	aTotal[48]	:= 0
	aTotal[49]	:= 0 


	// Fazer a impressão
	nLinCor := ImpCorpo(nLinCor,aProp[_n])

// Tratamento para colunas do financeiro
	aadd(a600,array(04))
	a600[_n][1] := (_cAliasAdz)->ADZ_PRODUT
	a600[_n][2] := aProp[_n][45]
	a600[_n][3] := (_cAliasAdz)->ADZ_CONDPG
	a600[_n][4] := (_cAliasAdz)->ADZ_DT1VEN
              
	_n := _n + 1
	nLinCor := nLinCor + 50

	(_cAliasAdz)->(dbSkip())

enddo

If Select(_cAliasAdz) > 0
	DbSelectArea(_cAliasAdz)
	DbCloseArea()
EndIf

aTotal[37]	:= aTotal[37] // _n
aTotal[48]	:= aTotal[45] - aTotal[37]
aTotal[49]	:= aTotal[48] * 0.8                                                                                                                   

// Imprimir Totais
nLinCor := ImpCorpo(nLinCor,aTotal)

nLinCor := nLinCor + 50

return(nLinCor)
//------------------------------------------------------------------------------------------------------------------------------
// função responsável pela impressão do corpo do relatório

Static Function IMPCORPO(nLinCor,aCorpo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nLinCor2	:= nLinCor + 50

// valido quebra de página  Se quebrar, imprimo o cabeçalho
if nLinCor >= 2300
	oPrn:EndPage()
	oPrn:StartPage()                                                                                                                   
	nLinCor		:= ImpCabec()                                                                                         
	nLinCor		:= ImpProgr(nLinCor)
	nLinCor2	:= nLinCor + 50
endif

if MV_PAR01 = 1 // TV
	nPosA := 350
	nPosB := 350
	nPosC := nPosA + 10
else
	nPosA := 750
	nPosB := 750
	nPosC := nPosA + 10
endif

// PROGRAMAÇÃO     
	oPrn:Box(nLinCor,0100,nLinCor2,nPosB)
	oPrn:Say(nLinCor,0125, alltrim(aCorpo[40]),oFont08,100)
	nPosA := nPosB
	nPosB := nPosB + 50
	nPosC := nPosA + 10 	

if MV_PAR01 = 1 // TV
	// TE
	oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
	oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[34]),oFont08,100)
	nPosA := nPosB
	nPosB := nPosB + 50
	nPosC := nPosA + 10
endif

// dia 01
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[01]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 02
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[02]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 03
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[03]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 04
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[04]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 05
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[05]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 06
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[06]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 07
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[07]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 08
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[08]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 09
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[09]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 10
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[10]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 11
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[11]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 12
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[12]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 13
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[13]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 14
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[14]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 15
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[15]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 16
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[16]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 17
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[17]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 18
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[18]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 19
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[19]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 20
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[20]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 21
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[21]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 22
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[22]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 23
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[23]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 24
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[24]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 25
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[25]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 26
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[26]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 27
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[27]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 28
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[28]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 29
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[29]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 30
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[30]),oFont08,100)
nPosA := nPosB
nPosB := nPosB + 50
nPosC := nPosA + 10

// dia 31
oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[31]),oFont08,100)
nPosA := nPosB
nPosC := nPosA + 10

if MV_PAR01 = 1 // TV

	nPosB := nPosB + 100

	// INS. 100
	oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
	oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[41]),oFont08,100)
	nPosA := nPosB
	nPosB := nPosB + 100
	nPosC := nPosA + 10

	// IA. DOM 100
	oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
	oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[35]),oFont08,100)
	nPosA := nPosB
	nPosB := nPosB + 100
	nPosC := nPosA + 10 
	
	// IA. IND. 100
	oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
	oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[42]),oFont08,100)
	nPosA := nPosB
	nPosB := nPosB + 150
	nPosC := nPosA + 10         
	
	// TARP ABC 25 + 150
	oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
	oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[43]),oFont08,100)
	nPosA := nPosB
	nPosB := nPosB + 100
	nPosC := nPosA + 10

	// GRP. 100
	oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
	oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[36]),oFont08,100)
	nPosA := nPosB
	nPosB := nPosB + 100
	nPosC := nPosA + 10
             
	// UN. Tabela 150
	oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
	oPrn:Say(nLinCor ,nPosC, ConvType(aCorpo[38],15,2),oFont08,100)
	nPosA := nPosB
	nPosB := nPosB + 150
	nPosC := nPosA + 10

	// Desconto 200
	oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
	oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[37],15,2),oFont08,100)
	nPosA := nPosB
	nPosB := nPosB + 150
	nPosC := nPosA + 10


	// UN. Neg 150
	oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
	oPrn:Say(nLinCor ,nPosC, ConvType(aCorpo[39],15,2),oFont08,100)
	nPosA := nPosB
	nPosB := nPosB + 200
	nPosC := nPosA + 10
	
	//Total Tab
	oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
	oPrn:Say(nLinCor ,nPosC, ConvType(aCorpo[45],15,2),oFont08,100)
	nPosA := nPosB
	nPosB := nPosB + 200
	nPosC := nPosA + 10

	//Total Neg
	oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
	oPrn:Say(nLinCor ,nPosC, ConvType(aCorpo[46],15,2),oFont08,100)
	nPosA := nPosB
	nPosB := 3225
	nPosC := nPosA + 10

else

	nPosB := nPosB + 335

	// TOTAL
	oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
	oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[41]),oFont08,100)
	nPosA := nPosB
	nPosB := nPosB + 335
	nPosC := nPosA + 10

	// VLR UNITARIO
	oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
	oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[38],15,2),oFont08,100)
	nPosA := nPosB
	nPosB := 3325
	nPosC := nPosA + 10

	// VLR TOTAL
	oPrn:Box(nLinCor,nPosA,nLinCor2,nPosB)
	oPrn:Say(nLinCor,nPosC, ConvType(aCorpo[45],15,2),oFont08,100)

endif

return(nLinCor)

//-----------------------------------------------------------------------------------------------------------------------------
// Funçao de impressão do faturamento

Static Function IMPFAT(nLinFat)

Local nLinFat2	:= nLinFat
local aCrono	:= {}
local aCrono2	:= {}
                                      
aCrono := a600SmsFinance()

// valido quebra de página  Se quebrar, imprimo o cabeçalho
if nLinFat + 400 >= 2300
	oPrn:EndPage()
	oPrn:StartPage()
	nLinFat		:= ImpCabec()
	nLinFat2	:= nLinFat + 50
endif

for nX := 1 to 24
	aadd(aCrono2,array(3))
	if nX > len(aCrono)
		aCrono2[nX][1] := ""
		aCrono2[nX][2] := ""
		aCrono2[nX][3] := ""
	else
		aCrono2[nX][1] := alltrim(aCrono[nX][1])
		aCrono2[nX][2] := DTOC(aCrono[nX][2])
		aCrono2[nX][3] := alltrim(str(aCrono[nX][3]))
	endif
next nX

nLinFat := nLinFat2 + 50
nLinFat2 := nLinFat + 20

// FATURAMENTO
oPrn:FillRect( {nLinFat,0100,nLinFat2,3325}, oBlack )
oPrn:Say(nLinFat,0125, "FATURAMENTO",oFont06,100,CLR_WHITE)

nLinFat := nLinFat2
nLinFat2 := nLinFat + 40

// Parcelamento renata
oPrn:Box(nLinFat,100,nLinFat2,200)
oPrn:Say(nLinFat,110, "PARC",oFont08n,100)

// Valor renata
oPrn:Box(nLinFat,200,nLinFat2,400)
oPrn:Say(nLinFat,220, "VALOR",oFont08n,100)

// Vencimento
oPrn:Box(nLinFat,400,nLinFat2,600)
oPrn:Say(nLinFat,425, "VCTO",oFont08n,100)

// Parcelamento
oPrn:Box(nLinFat,600,nLinFat2,700)
oPrn:Say(nLinFat,610, "PARC",oFont08n,100)

// Valor
oPrn:Box(nLinFat,700,nLinFat2,900)
oPrn:Say(nLinFat,720, "VALOR",oFont08n,100)

// Vencimento
oPrn:Box(nLinFat,900,nLinFat2,1100)
oPrn:Say(nLinFat,925, "VCTO",oFont08n,100) 

// Parcelamento
oPrn:Box(nLinFat,1100,nLinFat2,1200)
oPrn:Say(nLinFat,1110, "PARC",oFont08n,100) 

// Valor
oPrn:Box(nLinFat,1200,nLinFat2,1400)
oPrn:Say(nLinFat,1220, "VALOR",oFont08n,100)   

// Vencimento
oPrn:Box(nLinFat,1400,nLinFat2,1600)
oPrn:Say(nLinFat,1425, "VCTO",oFont08n,100)   

// Parcelamento
oPrn:Box(nLinFat,1600,nLinFat2,1700)
oPrn:Say(nLinFat,1610, "PARC",oFont08n,100) 

// Valor
oPrn:Box(nLinFat,1700,nLinFat2,1900)
oPrn:Say(nLinFat,1720, "VALOR",oFont08n,100)   

// Vencimento
oPrn:Box(nLinFat,1900,nLinFat2,2100)
oPrn:Say(nLinFat,1925, "VCTO",oFont08n,100)

// Total Tabela
oPrn:Box(nLinFat,2650,nLinFat2,3000)
oPrn:Say(nLinFat,2675, "TOTAL TABELA",oFont08n,100)

// Total Tabela - Valor
oPrn:Box(nLinFat,3000,nLinFat2,3325)
oPrn:Say(nLinFat,3025, ConvType(aTotal[45],15,2),oFont08,100)

nLinFat := nLinFat2
nLinFat2 := nLinFat + 40

// Parcela 01

oPrn:Box(nLinFat,100,nLinFat2,200)
oPrn:Say(nLinFat,115, "01",oFont08,100)

// Valor 01
oPrn:Box(nLinFat,200,nLinFat2,400)
oPrn:Say(nLinFat,220, ConvType(val(aCrono2[1][3]),15,2),oFont08,100)

// Vencimento 01
oPrn:Box(nLinFat,400,nLinFat2,600)
oPrn:Say(nLinFat,425, aCrono2[1][2],oFont08,100)

// Parcela 07
oPrn:Box(nLinFat,600,nLinFat2,700)
oPrn:Say(nLinFat,615, "07",oFont08,100)

// Valor 07
oPrn:Box(nLinFat,700,nLinFat2,900)
oPrn:Say(nLinFat,720, ConvType(val(aCrono2[7][3]),15,2),oFont08,100)

// Vencimento 07
oPrn:Box(nLinFat,900,nLinFat2,1100)
oPrn:Say(nLinFat,925, aCrono2[7][2],oFont08,100)   

// Parcela 13

oPrn:Box(nLinFat,1100,nLinFat2,1200)
oPrn:Say(nLinFat,1110, "13",oFont08,100)

// Valor 13
oPrn:Box(nLinFat,1200,nLinFat2,1400)
oPrn:Say(nLinFat,1220, ConvType(val(aCrono2[13][3]),15,2),oFont08,100)

// Vencimento 13
oPrn:Box(nLinFat,1400,nLinFat2,1600)
oPrn:Say(nLinFat,1425, aCrono2[13][2],oFont08,100)

// Parcela 19
oPrn:Box(nLinFat,1600,nLinFat2,1700)
oPrn:Say(nLinFat,1610, "19",oFont08,100)

// Valor 19
oPrn:Box(nLinFat,1700,nLinFat2,1900)
oPrn:Say(nLinFat,1720, ConvType(val(aCrono2[19][3]),15,2),oFont08,100)

// Vencimento 19
oPrn:Box(nLinFat,1900,nLinFat2,2100)
oPrn:Say(nLinFat,1925, aCrono2[19][2],oFont08,100)

// Desconto
oPrn:Box(nLinFat,2650,nLinFat2,3000)
oPrn:Say(nLinFat,2675,  "DESCONTO",oFont08n,100)

// Total Tabela - Valor
oPrn:Box(nLinFat,3000,nLinFat2,3325)
oPrn:Say(nLinFat,3025, ConvType(aTotal[48],15,2),oFont08,100)

nLinFat := nLinFat2
nLinFat2 := nLinFat + 40

// Parcela 02
oPrn:Box(nLinFat,100,nLinFat2,200)
oPrn:Say(nLinFat,115, "02",oFont08,100)

// Valor 02
oPrn:Box(nLinFat,200,nLinFat2,400)
oPrn:Say(nLinFat,220, ConvType(val(aCrono2[2][3]),15,2),oFont08,100)

// Vencimento 02
oPrn:Box(nLinFat,400,nLinFat2,600)
oPrn:Say(nLinFat,425, aCrono2[2][2],oFont08,100)

// Parcela 08
oPrn:Box(nLinFat,600,nLinFat2,700)
oPrn:Say(nLinFat,615, "08",oFont08,100)

// Valor 08
oPrn:Box(nLinFat,700,nLinFat2,900)
oPrn:Say(nLinFat,720, ConvType(val(aCrono2[8][3]),15,2),oFont08,100)

// Vencimento 08
oPrn:Box(nLinFat,900,nLinFat2,1100)
oPrn:Say(nLinFat,925, aCrono2[8][2],oFont08,100) 

// Parcela 14

oPrn:Box(nLinFat,1100,nLinFat2,1200)
oPrn:Say(nLinFat,1110, "14",oFont08,100)

// Valor 14
oPrn:Box(nLinFat,1200,nLinFat2,1400)
oPrn:Say(nLinFat,1220, ConvType(val(aCrono2[14][3]),15,2),oFont08,100)

// Vencimento 14
oPrn:Box(nLinFat,1400,nLinFat2,1600)
oPrn:Say(nLinFat,1425, aCrono2[14][2],oFont08,100)

// Parcela 20
oPrn:Box(nLinFat,1600,nLinFat2,1700)
oPrn:Say(nLinFat,1610, "20",oFont08,100)

// Valor 20
oPrn:Box(nLinFat,1700,nLinFat2,1900)
oPrn:Say(nLinFat,1720, ConvType(val(aCrono2[20][3]),15,2),oFont08,100)

// Vencimento 20
oPrn:Box(nLinFat,1900,nLinFat2,2100)
oPrn:Say(nLinFat,1925, aCrono2[20][2],oFont08,100)

oPrn:Box(nLinFat,2650,nLinFat2,3000)
oPrn:Say(nLinFat,2675, "TOTAL NEG. BRUTO",oFont08n,100)

// Total Tabela - Valor
oPrn:Box(nLinFat,3000,nLinFat2,3325)
oPrn:Say(nLinFat,3025, ConvType(aTotal[39],15,2),oFont08,100)

nLinFat := nLinFat2
nLinFat2 := nLinFat + 40

// Parcela 03
oPrn:Box(nLinFat,100,nLinFat2,200)
oPrn:Say(nLinFat,115, "03",oFont08,100)

// Valor 03
oPrn:Box(nLinFat,200,nLinFat2,400)
oPrn:Say(nLinFat,220, ConvType(val(aCrono2[3][3]),15,2),oFont08,100)

// Vencimento 03
oPrn:Box(nLinFat,400,nLinFat2,600)
oPrn:Say(nLinFat,425, aCrono2[3][2],oFont08,100)

// Parcela 09
oPrn:Box(nLinFat,600,nLinFat2,700)
oPrn:Say(nLinFat,615, "09",oFont08,100)

// Valor 09
oPrn:Box(nLinFat,700,nLinFat2,900)
oPrn:Say(nLinFat,720, ConvType(val(aCrono2[9][3]),15,2),oFont08,100)

// Vencimento 09
oPrn:Box(nLinFat,900,nLinFat2,1100)
oPrn:Say(nLinFat,925, aCrono2[9][2],oFont08,100)  

// Parcela 15

oPrn:Box(nLinFat,1100,nLinFat2,1200)
oPrn:Say(nLinFat,1110, "15",oFont08,100)

// Valor 15
oPrn:Box(nLinFat,1200,nLinFat2,1400)
oPrn:Say(nLinFat,1220, ConvType(val(aCrono2[15][3]),15,2),oFont08,100)

// Vencimento 15
oPrn:Box(nLinFat,1400,nLinFat2,1600)
oPrn:Say(nLinFat,1425, aCrono2[15][2],oFont08,100)

// Parcela 21
oPrn:Box(nLinFat,1600,nLinFat2,1700)
oPrn:Say(nLinFat,1610, "21",oFont08,100)

// Valor 21
oPrn:Box(nLinFat,1700,nLinFat2,1900)
oPrn:Say(nLinFat,1720, ConvType(val(aCrono2[21][3]),15,2),oFont08,100)

// Vencimento 21 
oPrn:Box(nLinFat,1900,nLinFat2,2100)
oPrn:Say(nLinFat,1925, aCrono2[21][2],oFont08,100)

// Comissão Agência
oPrn:Box(nLinFat,2650,nLinFat2,3000)
oPrn:Say(nLinFat,2675, "COMISSÃO AGÊNCIA",oFont08n,100)

// Total Tabela - Valor
oPrn:Box(nLinFat,3000,nLinFat2,3325)
oPrn:Say(nLinFat,3025, "20%",oFont08,100)

nLinFat := nLinFat2
nLinFat2 := nLinFat + 40

// Parcela 04
oPrn:Box(nLinFat,100,nLinFat2,200)
oPrn:Say(nLinFat,115, "04",oFont08,100)

// Valor 04
oPrn:Box(nLinFat,200,nLinFat2,400)
oPrn:Say(nLinFat,220, ConvType(val(aCrono2[4][3]),15,2),oFont08,100)

// Vencimento 04
oPrn:Box(nLinFat,400,nLinFat2,600)
oPrn:Say(nLinFat,425, aCrono2[4][2],oFont08,100)

// Parcela 10
oPrn:Box(nLinFat,600,nLinFat2,700)
oPrn:Say(nLinFat,615, "10",oFont08,100)

// Valor 10
oPrn:Box(nLinFat,700,nLinFat2,900)
oPrn:Say(nLinFat,720, ConvType(val(aCrono2[10][3]),15,2),oFont08,100)

// Vencimento 10
oPrn:Box(nLinFat,900,nLinFat2,1100)
oPrn:Say(nLinFat,925, aCrono2[10][2],oFont08,100)

// Parcela 16

oPrn:Box(nLinFat,1100,nLinFat2,1200)
oPrn:Say(nLinFat,1110, "16",oFont08,100)

// Valor 16
oPrn:Box(nLinFat,1200,nLinFat2,1400)
oPrn:Say(nLinFat,1220, ConvType(val(aCrono2[16][3]),15,2),oFont08,100)

// Vencimento 16
oPrn:Box(nLinFat,1400,nLinFat2,1600)
oPrn:Say(nLinFat,1425, aCrono2[16][2],oFont08,100)

// Parcela 22
oPrn:Box(nLinFat,1600,nLinFat2,1700)
oPrn:Say(nLinFat,1610, "22",oFont08,100)

// Valor 22
oPrn:Box(nLinFat,1700,nLinFat2,1900)
oPrn:Say(nLinFat,1720, ConvType(val(aCrono2[22][3]),15,2),oFont08,100)

// Vencimento 22
oPrn:Box(nLinFat,1900,nLinFat2,2100)
oPrn:Say(nLinFat,1925, aCrono2[22][2],oFont08,100)

// Total Líquido
oPrn:Box(nLinFat,2650,nLinFat2,3000)
oPrn:Say(nLinFat,2675, "TOTAL LÍQUIDO",oFont08n,100)

// Total Tabela - Valor
oPrn:Box(nLinFat,3000,nLinFat2,3325)
oPrn:Say(nLinFat,3025, ConvType(aTotal[49],15,2),oFont08,100)

nLinFat := nLinFat2
nLinFat2 := nLinFat + 40

// Parcela 05
oPrn:Box(nLinFat,100,nLinFat2,200)
oPrn:Say(nLinFat,115, "05",oFont08,100)

// Valor 05
oPrn:Box(nLinFat,200,nLinFat2,400)
oPrn:Say(nLinFat,220, ConvType(val(aCrono2[5][3]),15,2),oFont08,100)

// Vencimento 05
oPrn:Box(nLinFat,400,nLinFat2,600)
oPrn:Say(nLinFat,425, aCrono2[5][2],oFont08,100)

// Parcela 11
oPrn:Box(nLinFat,600,nLinFat2,700)
oPrn:Say(nLinFat,615, "11",oFont08,100)

// Valor 11
oPrn:Box(nLinFat,700,nLinFat2,900)
oPrn:Say(nLinFat,720, ConvType(val(aCrono2[11][3]),15,2),oFont08,100)

// Vencimento 11
oPrn:Box(nLinFat,900,nLinFat2,1100)
oPrn:Say(nLinFat,925, aCrono2[11][2],oFont08,100)  

// Parcela 17

oPrn:Box(nLinFat,1100,nLinFat2,1200)
oPrn:Say(nLinFat,1110, "17",oFont08,100)

// Valor 17
oPrn:Box(nLinFat,1200,nLinFat2,1400)
oPrn:Say(nLinFat,1220, ConvType(val(aCrono2[17][3]),15,2),oFont08,100)

// Vencimento 17
oPrn:Box(nLinFat,1400,nLinFat2,1600)
oPrn:Say(nLinFat,1425, aCrono2[17][2],oFont08,100)

// Parcela 23
oPrn:Box(nLinFat,1600,nLinFat2,1700)
oPrn:Say(nLinFat,1610, "23",oFont08,100)

// Valor 23
oPrn:Box(nLinFat,1700,nLinFat2,1900)
oPrn:Say(nLinFat,1720, ConvType(val(aCrono2[23][3]),15,2),oFont08,100)

// Vencimento 23
oPrn:Box(nLinFat,1900,nLinFat2,2100)
oPrn:Say(nLinFat,1925, aCrono2[23][2],oFont08,100)

if MV_PAR01 = 1 // TV

	// Total de GRP
	oPrn:Box(nLinFat,2650,nLinFat2,3000)
	oPrn:Say(nLinFat,2675, "TOTAL DE GRP",oFont08n,100)

	// Total de GRP - Valor
	oPrn:Box(nLinFat,3000,nLinFat2,3325)
	oPrn:Say(nLinFat,3025, ConvType(aTotal[36]),oFont08,100)
endif

nLinFat := nLinFat2
nLinFat2 := nLinFat + 40

// Parcela 06
oPrn:Box(nLinFat,100,nLinFat2,200)
oPrn:Say(nLinFat,115, "06",oFont08,100)

// Valor 06
oPrn:Box(nLinFat,200,nLinFat2,400)
oPrn:Say(nLinFat,220, ConvType(val(aCrono2[6][3]),15,2),oFont08,100)

// Vencimento 06
oPrn:Box(nLinFat,400,nLinFat2,600)
oPrn:Say(nLinFat,425, aCrono2[6][2],oFont08,100)

// Parcela 12
oPrn:Box(nLinFat,600,nLinFat2,700)
oPrn:Say(nLinFat,615, "12",oFont08,100)

// Valor 12
oPrn:Box(nLinFat,700,nLinFat2,900)
oPrn:Say(nLinFat,720, ConvType(val(aCrono2[12][3]),15,2),oFont08,100)

// Vencimento 12
oPrn:Box(nLinFat,900,nLinFat2,1100)
oPrn:Say(nLinFat,925, aCrono2[12][2],oFont08,100)  

// Parcela 18

oPrn:Box(nLinFat,1100,nLinFat2,1200)
oPrn:Say(nLinFat,1110, "18",oFont08,100)

// Valor 18
oPrn:Box(nLinFat,1200,nLinFat2,1400)
oPrn:Say(nLinFat,1220, ConvType(val(aCrono2[18][3]),15,2),oFont08,100)

// Vencimento 18
oPrn:Box(nLinFat,1400,nLinFat2,1600)
oPrn:Say(nLinFat,1425, aCrono2[18][2],oFont08,100)

// Parcela 24
oPrn:Box(nLinFat,1600,nLinFat2,1700)
oPrn:Say(nLinFat,1610, "24",oFont08,100)

// Valor 24
oPrn:Box(nLinFat,1700,nLinFat2,1900)
oPrn:Say(nLinFat,1720, ConvType(val(aCrono2[24][3]),15,2),oFont08,100)

// Vencimento 24
oPrn:Box(nLinFat,1900,nLinFat2,2100)
oPrn:Say(nLinFat,1925, aCrono2[24][2],oFont08,100)

nLinFat := nLinFat2

return(nLinFat)

//-----------------------------------------------------------------------------------------------------------------------------
// Funçao de impressão de mensagens

Static Function IMPMENS(nLinMens)

Local cTexto 	:= ""
local aTexto 	:= {}

cTexto := "1. Considerando-se que a contratação dos serviços de veiculação requer prévia reserva de espaço comercial,"
cTexto += " não será permitido o cancelamento deste instrumento, salvo na hipótese de reprovação de cadastro do CONTRATANTE"
cTexto += " para as vendas à prazo. 2.Deste modo, o(a) CONTRATANTE, desde já, reconhece como líquido, certo e exigíveis os valores"
cTexto += " constantes do quadro de faturamento adiante delineado. 3. MATERIAL E PRAZO DE ENTREGA: O material deverá"
cTexto += " ser entrege convertido para o sistema operacional da CONTRATADA, no departamento de operações comerciais da mesma,"
cTexto += " sempre com 36 horas de antecedência. 4 DETERMINAÇÃO DE MATERIAL DE EXIBIÇÃO: A determinação (VT) serão de"
cTexto += " responsabilidade do Anunciante. 5 CRÉDITOS: O presente contrato é firmado entre as partes e nao podendo ser"
cTexto += " transferido ou cedido para terceiros a utilização de espaços contratados. 6. FALHAS: Em caso de falha será adotado"
cTexto += " a compensação no mesmo programa em nova data. 7. PROGRAMAÇÃO: Em caso de aletrações na grade de programação a"
cTexto += " CONTRATADA sempre fará valer o horário contrato para a veiculação e não a título de programa. 8. COBRANÇA: A"
cTexto += " CONTRATADA nao mantém colaboradores. Toda a sua cobrança é feita via banco. 9. Na hipótese de atraso dos pagamentos,"
cTexto += " a CONTRATANTE pagará a dívida atualizada pelo INPC, acrescida de juros de 1% ao mês e multa moratória de 2%"
cTexto += " sobre o montante devido. 10. Fica eleito o Foro da Comarca da CONTRATADA, para dirimir dúvidas ou questões oriundas do"
cTexto += " presente contrato."

aTexto := JustificaTxt(cTexto,250,.T.,.F.)

nLinMens := nLinMens + 50

// valido quebra de página  Se quebrar, imprimo o cabeçalho
if nLinMens + 25*len(aTexto) >= 2300
	oPrn:EndPage()
	oPrn:StartPage()
	nLinMens	:= ImpCabec()
	nLinMens	:= nLinMens + 50
endif

For nI:=1 to Len(aTexto)
	if !empty(aTexto[nI])
		oPrn:Say(nLinMens, 0100, alltrim(aTexto[nI]) ,oFont08,100)
		nLinMens := nLinMens + 25
	endif
Next nI

return(nLinMens)

//-----------------------------------------------------------------------------------------------------------------------------
// Funçao de impressão do Rodapé

Static Function IMPRODAPE(nLinRod)

// valido quebra de página  Se quebrar, imprimo o cabeçalho
if nLinRod + 400 >= 2300
	oPrn:EndPage()
	oPrn:StartPage()
	nLinRod		:= ImpCabec()
	nLinRod2	:= nLinRod + 300
else
	nLinRod := nLinRod + 50
	nLinRod2 := nLinRod + 300
endif

// Contratada - 650
oPrn:Box(nLinRod,100,nLinRod2,720)
oPrn:Say(nLinRod,125, "CONTRATADA",oFont08,100)

// Contratante - 650
oPrn:Box(nLinRod,720,nLinRod2,1370)
oPrn:Say(nLinRod,740, "CONTRATANTE",oFont08,100)

// Avalista - 650
oPrn:Box(nLinRod,1370,nLinRod2,2020)
oPrn:Say(nLinRod,1390, "AVALISTA",oFont08,100)

// Contato - 650
oPrn:Box(nLinRod,2020,nLinRod2,2670)
oPrn:Say(nLinRod,2040, "CONTATO",oFont08,100)

// Crédito - 650
oPrn:Box(nLinRod,2670,nLinRod2,3325)
oPrn:Say(nLinRod,2690, "CRÉDITO: APROVAÇÃO/VISTO",oFont08,100)
oPrn:Say(nLinRod + 50,2690, "SIM",oFont08,100)
oPrn:Box(nLinRod + 50,3100,nLinRod + 100,3200)
oPrn:Say(nLinRod + 100,2690, "NAO",oFont08,100)
oPrn:Box(nLinRod + 100,3100,nLinRod + 150,3200)

nLinRod := nLinRod + 250

// Contratada - 650
oPrn:Line(nLinRod,100,nLinRod,720)
oPrn:Say(nLinRod,125, "(Assinatura da Contratada)",oFont08,100)

// Contratante - 650
oPrn:Line(nLinRod,720,nLinRod,1370)
oPrn:Say(nLinRod,740, "(Assinatura do Contratante)",oFont08,100)

// Avalista - 650
oPrn:Line(nLinRod,1370,nLinRod,2020)
oPrn:Say(nLinRod,1390, "(Assinatura do Avalista)",oFont08,100)

// Contato - 650
oPrn:Line(nLinRod,2020,nLinRod,2670)
oPrn:Say(nLinRod,2040, "(Assinatura do Contato)",oFont08,100)

// Crédito - 650
oPrn:Line(nLinRod,2670,nLinRod,3325)
oPrn:Say(nLinRod,2690, "(Assinatura)",oFont08,100)

return()

//----------------------------------------------------------------------------------------------------------------------------
// função que alimenta o cronograma financeiro

static Function A600SmsFinance()

Local aArea			:= GetArea()
Local aVencto 		:= {}
Local aCronoAtu		:= {}
Local nC			:= 0
Local nA			:= 0
Local nS			:= 0
Local nI			:= 0
Local nPosData		:= 0
Local cTipoPar		:= SuperGetMv("MV_1DUP")
Local cSequencia    := " "  
Local aProdutos		:= {}
Local aCronoFin		:= {}
Local aTipo09		:= {}
Local lAdCronograma	:= .T.

aAdd(aProdutos,A600) //Produto(s)

For nS:=1 TO Len(aProdutos)	//Folder Produto(s)

	For nI:=1 To Len(aProdutos[nS])

		lAdCronograma := .T.

		DbSelectArea("SE4")
		DbSetOrder(1)
		IF	dbSeek(xFilial("SE4")+aProdutos[nS][nI][3])

			If	SE4->E4_TIPO <> "9" .AND. lAdCronograma

		   		aVencto := Condicao(aProdutos[nS][nI][2],aProdutos[nS][nI][3],0,dDatabase,0)

				For nA:=1 To Len(aVencto)

					If	!Empty(aProdutos[nS][nI][4]) .AND. aProdutos[nS][nI][4] <> dDataBase .AND. nA == 1
						aVencto[nA,1] := aProdutos[nS][nI][4]
					Endif

					// Tratamento para evitar de cair o vencimento nos finais de semana.
					aVencto[nA,1] := DataValida(aVencto[nA,1])

					nPosData := aScan( aCronoAtu, { |x| x[1] == aVencto[nA,1] } )

					If	nPosData == 0
						Aadd(aCronoAtu,{aVencto[nA,1],aVencto[nA,2]})
					Else
						aCronoAtu[nPosData,2] += aVencto[nA,2]
					Endif

				Next nA

			Endif

		Endif

	Next nI

Next nS

If	Len(aTipo09)>0

	For nA:=1 To Len(aTipo09)

		If	lAdCronograma

			// Tratamento para evitar de cair o vencimento nos finais de semana.
			aTipo09[nA,2] := Datavalida(aTipo09[nA,2])

			If	Len(aCronoAtu)>0
				nPosData := aScan( aCronoAtu, { |x| x[1] == aTipo09[nA,2] } )
			Else
				nPosData := 0
			Endif

			If	nPosData == 0
				aadd(aCronoAtu,{aTipo09[nA,2],aTipo09[nA,3]})
			Else
				aCronoAtu[nPosData,2] += aTipo09[nA,3]
			Endif

		Endif

	Next nA

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Trata o iniciador da parcela inicial ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	cTipoPar == "A"
	cSequencia	:= "9"
Else
	cSequencia	:= "0"
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordena as parcelas pela data de vencimento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCronoAtu := ASort(aCronoAtu,,,{|parc1,parc2|parc1[1]<parc2[1]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza cronograma financeiro ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nC:=1 To Len(aCronoAtu)

	cSequencia := Soma1(cSequencia)

	If	nC == 1
		aadd(aCronoFin,{"",CtoD(Space(8)),0})
		aCronoFin[nC,1] := Substr(cSequencia,1,1)
		aCronoFin[nC,2] := aCronoAtu[nC,1]
		aCronoFin[nC,3] := aCronoAtu[nC,2]
	Else
		AAdd(aCronoFin,{SubStr(cSequencia,1,1),aCronoAtu[nC,1],aCronoAtu[nC,2]})
	Endif

	If cSequencia == "Z"
		cSequencia := "0"
	Endif

Next nC

RestArea(aArea)

Return(aCronoFin)

//-----------------------------------------------------------------------------------------------------------------------------
Static Function ConvType(xValor,nTam,nDec)

Local cNovo := ""

DEFAULT nDec := 0

Do Case
	Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor,nTam,nDec))
		Else
			cNovo := "0"
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
//		DEFAULT nTam := 60
//		cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam))))

	Case valtype(xValor) == "U"
			xValor := ""

EndCase

Return(cNovo)

//-------------------------------------------

//Imprime Grid e/ou Cordenadas
Static Function Grid(oPrn,oFnt,lGrid)
Local i:=0

For i:= 100 To 3325 STEP 25
    If lGrid
       oPrn:Line(i, 100, i, 3325) //H
    Endif
    oPrn:Say(i-10,25,Strzero(i,4),oFnt)
Next

For i:= 100 To 3325 STEP 25
    If lGrid
       oPrn:Line(100, i, 3400, i) //V
    Endif
    oPrn:Say(10,i-5,substr(strzero(i,4),1,1),oFnt)
    oPrn:Say(28,i-5,substr(strzero(i,4),2,1),oFnt)
    oPrn:Say(46,i-5,substr(strzero(i,4),3,1),oFnt)
    oPrn:Say(64,i-5,substr(strzero(i,4),4,1),oFnt)
Next
Return Nil
