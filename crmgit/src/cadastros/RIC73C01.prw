#Include 'Protheus.ch'

Static cEntRet := ""
Static cLojRet := ""
Static cDscEnt := ""
/*/{Protheus.doc} RIC73C01
Consulta padrão de entidade na proposta comercial.
Dinamiza a criação da consulta verificando o conteúdo do campo Tipo de Entidade.
SA1 Para clientes
SUS Para Prospects
@type function
@author fabio.branis
@since 08/01/2016
@version 1.0
@param cTpEnt, String, Tipo de entidade - 1 = Cliente 2 = Prospect
@return lRet, Retorno da consulta padrão - Sempre .T.
/*/
User Function RIC73C01(cTpEnt)

	Local cConTab		:= ""
	Local cCpoEnti	:= ""
	Local cLojaEnti	:= ""
	Local cDscEnti	:= ""
	
	do case
	case cTpEnt == "1" //Cliente
		cConTab := "SA1"
		cCpoEnti := "SA1->A1_COD"
		cLojaEnti := "SA1->A1_LOJA"
		cDscEnti := "SA1->A1_NREDUZ"
	case cTpEnt == "2" //Prospect
		cConTab := "SUS"
		cCpoEnti := "SUS->US_COD"
		cLojaEnti := "SUS->US_LOJA"
		cDscEnti := "SUS->US_NREDUZ"
	endcase
	
	//Executa a consulta	
	if ConPad1(,,,cConTab)
		cEntRet := &(cCpoEnti)
		cLojRet := &(cLojaEnti)
		cDscEnt := &(cDscEnti)
	endif
	
Return .T.

//Retorno do código da entidade
User Function R73C01CD()
return cEntRet

//Retorno da loja da entidade
User Function R73C01LJ()
return cLojRet

//Retorno da loja da entidade
User Function R73C01DS()
return cDscEnt