
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

User Function GatTv()

Local nPrcV  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})
Local nDesc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})
Local nForm  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XFORMA'})
Local nVlVen := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCVEN'})
Local nDescon:= 0
Local nFmto  := 0
Local nValUn := 0
Local VlrUn  := 0
Local nPrc   := 0

For nX := 1 to len(acols)
	
	nPrc   := aCols[1][nPrcV]
	nDescon:= aCols[1][nDesc]
	nFmto  := aCols[1][nForm]
	VlrUn  := aCols[1][nVlVen]
	
Next nX

If nDescon == 0 .AND. nFmto == 0
	
	nValUn:= U_TABPRC()
	
ElseIf nDescon == 0 .AND. nFmto <> 0
	
	nValUn:= VlrUn
	
ElseIf nDescon <> 0 .AND. nFmto == 0
	
	nValUn:=nPrc-(nPrc*nDescon/100)
	
Else
	
	nValUn:=nPrc-(nPrc*nDescon/100)
	
EndIf

Return (nValUn)


//Calcula valor unitário tabela

User Function GatTv1()

Local nPrcV  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})
Local nDesc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})
Local nForm  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XFORMA'})
Local nDescon:= 0
Local nPrc   := 0
Local nTabUn := 0
Local nFmto  := 0

For nX := 1 to len(acols)
	
	nPrc   := aCols[1][nPrcV]
	nDescon:= aCols[1][nDesc]
	nFmto  := aCols[1][nForm]
	
Next nX

If nDescon == 0 .AND. nFmto == 0
	
	nTabUn:= U_TABPRC()
	
ElseIf nDescon == 0 .AND. nFmto <> 0
	
	nTabUn:= nPrc
	
ElseIf nDescon <> 0 .AND. nFmto == 0
	
	nTabUn:=nPrc
	
Else
	
	nTabUn:=nPrc
	
EndIf

Return (nTabUn)


//Calcula valor total negociado

User Function GatTv2()

Local nPrcV  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})
Local nDesc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})
Local nForm  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XFORMA'})
Local nDescon:= 0
Local nFmto  := 0
Local nNegBr := 0
Local VlrUn  := 0


For nX := 1 to len(acols)
	
	nPrc   := aCols[1][nPrcV]
	nDescon:= aCols[1][nDesc]
	nFmto  := aCols[1][nForm]
	
Next nX

If nDescon == 0 .AND. nFmto == 0
	
	nNegBr:= U_TABPRC()
	
	nNegBr:= nNegBr * M->ADZ_QTDVEN
	
ElseIf nDescon == 0 .AND. nFmto <> 0
	
	nNegBr:= nPrc * M->ADZ_QTDVEN
	
ElseIf nDescon <> 0 .AND. nFmto == 0
	
	nNegBr:=nPrc-(nPrc*nDescon/100)
	
	nNegBr:= nNegBr * M->ADZ_QTDVEN
	
Else
	
	nNegBr:=nPrc-(nPrc*nDescon/100)
	
	nNegBr:= nNegBr * M->ADZ_QTDVEN
	
EndIf

Return (nNegBr)


//Calcula valor total tabela

User Function GatTv3 ()

Local nPrcV  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})
Local nDesc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})
Local nForm  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XFORMA'})
Local nPrc   := 0
Local nFmto  := 0
Local nNegLiq:= 0
Local nDescon:= 0

For nX := 1 to len(acols)
	
	nPrc   := aCols[1][nPrcV]
	nDescon:= aCols[1][nDesc]
	nFmto  := aCols[1][nForm]
	
	
Next nX

If nDescon == 0 .AND. nFmto == 0
	
	nNegLiq:= U_TABPRC()
	
	nNegLiq:= nNegLiq * M->ADZ_QTDVEN
	
ElseIf nDescon == 0 .AND. nFmto <> 0
	
	nNegLiq:= nPrc * M->ADZ_QTDVEN
	
ElseIf nDescon <> 0 .AND. nFmto == 0
	
	nNegLiq:=nPrc * M->ADZ_QTDVEN
	
Else
	
	nNegLiq:=nPrc * M->ADZ_QTDVEN
	
EndIf

Return (nNegLiq)




                                                                                                 
/*----------------------------------------------------------------------+
¦       Cálculo do preço de tabela baseado no fator de conversão.       ¦
+----------------------------------------------------------------------*/

User Function ConvTv()

Local nFator:= ZA9->ZA9_FATOR
Local nPrcV := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})
Local nDesc := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})
Local nTabel:= 0
Local nDescon:= 0


For nX := 1 to len(acols)
	
	nUniNeg := U_TABPRC() * nFator
	nDescon:= aCols[1][nDesc]
	
Next nX

If nDescon == 0
	
	nUniNeg := nUniNeg
	
Else
	
	nUniNeg :=nUniNeg-(nUniNeg*nDescon/100)
	
EndIf

Return (nUniNeg)     

User Function ConvTv1()

Local nFator:= ZA9->ZA9_FATOR
Local nPrcV := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})
Local nDesc := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})  
Local Qtde  :=AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_QTDVEN'})
Local nUniTab:= 0
Local nDescon:= 0     
Local nQtde  := 0


For nX := 1 to len(acols)
	
	nUniTab := U_TABPRC() * nFator
	nDescon:= aCols[1][nDesc] 
	nQtde  :=aCols[1][qtde]
	
