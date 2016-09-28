#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"           
#INCLUDE "topconn.ch"

User Function TK273PT2()

Local aArea := GetArea()

Reclock("SUS",.F.)
SUS->US_CODCLI := SA1->A1_COD
MsUnlock()

RestArea(aArea)

Return