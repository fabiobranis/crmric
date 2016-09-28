#include 'protheus.ch'

/*/{Protheus.doc} CRMLogin
Classe que cont�m a l�gica de neg�cio do servi�o de Login do portal CRM
@author fabiobranis
@since 21/04/2016
@version 1.0
/*/
class CRMLoginSite 
	
	// os atributos geram o retorno - n�o haver� m�todos getters e setters
	// apenas um m�todo para gerar os atributos para resposta
	
	/**
	 *Atributos
	 */
	data erroAuto
	data attr
	data attrVend 
	
	/**
	 * M�todos
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
M�todo que faz o login do usu�rio no portal
@author fabiobranis
@since 21/04/2016
@version undefined
@param oUser, object, Objeto DAO do usu�rio
@param cPsw, characters, Password informado no portal
/*/
method doLogin(cPsw) class CRMLoginSite
	
	// teste para ver se o opassword bate
	if PswName(cPsw) .and. ::usrIsEmp()
		return .T.
	endif 
	::erroAuto := "Login inv�lido - usu�rio ou senha inv�lidos"
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
	::erroAuto := "Usu�rio sem acesso a esta empresa/filial"
return .F.

/*/{Protheus.doc} valToken
m�todo que valida se o token est� ativo
@author fabiobranis
@since 21/04/2016
@version undefined
@param oUser, object, Objeto DAO do usu�rio
@param cToekn, characters, Token enviado pela aplica��o client
/*/
method valToken(oUser,cToken) class CRMLoginSite
	
	// verifico se o token � o mesmo que est� guardado no banco
	if alltrim(oUser:token) == cToken
		return .T.
	endif
	::erroAuto := "Token inv�lido"
return .F.

/*/{Protheus.doc} valSession
m�todo que valida se a sess�o expirou
@author fabiobranis
@since 21/04/2016
@version undefined
@param oUser, object, Objeto DAO do usu�rio
/*/
method valSession(oUser) class CRMLoginSite
	
	Local nTimeSess 	:= SuperGetMV("RC_TMPSES",.F.,120000000)
	Local nDifDay		:= dDataBase - oUser:dtaces // diferen�a de dias
	Local nDifSeconds	:= HrToSec(ElapTime(oUser:haces,time()))// diferen�a de horas
	
	// se j� passou um dia eu n�o deixo continuar
	if nDifDay > 0
		::erroAuto := "Sess�o expirada"
		return .F.
	endif

	// se j� passou o limite de segundos eu n�o deixo continuar
	if nDifSeconds > nTimeSess
		::erroAuto := "Sess�o expirada"
		return .F.
	endif
	
return .T.

/*/{Protheus.doc} valSession
Valida se o sistema est� entrando nos servi�os com os dados
de empresa e filial de acordo com a sess�o do usu�rio
@author Fabio
@since 14/05/2016
@version undefined
@param oUser, object, descricao
/*/
method valEmpFil(oUser) class CRMLoginSite
	
	if oUser:empses <> cEmpAnt
		::erroAuto := "Empresa inv�lida para a sess�o ativa"
		return .F.
	endif
	
	if oUser:filses <> cFilAnt
		::erroAuto := "Filial inv�lida para a sess�o ativa"
		return.F.
	endif
	
return .T.

/*/{Protheus.doc} genToken
m�todo est�tico que gera um token a partir de uma sequ�ncia aleat�ria de caracteres
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
		cRet += substr(cStr,Randomize(1,len(cStr)),1) // uso a fun��o de randomizar com base na string para retornar a posi��o e o caracter
	next

return cRet

/*/{Protheus.doc} updUser
m�todo que chama o m�todo de atualiza��o do DAO de usu�rios.
Encapsula a atualiza��o do controller da aplica��o
@author fabiobranis
@since 21/04/2016
@version undefined
@param oUser, object, Objeto DAO do usu�rio
/*/
method updUser(oUser) class CRMLoginSite
	
return oUser:save()

static function HrToSec(cHour)
	
	Local nHrs	:= val(substr(cHour,1,2))
	Local nMins	:= val(substr(cHour,4,2))
	Local nSecs	:= val(substr(cHour,7,2))
	
return nHrs * 3600 + nMins * 60 + nSecs 