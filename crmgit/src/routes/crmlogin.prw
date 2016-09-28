#include "TOTVS.CH"
#include "RESTFUL.CH"

/**
* Definições de constantes
*/

#define STR001 "Serviço de autenticação do CRM Ric [ERP Protheus]"
#define STR002 "Método de login"

/*/{Protheus.doc} crmlogin
Classe Rest com os métodos relacionados ao serviço de login dos usuários do portal CRM
@author fabiobranis
@since 21/04/2016
@version 1.0
/*/
wsrestful crmlogin description STR001

wsdata usuario as string
wsdata senha as string

wsmethod post description STR002 wssyntax "/crmlogin"

end wsrestful

// método de login
wsmethod post wsreceive usuario, senha wsservice crmlogin

	Local cContent	:= ""
	Local oJson		:= nil
	Local oUser		:= nil
	Local oLogin	:= nil
	Local oVend		:= nil
	Local oResp		:= nil
	Local cResp		:= ""
	Local aArrayForm	:= {"usuario","vendedor"}
	Local aObjArr		:= {}
	Local aAttrClass	:= {}
	Local ni			:= 0

	// define o tipo de retorno do método
	::SetContentType("application/json")

	// pego o conteúdo enviado
	cContent := ::GetContent()
	
	// transformo em objeto
	if FwJsonDeserialize(cContent,@oJson)

		// instância da classe DAO usuário (model)
		oUser := ZADUserPortal():New(oJson:usuario)
		
		aObjArr := ClassDataArr(oUser)
		for ni := 1 to len(aObjArr)
			aadd(aAttrClass,lower(aObjArr[ni][1]))
		next
		
		// instância da classe de negócios (model)
		oLogin := CRMLoginSite():New()
		oLogin:attr := aAttrClass

		// faço o login
		if oLogin:doLogin(oJson:senha)

			oVend := SA3Vendedor():New(oUser:iderp)
			aObjArr := ClassDataArr(oVend)
			
			aAttrClass := {}
			for ni := 1 to len(aObjArr)
				aadd(aAttrClass,lower(aObjArr[ni][1]))
			next
			oLogin:attrVend := aAttrClass
			if oVend:isVend()
				/**
				* Definição das propriedades que serão persistidas
				*/
				oUser:token := oLogin:genToken()
				oUser:dtaces := dDataBase
				oUser:haces := time()

				// faço o update - gravo as propriedades geradas
				if oLogin:updUser(oUser)

					// aqui eu defino os atributos de retorno do objeto de login
					//oLogin:setAttr(oUser,oVend)
					oResp := CRMResp():New(201,oLogin:attr,aArrayForm) 
					oResp:addBody(aArrayForm[1],oUser)
					oResp:addBody(aArrayForm[2],oVend)
					oResp:addProperties(oLogin:attrVend)
					// Serializo o json e armazeno na resposta
					cResp := oResp:toJson()

				endif
			else
				// se houver falha no logins
				SetRestFault(401,"Usuário não é vendedor")
				return .F.
			endif
		else
			// se houver falha no logins
			SetRestFault(401,oLogin:erroAuto)
			return .F.
		endif
	else

		// se não chegaram os parâmetros
		SetRestFault(401, "Erro interno")
		return .F.
	endif
	
	FreeObj(oResp)
	FreeObj(oLogin)
	FreeObj(oVend)
	FreeObj(oUser)
	FreeObj(oJson)
	
	
	// defino a resposta
	::SetResponse(cResp)
	

return .T.