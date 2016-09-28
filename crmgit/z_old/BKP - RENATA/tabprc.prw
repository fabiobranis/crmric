
User Function Tabprc(cFil,cTabPrc,cCodPro)

Local aAreaAtu	:= GetArea()   						//Guarda a area atual 
Local nNumPRC 	:= 0 								//Preco do produto


DbSelectArea("DA1")
DbSetOrder(1)
DbSeek(cFil+cTabPrc+cCodPro, .F.) .AND. DA1->DA1_PRCVEN > 0  

nNumPRC := DA1->DA1_PRCVEN       

RestArea(aAreaAtu)

Return(nNumPRC)
