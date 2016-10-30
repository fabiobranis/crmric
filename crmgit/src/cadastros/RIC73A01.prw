//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Variáveis Estáticas
Static cTitulo := "Propostas"
Static aMeses	:= {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
 
/*/{Protheus.doc} RIC73A01
Rotina de manutenção das propostas comerciais 
(ADY) - Propostas, 
(ADZ) - Itens das propostas
(ZAA) - Calendário de veiculação
(ZAE) - Propostas pais/filhas X Filiais
@author Fábio Branis
@since 08/08/2016
@version 1.0
@return Nil, Função não tem retorno
/*/
 
User Function RIC73A01()
    Local aArea   := GetArea()
    Local oBrowse
    // variáveis que controlam o carregamento do calendário de veiculação - devem estar como private no escopo da rotina.
    Private aItRef	:= {}
    Private nPosIt	:= 0
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cabeçalho de propostas
    oBrowse:SetAlias("ADY")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
	oBrowse:AddLegend( "ADY_STATUS == 'F' ", "RED", "Proposta Finalizada" )
	oBrowse:AddLegend( "ADY_STATUS == 'A' ", "GREEN" , "Proposta em aberto")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil

/*/{Protheus.doc} MenuDef
Função que monta o array de funcionalidades do menu do browse
@author fabio
@since 28/08/2016
@version 1.0
@return Array,chamadas das rotinas
/*/ 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.RIC73A01' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.RIC73A01' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.RIC73A01' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.RIC73A01' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Contrato de Veiculação de Publicidade'    ACTION 'u_FT600IMP()' OPERATION 8 ACCESS 0 //OPERATION 5
 
Return aRot
 
/*/{Protheus.doc} ModelDef
Função que define o modelo de dados da aplicação
@author Fábio Branis
@since 28/08/2016
@version 1.0
@return object, Modelo de dados
/*/
Static Function ModelDef()
    Local oModel        := Nil
    Local oStPai        := FWFormStruct(1, 'ADY')
    Local oStFilho  := FWFormStruct(1, 'ADZ')
    Local oStNeto   := FWFormStruct(1, 'ZAA')
    Local oStruZAE	:= FWFormStruct( 1, 'ZAE' )
    Local aADZRel       := {}
    Local aZAARel       := {}
    Local bValPost		:= {|oModel| U_R73A01VLD(oModel)}
    Local bCommit 	:= {|oModel| U_R73A01COM(oModel)}
    Local bAdzPost	:= {|oGrid,nLin| U_R73A01LVD(oGrid,nLin)}
     
    //Criando o modelo e os relacionamentos
    oModel := MPFormModel():New('RIC73A1M',,bValPost,bCommit)
    
    //Entidade principal - Enchoice
    oModel:AddFields('ADYMASTER',/*cOwner*/,oStPai)
    
    // Entidades dependentes - grid
    oModel:AddGrid('ADZDETAIL','ADYMASTER',oStFilho,/*bLinePre*/, bAdzPost,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,{|oModel,lCopy|LoadItem(oModel,lCopy)})  //cOwner é para quem pertence
    oModel:AddGrid('ZAADETAIL','ADZDETAIL',oStNeto,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,{|oModel,lCopy|LoadCale(oModel,lCopy)})  //cOwner é para quem pertence
    oModel:AddGrid( 'ZAEFIL', 'ADZDETAIL', oStruZAE,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*{|oModel,lCopy|LoadFil(oModel,lCopy)}*/)
     
    //Relacionamento entre cabeçalho e itens
    aAdd(aADZRel, { 'ADZ_FILIAL', 'ADY_FILIAL' })
    aAdd(aADZRel, {'ADZ_PROPOS', 'ADY_PROPOS' } )
     
    //Relacionamento entre itens e calendário de veiculação
    aAdd(aZAARel, { 'ZAA_FILIAL', 'ADZ_FILIAL' })
    aAdd(aZAARel, {'ZAA_ITPROP', 'ADZ_ITEM' }) 
    aAdd(aZAARel, {'ZAA_PROPOS', 'ADY_PROPOS' }) 
     
    oModel:SetRelation('ADZDETAIL', aADZRel, ADZ->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('ADZDETAIL'):SetUniqueLine({"ADZ_FILIAL","ADZ_ITEM"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
     
    oModel:SetRelation('ZAADETAIL', aZAARel, ZAA->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('ZAADETAIL'):SetUniqueLine({"ZAA_FILIAL","ZAA_ITPROP","ZAA_DTEXIB"}) //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:GetModel( 'ZAADETAIL' ):SetOptional(.T.)
    
    // definição de relacionamento com a tabela de propostas pai/filha X Filiais
    oModel:SetRelation( 'ZAEFIL', { { 'ZAE_FILIAL', 'ADY_FILIAL' }, {'ZAE_NUMPRC', 'ADY_PROPOS' }}, ZAE->( IndexKey( 1 ) ) )
    oModel:GetModel( 'ZAEFIL' ):SetOptional(.T.) 
    
    //Setando as descrições
    oModel:SetDescription("Propostas - Mod. X")
    oModel:GetModel('ADYMASTER'):SetDescription('Modelo Proposta')
    oModel:GetModel('ADZDETAIL'):SetDescription('Modelo Itens')
    oModel:GetModel('ZAADETAIL'):SetDescription('Modelo Calendario')
    
    // propriedades especificas dos campos no modelo    
    oStPai:SetProperty('ADY_OPORTU',MODEL_FIELD_OBRIGAT,.F.)
	oStPai:SetProperty('ADY_REVISA',MODEL_FIELD_OBRIGAT,.F.)
	oStPai:SetProperty('ADY_VEND',MODEL_FIELD_INIT,{||Posicione("SA3",7,xFilial("SA3") + RetCodUsr(),"A3_COD")})
	oStPai:SetProperty('ADY_FILIAL',MODEL_FIELD_INIT,{||xFilial("ADY")})
	oStFilho:SetProperty('ADZ_FILIAL',MODEL_FIELD_INIT,{||xFilial("ADZ")})
    oStNeto:SetProperty('ZAA_FILIAL',MODEL_FIELD_INIT,{||xFilial("ZAA")}) 
    oStNeto:SetProperty('ZAA_ITPROP',MODEL_FIELD_INIT,{||oModel:GetModel('ADZDETAIL'):GetValue("ADZ_ITEM",oModel:GetModel('ADZDETAIL'):GetLine())}) 

Return oModel

/*/{Protheus.doc} LoadItem
Função que é chamada no carregamento dos itens da grid (ADZ).
Faz a busca nas filiais com propostas filhas para trazer os dados de forma ordenada na montagem do modelo para edição.
@author fabio
@since 28/08/2016
@version 1.0
@param oModel, object, objeto do grid carregado
@param lCopy, logical, define se é uma operação de cópia
@return array, dados dos itens da proposta
/*/
static function LoadItem(oModel,lCopy)
	local aModel	:= {}
	local aAux		:= {}
	local aStruADZ 	:= oModel:GetStruct():GetFields()
	local ni		:= 0
	local aAreaADZ	:= ADZ->(GetArea())
	local nItem		:= 0
	
	// essas duas variáveis serão usadas para controlar o calendário de veiculação em outra função
	aItRef	:= {}
    nPosIt	:= 0

	// se for inclusão retorno vazio
	if oModel:GetOperation() == 3
		return aModel
	endif
	
	// posiciono no primeiro item da proposta na filial corrente
	ADZ->(dbsetorder(1))
	if !ADZ->(dbseek(xFilial("ADZ") + ADY->ADY_PROPOS))
		return aModel
	endif
	
	// carrego os dados da filial corrente
	while ADZ->(!eof()) .and. ADZ->(ADZ_FILIAL + ADZ_PROPOS) == ADY->(ADY_FILIAL + ADY_PROPOS)
		aAux := {}
		for ni := 1 to len(aStruADZ)
			aadd(aAux,ADZ->(FieldGet(FieldPos(aStruADZ[ni][3]))))
		next
		aadd(aItRef,{ADZ->ADZ_FILIAL,ADZ->ADZ_PROPOS,ADZ->ADZ_ITEM,ADZ->ADZ_ITEM})
		
		// para a filial corrente eu uso o recno
		aadd(aModel,{ADZ->(recno()),aAux})
		
		// defino o item posicionado para não haver duplicidade ou carregamento equivocado nos itens das outras filiais
		nItem := val(ADZ->ADZ_ITEM) 
		ADZ->(dbskip())
	enddo
	
	// verifico se a proposta contém propostas filhas
	ZAE->(dbsetorder(1))
	if !ZAE->(dbseek(xFilial("ZAE") + ADY->ADY_PROPOS))
		return aModel
	endif
	
	// percorro as propostas filhas para carregar os dados
	while ZAE->(!eof()) .and. ZAE->(ZAE_FILIAL + ZAE_NUMPRC) == ADY->(ADY_FILIAL + ADY_PROPOS)
		
		// validação para posicionar no item
		if !ADZ->(dbseek(ZAE->(ZAE_FILPRP + ZAE_PROPOS)))
			ZAE->(dbskip())
			loop
		endif
		
		// percorro os itens da proposta filha
		while ADZ->(!eof()) .and. ADZ->(ADZ_FILIAL + ADZ_PROPOS) == ZAE->(ZAE_FILPRP + ZAE_PROPOS)
			aAux := {}
			
			// incremento o item que está carregado com o último item da proposta pai
			nItem++
			
			// carga de dados
			for ni := 1 to len(aStruADZ)
				if aStruADZ[ni][3] == "ADZ_FILIAL"
					aadd(aAux,xFilial("ADZ"))
					loop
				endif
				if aStruADZ[ni][3] == "ADZ_PROPOS"
					aadd(aAux,ADY->ADY_PROPOS)
					loop
				endif
				if aStruADZ[ni][3] == "ADZ_REVISA"
					aadd(aAux,ADY->ADY_REVISA)
					loop
				endif
				if aStruADZ[ni][3] == "ADZ_ITEM"
					aadd(aAux,strzero(nItem,TamSx3("ADZ_ITEM")[1]))
					loop
				endif
				aadd(aAux,ADZ->(FieldGet(FieldPos(aStruADZ[ni][3]))))
			next
			aadd(aItRef,{ADZ->ADZ_FILIAL,ADZ->ADZ_PROPOS,ADZ->ADZ_ITEM,strzero(nItem,TamSx3("ADZ_ITEM")[1])})
			
			// uso o recno como se fosse uma inclusão, para os itens de outras filiais - faço isso pois a alteração do modelo se dará depois
			aadd(aModel,{0,aAux})
			ADZ->(dbskip())
		enddo
		ZAE->(dbskip())
	enddo
	
	RestArea(aAreaADZ)
	
return aModel

/*/{Protheus.doc} LoadCale
Função que carrega os dados do calendário de veiculação.
Entidade ZAA
@author fabio
@since 28/08/2016
@version undefined
@param oModel, object, objeto da grid ZAA
@param lCopy, logical, define se é uma operação de cópia
@return array, dados da entidade
/*/
static function LoadCale(oModel,lCopy)
	local aModel	:= {}
	local aStruZAA 	:= oModel:GetStruct():GetFields()
	local ni		:= 0
	local nItem		:= 0
	local cFilADZ	:= ""
	local cItemADZ	:= ""
	local cPropADZ	:= "" 
	local nRecZAA	:= 0
	local cItProp	:= ""
	
	nPosIt++
	if len(aItRef) >= nPosIt
		cFilADZ := aItRef[nPosIt][1]
		cPropADZ := aItRef[nPosIt][2]
		cItemADZ := aItRef[nPosIt][3]
		cItProp	 := aItRef[nPosIt][4]
	endif
	
	// inclusão
	if oModel:GetOperation() == 3
		return aModel
	endif
	
	ZAA->(dbsetorder(1))
	if !ZAA->(dbseek(cFilADZ + cPropADZ + cItemADZ ))
		return aModel
	endif
	
	while ZAA->(!eof()) .and. ZAA->(ZAA_FILIAL + ZAA_PROPOS + ZAA_ITPROP) == cFilADZ + cPropADZ + cItemADZ
		aAux := {}
		for ni := 1 to len(aStruZAA)
			if aStruZAA[ni][3] == "ZAA_FILIAL"
				aadd(aAux,xFilial("ZAA"))
				loop
			endif
			if aStruZAA[ni][3] == "ZAA_PROPOS"
				aadd(aAux,ADY->ADY_PROPOS)
				loop
			endif
			if aStruZAA[ni][3] == "ZAA_ITPROP"
				aadd(aAux,cItProp)
				loop
			endif
			aadd(aAux,ZAA->(FieldGet(FieldPos(aStruZAA[ni][3]))))
		next
		
		nRecZAA := iif(cFilAnt == cFilADZ,ZAA->(recno()),0)
		aadd(aModel,{nRecZAA,aAux})
		ZAA->(dbskip())
	enddo
	
return aModel

 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local oView     := Nil
    Local oModel        := FWLoadModel('RIC73A01')
    Local oStPai        := FWFormStruct(2, 'ADY')
    Local oStFilho  := FWFormStruct(2, 'ADZ')
    Local oStNeto       := FWFormStruct(2, 'ZAA')
    
    //Estruturas das tabelas e campos a serem considerados
    Local aStruADY  := ADY->(DbStruct())
    Local aStruADZ  := ADZ->(DbStruct())
    Local aStruZAA  := ZAA->(DbStruct())
    Local cConsADY  := "ADY_OPORTU;ADY_REVISA;ADY_DESOPO;ADY_ORCAME;ADY_DESOPO"
    Local cConsADZ  := "ADZ_XMESEX"
    Local cConsZAA  := ""
    Local nAtual        := 0
     
    //Criando a View
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Adicionando os campos do cabeçalho e o grid dos filhos
    oView:AddField('VIEW_ADY',oStPai,'ADYMASTER')
    oView:AddGrid('VIEW_ADZ',oStFilho,'ADZDETAIL')
    oView:AddGrid('VIEW_ZAA',oStNeto,'ZAADETAIL')
     
    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC',40)
    oView:CreateHorizontalBox('GRID',30)
    oView:CreateHorizontalBox('GRID2',30)

     
    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_ADY','CABEC')
    oView:SetOwnerView('VIEW_ADZ','GRID')
    oView:SetOwnerView('VIEW_ZAA','GRID2')
     
    //Habilitando título
    oView:EnableTitleView('VIEW_ADY','Proposta')
    oView:EnableTitleView('VIEW_ADZ','Itens')
    oView:EnableTitleView('VIEW_ZAA','Calendário')
     
    //Percorrendo a estrutura da ADY
    For nAtual := 1 To Len(aStruADY)
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(aStruADY[nAtual][01]) $ cConsADY
            oStPai:RemoveField(aStruADY[nAtual][01])
        EndIf
    Next
     
    //Percorrendo a estrutura da ADZ
    For nAtual := 1 To Len(aStruADZ)
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(aStruADZ[nAtual][01]) $ cConsADZ
            oStFilho:RemoveField(aStruADZ[nAtual][01])
        EndIf
    Next
    
   // oView:AddUserButton("Teste Calendário","MAGIC_BMP",{|oView|SetCale(oView)},"Teste Calendário") 
    //Percorrendo a estrutura da ZAA
    /*For nAtual := 1 To Len(aStruZAA)
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(aStruZAA[nAtual][01]) $ cConsZAA
            oStNeto:RemoveField(aStruZAA[nAtual][01])
        EndIf
    Next*/
    
    oView:AddIncrementalField("VIEW_ADZ","ADZ_ITEM")
    
Return oView

user function R73A01LVD(oGrid,nLin)
	local lRet := .T.

	if nLin == 1 .and. oGrid:GetValue("ADZ_XFILPV",nLin) <> xFilial("ADZ")
		Help('',1,'PRACA',,'O primeiro item da proposta deve ser da mesma praça da proposta',1,0)
		return .F. 
	endif
	
return lRet

// Validação TUDO-OK
user function R73A01VLD(oModel)
	
	local lRet			:= .T.
	local oCabec		:= oModel:GetModel("ADYMASTER")
	local oGridItens 	:= oModel:GetModel("ADZDETAIL")
	local oGridCalend	:= oModel:GetModel("ZAADETAIL")
	local ni			:= 0
	local nj			:= 0
	local nAux			:= 0
	local cAux			:= ""
	
	// define o calendário de veiculação
	/*if !SetCale()
		return .F.
	endif
	*/
	for ni := 1 to oGridItens:Length()
		oGridItens:GoLine(ni)
		nAux := 0
		for nj := 1 to oGridCalend:Length()
			oGridCalend:GoLine(ni)
			nAux += oGridCalend:GetValue("ZAA_QTDE",nj)
			/*if val(oGridItens:GetValue("ADZ_XMESEX",ni)) <> month(oGridCalend:GetValue("ZAA_DTEXIB",nj))
				cAux := "Item da proposta: " + oGridCalend:GetValue("ZAA_ITPROP",nj)
				cAux += " Data da veiculação: " + cValToChar(oGridCalend:GetValue("ZAA_DTEXIB",nj))
				Help('',1,'MESEXIB',,'Existe(m) veiculações com mês diferente do item da proposta ' + CRLF +  cAux ,1,0)
				return .F. 
			endif*/
		next
		
		if nAux <> oGridItens:GetValue("ADZ_QTDVEN",ni)
			cAux := "Item da proposta: " + oGridItens:GetValue("ADZ_ITEM",ni)
			Help('',1,'QTDEXIB',,'Quantidade de veiculções não está de acordo com a quantidade vendida ' + CRLF + cAux,1,0)
			return .F. 
		endif
	next
	
	
return lRet

// Código que faz o commit do modelo ativo
User Function R73A01COM(oModel)
	
	local oGridItens 	:= oModel:GetModel("ADZDETAIL")
	local oGridCalend	:= oModel:GetModel("ZAADETAIL")
	local oFilProp		:= nil 
	local ni			:= 0
	local nj			:= 0
	local nx			:= 0
	local nLinFil		:= 0
	local nLinIt		:= 0
	local oCabec		:= oModel:GetModel("ADYMASTER")
	local aAux			:= {}
	local aLine			:= {}
	local aCalend		:= {}
	local aCalJob		:= {}
	local aItJob		:= {}
	local aCabProp		:= {}
	local cPropNumber	:= ""
	Local aStruADZ  	:= ADZ->(DbStruct())
	Local aStruADY  	:= ADY->(DbStruct())
	Local aStruZAA  	:= ZAA->(DbStruct())
	local cTxtErro		:= ""
	local aPropDel		:= {}
	local aPropInc		:= {}
	
	for ni := 1 to oGridItens:Length()
		oGridItens:GoLine(ni)
		if oGridItens:GetValue("ADZ_XFILPV",ni) <> cFilAnt
			nLinFil := oModel:GetModel("ZAEFIL"):Length()
			if nLinFil > 1
				oModel:GetModel("ZAEFIL"):AddLine()
			endif
			if !oModel:GetModel("ZAEFIL"):SeekLine({{"ZAE_FILPRP",oGridItens:GetValue("ADZ_XFILPV",ni)}})
				oModel:GetModel("ZAEFIL"):GoLine(nLinFil)
				oModel:SetValue("ZAEFIL","ZAE_FILIAL",xFilial("ZAE"))
				oModel:SetValue("ZAEFIL","ZAE_NUMPRC",oModel:GetModel("ADYMASTER"):GetValue("ADY_PROPOS"))
				oModel:SetValue("ZAEFIL","ZAE_FILPRP",oGridItens:GetValue("ADZ_XFILPV",ni))
				//cPropNumber := GetPropNum(oGridItens:GetValue("ADZ_XFILPV",ni))
				//oModel:SetValue("ZAEFIL","ZAE_PROPOS",cPropNumber)
			endif
			
			aAux := {}
			for nj := 1 to len(aStruADZ)
			  	aadd(aAux,oGridItens:GetValue(aStruADZ[nj][1],ni))
			next
			aadd(aAux,oGridItens:IsDeleted())
			aadd(aLine,aAux)
			
			for nx := 1 to oModel:GetModel("ZAADETAIL"):Length()
				oModel:GetModel("ZAADETAIL"):GoLine(nx)
				if aScan(aLine,{|x|alltrim(x[2]) == oModel:GetModel("ZAADETAIL"):GetValue("ZAA_ITPROP",nx)}) > 0
					aAux := {}
					for nj := 1 to len(aStruZAA)
					  	aadd(aAux,oModel:GetModel("ZAADETAIL"):GetValue(aStruZAA[nj][1],nx))
					next
					aadd(aAux,oModel:GetModel("ZAADETAIL"):IsDeleted())
					aadd(aCalend,aAux)
					if oModel:GetOperation() <> 5
						oModel:GetModel("ZAADETAIL"):DeleteLine()
					endif
				endif
			next
			if oModel:GetOperation() <> 5
				oGridItens:DeleteLine()
			endif
		endif
	next
	
	oFilProp := oModel:GetModel("ZAEFIL")
	
	for ni := 1 to oFilProp:Length()
		aItJob := {}
		aCalJob := {}
		aCabProp := {}
		cPropNumber := ""
		
		if empty(oFilProp:GetValue("ZAE_FILPRP",ni))
			loop
		endif
		
		for nj := 1 to len(aStruADY)
			aadd(aCabProp,oCabec:GetValue(aStruADY[nj][1]))
		next
		
		for nj := 1 to len(aLine)
			if oFilProp:GetValue("ZAE_FILPRP",ni) == aLine[nj][aScan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_XFILPV"})]
				aadd(aItJob,aLine[nj])
			endif
		next
		for nj := 1 to len(aCalend)
			if aScan(aItJob,{|x|alltrim(x[2]) == aCalend[nj][2]}) > 0
				aadd(aCalJob,aCalend[nj]) 
			endif
			next
		if oModel:GetOperation() <> 3
			cPropNumber := oFilProp:GetValue("ZAE_PROPOS",ni)
		endif
		if !MVCMPRF(oFilProp:GetValue("ZAE_FILPRP",ni),aCabProp,aItJob,aCalJob,@cPropNumber,@cTxtErro,@aPropDel,oModel:GetOperation())
			Help('',1,'PROPFIL',,'Não foi possível inserir a proposta na filial ' + CRLF + cTxtErro,1,0)
			return .F. 
		endif
		if ascan(aPropDel,{|x|x[1] + x[2] == oFilProp:GetValue("ZAE_FILPRP",ni) + cPropNumber}) == 0
			aadd(aPropInc,{oFilProp:GetValue("ZAE_FILPRP",ni),cPropNumber})
		endif
		if oModel:GetOperation() <> 5	
			oModel:SetValue("ZAEFIL","ZAE_PROPOS",cPropNumber)
			oFilProp:DeleteLine()
		endif
	next
	
	FwFormCommit(oModel)
	
	ZAE->(dbsetorder(1))
	for ni := 1 to len(aPropDel)
		if ZAE->(dbseek(xFilial("ZAE") + oModel:GetModel("ADYMASTER"):GetValue("ADY_PROPOS") + aPropDel[ni][1] + aPropDel[ni][2]))
			RecLock("ZAE",.F.)
			ZAE->(dbdelete())
			ZAE->(MsUnlock())
		endif
	next
	if oModel:GetOperation() <> 5
		for ni := 1 to len(aPropInc) 
			if !ZAE->(dbseek(xFilial("ZAE") + oModel:GetModel("ADYMASTER"):GetValue("ADY_PROPOS") + aPropInc[ni][1] + aPropInc[ni][2]))
				RecLock("ZAE",.T.)
				ZAE->ZAE_FILIAL := xFilial("ZAE")
				ZAE->ZAE_NUMPRC := oModel:GetModel("ADYMASTER"):GetValue("ADY_PROPOS")
				ZAE->ZAE_FILPRP := aPropInc[ni][1]
				ZAE->ZAE_PROPOS := aPropInc[ni][2]
				ZAE->(MsUnlock())
			endif
		next
	endif
	aItRef	:= {}
    nPosIt	:= 0
return .T.

Static Function GetPropNum(cFilProp)

	Local aAreaADY	:= ADY->(GetArea())
	Local cCodNovo  := StrZero(1,TamSx3("ADY_PROPOS")[1])
	
	ADY->(dbsetorder(1))
	while ADY->(dbseek(cFilProp + cCodNovo))
		
		cCodNovo := soma1(cCodNovo)
	enddo
	RestArea(aAreaADY)
	
return cCodNovo

Static Function MVCMPRF(cFilJob,aCabecAdy,aLinesAdz,aLinesZAA,cNumPropos,cErroRot,aPropDel,nOperPai)

	Local oModel    := FWLoadModel('RIC73A01')
	local nOper		:= 0
	local cFilAux	:= cFilAnt
	local ni		:= 0
	local nj		:= 0
	local nx		:= 0
	Local aStruADZ  	:= ADZ->(DbStruct())
	Local aStruADY  	:= ADY->(DbStruct())
	Local aStruZAA  	:= ZAA->(DbStruct())
	local nPItAdz		:= ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_ITEM"})
	local nPItZaa		:= ascan(aStruZAA,{|x|alltrim(x[1]) == "ZAA_ITPROP"})
	local lRet			:= .T.
	local aErro			:= {}
	local cStrErro		:= ""
	local cRevisa		:= "01"
	local lDeleta		:= .F.
	local nDeletados	:= 0
	local nZaa			:= 0
	
	cFilAnt := cFilJob
	if empty(cNumPropos)
		nOper := 3
	elseif ADY->(dbseek(cFilJob + cNumPropos))
		nOper := 4
	endif
	
	for ni := 1 to len(aLinesAdz)
		if aLinesAdz[ni][len(aLinesAdz[ni])]
			nDeletados++
		endif
	next
	
	lDeleta := nDeletados == len(aLinesAdz)
	
	if (lDeleta .and. nOper == 4) .or. nOperPai == 5
		nOper := 5
		aadd(aPropDel,{cFilJob,cNumPropos})
	endif
	oModel:SetOperation(nOper)
	
	oModel:Activate()
	if nOper == 5
		oModel:CommitData()
		oModel:DeActivate()
		cFilAnt := cFilAux
		return lRet
	endif
	
	for ni := 1 to len(aStruADY)
		if aStruADY[ni][1] == "ADY_FILIAL"
			oModel:SetValue("ADZDETAIL",aStruADZ[ni][1],cFilJob)
			loop
		endif
		if aStruADY[ni][1] == "ADY_PROPOS"
			//oModel:SetValue("ADZDETAIL",aStruADZ[ni][1],cNumPropos)
			loop
		endif
		if aStruADY[ni][1] == "ADY_REVISA"
			oModel:SetValue("ADZDETAIL",aStruADZ[ni][1],cRevisa)
			loop
		endif
		oModel:SetValue("ADYMASTER",aStruADY[ni][1],aCabecAdy[ni])
	next
	
	cNumPropos := oModel:GetModel("ADYMASTER"):GetValue("ADY_PROPOS")
	for ni := 1 to len(aLinesAdz)
		if ni > oModel:GetModel("ADZDETAIL"):Length()
			oModel:GetModel("ADZDETAIL"):AddLine()
		endif
		oModel:GetModel("ADZDETAIL"):GoLine(ni)

		oModel:SetValue("ADZDETAIL","ADZ_FILIAL",cFilJob)
		oModel:SetValue("ADZDETAIL","ADZ_ITEM",StrZero(ni,TamSx3("ADZ_ITEM")[1]))
		oModel:SetValue("ADZDETAIL","ADZ_XPRACA",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_XPRACA"})])
		oModel:SetValue("ADZDETAIL","ADZ_XFILPV",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_XFILPV"})])
		oModel:SetValue("ADZDETAIL","ADZ_XTABPR",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_XTABPR"})])
		oModel:SetValue("ADZDETAIL","ADZ_PRODUT",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_PRODUT"})])
		oModel:SetValue("ADZDETAIL","ADZ_DESCRI",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_DESCRI"})])
		oModel:SetValue("ADZDETAIL","ADZ_XFORMA",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_XFORMA"})])
		oModel:SetValue("ADZDETAIL","ADZ_XALTUR",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_XALTUR"})])
		oModel:SetValue("ADZDETAIL","ADZ_XCOLUN",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_XCOLUN"})])
		oModel:SetValue("ADZDETAIL","ADZ_XPAGIN",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_XPAGIN"})])
		oModel:SetValue("ADZDETAIL","ADZ_QTDVEN",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_QTDVEN"})])
		oModel:SetValue("ADZDETAIL","ADZ_DESCON",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_DESCON"})])
		oModel:LoadValue("ADZDETAIL","ADZ_PRCTAB",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_PRCTAB"})])
		oModel:SetValue("ADZDETAIL","ADZ_MOEDA",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_MOEDA"})])
		oModel:SetValue("ADZDETAIL","ADZ_XMESEX",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_XMESEX"})])
		oModel:SetValue("ADZDETAIL","ADZ_XDETER",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_XDETER"})])
		oModel:SetValue("ADZDETAIL","ADZ_TES",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_TES"})])
		oModel:SetValue("ADZDETAIL","ADZ_CONDPG",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_CONDPG"})])
		oModel:SetValue("ADZDETAIL","ADZ_VALDES",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_VALDES"})])
		oModel:SetValue("ADZDETAIL","ADZ_XTPVEI",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_XTPVEI"})])
		oModel:SetValue("ADZDETAIL","ADZ_DT1VEN",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_DT1VEN"})])
		oModel:SetValue("ADZDETAIL","ADZ_ORCAME",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_ORCAME"})])
		oModel:SetValue("ADZDETAIL","ADZ_XPRFAT",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_XPRFAT"})])
		oModel:SetValue("ADZDETAIL","ADZ_XFILFA",aLinesAdz[ni][ascan(aStruADZ,{|x|alltrim(x[1]) == "ADZ_XFILFA"})])
		oModel:SetValue("ADZDETAIL","ADZ_PROPOS",cNumPropos)
		oModel:SetValue("ADZDETAIL","ADZ_REVISA",cRevisa)
		
		if aLinesAdz[ni][len(aLinesAdz[ni])]
			oModel:GetModel("ADZDETAIL"):DeleteLine()
		endif
		
		for nj := 1 to len(aLinesZAA)
			
			if aLinesZAA[nj][nPItZaa] == aLinesAdz[ni][nPItAdz] 
				nZaa++
				if nZaa > oModel:GetModel("ZAADETAIL"):Length()
					oModel:GetModel("ZAADETAIL"):AddLine()
				endif
				oModel:GetModel("ZAADETAIL"):GoLine(nZaa)
				for nx := 1 to len(aStruZAA)
					if aStruZAA[nx][1] == "ZAA_PROPOS"
						oModel:SetValue("ZAADETAIL",aStruZAA[nx][1],cNumPropos)
						loop
					endif
					if aStruZAA[nx][1] == "ZAA_FILIAL"
						oModel:SetValue("ZAADETAIL",aStruZAA[nx][1],cFilJob)
						loop
					endif
					if aStruZAA[nx][1] == "ZAA_ITPROP"
						oModel:SetValue("ZAADETAIL",aStruZAA[nx][1],strzero(ni,TamSx3("ADZ_ITEM")[1]))
						loop
					endif
					oModel:SetValue("ZAADETAIL",aStruZAA[nx][1],aLinesZAA[nj][nx])
				next
				if aLinesZAA[nj][len(aLinesZAA[nj])]
					oModel:GetModel("ZAADETAIL"):DeleteLine()
				endif
			endif
		next
		nZaa := 0
	next
	if oModel:VldData()
		oModel:CommitData()
	else
		aErro := oModel:GetErrorMessage()
		for ni := 1 to len(aErro)
			if valtype(aErro[ni]) == "C"
				cStrErro += aErro[ni] + CRLF
			endif
		next
		cErroRot := cStrErro
		lRet := .F.
	endif
	oModel:DeActivate()
	cFilAnt := cFilAux
return lRet

static function SetCale(oView)

	local lRet	:= .F.
	local lOk 	:= .F.
	local aButtons	:= {}
	local oDlgVeic	:= nil
	local cCombo1	:= nil
	local oModelIt	:= oView:GetModel("ADZDETAIL")
	local oModelCal	:= oView:GetModel("ZAADETAIL")
	local aItems	:= SetCombo(oModelIt)
	local cCombo1	:= space(2)
	local aHeader	:= {}
	local aCols		:= {}
	local nOpc 		:= GD_UPDATE
	local aHdEdit	:= {}
	private nMes	:= 0
	private oBrw1
		
	// verifico se está vazio, se estiver é porque não há itens
	if empty(aItems)
		Help('',1,'NOITEMS',,'Esta proposta não tem itens.',1,0)
		return .F. 
	endif
	
	// o combo é sempre alimentado com o primeiro item
	cCombo1 := aItems[1]
	nMes := ascan(aMeses,aItems[1])
	aHeader := GetHeader(cCombo1,@aHdEdit) 
	aCols	:= GetCols(cCombo1,oModelIt,oModelCal)
	
	// Cria diálogo
	oDlgVeic := MSDialog():New(180,30,550,1300,'Calendário de Veiculações',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	TSay():New(5,15,{||'Mês de exibição'},oDlgVeic,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
	
    oCombo1 := TComboBox():New(15,15,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItems,100,20,oDlgVeic,,{||nMes := oCombo1:nAt},,,,.T.,,,,,,,,,'cCombo1')
	oBrw1 := MsNewGetDados():New( 30 , 15, 160, 620,nOpc,"AllwaysTrue()","AllwaysTrue()",,aHdEdit,0,99,"u_ValDatZa()",,"AllwaysTrue()",oDlgVeic,aHeader,aCols)
	oDlgVeic:bInit := {||EnchoiceBar(oDlgVeic,{||lOk:=.T.,oDlgVeic:End()},{||oDlgVeic:End()},,@aButtons)}
	// Ativa diálogo centralizado
  	oDlgVeic:Activate(,,,.T.,{||msgstop('validou!'),.T.},,)
	
return lRet

static function SetCombo(oModelIt)
	
	local ni	:= 0
	local aRet	:= {}
	local nMes	:= 0
	
	for ni := 1 to oModelIt:Length()
		oModelIt:GoLine(ni)
		if nMes != val(oModelIt:GetValue("ADZ_XMESEX",ni))
			nMes := val(oModelIt:GetValue("ADZ_XMESEX",ni))
			aadd(aRet,aMeses[nMes])
		endif
	next	
	
return aRet

static function GetHeader(cMes,aHdEdit)

	local aRet		:= {}
	local ni		:= 0
	local dDiaRefer	:= ctod("01/" + StrZero(aScan(aMeses,cMes),2) + "/" + cValToChar(year(date())))
	local nDias		:= day(LastDay(dDiaRefer))
	local cPicture	:= PesqPict("ZAA","ZAA_QTDE")
	local nSize		:= TamSX3("ZAA_QTDE")[1] 
	
	aadd(aRet,{"Produto","PROD",PesqPict("ADZ","ADZ_PRODUT"),TamSX3("ADZ_PRODUT")[1],0,"","","N","",""})
	
	for ni := 1 to nDias
		aadd(aRet,{StrZero(ni,2),"D_"+StrZero(ni,2),cPicture,nSize,0,"","","N","",""})
		aadd(aHdEdit,"D_"+StrZero(ni,2))
	next
	
return aRet	

static function GetCols(cMes,oGrid,oGridCal)
	
	local ni		:= 0
	local nj		:= 0
	local aRet		:= {}
	local aAux		:= {}
	local aAuxCal	:= {}
	local dDiaRefer	:= ctod("01/" + StrZero(aScan(aMeses,cMes),2) + "/" + cValToChar(year(date())))
	local nDias		:= day(LastDay(dDiaRefer))
	local nMes		:= aScan(aMeses,cMes)
	
	for ni := 1 to oGrid:Length()
		oGrid:GoLine(ni)
		if nMes == val(oGrid:GetValue("ADZ_XMESEX",ni))
			aAux := {}
			aAuxCal := {}
			aadd(aAux,oGrid:GetValue("ADZ_PRODUT",ni))
			
			for nj := 1 to oGridCal:Length()
				if oGridCal:GetValue("ZAA_QTDE",nj) > 0
					aadd(aAuxCal,{day(oGridCal:GetValue("ZAA_DTEXIB",nj)),oGridCal:GetValue("ZAA_QTDE",nj)})
				endif
			next
			
			for nj := 1 to nDias
				if ascan(aAuxCal,{|x|x[1] == nj}) > 0
					aadd(aAux,aAuxCal[ascan(aAuxCal,{|x|x[1] == nj})][2])
				else
					aadd(aAux,0)
				endif
			next
			aadd(aAux,.F.)
			aadd(aRet,aAux)
		endif
	next
	
return aRet

user function ValDatZa()

	local oModel	:= FwModelActive()
	local oModelIt	:= oModel:GetModel("ADZDETAIL")
	local oModelCal	:= oModel:GetModel("ZAADETAIL")
	local nQtd		:= &(ReadVar())
	local nQtdAv	:= 0
	local nDia		:= val(substr(ReadVar(),6))
	local ni		:= 0
	local nDayAv	:= 0
	local nQtdMax	:= 0
	
	// se quantidade for zero eu não faço nada
	if nQtd <= 0
		return .T.
	endif
	
	//oModelIt:GoLine(n)nMes
	oModelIt:SeekLine({{"ADZ_PRODUTO",alltrim(aCols[n][1])},{"ADZ_XMESEX",cValToChar(nMes)}})
	nQtdMax := oModelIt:GetValue("ADZ_QTDVEN",n)
	for ni := 1 to oModelCal:Length()
		
		oModelCal:GoLine(ni)
		// se o dia for o mesmo e a quantidade também, não faço nada
		if day(oModelCal:GetValue("ZAA_DTEXIB",ni)) == nDia .and. oModelCal:GetValue("ZAA_QTDE",ni) == nQtd
			return .T.
		endif
		
	next
	
	for ni := 1 to len(aHeader)
		if aHeader[ni][2] == "PROD"
			loop
		endif
		nDayAv++
		
		if nDayAv == nDia
			nQtdAv += nQtd
		else
			nQtdAv += aCols[n][ni]
		endif
		
 	next
	
	
return .T.