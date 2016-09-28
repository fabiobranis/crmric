#include 'protheus.ch'

/*/{Protheus.doc} CRMLogin
Classe que contém a lógica de negócio do serviço de Login do portal CRM
@author fabiobranis
@since 21/04/2016
@version 1.0
/*/
class CRMLoginSite 
	
	// os atributos geram o retorno - não haverá métodos getters e setters
	// apenas um método para gerar os atributos para resposta
	
	/**
	 *Atributos
	 */
	data erroAuto
	data attr
	data attrVend 
	
	/**
	 * Métodos
	 */
	method new() constructor 
	method doLogin(cPsw)
	method usrIsEmp()
	method valToken(oUser,cToken)
	method valEmpFil(oUser)
	method valSession(oUser)
	method genToken()
	method updUser(oUser)
	method setAttr(oUser)

endclass

/*/{Protheus.doc} new
Metodo construtor
@author fabiobranis
@since 21/04/2016 
@version 1.0
/*/
method new() class CRMLoginSite
	
	::attr 		:= {}
	::attrVend 	:= {}
	::erroAuto 	:= ""
	
return

/*/{Protheus.doc} doLogin
Método que faz o login do usuário no portal
@author fabiobranis
@since 21/04/2016
@version undefined
@param oUser, object, Objeto DAO do usuário
@param cPsw, characters, Password informado no portal
/*/
method doLogin(cPsw) class CRMLoginSite
	
	// teste para ver se o opassword bate
	if PswName(cPsw) .and. ::usrIsEmp()
		return .T.
	endif 
	::erroAuto := "Login inválido - usuário ou senha inválidos"
return .F.

method usrIsEmp() class CRMLoginSite
	
	Local aEmprUsr	:= PswRet(2)
	
	// todos os acessos
	if aEmprUsr[1][6][1] == "@@@@"
		return .T.
	endif
	
	// verifica se tem acesso a empresa logada
	if ascan(aEmprUsr[1][6],FWGrpCompany()+cFilAnt) > 0
		return .T.
	endif
	::erroAuto := "Usuário sem acesso a esta empresa/filial"
return .F.

/*/{Protheus.doc} valToken
método que valida se o token está ativo
@author fabiobranis
@since 21/04/2016
@version undefined
@param oUser, object, Objeto DAO do usuário
@param cToekn, characters, Token enviado pela aplicação client
/*/
method valToken(oUser,cToken) class CRMLoginSite
	
	// verifico se o token é o mesmo que está guardado no banco
	if alltrim(oUser:token) == cToken
		return .T.
	endif
	::erroAuto := "Token inválido"
return .F.

/*/{Protheus.doc} valSession
método que valida se a sessão expirou
@author fabiobranis
@since 21/04/2016
@version undefined
@param oUser, object, Objeto DAO do usuário
/*/
method valSession(oUser) class CRMLoginSite
	
	Local nTimeSess 	:= SuperGetMV("RC_TMPSES",.F.,120000000)
	Local nDifDay		:= dDataBase - oUser:dtaces // diferença de dias
	Local nDifSeconds	:= HrToSec(ElapTime(oUser:haces,time()))// diferença de horas
	
	// se já passou um dia eu não deixo continuar
	if nDifDay > 0
		::erroAuto := "Sessão expirada"
		return .F.
	endif

	// se já passou o limite de segundos eu não deixo continuar
	if nDifSeconds > nTimeSess
		::erroAuto := "Sessão expirada"
		return .F.
	endif
	
return .T.

/*/{Protheus.doc} valSession
Valida se o sistema está entrando nos serviços com os dados
de empresa e filial de acordo com a sessão do usuário
@author Fabio
@since 14/05/2016
@version undefined
@param oUser, object, descricao
/*/
method valEmpFil(oUser) class CRMLoginSite
	
	if oUser:empses <> cEmpAnt
		::erroAuto := "Empresa inválida para a sessão ativa"
		return .F.
	endif
	
	if oUser:filses <> cFilAnt
		::erroAuto := "Filial inválida para a sessão ativa"
		return.F.
	endif
	
return .T.

/*/{Protheus.doc} genToken
método estático que gera um token a partir de uma sequência aleatória de caracteres
@author fabiobranis
@since 21/04/2016
@version undefined
/*/
method genToken() class CRMLoginSite

	Local cStr			:= "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	Local nTokenLength	:= TamSx3("ZAD_TOKEN")[1] 
	Local cRet			:= ""
	Local ni			:= 0
	
	// percorro a string base
	for ni := 1 to nTokenLength
		cRet += substr(cStr,Randomize(1,len(cStr)),1) // uso a função de randomizar com base na string para retornar a posição e o caracter
	next

return cRet

/*/{Protheus.doc} updUser
método que chama o método de atualização do DAO de usuários.
Encapsula a atualização do controller da aplicação
@author fabiobranis
@since 21/04/2016
@version undefined
@param oUser, object, Objeto DAO do usuário
/*/
method updUser(oUser) class CRMLoginSite
	
return oUser:save()

static function HrToSec(cHour)
	
	Local nHrs	:= val(substr(cHour,1,2))
	Local nMins	:= val(substr(cHour,4,2))
	Local nSecs	:= val(substr(cHour,7,2))
	
return nHrs * 3600 + nMins * 60 + nSecs 