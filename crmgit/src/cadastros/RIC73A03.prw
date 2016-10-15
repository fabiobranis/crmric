#include 'protheus.ch'
#Include 'FWMVCDef.ch'
/*/{Protheus.doc} RIC73A03
Rotina de manutenção dos logs das rotinas do CRM 
@author fabio
@since 27/09/2016
@version undefined
/*/
//Variáveis Estáticas
Static cTitulo := "Log CRM RIC"
user function RIC73A03()

    Local oBrowse
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cabeçalho de propostas
    oBrowse:SetAlias("ZAF")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
	oBrowse:AddLegend( "ZAF_OPERA == 'I' ", "GREEN", "Operação de inclusão" )
	oBrowse:AddLegend( "ZAF_OPERA == 'A' ", "YELLOW" , "Operação de alteração")
	oBrowse:AddLegend( "ZAF_OPERA == 'E' ", "RED" , "Operação de exclusão")
     
    //Ativa a Browse
    oBrowse:Activate()
     
return

static function ModelDef()
	
	local oModel	:= nil
	local oStruZAF	:= FWFormStruct(1,"ZAF")
	
	oModel := MPFormModel():New("ZAFMOD")
	
	oModel:AddFields("FORMZAF",,oStruZAF)
	
	oModel:SetPrimaryKey({"ZAF_FILIAL","ZAF_IDLOG"})
	
	oModel:SetDescription("Modelo de dados do LOG CRM")
	
return oModel

static function ViewDef()
	
	local oModel	:= FWLoadModel("RIC73A03")
	local oStruZAF	:= FWFormStruct(2,"ZAF")
	local oView		:= nil
	
	//Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_ZAF", oStruZAF, "FORMZAF")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
	
	//O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_ZAF","TELA")
    
return oView

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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.RIC73A03' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.RIC73A03' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot

/*/{Protheus.doc} R73A3INC
Função que grava as informações de log das rotinas
@author fabio
@since 28/08/2016
@version 1.0
@param aDataInc, array, Informações a serem gravadas
@return Array,chamadas das rotinas
/*/ 
user function R73A3INC(aDataInc)
	
	local ni		:= 0
	local oModel	:= FWLoadModel("RIC73A03")
	
	oModel:SetOperation(3)
	oModel:Activate()
	
	for ni := 1 to len(aDataInc)
		oModel:SetValue("FORMZAF",aDataInc[ni][1],aDataInc[ni][2])
	next
	
	if oModel:VldData()
		oModel:CommitData()
	endif
	
	oModel:DeActivate()
	
return