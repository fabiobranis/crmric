	
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

User Function ConvJnd()

Local nAlt   := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XALTUR'})  
Local nCol   := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XCOLUN'})   
Local nPrcTab:= AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'}) 
Local nDesc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})
Local nPreco := 0
Local nColuna:= 0 
Local nAltura:= 0	
Local nUniNeg := 0                                                                   

For nX := 1 to len(acols) 

	nColuna := aCols[1][nAlt]
	nAltura := aCols[1][nCol] 
	nDescon := aCols[1][nDesc]
	nPreco  := U_TABPRC()
	
Next nX     

If nColuna == 0 .AND. nAltura == 0 .AND. nDescon == 0                              

nUniNeg := nPreco     

ElseIf  nColuna == 0 .AND. nAltura == 0 .AND. nDescon <> 0

nUniNeg := nPreco 

nUniNeg:=nUniNeg-(nUniNeg*nDescon/100)   

ElseIf nColuna == 0 .AND. nAltura <> 0 .AND. nDescon <> 0     
  
nUniNeg:=nPreco-(nPreco*nDescon/100) 

ElseIf nColuna ==0 .AND. nAltura <> 0 .AND. nDescon = 0    

nUniNeg := nPreco  
  
ElseIf nColuna <> 0 .AND. nAltura == 0 .AND. nDescon <> 0 

nUniNeg:=nPreco-(nPreco*nDescon/100) 

ElseIf nColuna <> 0 .AND. nAltura == 0 .AND. nDescon == 0   

nUniNeg := nPreco     

ElseIf  nColuna <> 0 .AND. nAltura <> 0 .AND. nDescon <> 0  

 nUniNeg:=nPreco-(nPreco*nDescon/100)
 
 Else                         

nUniNeg := (nColuna * nAltura)* nPreco 
                                           
EndIf

Return (nUniNeg)    
   

/*----------------------------------------------------------------------+
�       C�lculo do pre�o de tabela baseado no fator de convers�o.       �
+----------------------------------------------------------------------*/

User Function ConvJnd1()       
                                                   
Local nAlt   := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XALTUR'})  
Local nCol   := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XCOLUN'})   
Local nPrcTab:= AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'}) 
Local nDesc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})
Local nPreco := 0
Local nColuna:= 0 
Local nAltura:= 0	
Local nUniTab := 0                                                                   

For nX := 1 to len(acols) 

	nColuna := aCols[1][nAlt]
	nAltura := aCols[1][nCol] 
	nDescon := aCols[1][nDesc]
	nPreco  := U_TABPRC()
	
Next nX     

If nColuna == 0 .AND. nAltura == 0                              

nUniTab := nPreco     
 
ElseIf nColuna == 0 .AND. nAltura <> 0    
  
nUniTab:=nPreco 
  
ElseIf nColuna <> 0 .AND. nAltura == 0 

nUniTab:=nPreco

ElseIf nColuna <> 0 .AND. nAltura <> 0   

nUniTab := (nColuna * nAltura)* nPreco    

Else    

nUniTab := (nColuna * nAltura)* nPreco

EndIf    

Return (nUniTab)  


/*----------------------------------------------------------------------+
�       C�lculo do pre�o de tabela baseado no fator de convers�o.       �
+----------------------------------------------------------------------*/

User Function ConvJn2()       
                                                  
Local nAlt   := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XALTUR'})  
Local nCol   := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XCOLUN'})   
Local nPrcTab:= AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'}) 
Local nDesc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'}) 
Local Qtde  :=AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_QTDVEN'})    
Local nQtde  := 0
Local nPreco := 0
Local nColuna:= 0 
Local nAltura:= 0	
Local nTotNeg := 0                                                                   

For nX := 1 to len(acols) 

	nColuna := aCols[1][nAlt]
	nAltura := aCols[1][nCol] 
	nDescon := aCols[1][nDesc] 
	nQtde  := aCols[1][Qtde]
	nPreco  := U_TABPRC()
	
