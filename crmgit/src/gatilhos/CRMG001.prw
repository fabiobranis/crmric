
/*__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    �  Gatilhos   � Autor � Renata C Calaca     � Data �  .  .   ���
��+----------+------------------------------------------------------------���
���Descri��o � Fun��es inseridas nos gatilhos criados para realizar os    ���
���          � c�lculos das convers�es de acordo com o tipo de proposta e ���
���          � tambem c�lculo dos descontos e do pre�o de venda.          ���
��+-----------------------------------------------------------------------+��
���Uso       � Gatilhos de c�lculo de valores no campo quantidade.        ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

/*----------------------------------------------------------------------+
�C�lculo do pre�o de tabela baseado no fator de convers�o e quantidade. �
+----------------------------------------------------------------------*/                                    

//Calcula valor unit�rio negociado

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

//Calcula valor unit�rio tabela

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
�       C�lculo do pre�o de tabela baseado no fator de convers�o.       �
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
�C�lculo do pre�o de tabela baseado no fator de convers�o com desconto. �
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


//Calcula valor unit�rio tabela

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