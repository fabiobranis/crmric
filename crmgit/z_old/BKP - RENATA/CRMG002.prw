	
/*__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    �  AXCadastro � Autor � Renata C Calaca     � Data �01.12.14 ���


��+----------+------------------------------------------------------------���
���Descri��o � Fun��es inseridas nos gatilhos criados para realizar os    ���
���          � c�lculos das convers�es de cardo com o tipo de proposta e  ��� 
���          � tambem c�lculo dos descontos e do pre�o de venda.          ���
��+-----------------------------------------------------------------------+��
���Uso       � Convers�es de valores.                                     ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/ 
               

/*----------------------------------------------------------------------+
�               C�lculo de convers�o da tabela do JND.				    �
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
�       C�lculo do pre�o de tabela baseado no fator de convers�o.       �
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
�       C�lculo do pre�o de tabela baseado no fator de convers�o.       �
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
�                C�lculo do  valor final com determina��o.              �
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


