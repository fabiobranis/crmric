#include 'protheus.ch'

/*/{Protheus.doc} ZADUserPortal
Classe DAO do modelo de usuários
@author fabiobranis
@since 21/04/2016
@version 1.0
/*/
class ZADUserPortal 
	
	/**
	 * Atributos
	 */
	data filial
	data iderp
	data login
	data nome
	data token
	data dtaces
	data haces
	data empses
	data filses
	data timesession

	
	/**
	 * Métodos
	 */
	
	method new(login,codusr) constructor
	method save()	

endclass

/*/{Protheus.doc} New
Metodo construtor
@author fabiobranis
@since 21/04/2016
@version 1.0
@param login, Character, login name do usuário
/*/
method New(login,codusr) class ZADUserPortal

Local cIndUsr	:= ""
default login := ""
default codusr := ""

// teste para verificar se o parâmetro foi enviado
if !(empty(login))
	cIndUsr := login
	PswOrder(4)
endif

if !(empty(codusr))
	cIndUsr := codusr
	PswOrder(1)
endif
	
if PswSeek(cIndUsr) 

	::filial 	:= xFilial("ZAD")
	::login 	:= login
	::iderp 	:= PswRet()[1][1]
	::nome		:= PswRet()[1][2]
	::token		:= ""
	::dtaces	:= dDataBase
	::haces		:= time()
	::empses	:= cEmpAnt
	::filses	:= cFilAnt
	::timesession	:= SuperGetMV("RC_TMPSES",.F.,120000000)
	// Filial + Código de Usuário
	ZAD->(dbsetorder(1))	
	if ZAD->(dbseek(xFilial("ZAD") + cIndUsr))
		
		// defino os atributos na instância da classe pelo contrutor de acordo com o banco
		::iderp 	:= ZAD->ZAD_IDERP
		::token		:= ZAD->ZAD_TOKEN
		::dtaces	:= ZAD->ZAD_DTACES
		::haces		:= ZAD->ZAD_HRACES
		::empses	:= ZAD->ZAD_EMPSES
		::filses	:= ZAD->ZAD_FILSES
	endif

endif

return self

/*/{Protheus.doc} save
Salva os dados no banco.
Faz apenas update pois o objetivo é apenas atualizar os dados do login e não incluir ou excluir usuários
@author fabiobranis
@since 21/04/2016
@version undefined
/*/
method save() class ZADUserPortal

// se estiver vazio eu não salvo
if empty(::iderp)
	return .F.
endif 

// busco no banco o usuário para atualizar
ZAD->(dbsetorder(1))
if ZAD->(dbseek(xFilial("ZAD") + ::iderp))
	
	RecLock("ZAD",.F.)
	ZAD->ZAD_TOKEN  	:= ::token
	ZAD->ZAD_DTACES 	:= ::dtaces
	ZAD->ZAD_HRACES		:= ::haces
	ZAD->ZAD_EMPSES		:= cEmpAnt
	ZAD->ZAD_FILSES		:= cFilAnt
	MsUnlock("ZAD")
	
else
	RecLock("ZAD",.T.)
	ZAD->ZAD_FILIAL  	:= ::filial
	ZAD->ZAD_IDERP 		:= ::iderp
	ZAD->ZAD_TOKEN  	:= ::token
	ZAD->ZAD_DTACES 	:= ::dtaces
	ZAD->ZAD_HRACES		:= ::haces
	ZAD->ZAD_EMPSES		:= ::empses
	ZAD->ZAD_FILSES		:= cFilAnt
	MsUnlock("ZAD")
endif

return .T.