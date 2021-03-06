#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"           
#INCLUDE "topconn.ch"
#INCLUDE "font.ch"
#INCLUDE "colors.ch"        

/*__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    �  TMK273PTC  � Autor � Renata C Calaca     � Data �25.11.14 ���
��+----------+------------------------------------------------------------���
���Descri��o � Ponto de entrada na convers�o do prospect para cliente     ���
���          � na grava��o da proposta que torna obrigat�rio preencher    ���
���          � os campos CNPJ e Ins. Estadual e grava o c�digo do cliente ���
���          � com os d�gitos do CNPJ.                                    ���
��+-----------------------------------------------------------------------+��
���Uso       � Proposta Cormecial - FATA300                               ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function TMK273PTC()

Local aArea := GetArea()

Private _cCli := ''
Private _cInsc:= ''

If Empty(SA1->A1_CGC)
	
	Aviso("Atencao!","O campo CNPJ/CPF deve ser preenchido!",{"Ok"},1)
	
	_cCli:=U_TelaCli()
	
	RecLock("SA1",.F.)
	SA1->A1_CGC := _cCli
	SA1->A1_COD := Substr(_cCli,1,9)
	MsUnlock()
	
EndIf

If Empty(SA1->A1_INSCR)
	
	Aviso("Atencao!","O campo Insc. Estadual deve ser preenchido!",{"Ok"},1)
	
	_cInsc:=U_TelaInsc()
	
	RecLock("SA1",.F.)
	SA1->A1_INSCR := _cInsc
	MsUnlock()
	
EndIf

RestArea(aArea)

Return .T.    



User Function TelaCli()

Local cCnpj := space(14)
Static oCnpj
Private oDlg1

	// Monta Tela
	@ 000 , 000 TO 80,250 DIALOG oDlg1 TITLE "Preencher CNPJ/CPF"
	@ 010 , 004 SAY    "CNPJ/CGC"
	@ 010 , 030 GET oCnpj VAR cCnpj OF oDlg1 SIZE 80,15 Valid IsDigit(cCnpj) COLORS 0, 16777215 HSCROLL PIXEL

	// A��o a ser executada no bot�o OK
	@ 30,80 BmpButton Type 1 Action (Close(oDlg1))

	ACTIVATE DIALOG oDlg1 CENTERED

Return cCnpj       



User Function TelaInsc()

Local cInsc := space(14)
Static oInsc
Private oDlg1

	// Monta Tela
	@ 000 , 000 TO 80,250 DIALOG oDlg1 TITLE "Preencher Insc. Estadual"
	@ 010 , 002 SAY    "Insc. Estadual"
	@ 010 , 036 GET oInsc VAR cInsc OF oDlg1 SIZE 80,15 Valid COLORS 0, 16777215 HSCROLL PIXEL

	// A��o a ser executada no bot�o OK
	@ 30,80 BmpButton Type 1 Action (Close(oDlg1))

	ACTIVATE DIALOG oDlg1 CENTERED

Return cInsc
 
