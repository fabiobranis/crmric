
	
/*__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    �  AXCadastro � Autor � Renata C Calaca     � Data �01.12.14 ���


��+----------+------------------------------------------------------------���
���Descri��o � Fun��es inseridas nos gatilhos criados para realizar os    ���
���          � c�lculos da views de internet para pre�o de tabela         ��� 
���          � tambem c�lculo dos descontos e do pre�o de venda.          ���
��+-----------------------------------------------------------------------+��
���Uso       � Convers�es de valores.                                     ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/ 


/*----------------------------------------------------------------------+
�         C�lculo de unitario negociado da tabela de Internet.		    �
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
�               C�lculo do pre�o de tabela de internet.                 �
+----------------------------------------------------------------------*/

User Function ConvInt1(nPage)       
                                                      
Local nUniTab := 0  
Local nPrcTab := aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})]                                                                                               

nUniTab := nPrcTab * (nPage * 1000)  

nUniTab := nUniTab 
 
Return (nUniTab)  


/*----------------------------------------------------------------------+
�       C�lculo do pre�o de tabela baseado no fator de convers�o.       �
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
�                C�lculo do  valor final com determina��o.              �
+----------------------------------------------------------------------*/    
                                                                     	

User Function ConvInt3(nPage,nQtde)       
                                                      
Local nTotTab := 0   
Local nPrcTab := aCols[1][AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})]                                                                   
                        
nUnit := nPrcTab * (nPage * 1000)                           

nTotTab:= nUnit * nQtde     
  

Return (nTotTab) 
