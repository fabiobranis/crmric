#include 'protheus.ch'
#include 'parmtype.ch'

user function advunit()
	
	if RpcSetEnv("01","022101")
		testcontr()
	endif

return

static function testcontr()
	
	local oTeste := CRMContrato():New("000053")
	
return

static function testPropMvc()
	
	/*local oModel := FWLoadModel("RIC73A01")
	
	Private aItRef	:= {}
    Private nPosIt	:= 0
    
	ADY->(dbsetorder(1))
	ADY->(dbseek(xFilial("ADY") + "000057"))	
	
	oModel:SetOperation(4)
	oModel:Activate()
	
	oModel:GetModel("ADZDETAIL")*/
	local oTest	:= ADYProposta():New("000057")
	
	
	
return

static function testEmpArray()
	
	Local aEmprRet		:= FWLoadSM0()
	Local aSortedRet	:= {}
	Local aFilteredRet	:= {}
	Local aEmpData		:= {}
	Local ni			:= 0
	Local nOrder		:= 3
	Local cTpOrder		:= "DESC"
	Local bOrder		:= iif(cTpOrder == "ASC",{|x,y| x[nOrder] < y[nOrder]}, {|x,y| x[nOrder] > y[nOrder]})
	Local nPageLength	:= 5
	Local nTotalRegs	:= 0
	Local aRet			:= {}
	Local cTerm			:= "TV"
	Local cPropName		:= "nomefil"
	Local aProps		:= {"codemp","nomeemp","codfil","nomefil"}
	Local nTermFilt		:= ascan(aProps,cPropName)
	
	for ni := 1 to len(aEmprRet)
		aadd(aEmpData,{aEmprRet[ni][3],aEmprRet[ni][6],aEmprRet[ni][2],aEmprRet[ni][7]})
	next
	
	aSortedRet := asort(aEmpData,,,bOrder)
	
	for ni := 1 to len(aSortedRet)
		if cTerm $ aSortedRet[ni][nTermFilt]
			aadd(aFilteredRet,aSortedRet[ni])
		endif
	next
	
	nTotalRegs := len(aSortedRet)
	
	for ni := 1 to nPageLength
		if ni <= len(aFilteredRet)
			aadd(aRet,aFilteredRet[ni])
		endif
	next

return

static function testclass()
	oCli := SA1Clientes():New()
	
	aObjArr := ClassDataArr(oCli)
	aAttrClass := {}
	for ni := 1 to len(aObjArr)
		aadd(aAttrClass,lower(aObjArr[ni][1]))
	next
return

static function testJsonA()
	
	Local aTest 	:= {}
	Local aArrayForm	:= {"usuario","vendedor"}
	Local oJson		:= nil
	Local oUser 	:= ZADUserPortal():New(nil,"000791")
	Local oVend		:= SA3Vendedor():New(oUser:iderp)
	Local attr 		:= {"filial","iderp","login","nome","token","dtaces","haces","empses","filses","timesession"}
	Local attrVend 	:= {"filial","idusr","cod","nome","email"}
	Local aDim		:= {}
	Local cJson		:= ""//FWJsonSerialize(aDim1,.F.,.T.) 
	Local ni,nj		:= 0
	Local cStrAux	:= ""
	Local aObjs		:= {}
	
	aadd(aDim,attr)
	aadd(aDim,attrVend)
	
	aadd(aObjs,oUser)
	aadd(aObjs,oVend)
	
	cJson := '{"status": 201, "body":{'
	
	for ni := 1 to len(aDim)
		cStrAux := FWJsonSerialize(aObjs[ni],.F.,.T.) 
		for nj := 1 to len(aDim[ni])
			cStrAux := strtran(cStrAux,upper(aDim[ni][nj]),aDim[ni][nj])
		next
		cJson += '"' + aArrayForm[ni] + '"' + ': '+cStrAux + iif(ni < len(aDim),',','}}')
	next

	
return	

static function testprp()
	Local cContent	:= '{"nome": "CLIENTE TESTE API 02", "nreduz": "CLIENTE TESTE 02", "tipo": "F", "ender": "RUA DAS BANANEIRAS, 192", "mun": "FLORIANOPOLIS", "bairro": "CENTRO", "cep": "88888888",  "ddd": "48",  "tel": "89999898","est": "SC" , "email": "cliente@teste2.com.br"}'
	Local oJson		:= nil
	Local oUser		:= nil
	Local oLogin	:= nil
	Local oVend		:= nil
	Local oProspect	:= nil
	Local oProspectBus	:= nil
	Local cResp		:= ""
	Local cOper		:= ""
	Local cCodPros	:= nil
	Local cLojPros	:= nil
	
	
	/*if ::codusu == nil .or. ::token == nil
		SetRestFault(401,"Informe os parâmetros de autenticação")
		return .F.
	endif*/
	
	// define o tipo de retorno do método
	//::SetContentType("application/json")

	// pego o conteúdo enviado
	//cContent := ::GetContent()
	
	// instância da classe DAO usuário (model)
	oUser := ZADUserPortal():New(,"000791")

	// instância da classe de negócios (model)
	oLogin := CRMLoginSite():New()

	// faço o login
	if !oLogin:valToken(oUser,"GruOpwpJlC6hx1C5UnEg")
		// se houver falha no logins
		//SetRestFault(401,"Token Inválido")
		return .F.
	endif
	
	// verifico se a sessão não expirou
