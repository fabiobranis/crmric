
	
/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦  AXCadastro ¦ Autor ¦ Renata C Calaca     ¦ Data ¦01.12.14 ¦¦¦


¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Funções inseridas nos gatilhos criados para realizar os    ¦¦¦
¦¦¦          ¦ cálculos da views de internet para preço de tabela         ¦¦¦ 
¦¦¦          ¦ tambem cálculo dos descontos e do preço de venda.          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Uso       ¦ Conversões de valores.                                     ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/ 

User Function GatInt(nDesc,nPage,cFil,cTabPrc,cCodPro)
	
	Local nFator	:=  iif(nPage > 0,(nPage * 1000),1)
	Local nPrctab	:= u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	Local nValUn	:= 0
	
	if nDesc > 0
		nValUn := nPrctab - (nPrctab * (nDesc/100))
	else
		nValUn := nPrctab
	endif

Return (nValUn)

//Calcula valor unitário tabela

User Function GatInt1(nPage,cFil,cTabPrc,cCodPro)
	
	Local nFator	:=  iif(nPage > 0,(nPage * 1000),1)
	Local nPrctab	:= u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	
Return (nPrctab)


//Calcula valor total negociado

User Function GatInt2(nDesc,nQtde,nPage,cFil,cTabPrc,cCodPro)

	Local nNegBr	:= 0
	Local nFator	:= iif(nPage > 0,(nPage * 1000),1)
	Local nPrctab	:= u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	
	if nDesc > 0
		nNegBr := nQtde * (nPrcTab - (nPrcTab * (nDesc/100)))
	else
		nNegBr := nQtde * nPrcTab
	endif
	
Return (nNegBr)


//Calcula valor total tabela

User Function GatInt3(nQtde,nPage,cFil,cTabPrc,cCodPro)

	Local nNegLiq	:= 0 
	Local nFator	:=  iif(nPage > 0,(nPage * 1000),1)
	Local nPrctab	:= u_Tabprc(cFil,cTabPrc,cCodPro) * nFator
	
	nNegLiq := nPrctab * nQtde

Return (nNegLiq)



/*----------------------------------------------------------------------+
¦         Cálculo de unitario negociado da tabela de Internet.		    ¦
+----------------------------------------------------------------------*/     

User Function ConvInt(nDesc,nPage,cFil,cTabPrc,cCodPro)
    
	Local nUniNeg := 0      
	Local nPrcTab := u_Tabprc(cFil,cTabPrc,cCodPro) 
	Local nUnit   := 0		   
	Local nFator 	:= iif(nPage > 0,(nPage * 1000),1) //M->ADZ_XFORMA                                                         
	
	nUniNeg := nPrcTab * nFator  
	nUniNeg := nUniNeg
	
	If nDesc > 0
	
		nUnit := nPrcTab * nFator
		nUniNeg := nUnit - (nUnit * (nDesc/100)) 
	                                           
	EndIf

Return (nUniNeg)    
   

/*----------------------------------------------------------------------+
¦               Cálculo do preço de tabela de internet.                 ¦
+----------------------------------------------------------------------*/

User Function ConvInt1(nPage,cFil,cTabPrc,cCodPro)       
                                                      
	Local nUniTab := 0  
	Local nPrcTab := u_Tabprc(cFil,cTabPrc,cCodPro)   
	Local nUnit   := 0                 
	Local nFator 	:= iif(nPage > 0,(nPage * 1000),1) //M->ADZ_XFORMA                                                                              
	
	nUniTab := nPrcTab * nFator 
	
	nUniTab := nUniTab 
 
Return (nUniTab)  


/*----------------------------------------------------------------------+
¦       Cálculo do preço de tabela baseado no fator de conversão.       ¦
+----------------------------------------------------------------------*/

User Function ConvInt2(nDesc,nPage,nQtde,cFil,cTabPrc,cCodPro)       
                                                       
	Local nTotNeg := 0 
	Local nPrcTab := u_Tabprc(cFil,cTabPrc,cCodPro)   
	Local nUnit   := 0       
	Local nFator 	:= iif(nPage > 0,(nPage * 1000),1) //M->ADZ_XFORMA                                                          
	
	If nDesc == 0   
	
		nUnit := nPrcTab * nFator                          
		nTotNeg:= nUnit * nQtde    
	
	Else
		nUnit := nPrcTab * nFator   
		nTotNeg := nUnit - (nUnit * (nDesc/100))  
		nTotNeg:= nTotNeg * nQtde
	EndIf

Return (nTotNeg) 


/*----------------------------------------------------------------------+
¦                Cálculo do  valor final com determinação.              ¦
+----------------------------------------------------------------------*/    
                                                                     	

User Function ConvInt3(nPage,nQtde,cFil,cTabPrc,cCodPro)       
                                                      
	Local nTotTab := 0   
	Local nPrcTab := u_Tabprc(cFil,cTabPrc,cCodPro) 
	Local nUnit   := 0           
	Local nFator 	:= iif(nPage > 0,(nPage * 1000),1) //M->ADZ_XFORMA                                                      
	                        
	nUnit := nPrcTab * nFator                           
	
	nTotTab:= nUnit * nQtde     
  

Return (nTotTab) 

User Function DescInt(nDesc,nPage,cFil,cTabPrc,cCodPro)
 
	Local nFator 	:= iif(nPage > 0,(nPage * 1000),1) //M->ADZ_XFORMA
	Local nValUn 	:= 0
	Local nPrcTab	:= u_Tabprc(cFil,cTabPrc,cCodPro)

	nValUn:= nPrcTab * nFator  
	if nDesc > 0
		nValUn := nValUn -(nValUn * (nDesc / 100))
	endif
		
Return (nValUn)


//Calcula valor unitário tabela

User Function DescInt1(nPage,cFil,cTabPrc,cCodPro)
                             
	Local nFator 	:= iif(nPage > 0,(nPage * 1000),1) //M->ADZ_XFORMA
	Local nTabUn 	:= 0
	Local nPrcTab	:= u_Tabprc(cFil,cTabPrc,cCodPro)
		
	nTabUn := nPrcTab * nFator

Return (nTabUn)


//Calcula valor total negociado

User Function DescInt2(nDesc,nQtde,nPage,cFil,cTabPrc,cCodPro) 

	Local nFator 	:= iif(nPage > 0,(nPage * 1000),1) //M->ADZ_XFORMA
	Local nNegBr := 0
	Local nPrcTab := u_Tabprc(cFil,cTabPrc,cCodPro)

	nPrcTab := nPrcTab * nFator
	if nDesc > 0 		
		nPrcTab := nPrcTab - (nPrcTab * (nDesc / 100))
	endif		
	nNegBr:= nPrcTab * nQtde

Return (nNegBr)


//Calcula valor total tabela

User Function DescInt3(nQtde,nPage,cFil,cTabPrc,cCodPro)
                     
	Local nFator 	:= iif(nPage > 0,(nPage * 1000),1) //M->ADZ_XFORMA
	Local nNegLiq:= 0
	nPrcTab:= u_Tabprc(cFil,cTabPrc,cCodPro)
		
	nNegLiq:= nPrcTab * nFator 		
	nNegLiq:= nNegLiq * nQtde

Return (nNegLiq)