Next nX
	
	nUniTab := nUniTab 


Return (nUniTab)      

User Function ConvTv2()

Local nFator:= ZA9->ZA9_FATOR
Local nPrcV := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})
Local nDesc := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})  
Local Qtde  :=AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_QTDVEN'})    
Local nQtde  := 0
Local nTotLiq:= 0
Local nDescon:= 0   
Local nQtde  := 0


For nX := 1 to len(acols)
	
	nTotLiq := U_TABPRC() * nFator
	nDescon:= aCols[1][nDesc]
	nQtde  := aCols[1][Qtde]
	
Next nX

If nDescon == 0
	
	nTotLiq := nTotLiq 
	
	If	nQtde <> 0
		nTotLiq := nTotLiq * nQtde
	EndIf
	
Else
	
	nTotLiq := nTotLiq * nQtde
	nTotLiq :=nTotLiq-(nTotLiq*nDescon/100)
	
	If	nQtde <> 0
		nTotLiq := nTotLiq * nQtde
	EndIf
	
EndIf

Return (nTotLiq)     


User Function ConvTv3()

Local nFator:= ZA9->ZA9_FATOR
Local nPrcV := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCTAB'})
Local nDesc := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'}) 
Local Qtde  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_QTDVEN'})
Local nTotBrt:= 0
Local nDescon:= 0 
Local nQtde  := 0


For nX := 1 to len(acols)
	
	nTotBrt := U_TABPRC() * nFator
	nDescon:= aCols[1][nDesc] 
	nQtde  := aCols[1][Qtde]
	
Next nX
	
	nTotBrt := nTotBrt 
	
	If	nQtde <> 0
		nTotBrt := nTotBrt * nQtde
	EndIf


Return (nTotBrt) 
                 

/*----------------------------------------------------------------------+
¦Cálculo do preço de tabela baseado no fator de conversão com desconto. ¦
+----------------------------------------------------------------------*/

User Function DescTv()
                          

Local nFator:= ZA9->ZA9_FATOR
Local nDesc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})
Local nForm  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XFORMA'})
Local nVlVen := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_PRCVEN'}) 
Local nDescon:= 0
Local nFmto  := 0
Local nValUn := 0
Local VlrUn  := 0

For nX := 1 to len(acols)
	
	nDescon:= M->ADZ_DESCON
	nFmto  := aCols[1][nForm]
	VlrUn  := aCols[1][nVlVen]
	
Next nX

	If nFmto == 0
	
	nValUn:= U_TABPRC()  
	
	nValUn:=nValUn-(nValUn*nDescon/100)
	
Else 
	
	nValUn:= U_TABPRC() * nFator  
	
	nValUn:=nValUn-(nValUn*nDescon/100)
	
EndIf                                                       

Return (nValUn)


//Calcula valor unitário tabela

User Function DescTv1()
                             
Local nFator:= ZA9->ZA9_FATOR
Local nDesc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})
Local nForm  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XFORMA'}) 
Local nDescon:= 0
Local nTabUn := 0
Local nFmto  := 0

For nX := 1 to len(acols)
	
	nDescon:= M->ADZ_DESCON
	nFmto  := aCols[1][nForm]
	
Next nX

If nFmto == 0
	
	nTabUn:= U_TABPRC()
	
Else
	
	nTabUn:= U_TABPRC() * nFator
	
EndIf

Return (nTabUn)


//Calcula valor total negociado

User Function DescTv2() 

Local nFator:= ZA9->ZA9_FATOR
Local nDesc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})
Local nForm  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XFORMA'}) 
Local Qtde   :=AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_QTDVEN'})    
Local nQtde  := 0
Local nDescon:= 0
Local nFmto  := 0
Local nNegBr := 0
Local VlrUn  := 0


For nX := 1 to len(acols)
	
	nPrc   := U_TABPRC()
	nDescon:= M->ADZ_DESCON
	nFmto  := aCols[1][nForm]  
	nQtde  := aCols[1][Qtde]
	
Next nX
	
If nFmto == 0
	
	nNegBr:=nPrc-(nPrc*nDescon/100)
	
	nNegBr:= nNegBr * nQtde
	
Else
	
	nPrc := nPrc * nFator 
	
	nNegBr:=nPrc-(nPrc*nDescon/100)
	
	nNegBr:= nNegBr * nQtde
	
EndIf

Return (nNegBr)


//Calcula valor total tabela

User Function DescTv3 ()
                     
Local nFator:= ZA9->ZA9_FATOR
Local nDesc  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_DESCON'})
Local nForm  := AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_XFORMA'})   
Local Qtde  :=AScan(aHeader, { |x| Alltrim(x[2]) = 'ADZ_QTDVEN'})    
Local nQtde  := 0
Local nPrc   := 0
Local nFmto  := 0
Local nNegLiq:= 0
Local nDescon:= 0

For nX := 1 to len(acols)
	
	nDescon:= M->ADZ_DESCON
	nFmto  := aCols[1][nForm]
	nQtde  := aCols[1][Qtde]
	
	
Next nX

If nFmto == 0
	
	nNegLiq:= U_TABPRC()
	
	nNegLiq:= nNegLiq * nQtde
	
Else
	
	nNegLiq:= U_TABPRC() * nFator 
	
	nNegLiq:= nNegLiq * nQtde
	
EndIf

Return (nNegLiq)