
	
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


/*----------------------------------------------------------------------+
¦         Cálculo de unitario negociado da tabela de Internet.		    ¦
+----------------------------------------------------------------------*/     

User Function ConvInt(nDesc,nPage)
    
Local nUniNeg := 0      
Local nPrcTab := aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})]                                                             

nUniNeg := nPrcTab * (nPage * 1000)    

nUniNeg := nUniNeg

If nDesc <> 0

nUnit := nPrcTab * (nPage * 1000) 

nUniNeg:=nUnit(nUnit*nDesc/100) 
                                           
EndIf

Return (nUniNeg)    
   

/*----------------------------------------------------------------------+
¦               Cálculo do preço de tabela de internet.                 ¦
+----------------------------------------------------------------------*/

User Function ConvInt1(nPage)       
                                                      
Local nUniTab := 0  
Local nPrcTab := aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})]                                                                                               

nUniTab := nPrcTab * (nPage * 1000)  

nUniTab := nUniTab 
 
Return (nUniTab)  


/*----------------------------------------------------------------------+
¦       Cálculo do preço de tabela baseado no fator de conversão.       ¦
+----------------------------------------------------------------------*/

User Function ConvInt2(nDesc,nPage,nQtde)       
                                                       
Local nTotNeg := 0 
Local nPrcTab := aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})]                                                                  

If nDesc == 0   

nUnit := nPrcTab * (nPage * 1000)                           

nTotNeg:= nUnit * nQtde    

Else

nUnit := nPrcTab * (nPage * 1000)    

nTotNeg:=nUnit-(nUnit*nDesc/100)  

nTotNeg:= nTotNeg * nQtde

EndIf

Return (nTotNeg) 


/*----------------------------------------------------------------------+
¦                Cálculo do  valor final com determinação.              ¦
+----------------------------------------------------------------------*/    
                                                                     	

User Function ConvInt3(nPage,nQtde)       
                                                      
Local nTotTab := 0   
Local nPrcTab := aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})]                                                                   
                        
nUnit := nPrcTab * (nPage * 1000)                           

nTotTab:= nUnit * nQtde     
  

Return (nTotTab) 
