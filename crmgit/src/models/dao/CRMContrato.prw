#include 'protheus.ch'

#define MSGCONTR "1. Considerando-se que a contratação dos serviços de veiculação requer prévia reserva de espaço comercial, não será permitido o cancelamento deste instrumento, salvo na hipótese de reprovação de cadastro do CONTRATANTE para as vendas à prazo. 2.Deste" +;
					"modo, o(a) CONTRATANTE, desde já, reconhece como líquido, certo e exigíveis os valores constantes do quadro de faturamento adiante delineado. 3. MATERIAL E PRAZO DE ENTREGA: O material deverá ser entrege convertido para o sistema operacional da "+;
					"CONTRATADA, no departamento de operações comerciais da mesma, sempre com 36 horas de antecedência. 4 DETERMINAÇÃO DE MATERIAL DE EXIBIÇÃO: A determinação (VT) serão de responsabilidade do Anunciante. 5 CRÉDITOS: O presente contrato é firmado entre as"+;
					"partes e nao podendo ser transferido ou cedido para terceiros a utilização de espaços contratados. 6. FALHAS: Em caso de falha será adotado a compensação no mesmo programa em nova data. 7. PROGRAMAÇÃO: Em caso de aletrações na grade de programação a"+;
					"CONTRATADA sempre fará valer o horário contrato para a veiculação e não a título de programa. 8. COBRANÇA: A CONTRATADA nao mantém colaboradores. Toda a sua cobrança é feita via banco. 9. Na hipótese de atraso dos pagamentos, a CONTRATANTE pagará a"+;
					"dívida atualizada pelo INPC, acrescida de juros de 1% ao mês e multa moratória de 2% sobre o montante devido. 10. Fica eleito o Foro da Comarca da CONTRATADA, para dirimir dúvidas ou questões oriundas do presente contrato."
/*/{Protheus.doc} CRMContrato
(long_description)
@author fabio
@since 08/09/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMContrato 
	
	data propos
	data empdata
	data clidata
	data agencdata
	data tottab
	data totdesc
	data totnegbr
	data perccom
	data totliq
	data totgrp
	data msgcontr
	data apracasvei
	data aitens
	data afatura
	
	method new(cNumProp) constructor 
	method SetTotTab() 
	method SetTotDesc() 
	method SetTotNegBr() 
	method SetTotLiq() 
	method SetTotGRP() 

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
method new(cNumProp) class CRMContrato
	
	local cFilAux	:= cFilAnt
	local aFatur	:= {}
	
	ADY->(dbsetorder(1))
	if ADY->(dbseek(xFilial("ADY") + cNumProp))
		::propos    := ADY->ADY_PROPOS
		::empdata   := CRMFornCont():New()
		::clidata   := CRMCliCont():New(ADY->ADY_CODIGO)
		::agencdata := CRMAgenCont():New(ADY->ADY_VEND)
		::tottab    := 0
		::totdesc   := 0
		::totnegbr  := 0
		::perccom   := 20
		::totliq    := 0
		::totgrp    := 0
		::msgcontr  := MSGCONTR
		::aitens	:= {}
		::apracasvei	:= {}
		
		ADZ->(dbsetorder(1))
		if ADZ->(dbseek(xFilial("ADZ") + ADY->ADY_PROPOS))
			while ADZ->(!eof()) .and. ADZ->(ADZ_FILIAL + ADZ_PROPOS) == ADY->(ADY_FILIAL + ADY_PROPOS)
				aadd(::aitens,CRMItensCont():New(ADZ->ADZ_PROPOS, ADZ->ADZ_ITEM))
				aadd(aFatur,{ADZ->ADZ_PRODUT,ADZ->(ADZ_QTDVEN * ADZ_PRCTAB),ADZ->ADZ_CONDPG,ADZ->ADZ_DT1VEN})
				ADZ->(dbskip())
			enddo
		endif
		aadd(::apracasvei,CRMPracasCont():New(xFilial("ADY"),ADY->ADY_PROPOS))
		ZAE->(dbsetorder(1))
		if ZAE->(dbseek(xFilial("ZAE") + ADY->ADY_PROPOS))
			while ZAE->(!eof()) .and. ZAE->(ZAE_FILIAL + ZAE_NUMPRC) == ADY->(ADY_FILIAL + ADY_PROPOS)
				
				cFilAnt := ZAE->ZAE_FILPRP
				aadd(::apracasvei,CRMPracasCont():New(ZAE->ZAE_FILPRP,ZAE->ZAE_PROPOS))
				if ADZ->(dbseek(xFilial("ADZ") + ZAE->ZAE_PROPOS))
					while ADZ->(!eof()) .and. ADZ->(ADZ_FILIAL + ADZ_PROPOS) == ZAE->(ZAE_FILPRP + ZAE_PROPOS)
						aadd(::aitens,CRMItensCont():New(ADZ->ADZ_PROPOS, ADZ->ADZ_ITEM))
						aadd(aFatur,{ADZ->ADZ_PRODUT,ADZ->(ADZ_QTDVEN * ADZ_PRCTAB),ADZ->ADZ_CONDPG,ADZ->ADZ_DT1VEN})
						ADZ->(dbskip())
					enddo
				endif
				
				ZAE->(dbskip())
			enddo
		endif
		cFilAnt := cFilAux
		
		if len(aFatur) > 0
			::afatura := A600SmsFinance(aFatur)
		endif
		::tottab    := ::SetTotTab()
		::totdesc   := ::SetTotDesc()
		::totnegbr  := ::SetTotNegBr()
		::totliq    := ::SetTotLiq()
		::totgrp    := ::SetTotGRP()
		
	endif

return self

method SetTotTab() class CRMContrato
	
	local nTotal	:= 0
	local ni		:= 0
	for ni := 1 to len(::aitens)
		nTotal += ::aitens[ni]:prctottab
	next
	
return nTotal

method SetTotDesc() class CRMContrato
	local nTotal	:= 0
	local ni		:= 0
	for ni := 1 to len(::aitens)
		nTotal += ::aitens[ni]:descont 
	next
return nTotal

method SetTotNegBr() class CRMContrato
	local nTotal	:= 0
	local ni		:= 0
	for ni := 1 to len(::aitens)
		nTotal += (::aitens[ni]:totalneg + ::aitens[ni]:descont) 
	next
return nTotal

method SetTotLiq() class CRMContrato
	local nTotal	:= 0
	local ni		:= 0
	for ni := 1 to len(::aitens)
		nTotal += ::aitens[ni]:totalneg 
	next
return nTotal

method SetTotGRP() class CRMContrato
	local nTotal	:= 0
	local ni		:= 0
	for ni := 1 to len(::aitens)
		nTotal += 0
	next
return nTotal


// função que alimenta o cronograma financeiro

static Function A600SmsFinance(aFatur)

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
	
	aAdd(aProdutos,aFatur) //Produto(s)
	
	// Tratamento para colunas do financeiro
	/*
	aadd(a600,array(04))
	a600[_n][1] := (_cAliasAdz)->ADZ_PRODUT
	a600[_n][2] := aProp[_n][45]
	a600[_n][3] := (_cAliasAdz)->ADZ_CONDPG
	a600[_n][4] := (_cAliasAdz)->ADZ_DT1VEN
	*/
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