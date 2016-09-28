	
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
�			 C�lculo de convers�o da tabela da TV.                      �
+----------------------------------------------------------------------*/

User Function DescTv()

Local nForm := 0    
Local nPrc  := 0
Local nQtde := 0	
Local nQuant:= AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_QTDVEN'})  
Local nPrcUn:= AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCVEN'}) 
Local nForm := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XFORMA'}) 
Local nDesc := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})
Local nFator:= 0
Local nFator:= 0                                                                  


For nX := 1 to len(acols) 

	nPrc := aCols[1][nPrcUn]
	nQtde:= aCols[1][nQuant]

dbSelectArea("ZA9")
dbSetOrder(1)      

 
	nFator := aCols[1][nPrcUn]
	
Next nX                                      

nFatot := nFator-(nFator*nDesc/100)   

nFatot := nFatot * nQtde                                                                

Return (nFatot) 


/*----------------------------------------------------------------------+
�       C�lculo do pre�o de tabela baseado no fator de convers�o.       �
+----------------------------------------------------------------------*/

User Function ConvTv()       
                            
Local nFator:= ZA9->ZA9_FATOR                        
Local nPrcV := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})  
Local nTabel:= 0                                                                   

For nX := 1 to len(acols) 

	nTabel := aCols[nX][nPrcV] * nFator
	
Next nX

Return (nTabel) 

/*----------------------------------------------------------------------+
�                  C�lculo de total Tabela.         				    �
+----------------------------------------------------------------------*/  
    
User Function CalTab()

Local _nQuant:= AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_QTDVEN'})  
Local _nPrcUn:= AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XPRTAB'})  
Local _nPrc  := 0
Local _nQtde := 0	
Local _nTotal:= 0                                                                   

For nX := 1 to len(acols) 

	_nPrc := aCols[1][_nPrcUn]
	_nQtde:= aCols[1][_nQuant]
	
Next nX                                      

_nTotal := _nPrc * _nQtde               

Return (_nTotal)   

/*----------------------------------------------------------------------+
�             C�lculo de total Negociado com desconto.   	    	    �
+----------------------------------------------------------------------*/    

/*User Function CalcNeg()

Local _nQuant:= AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_QTDVEN'})  
Local _nPrc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XPRTAB'})   
Local _nDesc := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XDESCO'})
Local _nQtde := 0	
Local _nVldes:= 0
Local _nTotal:= 0                                                                   

For nX := 1 to len(acols) 

	_nPrc  := aCols[1][_nPrc]
	_nQtde := aCols[1][_nQuant] 
	_nVldes:= aCols[1][_nDesc]                                                
	
Next nX                                      

_Perc := (_nPrc * _nVldes) / 100

_nTotal:= (_nPrc * _nQtde) - (_Perc *_nQtde)

Return (_nTotal)  */
                       

/*----------------------------------------------------------------------+
�            C�lculo de Unitario Negociado com desconto.   			    �
+----------------------------------------------------------------------*/    

/*User Function CalcDesc()

Local nQuant:= AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_QTDVEN'})  
Local nPrc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XPRTAB'})   
Local nDesc := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XDESCO'})
Local nQtde := 0	
Local nVldes:= 0
Local nTot:= 0                                                                   

For nX := 1 to len(acols) 

	nPrc  := aCols[1][nPrc]
	nQtde := aCols[1][nQuant] 
	nVldes:= aCols[1][nDesc]                                                
	
Next nX                                      

Perc := (nPrc * nVldes) / 100

nTot:= nPrc - Perc

Return (nTot)          */


/*----------------------------------------------------------------------+
�                    C�lculo do valor do desconto.      	    	    �
+----------------------------------------------------------------------*/    

/*User Function Calvlr()

Local _nQuant:= AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_QTDVEN'})  
Local _nPrc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XPRTAB'})   
Local _nDesc := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XDESCO'})
Local _nQtde := 0	
Local _nVldes:= 0
Local _nTotal:= 0                                                                   

For nX := 1 to len(acols) 

	_nPrc  := aCols[1][_nPrc]
	_nQtde := aCols[1][_nQuant] 
	_nVldes:= aCols[1][_nDesc]                                                
	
Next nX                                      

_Perc := (_nPrc * _nVldes) / 100         */


/*----------------------------------------------------------------------+
�               C�lculo de convers�o da tabela do JND.				    �
+----------------------------------------------------------------------*/     

User Function ConvJnd()

Local nAlt   := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XALTUR'})  
Local nCol   := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XCOLUN'})   
Local nPrcTab:= AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'}) 
Local nPreco := 0
Local nColuna:= 0 
Local nAltura:= 0	
Local nTotal := 0                                                                   

For nX := 1 to len(acols) 

	nColuna := aCols[nX][nAlt]
	nAltura := aCols[nX][nCol] 
	nPreco  := aCols[nX][nPrcTab]
	
Next nX                                      

nTotal := (nColuna * nAltura)* nPreco               


Return (nTotal)    
   

/*----------------------------------------------------------------------+
�       C�lculo do pre�o de tabela baseado no fator de convers�o.       �
+----------------------------------------------------------------------*/

/*User Function TabJnd()       
                                                   
Local nPrcV := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})  
Local nTabel:= 0                                                                   

For nX := 1 to len(acols) 

	nTabel := aCols[nX][nPrcV]
	
Next nX

Return (nTabel)               */


/*----------------------------------------------------------------------+
�       C�lculo do pre�o de tabela baseado no fator de convers�o.       �
+----------------------------------------------------------------------*/

/* User Function TotNG()       
                                                  
Local nPrc := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XTOTAL'})  
Local nTabel:= 0                                                                   

For nX := 1 to len(acols) 

	nTabel := aCols[nX][nPrc]
	
Next nX

Return (nTabel)     */
   


/*----------------------------------------------------------------------+
�                C�lculo do  valor final com determina��o.              �
+----------------------------------------------------------------------*/    
                                                                     	

/*User Function VlrDet()

Local _nPrcV := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XPRVEN'})  
Local _cDeter:= 0 
Local _nPreco:= 0
Local _cDet  := 0 
Local _nVlrDt:= 0
Local _nTot  := 0

For nX := 1 to len(acols) 

	_nPreco:= aCols[nX][_nPrcV]   
	_cDeter:= M->ADZ_XDETER

If _cDeter == "1"	

_nVlrDt := (ADZ_XPRVEN * 30)/100 

_nTot := _nPreco + _nVlrDt 	                               

EndIf

Next nX


Return (_nTot)     */  


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
