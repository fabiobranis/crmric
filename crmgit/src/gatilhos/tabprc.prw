
User Function Tabprc(cFil,cTabPrc,cCodPro)

	Local aAreaAtu	:= DA1->(GetArea())   						//Guarda a area atual 
	Local nNumPRC 	:= 0 								//Preco do produto

	DA1->(DbSetOrder(1))
	if DA1->(DbSeek(cFil+cTabPrc+cCodPro, .F.) .AND. DA1->DA1_PRCVEN > 0)  
		nNumPRC := DA1->DA1_PRCVEN       
	endif
	RestArea(aAreaAtu)

Return(nNumPRC)
