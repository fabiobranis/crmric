
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

User Function GatTv(nDesc,nFmto,cFil,cTabPrc,cCodPro)
	
	Local nFator	:= iif(nFmto > 0, nFmto, 1)
	Local nPrctab	:= u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	Local nValUn	:= 0
	
	if nDesc > 0
		nValUn := nPrctab - (nPrctab * (nDesc/100))
	else
		nValUn := nPrctab
	endif

Return (nValUn)

//Calcula valor unitário tabela

User Function GatTv1(nFmto,cFil,cTabPrc,cCodPro)
	
	Local nFator	:= iif(nFmto > 0, nFmto, 1)
	Local nPrctab	:= u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	
Return (nPrctab)


//Calcula valor total negociado

User Function GatTv2(nDesc,nQtde,nFmto,cFil,cTabPrc,cCodPro)

	Local nNegBr	:= 0
	Local nFator	:= iif(nFmto > 0, nFmto, 1)
	Local nPrctab	:= u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	
	if nDesc > 0
		nNegBr := nQtde * (nPrcTab - (nPrcTab * (nDesc/100)))
	else
		nNegBr := nQtde * nPrcTab
	endif
	
Return (nNegBr)


//Calcula valor total tabela

User Function GatTv3(nQtde,nFmto,cFil,cTabPrc,cCodPro)

	Local nNegLiq	:= 0 
	Local nFator	:= iif(nFmto > 0, nFmto, 1)
	Local nPrctab	:= u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	
	nNegLiq := nPrctab * nQtde

Return (nNegLiq)


                                                                                                 
/*----------------------------------------------------------------------+
¦       Cálculo do preço de tabela baseado no fator de conversão.       ¦
+----------------------------------------------------------------------*/

User Function ConvTv(nDesc,nForma,cFil,cTabPrc,cCodPro)

	Local nFator 	:= iif(nForma > 0,nForma,1) //M->ADZ_XFORMA
	Local nUniNeg:= 0

	//nUniNeg := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})] * nFator
	nUniNeg := u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	
	if nDesc > 0
		nUniNeg := nUniNeg - (nUniNeg * (nDesc/100))
	endif

Return (nUniNeg)   
  

User Function ConvTv1(nForma,cFil,cTabPrc,cCodPro)

	Local nFator := iif(nForma > 0,nForma,1) //M->ADZ_XFORMA
	Local nUniTab:= 0

	//nUniNeg := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})] * nFator
	nUniTab := u_Tabprc(cFil,cTabPrc,cCodPro) * nFator

Return (nUniTab)      



User Function ConvTv2(nDesc,nQtde,nForma,cFil,cTabPrc,cCodPro)

	Local nFator 	:= iif(nForma > 0,nForma,1)//M->ADZ_XFORMA
	Local nTotLiq	:= 0 
	
	nTotLiq := u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	if nDesc > 0
		nTotLiq := nTotLiq - (nTotLiq * (nDesc/100))
	endif
	nTotLiq := nTotLiq * nQtde

Return (nTotLiq)     


User Function ConvTv3(nQtde,nForma,cFil,cTabPrc,cCodPro)

	Local nFator:= iif(nForma > 0,nForma,1)//M->ADZ_XFORMA
	Local nTotBrt:= 0
	
	nTotBrt := u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	
	nTotBrt := nTotBrt * nQtde

Return (nTotBrt) 
                 

/*----------------------------------------------------------------------+
¦Cálculo do preço de tabela baseado no fator de conversão com desconto. ¦
+----------------------------------------------------------------------*/

User Function DescTv(nDesc,nForma,cFil,cTabPrc,cCodPro)
                          

	Local nFator 	:= iif(nForma > 0,nForma,1)//M->ADZ_XFORMA
	Local nValUn 	:= 0
	Local nPrcTab	:= u_Tabprc(cFil,cTabPrc,cCodPro)

	nValUn:= nPrcTab * nFator  
	if nDesc > 0
		nValUn := nValUn -(nValUn * (nDesc / 100))
	endif
		
Return (nValUn)


//Calcula valor unitário tabela

User Function DescTv1(nForma,cFil,cTabPrc,cCodPro)
                             
	Local nFator	:=  iif(nForma > 0,nForma,1) //M->ADZ_XFORMA
	Local nTabUn 	:= 0
	Local nPrcTab	:= u_Tabprc(cFil,cTabPrc,cCodPro)
		
	nTabUn := nPrcTab * nFator

Return (nTabUn)


//Calcula valor total negociado

User Function DescTv2(nDesc,nQtde,nForma,cFil,cTabPrc,cCodPro) 

	Local nFator := iif(nForma > 0,nForma,1)  //M->ADZ_XFORMA
	Local nNegBr := 0
	Local nPrcTab := u_Tabprc(cFil,cTabPrc,cCodPro)

	nPrcTab := nPrcTab * nFator
	if nDesc > 0 		
		nPrcTab := nPrcTab - (nPrcTab * (nDesc / 100))
	endif		
	nNegBr:= nPrcTab * nQtde

Return (nNegBr)


//Calcula valor total tabela

User Function DescTv3 (nQtde,nForma,cFil,cTabPrc,cCodPro)
                     
	Local nFator:= iif(nForma > 0,nForma,1)//M->ADZ_XFORMA
	Local nNegLiq:= 0
	nPrcTab:= u_Tabprc(cFil,cTabPrc,cCodPro)
		
	nNegLiq:= nPrcTab * nFator 		
	nNegLiq:= nNegLiq * nQtde

Return (nNegLiq)