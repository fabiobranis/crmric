
/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦  Gatilhos   ¦ Autor ¦ Renata C Calaca     ¦ Data ¦  .  .   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Funções inseridas nos gatilhos criados para realizar os    ¦¦¦
¦¦¦          ¦ cálculos das conversões de acordo com o tipo de proposta e ¦¦¦
¦¦¦          ¦ tambem cálculo dos descontos e do preço de venda.          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Uso       ¦ Gatilhos de cálculo de valores no campo quantidade.        ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

/*----------------------------------------------------------------------+
¦Cálculo do preço de tabela baseado no fator de conversão e quantidade. ¦
+----------------------------------------------------------------------*/                                    

//Calcula valor unitário negociado

User Function GatTv(nPrctab,nDesc,nFmto,VlrUn)

If nDesc == 0 .AND. nFmto == 0
	
	nValUn:= nPrctab
	
ElseIf nDesc == 0 .AND. nFmto <> 0
	
	nValUn:= VlrUn
	
ElseIf nDesc <> 0 .AND. nFmto == 0
	
	nValUn:=nPrctab-(nPrctab*nDesc/100)
	
Else
	
	nValUn:=nPrctab-(nPrctab*nDesc/100)
	
EndIf

Return (nValUn)


//Calcula valor unitário tabela

User Function GatTv1(nPrcTab,nDesc,nFmto)

Local nTabUn:= 0

If nDesc == 0 .AND. nFmto == 0
	
	nTabUn:= nPrctab
	
ElseIf nDesc == 0 .AND. nFmto <> 0
	
	nTabUn:= nPrcTab
	
ElseIf nDesc <> 0 .AND. nFmto == 0
	
	nTabUn:=nPrcTab
	
Else
	
	nTabUn:=nPrcTab
	
EndIf

Return (nTabUn)


//Calcula valor total negociado

User Function GatTv2(nPrcTab,nDesc,nFmto,nQtde)

Local nNegBr:=0

If nDesc == 0 .AND. nFmto == 0
	
	nNegBr:= nPrctab
	
	nNegBr:= nNegBr * nQtde
	
ElseIf nDesc == 0 .AND. nFmto <> 0
	
	nNegBr:= nPrcTab * nQtde
	
ElseIf nDesc <> 0 .AND. nFmto == 0
	
	nNegBr:=nPrcTab-(nPrcTab*nDesc/100)
	
	nNegBr:= nNegBr * nQtde
	
Else
	
	nNegBr:=nPrcTab-(nPrcTab*nDesc/100)
	
	nNegBr:= nNegBr * nQtde
	
EndIf

Return (nNegBr)


//Calcula valor total tabela

User Function GatTv3(nPrcTab,nDesc,nFmto,nQtde)

Local nNegLiq:=0 

If nDesc == 0 .AND. nFmto == 0
	
	nNegLiq:= nPrctab
	
	nNegLiq:= nNegLiq * nQtde
	
ElseIf nDesc == 0 .AND. nFmto <> 0
	
	nNegLiq:= nPrcTab * nQtde
	
ElseIf nDesc <> 0 .AND. nFmto == 0
	
	nNegLiq:=nPrcTab * nQtde
	
Else
	
	nNegLiq:=nPrcTab * nQtde
	
EndIf

Return (nNegLiq)


                                                                                                 
/*----------------------------------------------------------------------+
¦       Cálculo do preço de tabela baseado no fator de conversão.       ¦
+----------------------------------------------------------------------*/

User Function ConvTv(nDesc)

Local nFator := ZA9->ZA9_FATOR
Local nUniNeg:= 0



For nX := 1 to len(acols)
	
	nUniNeg := aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})] * nFator
	
Next nX

If nDesc == 0
	
	nUniNeg := nUniNeg
	
Else
	
	nUniNeg :=nUniNeg-(nUniNeg*nDesc/100)
	
EndIf

Return (nUniNeg)   
  

User Function ConvTv1()

Local nFator := ZA9->ZA9_FATOR
Local nUniTab:= 0

	nUniTab := aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})] * nFator

	nUniTab := nUniTab 


Return (nUniTab)      



User Function ConvTv2(nDesc,nQtde)

Local nFator := ZA9->ZA9_FATOR
Local nTotLiq:= 0 
	
	nTotLiq := aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})] * nFator
	
	
If nDesc == 0
	
		nTotLiq := nTotLiq * nQtde
	
Else
	
	nTotLiq := nTotLiq * nQtde
	
	nTotLiq :=nTotLiq-(nTotLiq*nDesc/100)

		nTotLiq := nTotLiq * nQtde
	
EndIf

Return (nTotLiq)     


User Function ConvTv3(nQtde)

Local nFator:= ZA9->ZA9_FATOR
Local nTotBrt:= 0

	
	nTotBrt := aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})] * nFator
	
		nTotBrt := nTotBrt * nQtde

Return (nTotBrt) 
                 

/*----------------------------------------------------------------------+
¦Cálculo do preço de tabela baseado no fator de conversão com desconto. ¦
+----------------------------------------------------------------------*/

User Function DescTv(nDesc,nFmto)
                          

Local nFator:= ZA9->ZA9_FATOR
Local nValUn := 0
Local nPrcTab:= aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})]

	If nFmto == 0
	
	nValUn:= nPrcTab 
	
	nValUn:=nValUn-(nValUn*nDesc/100)
	
Else 
	
	nValUn:= nPrcTab * nFator  
	
	nValUn:=nValUn-(nValUn*nDesc/100)
	
EndIf                                                       

Return (nValUn)


//Calcula valor unitário tabela

User Function DescTv1(nFmto)
                             
Local nFator:= ZA9->ZA9_FATOR
Local nTabUn := 0
Local nPrcTab:= aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})]

If nFmto == 0
	
	nTabUn:= nPrcTab * nFator
	
Else
	
	nTabUn:= nPrcTab
	
EndIf

Return (nTabUn)


//Calcula valor total negociado

User Function DescTv2(nDesc,nQtde,nFmto) 

Local nFator:= ZA9->ZA9_FATOR
Local nNegBr := 0
Local nPrcTab:= aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})]

If nFmto == 0
	
	nNegBr:=nPrcTab-(nPrcTab*nDesc/100)
	
	nNegBr:= nNegBr * nQtde
	
Else
	
	nPrcTab := nPrcTab * nFator 
	
	nNegBr:=nPrcTab-(nPrcTab*nDesc/100)
	
	nNegBr:= nNegBr * nQtde
	
EndIf

Return (nNegBr)


//Calcula valor total tabela

User Function DescTv3 (nFmto,nQtde)
                     
Local nFator:= ZA9->ZA9_FATOR
Local nNegLiq:= 0
nPrcTab:= aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})]


If nFmto == 0
	
	nNegLiq:= nPrcTab
	
	nNegLiq:= nNegLiq * nQtde
	
Else
	
	nNegLiq:= nPrcTab * nFator 
	
	nNegLiq:= nNegLiq * nQtde
	
EndIf

Return (nNegLiq)