	
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
               

/*----------------------------------------------------------------------+
¦               Cálculo de conversão da tabela do JND.				    ¦
+----------------------------------------------------------------------*/     

User Function ConvJnd(nColuna,nAltura,nDesc)
	
Local nUniNeg := 0      
Local nPrcTab:= aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})]                                                             
   
If nColuna == 0 .AND. nAltura == 0 .AND. nDesc == 0                              

nUniNeg := nPrcTab     

ElseIf  nColuna == 0 .AND. nAltura == 0 .AND. nDesc <> 0

nUniNeg := nPrcTab 

nUniNeg:=nUniNeg-(nUniNeg*nDesc/100)   

ElseIf nColuna == 0 .AND. nAltura <> 0 .AND. nDesc <> 0     
  
nUniNeg:=nPrcTab-(nPrcTab*nDesc/100) 

ElseIf nColuna ==0 .AND. nAltura <> 0 .AND. nDesc = 0    

nUniNeg := nPrcTab  
  
ElseIf nColuna <> 0 .AND. nAltura == 0 .AND. nDesc <> 0 

nUniNeg:=nPrcTab-(nPrcTab*nDesc/100) 

ElseIf nColuna <> 0 .AND. nAltura == 0 .AND. nDesc == 0   

nUniNeg := nPrcTab     

ElseIf  nColuna <> 0 .AND. nAltura <> 0 .AND. nDesc <> 0  

 nUniNeg:=nPrcTab-(nPrcTab*nDesc/100)
 
 Else                         

nUniNeg := (nColuna * nAltura)* nPrcTab 
                                           
EndIf

Return (nUniNeg)    
   

/*----------------------------------------------------------------------+
¦       Cálculo do preço de tabela baseado no fator de conversão.       ¦
+----------------------------------------------------------------------*/

User Function ConvJnd1(nColuna,nAltura)       
                                                   
Local nUniTab := 0     
Local nPrcTab:= aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})]                                                              
   

If nColuna == 0 .AND. nAltura == 0                              

nUniTab := nPrcTab     
 
ElseIf nColuna == 0 .AND. nAltura <> 0    
  
nUniTab:=nPrcTab 
  
ElseIf nColuna <> 0 .AND. nAltura == 0 

nUniTab:=nPrcTab

ElseIf nColuna <> 0 .AND. nAltura <> 0   

nUniTab := (nColuna * nAltura)* nPrcTab    

Else    

nUniTab := (nColuna * nAltura)* nPrcTab

EndIf    

Return (nUniTab)  


/*----------------------------------------------------------------------+
¦       Cálculo do preço de tabela baseado no fator de conversão.       ¦
+----------------------------------------------------------------------*/

User Function ConvJnd2(nColuna,nAltura,nDesc,nQtde)       
                                                  	
Local nTotNeg := 0 
Local nPrcTab:= aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})]                                                                  

If nColuna == 0 .AND. nAltura == 0 .AND. nDesc == 0                              

nTotNeg:= nPrcTab * nQtde    

ElseIf  nColuna == 0 .AND. nAltura == 0 .AND. nDesc <> 0

nTotNeg := nPrcTab 

nTotNeg:=nTotNeg-(nTotNeg*nDesc/100)  

nTotNeg:= nTotNeg * nQtde

ElseIf nColuna == 0 .AND. nAltura <> 0 .AND. nDesc <> 0     
  
nTotNeg:=nPrcTab-(nPrcTab*nDesc/100) 

nTotNeg:= nTotNeg * nQtde

ElseIf nColuna ==0 .AND. nAltura <> 0 .AND. nDesc = 0    

nTotNeg:= nPrcTab * nQtde 
  
ElseIf nColuna <> 0 .AND. nAltura == 0 .AND. nDesc <> 0 

nTotNeg:=nPrcTab-(nPrcTab*nDesc/100) 

nTotNeg:= nTotNeg * nQtde

ElseIf nColuna <> 0 .AND. nAltura == 0 .AND. nDesc == 0   

nTotNeg := nPrcTab * nQtde    

ElseIf  nColuna <> 0 .AND. nAltura <> 0 .AND. nDesc <> 0  

nTotNeg:= (nColuna * nAltura)* nPrcTab                                    

 nTotNeg:=nTotNeg-(nTotNeg*nDesc/100)
 
 nTotNeg:= nTotNeg * nQtde

Else                            

nTotNeg:= (nColuna * nAltura)* nPrcTab 

nTotNeg:= nTotNeg * nQtde    

EndIf

Return (nTotNeg) 


/*----------------------------------------------------------------------+
¦                Cálculo do  valor final com determinação.              ¦
+----------------------------------------------------------------------*/    
                                                                     	

User Function ConvJnd3(nColuna,nAltura,nQtde)       
                                                   	
Local nTotTab := 0 
                                                                 

If nColuna == 0 .AND. nAltura == 0                              

nTotTab := nPrcTab * nQtde    
 
ElseIf nColuna == 0 .AND. nAltura <> 0    
  
nTotTab := nPrcTab * nQtde
  
ElseIf nColuna <> 0 .AND. nAltura == 0 

nTotTab := nPrcTab * nQtde 

ElseIf nColuna <> 0 .AND. nAltura <> 0   

nTotTab := (nColuna * nAltura)* nPrcTab  

nTotTab := nTotTab * nQtde  

Else  

nTotTab := (nColuna * nAltura)* nPrcTab  

nTotTab := nTotTab * nQtde   

EndIf

Return (nTotTab) 


