#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M030INC   �Autor  �Emerson RIC        � Data �  15/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Criacao automatica da conta contabil de cliente no momento  ���
���          �da inclusao.                                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M030INC()

	local cCod:='C'+ALLTRIM(SA1->A1_COD)+ALLTRIM(SA1->A1_LOJA)
	aAutoCab:={}
	
	aadd(aAutoCab,{"CTH_CLVL"    ,'C'+ALLTRIM(SA1->A1_COD)+ALLTRIM(SA1->A1_LOJA),Nil})
	aadd(aAutoCab,{"CTH_CLASSE"   ,'2'	,Nil})
	aadd(aAutoCab,{"CTH_DESC01"   ,ALLTRIM(SA1->A1_NOME),Nil})
	aadd(aAutoCab,{"CTH_CLVLLP"   ,'C'+ALLTRIM(SA1->A1_COD)+ALLTRIM(SA1->A1_LOJA),Nil})
	aadd(aAutoCab,{"CTH_DESC05"   ,'Auto',Nil})
	Dbselectarea("CTH")
	Dbsetorder(1)
	if !Dbseek(xFilial("CTH")+cCod)                                                                                                                                             
	    MSExecAuto({|x,y| CTBA060(x,y)},aAutoCab,3)
	Endif
Return	