/*	if !oLogin:valSession(oUser)
		//SetRestFault(401,"Sessão expirada")
		return .F.
	endif*/
	
	if !oLogin:valEmpFil(oUser)
		//SetRestFault(401,"Empresa/Filial inválida para a sessão ativa")
		return .F.
	endif
	
	oProspectBus := CRMProspectSite():New()
	
	// transformo em objeto
	if !FwJsonDeserialize(cContent,@oJson)
		// se não chegaram os parâmetros
		//SetRestFault(401, "Erro interno")
		return .F.
	endif
	
	oVend := SA3Vendedor():New(oUser:iderp)
	
	if AttIsMemberOf(oJson,"codigo")
		cCodPros := oJson:codigo
	endif
	
	if AttIsMemberOf(oJson,"loja")
		cLojPros := oJson:loja
	endif
	
	oProspect := SUSProspectsPortal():New(cCodPros,cLojPros)
	
	// valido o conteúdo enviado
	if !(oProspectBus:valJson(cContent,oProspect))
		//SetRestFault(401,oProspectBus:erroMsg)
		return .F.
	endif
	
	oProspectBus:setFromJson(oJson,@oProspect)
	
	if !oProspectBus:valProsp(oProspect)
		//SetRestFault(401, oProspect:getErroAuto())
		return .F.
	endif

	if oProspectBus:isInclui(oProspect)
		cOper := "Incluído"
	else
		cOper := "Alterado"
	endif
	
	if !oProspectBus:save(oProspect)
		//SetRestFault(401, oProspect:getErroAuto())
		return .F.
	endif
	
	
	conout(varinfo("oProspect",oProspect))
return

static function testemp()
	Local cContent	:= ""
	Local oJson		:= nil
	Local oEmpre	:= nil
	Local cKeyEmp	:= "ricsc@rest2016-SC"
	Local cResp		:= ""
	Local aEmprRet	:= {}
	Local aRetorno	:= {}
	Local ni		:= 0

	// define o tipo de retorno do método
	//::SetContentType("application/json")

	// pego o conteúdo enviado
	cContent := '{"key" : "ricsc@rest2016-SC"}'//::GetContent()
	
	// transformo em objeto
	if FwJsonDeserialize(cContent,@oJson)
		
		if alltrim(oJson:key) == cKeyEmp
		
			aEmprRet := FWLoadSM0()
			for ni := 1 to len(aEmprRet)
				oEmpre := nil
				// instância da classe business empresa (model)
				oEmpre := CRMEmpSite():New(aEmprRet[ni][3],aEmprRet[ni][6],aEmprRet[ni][2],aEmprRet[ni][7])
				aadd(aRetorno,oEmpre)
			next
			cResp := FWJsonSerialize(aRetorno,.F.,.T.)
		else
			// se houver falha no logins
			//SetRestFault(401,"Forbidden")
			return .F.
		endif
	else
		// se não chegaram os parâmetros
		//SetRestFault(401, "Erro interno")
		return .F.
	endif

	// defino a resposta
	//::SetResponse(cResp)
return

static function testLogin()
	
	Local cContent	:= ""
	Local oJson		:= nil
	Local oUser		:= nil
	Local oLogin	:= nil
	Local oVend		:= nil
	Local cResp		:= ""

	// define o tipo de retorno do método
	//::SetContentType("application/json")

	// pego o conteúdo enviado
	cContent := '{ "usuario" : "fabio.branis@ricsc.com.br",  "senha": "fabio123"}'
	
	// transformo em objeto
	if FwJsonDeserialize(cContent,@oJson)

		// instância da classe DAO usuário (model)
		oUser := ZADUserPortal():New(oJson:usuario)

		// instância da classe de negócios (model)
		oLogin := CRMLoginSite():New()

		// faço o login
		if oLogin:doLogin(oJson:senha)

			oVend := SA3Vendedor():New(oUser:iderp)

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
					oLogin:setAttr(oUser,oVend)

					// Serializo o json e armazeno na resposta
					cResp := FWJsonSerialize(oLogin,.F.,.T.)

				endif
			else
				// se houver falha no logins
				//SetRestFault(401,"Usuário não é vendedor")
				return .F.
			endif
		else
			// se houver falha no logins
			//SetRestFault(401,"Login Inválido")
			return .F.
		endif
	else

		// se não chegaram os parâmetros
		//SetRestFault(401, "Erro interno")
		return .F.
	endif

	// defino a resposta
	//::SetResponse(cResp)
