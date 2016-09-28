#include 'protheus.ch'
#include 'topconn.ch'

/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦  RICA005    ¦ Autor ¦ Deivys Joenck       ¦ Data ¦26.02.15 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Calendário de veiculações.                                 ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function RICA005(cProduto,nQuant,cProp,cItProp)
Local cPrdDesc := AllTrim(cProduto)+" - "+Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC")

Private oButton1, oButton2, oDlg
Private oMSNewGetDados1
Private nStyle  := GD_UPDATE
Private aCampos := {}

Private nQtdVei := nQuant  
Private cItem   := cItProp
Private cProposta := cProp 
Private cPeriodo  := StrZero(Year(Date()),4)

DEFINE MSDIALOG oDlg TITLE "Calendário de Veiculações" FROM 000, 000  TO 365,963 PIXEL 
@ 009,012 Say "Produto:" 	SIZE 020, 020 OF oDlg COLORS 0, 16777215 PIXEL   
@ 007,040 MsGet cPrdDesc 	SIZE 150, 010 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL   
@ 009,215 Say "Quant. :" 	SIZE 040, 020 OF oDlg COLORS 0, 16777215 PIXEL   
@ 007,240 MsGet nQuant		SIZE 020, 010 When .F. OF oDlg COLORS 0, 16777215 PIXEL 
@ 009,280 Say "Período:" 	SIZE 020, 020  OF oDlg COLORS 0, 16777215 PIXEL   
@ 007,305 MsGet cPeriodo 	SIZE 020, 010 Valid NaoVazio() .and. IsDigit(cPeriodo) When .T. OF oDlg COLORS 0, 16777215 PIXEL   

@ 042.0,015 Say "JAN" SIZE 020, 020 OF oDlg COLORS 0, 16777215 PIXEL   
@ 051.0,015 Say "FEV" SIZE 020, 020 OF oDlg COLORS 0, 16777215 PIXEL   
@ 059.5,015 Say "MAR" SIZE 020, 020 OF oDlg COLORS 0, 16777215 PIXEL   
@ 068.0,015 Say "ABR" SIZE 020, 020 OF oDlg COLORS 0, 16777215 PIXEL   
@ 076.5,015 Say "MAI" SIZE 020, 020 OF oDlg COLORS 0, 16777215 PIXEL   
@ 085.0,015 Say "JUN" SIZE 020, 020 OF oDlg COLORS 0, 16777215 PIXEL   
@ 093.5,015 Say "JUL" SIZE 020, 020 OF oDlg COLORS 0, 16777215 PIXEL   
@ 102.0,015 Say "AGO" SIZE 020, 020 OF oDlg COLORS 0, 16777215 PIXEL   
@ 110.5,015 Say "SET" SIZE 020, 020 OF oDlg COLORS 0, 16777215 PIXEL   
@ 119.0,015 Say "OUT" SIZE 020, 020 OF oDlg COLORS 0, 16777215 PIXEL   
@ 127.5,015 Say "NOV" SIZE 020, 020 OF oDlg COLORS 0, 16777215 PIXEL   
@ 136.0,015 Say "DEZ" SIZE 020, 020 OF oDlg COLORS 0, 16777215 PIXEL   

@ 160, 398 BUTTON oButton1 PROMPT "Confirmar" SIZE 035, 012 ACTION(Iif(u_VaCols005(),(U_GrvVei(),oDlg:End()),)) OF oDlg PIXEL
@ 160, 440 BUTTON oButton2 PROMPT "Fechar"    SIZE 035, 012 ACTION(oDlg:End()) OF oDlg PIXEL
fMSNewGetDados1()

ACTIVATE MSDIALOG oDlg CENTERED

Return nQuant


/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦ fMSNewGetDados1 ¦ Autor ¦ Deivys Joenck   ¦ Data ¦26.02.15 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Gera o grid da tela de manutenção de metas.                ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fMSNewGetDados1()
Local nX, nY
Local cDataVei

Private aHeader := {}
Private aCols   := {}

aCampos := {"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"}
For nX := 1 to Len(aCampos) 
	Aadd(aHeader, {aCampos[nX],"ZAA_QTDE","@E 99",02,0,,,"N"}) 
Next nX

For nX := 1 to 12
	aAdd(aCols,Array(Len(aHeader)+1))
	For nY := 1 To Len(aHeader)

		aCols[Len(aCols)][nY]:= CriaVar(aHeader[nY][2])
		cDataVei := AllTrim(cPeriodo)+StrZero(nX,2)+aCampos[nY]
		
		dbSelectArea("ZAA")      
		dbSetOrder(1)
		If dbSeek(xFilial("ZAA")+cProposta+cItem+cDataVei)
			aCols[Len(aCols)][nY]:= ZAA->ZAA_QTDE
		Endif

	Next nY
	aCols[Len(aCols)][Len(aHeader)+1]:= .F.
Next

nTamaCols:= Len(aCols)                //059, 014, 240, 635
oMSNewGetDados1 := MsNewGetDados():New( 030, 030, 155, 475, nStyle , , , , ,, 12,, "AllwaysTrue", "AllwaysTrue", oDlg, aHeader, aCols)

Return


/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦ ValidaCols  ¦ Autor ¦ Deivys Joenck       ¦ Data ¦28.02.15 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Validação de todas as linhas do Grid.                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function VaCols005()
Local aCols1  := oMSNewGetDados1:aCols
Local nSumQtd := 0 
Local i,j

For i:=1 to Len(aCols1) 
	For j:=1 to Len(aCampos)
		nSumQtd += aCols1[i,j]
	Next
Next

If nSumQtd<>nQtdVei
	Aviso("Atenção!","As veiculações informadas diferem da quantidade original.",{"OK"},1)
	Return .F.
Endif 	

Return .T. 

/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦ GravaVei    ¦ Autor ¦ Deivys Joenck       ¦ Data ¦28.02.15 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Grava as informações lançadas em tela                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function GrvVei()
Local aColsGrv:= oMSNewGetDados1:aCols
Local cDataVei 
Local i,j

For i:= 1 to Len(aColsGrv)

	For j:=1 to Len(aCampos)      
	
		cDataVei := AllTrim(cPeriodo)+StrZero(i,2)+aCampos[j]
		dbSelectArea("ZAA")      
		dbSetOrder(1)
		If dbSeek(xFilial("ZAA")+cProposta+cItem+cDataVei)
			RecLock("ZAA",.F.)
			ZAA_FILIAL  := xFilial("ZAA")
			ZAA_ITPROP	:= cItem                                                                                                    
			ZAA_PROPOS  := cProposta
			ZAA_DTEXIB  := Stod(cDataVei)
			ZAA_QTDE   	:= aColsGrv[i,j]
			ZAA->(MsUnlock())			
		Else
			If aColsGrv[i,j]>0
				RecLock("ZAA",.T.)
				ZAA_FILIAL  := xFilial("ZAA")
				ZAA_ITPROP	:= cItem                                                                                                    
				ZAA_PROPOS  := cProposta
				ZAA_DTEXIB  := Stod(cDataVei)
				ZAA_QTDE   	:= aColsGrv[i,j]
				ZAA->(MsUnlock())			
			Endif		       
		Endif
		
	Next				 
Next
    
Return