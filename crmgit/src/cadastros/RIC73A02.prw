// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : RIC73A02.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 09/05/2016 | Fabio             | Gerado com aux�lio do Assistente de C�digo do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} RIC73A02
Manuten��o de dados em ZAD-USUARIOS X PORTAL CRM.

@author    Fabio
@version   11.3.0.201604142013
@since     09/05/2016
/*/
//------------------------------------------------------------------------------------------
user function RIC73A02()
	//-- vari�veis -------------------------------------------------------------------------

	//Indica a permiss�o ou n�o para a opera��o (pode-se utilizar 'ExecBlock')
	local cVldAlt := ".T." // Operacao: ALTERACAO
	local cVldExc := ".T." // Operacao: EXCLUSAO

	//Trabalho/apoio

	//-- procedimentos ---------------------------------------------------------------------
	chkFile("ZAD")
	dbSelectArea("ZAD")
	ZAD->(dbSetOrder(1))

	axCadastro("ZAD", "USUARIOS X PORTAL CRM", cVldExc, cVldAlt)

	//-- encerramento ----------------------------------------------------------------------

return
//-------------------------------------------------------------------------------------------
// Gerado pelo assistente de c�digo do TDS tds_version em 09/05/2016 as 19:53:28
//-- fim de arquivo--------------------------------------------------------------------------