return

static function testBPros()

	local oCrmPrs	:= CRMProspectSite():New()
	local cJson		:= oCrmPrs:getList("",1,10,1) 
	

return

static function testProsp()

	Local oProsp := SUSProspectsPortal():New()


	oProsp:nome		:= "CLIENTE DE TESTES 01"
	oProsp:nreduz	:= "TESTE 01"
	oProsp:tipo		:= "F"
	oProsp:ender	:= "RUA FERNANDO MACHADO, 192"
	oProsp:mun		:= "FLORIANOPOLIS"
	oProsp:bairro	:= "CENTRO"
	oProsp:cep		:= "88020130"
	oProsp:est		:= "SC"
	oProsp:ddd		:= "48"
	oProsp:tel		:= "99999999"
	oProsp:email	:= "TESTE@TESTE.COM.BR"
	oProsp:vend		:= ""
	oProsp:cgc		:= "24366881000127"
	oProsp:inscr	:= "ISENTO"

	if !oProsp:save()
		oProsp:getErroAuto()
	endif
	/*	
	if !oProsp:delReg()
		oProsp:getErroAuto()
	endif*/
return

static function testContato()

	Local oContato, oEnder, oTelef
	Local cStrErro	:= ""
	Local aEndere	:= {{"000005","SU5","000004","1"}}
	Local ni		:= 0

	oContato := SU5Contatos():New()

	oContato:contat	:= "JOAO DA SILVA"
	oContato:cpf 	:= "75075391567"
	oContato:sexo 	:= "1"
	oContato:civil 	:= "1"
	oContato:conjuge 	:= ""
	oContato:filhos 	:= 0
	oContato:nomef 	:= ""
	oContato:funcao 	:= "000004"
	oContato:status	:= "3"
	oContato:trata 	:= "01"
	oContato:natural	:= "SAO PAULO"
	oContato:animal 	:= "Cachorro"
	oContato:nomeani	:= "Nino"
	oContato:url 	:= "www.teste.com.br"
	oContato:xurl1	:= "facebook.com/teste"
	oContato:xurl2 	:= ""
	oContato:xurl3	:= "T"
	oContato:email	:= "joao@teste.com.br"
	oContato:obs	:= "Cliente para testes unitarios"
	oContato:niver	:= ctod("28/01/1970")
	
	/*for ni := 1 to len(aEndere)
		nPosAlt	:= oContato:getEndPos(aEndere[ni][1],aEndere[ni][2],aEndere[ni][3],aEndere[ni][4])
		if nPosAlt > 0
			oEnder := nil
			oEnder := AGAEnderecos():New(oContato:codcont,"000005")
			//oEnder:codigo	:= "000005"
			//oEnder:codent	:= "000004                   "
			oEnder:tipo		:= "1"
			oEnder:padrao	:= "1"
			oEnder:ender	:= "RUA TESTE NOVA"
			oEnder:cep		:= "88095350"
			oEnder:bairro	:= "BAIRRO TESTE"
			oEnder:mundes	:= "FLORIANOPOLIS"
			oEnder:est		:= "SC"
			oEnder:mun		:= "05407"
			oEnder:pais		:= "105"
			oEnder:comp		:= "apto 302"
			
			oContato:altEndByPos(nPosAlt,oEnder) 
			
		endif
		
	next*/
	
	//oContato:aaddEndCont(oEnder)
	
	oEnder := AGAEnderecos():New(oContato:codcont)
	oEnder:tipo		:= "1"
	oEnder:padrao	:= "2"
	oEnder:ender	:= "RUA ADICIONADA"
	oEnder:cep		:= "88095350"
	oEnder:bairro	:= "BAIRRO ADCIONADO"
	oEnder:mundes	:= "FLORIANOPOLIS"
	oEnder:est		:= "SC"
	oEnder:mun		:= "05407"
	oEnder:pais		:= "105"
	oEnder:comp		:= "apto 333"
	
	
	
	oContato:aaddEndCont(oEnder)
	
	oTelef := AGBTelefones():New(oContato:codcont)
	oTelef:tipo		:= "1"
	oTelef:padrao	:= "1"
	oTelef:ddd		:= "48"	
	oTelef:telefo	:= "888888"
	oTelef:comp		:= ""

	oContato:aaddTelCont(oTelef)

	cStrErro := oContato:save()
	if !empty(cStrErro)
		conout(cStrErro)
		//oContato:erroAuto
	endif

return