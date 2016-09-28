
User Function Tabprc()

Local aAreaAtu	:= GetArea()   						//Guarda a area atual 
Local nNumPRC 	:= 0 								//Preco do produto
Local laRound	:= SuperGetMV("MV_FT600RD",,.F.)   //Aplica arredondamento no preco de venda da tabela de preco. 
Local cTabela   := aScan(aHeader,{|x| AllTrim(x[2]) == "ADZ_XTABPR" })  
Local cProduto  := aScan(aHeader,{|x| AllTrim(x[2]) == "ADZ_PRODUT" })
Local nMoeda    := 1

For nIt := 1 to Len(aCols)

dbSelectArea("DA1")
dbSetOrder(1)
If	dbSeek(xFilial("DA1")+aCols[nIt][cTabela]+aCols[nIt][cProduto]) .AND. DA1->DA1_PRCVEN > 0  
	nNumPRC := xMoeda(DA1->DA1_PRCVEN,DA1->DA1_MOEDA,nMoeda)
Else 
	dbSelectArea("SB1")
	dbSetOrder(1)	
	If	dbSeek(xFilial("SB1")+aCols[nIt][cProduto])	.AND. B1_PRV1 > 0
		nNumPRC := B1_PRV1
	Endif
Endif 

Next          

If laRound
	nNumPRC := Round(nNumPRC,TamSX3("ADZ_PRCVEN")[2])
Endif 

RestArea(aAreaAtu)

Return(nNumPRC)

Return