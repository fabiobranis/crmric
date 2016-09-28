#include "TOTVS.CH"
#include "RESTFUL.CH"

/**
* Definições de constantes
*/

#define STR001 "Serviço de retorno de empresas da base[ERP Protheus]"
#define STR002 "Método de retorno"

/*/{Protheus.doc} crmlogin
Classe Rest com os métodos relacionados ao serviço de login dos usuários do portal CRM
@author fabiobranis
@since 21/04/2016
@version 1.0
/*/
wsrestful crmemp description STR001

wsdata key as string

wsmethod post description STR002 wssyntax "/crmemp"

end wsrestful

// método de login
wsmethod post wsreceive key wsservice crmemp

	Local cContent	:= ""
	Local oJson		:= nil
	Local oEmpre	:= nil
	Local cKeyEmp	:= "ricsc@rest2016-SC"
	Local cResp		:= ""
	Local aEmprRet	:= {}
	Local aRetorno	:= {}
	Local ni		:= 0
	Local aArrayForm	:= {"empresas"}
	Local aObjArr		:= {}
	Local aAttrClass	:= {}
	Local ni			:= 0
	// define o tipo de retorno do método
	::SetContentType("application/json")

	// pego o conteúdo enviado
	cContent := ::GetContent()
	
	// transformo em objeto
	if FwJsonDeserialize(cContent,@oJson)
		
		if alltrim(oJson:key) == cKeyEmp
			oResp := CRMResp():New(200,nil,aArrayForm) 
			aEmprRet := FWLoadSM0()
			for ni := 1 to len(aEmprRet)
				oEmpre := nil
				// instância da classe business empresa (model)
				oEmpre := CRMEmpSite():New(aEmprRet[ni][3],aEmprRet[ni][6],aEmprRet[ni][2],aEmprRet[ni][7])
				
				oResp:addBody(aArrayForm[1],oEmpre)
				aadd(aRetorno,oEmpre)
			next
			
			aObjArr := ClassDataArr(oEmpre)
			aAttrClass := {}
			for ni := 1 to len(aObjArr)
				aadd(aAttrClass,lower(aObjArr[ni][1]))
			next
			oResp:addProperties(aAttrClass)
			cResp := oResp:toJson()//FWJsonSerialize(aRetorno,.F.,.T.)
		else
			// se houver falha no logins
			SetRestFault(401,"Forbidden")
			return .F.
		endif
	else
		// se não chegaram os parâmetros
		SetRestFault(401, "Erro interno")
		return .F.
	endif

	// defino a resposta
	::SetResponse(cResp)
	
	FreeObj(oEmpre)
	FreeObj(oResp)
	FreeObj(oJson)
	
return .T.