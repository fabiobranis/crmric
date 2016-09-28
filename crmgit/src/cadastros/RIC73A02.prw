// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : RIC73A02.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 09/05/2016 | Fabio             | Gerado com auxílio do Assistente de Código do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} RIC73A02
Manutenção de dados em ZAD-USUARIOS X PORTAL CRM.

@author    Fabio
@version   11.3.0.201604142013
@since     09/05/2016
/*/
//------------------------------------------------------------------------------------------
user function RIC73A02()
	//-- variáveis -------------------------------------------------------------------------

	//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
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
// Gerado pelo assistente de código do TDS tds_version em 09/05/2016 as 19:53:28
//-- fim de arquivo--------------------------------------------------------------------------