Next nX     

If nColuna == 0 .AND. nAltura == 0 .AND. nDescon == 0                              

nTotNeg:= nPreco * nQtde    

ElseIf  nColuna == 0 .AND. nAltura == 0 .AND. nDescon <> 0

nTotNeg := nPreco 

nTotNeg:=nTotNeg-(nTotNeg*nDescon/100)  

nTotNeg:= nTotNeg * nQtde

ElseIf nColuna == 0 .AND. nAltura <> 0 .AND. nDescon <> 0     
  
nTotNeg:=nPreco-(nPreco*nDescon/100) 

nTotNeg:= nTotNeg * M->ADZ_QTDVEN

ElseIf nColuna ==0 .AND. nAltura <> 0 .AND. nDescon = 0    

nTotNeg:= nPreco * nQtde 
  
ElseIf nColuna <> 0 .AND. nAltura == 0 .AND. nDescon <> 0 

nTotNeg:=nPreco-(nPreco*nDescon/100) 

nTotNeg:= nTotNeg * nQtde

ElseIf nColuna <> 0 .AND. nAltura == 0 .AND. nDescon == 0   

nTotNeg := nPreco * nQtde    

ElseIf  nColuna <> 0 .AND. nAltura <> 0 .AND. nDescon <> 0  

nTotNeg:= (nColuna * nAltura)* nPreco                                    

 nTotNeg:=nTotNeg-(nTotNeg*nDescon/100)
 
 nTotNeg:= nTotNeg * nQtde

Else                            

nTotNeg:= (nColuna * nAltura)* nPreco 

nTotNeg:= nTotNeg * nQtde    

EndIf

Return (nTotNeg) 


/*----------------------------------------------------------------------+
�                C�lculo do  valor final com determina��o.              �
+----------------------------------------------------------------------*/    
                                                                     	

User Function ConvJnd3()       
                                                   
Local nAlt   := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XALTUR'})  
Local nCol   := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XCOLUN'})   
Local nPrcTab:= AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'}) 
Local nDesc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})  
Local Qtde  :=AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_QTDVEN'})    
Local nQtde  := 0
Local nPreco := 0
Local nColuna:= 0 
Local nAltura:= 0	
Local nTotTab := 0                                                                   

For nX := 1 to len(acols) 

	nColuna := aCols[1][nAlt]
	nAltura := aCols[1][nCol] 
	nDescon := aCols[1][nDesc]  
	nQtde  := aCols[1][Qtde]
	nPreco  := U_TABPRC()
	
Next nX     

If nColuna == 0 .AND. nAltura == 0                              

nTotTab := nPreco * nQtde    
 
ElseIf nColuna == 0 .AND. nAltura <> 0    
  
nTotTab := nPreco * nQtde
  
ElseIf nColuna <> 0 .AND. nAltura == 0 

nTotTab := nPreco * nQtde 

ElseIf nColuna <> 0 .AND. nAltura <> 0   

nTotTab := (nColuna * nAltura)* nPreco  

nTotTab := nTotTab * nQtde  

Else  

nTotTab := (nColuna * nAltura)* nPreco  

nTotTab := nTotTab * nQtde   

EndIf

Return (nTotTab) 


/*----------------------------------------------------------------------+
�    C�lculo do  valor unitario com determina��o.     �
+----------------------------------------------------------------------*/    
                                                                     	

/*User Function DetTot()

Local nPrcV := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XPRVEN'})  
Local nQuant:= AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_QTDVEN'})     
Local nQtde := 0
Local cDeter:= 0 
Local nPreco:= 0
Local cDet  := 0 
Local nVlrDt:= 0
Local nTot  := 0

For nX := 1 to len(acols) 

	nPreco:= aCols[nX][nPrcV]
	nQtde := aCols[nX][nQuant] 
	cDeter:= M->ADZ_XDETER

If cDeter == "1"	

nTot := nPreco * nQtde	                               

EndIf

Next nX


Return (nTot)     */
