	
/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦  AXCadastro ¦ Autor ¦ Renata C Calaca     ¦ Data ¦01.12.14 ¦¦¦


¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Funções inseridas nos gatilhos criados para realizar os    ¦¦¦
¦¦¦          ¦ cálculos das conversões de cardo com o tipo de proposta e  ¦¦¦ 
¦¦¦          ¦ tambem cálculo dos descontos e do preço de venda.          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Uso       ¦ Conversões de valores.                                     ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/ 
               
User Function GatJnd(nDesc,nColuna,nAltura,cFil,cTabPrc,cCodPro)
	
	Local nFator 	:= iif(nColuna > 0 .and. nAltura > 0,(nColuna * nAltura),1)   
	Local nPrctab	:= u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	Local nValUn	:= 0
	
	if nDesc > 0
		nValUn := nPrctab - (nPrctab * (nDesc/100))
	else
		nValUn := nPrctab
	endif

Return (nValUn)

//Calcula valor unitário tabela

User Function GatJnd1(nColuna,nAltura,cFil,cTabPrc,cCodPro)
	
	Local nFator 	:= iif(nColuna > 0 .and. nAltura > 0,(nColuna * nAltura),1)   
	Local nPrctab	:= u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	
Return (nPrctab)


//Calcula valor total negociado

User Function GatJnd2(nDesc,nQtde,nColuna,nAltura,cFil,cTabPrc,cCodPro)

	Local nNegBr	:= 0
	Local nFator 	:= iif(nColuna > 0 .and. nAltura > 0,(nColuna * nAltura),1)   
	Local nPrctab	:= u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	
	if nDesc > 0
		nNegBr := nQtde * (nPrcTab - (nPrcTab * (nDesc/100)))
	else
		nNegBr := nQtde * nPrcTab
	endif
	
Return (nNegBr)


//Calcula valor total tabela

User Function GatJnd3(nQtde,nColuna,nAltura,cFil,cTabPrc,cCodPro)

	Local nNegLiq	:= 0 
	Local nFator 	:= iif(nColuna > 0 .and. nAltura > 0,(nColuna * nAltura),1)   
	Local nPrctab	:= u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	
	nNegLiq := nPrctab * nQtde

Return (nNegLiq)


/*----------------------------------------------------------------------+
¦               Cálculo de conversão da tabela do JND.				    ¦
+----------------------------------------------------------------------*/     


User Function ConvJnd(nColuna,nAltura,nDesc,cFil,cTabPrc,cCodPro)
	
	Local nUniNeg 	:= 0      
	Local nPrcTab	:= u_Tabprc(cFil,cTabPrc,cCodPro)
	Local nFator 	:= iif(nColuna > 0 .and. nAltura > 0,(nColuna * nAltura),1)                                                           
	
	nUniNeg := nFator * nPrcTab
	
	if nDesc > 0
		nUniNeg := nUniNeg - (nUniNeg * (nDesc/100)) 
	endif

Return (nUniNeg)    
   

/*----------------------------------------------------------------------+
¦       Cálculo do preço de tabela baseado no fator de conversão.       ¦
+----------------------------------------------------------------------*/

User Function ConvJnd1(nColuna,nAltura,cFil,cTabPrc,cCodPro)       
                                                   
	Local nUniTab 	:= 0     
	Local nPrcTab	:= u_Tabprc(cFil,cTabPrc,cCodPro)                                                             
	Local nFator 	:= iif(nColuna > 0 .and. nAltura > 0,(nColuna * nAltura),1) 
	      
	nUniTab := nFator * nPrcTab

Return (nUniTab)  


/*----------------------------------------------------------------------+
¦       Cálculo do preço de tabela baseado no fator de conversão.       ¦
+----------------------------------------------------------------------*/

User Function ConvJnd2(nColuna,nAltura,nDesc,nQtde,cFil,cTabPrc,cCodPro)       
                                                  	
	Local nTotNeg 	:= 0 
	Local nPrcTab	:= u_Tabprc(cFil,cTabPrc,cCodPro)                                                                 
	Local nFator 	:= iif(nColuna > 0 .and. nAltura > 0,(nColuna * nAltura),1) 
	
	nTotNeg:= nFator * nPrcTab 
	
	if nDesc > 0
		nTotNeg := nPrcTab - (nPrcTab * (nDesc/100)) 
	endif
	
	nTotNeg:= nTotNeg * nQtde   

Return (nTotNeg) 


/*----------------------------------------------------------------------+
¦                Cálculo do  valor final com determinação.              ¦
+----------------------------------------------------------------------*/    
                                                                     	

User Function ConvJnd3(nColuna,nAltura,nQtde,cFil,cTabPrc,cCodPro)       
                                                   	
	Local nTotTab 	:= 0 
	Local nPrcTab	:= u_Tabprc(cFil,cTabPrc,cCodPro)  
	Local nFator 	:= iif(nColuna > 0 .and. nAltura > 0,(nColuna * nAltura),1) 
	
	nTotTab := nFator * nPrcTab  
	nTotTab := nTotTab * nQtde  

Return (nTotTab) 

User Function DescJnd(nDesc,nColuna,nAltura,cFil,cTabPrc,cCodPro)
                          

	Local nFator 	:= iif(nColuna > 0 .and. nAltura > 0,(nColuna * nAltura),1) //M->ADZ_XFORMA
	Local nValUn 	:= 0
	Local nPrcTab	:= u_Tabprc(cFil,cTabPrc,cCodPro)

	nValUn:= nPrcTab * nFator  
	if nDesc > 0
		nValUn := nValUn -(nValUn * (nDesc / 100))
	endif
		
Return (nValUn)


//Calcula valor unitário tabela

User Function DescJnd1(nColuna,nAltura,cFil,cTabPrc,cCodPro)
                             
	Local nFator	:=  iif(nColuna > 0 .and. nAltura > 0,(nColuna * nAltura),1)  //M->ADZ_XFORMA
	Local nTabUn 	:= 0
	Local nPrcTab	:= u_Tabprc(cFil,cTabPrc,cCodPro)
		
	nTabUn := nPrcTab * nFator

Return (nTabUn)


//Calcula valor total negociado

User Function DescJnd2(nDesc,nQtde,nColuna,nAltura,cFil,cTabPrc,cCodPro) 

	Local nFator := iif(nColuna > 0 .and. nAltura > 0,(nColuna * nAltura),1)   //M->ADZ_XFORMA
	Local nNegBr := 0
	Local nPrcTab := u_Tabprc(cFil,cTabPrc,cCodPro)

	nPrcTab := nPrcTab * nFator
	if nDesc > 0 		
		nPrcTab := nPrcTab - (nPrcTab * (nDesc / 100))
	endif		
	nNegBr:= nPrcTab * nQtde

Return (nNegBr)


//Calcula valor total tabela

User Function DescJnd3(nQtde,nColuna,nAltura,cFil,cTabPrc,cCodPro)
                     
	Local nFator:= iif(nColuna > 0 .and. nAltura > 0,(nColuna * nAltura),1) //M->ADZ_XFORMA
	Local nNegLiq:= 0
	nPrcTab:= u_Tabprc(cFil,cTabPrc,cCodPro)
		
	nNegLiq:= nPrcTab * nFator 		
	nNegLiq:= nNegLiq * nQtde

Return (nNegLiq)

