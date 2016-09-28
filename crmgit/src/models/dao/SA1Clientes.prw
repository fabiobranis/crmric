#include 'Protheus.ch'

/*/{Protheus.doc} SA1Clientes
Classe do modelo DAO que representa os prospects tabela SUS
@author fabiobranis
@since 23/04/2016
@version 1.0
/*/
class SA1Clientes 

	data filial
	data cod
	data loja
	data nome
	data nreduz
	data pessoa
	data tipo
	data ender
	data xcomple
	data cod_mun
	data mun
	data bairro
	data cep
	data est
	data codpais
	data pais
	data ddi
	data ddd
	data tel
	data fax
	data tpessoa
	data email
	data vend
	data cgc
	data inscr
	//data url
	data naturez
	data xagenci
	data xdesage
	data xurl1
	data xurl2
	data xurl3
	data xdescr1
	data xvend1
	data xdescr2
	data xvend2
	data xdescr3
	data xvend3
	data xdescr4
	data xvend4
	data xdescr5
	data xvend5
	data xdescr6
	data xvend6
	data xdescr7
	data xvend7

	method new(cod,loja) constructor
	method setProperties(cod,loja)
	method save()
	method delReg()

endclass

/*/{Protheus.doc} new
Metodo construtor
@author fabiobranis
@since 23/04/2016 
@version 1.0
@param cod, String, Código do cliente
@param loja, String, Loja do cliente
@return self, Objeto instanciado
/*/
method new(cod,loja) class SA1Clientes

	default cod = ""
	default loja = ""

	// se for enviado parãmetro de código eu gero as propriedades no sentido de busca
	if !(::setProperties(cod,loja))
		::cod		:= ""
		::loja		:= ""
		::nome     := ""
		::nreduz   := ""
		::pessoa   := ""
		::tipo     := ""
		::ender    := ""
		::xcomple  := ""
		::cod_mun  := ""
		::mun      := ""
		::bairro   := ""
		::cep      := ""
		::est      := ""
		::codpais  := "01058"
		::pais     := "105"
		::ddi      := "55"
		::ddd      := ""
		::tel      := ""
		::fax      := ""
		::tpessoa  := ""
		::email    := ""
		::vend     := ""
		::cgc      := ""
		::inscr    := "ISENTO"
		//::url      := ""
		::naturez  := "10101"
		::xagenci  := ""
		::xdesage  := ""
		::xurl1    := ""
		::xurl2    := ""
		::xurl3    := ""
		::xdescr1  := ""
		::xvend1   := ""
		::xdescr2  := ""
		::xvend2   := ""
		::xdescr3  := ""
		::xvend3   := ""
		::xdescr4  := ""
		::xvend4   := ""
		::xdescr5  := ""
		::xvend5   := ""
		::xdescr6  := ""
		::xvend6   := ""
		::xdescr7  := ""
		::xvend7   := ""

	endif

return ::self

/*/{Protheus.doc} setProperties
Define as propriedades da instancia, caso ache no banco de dados
@author Fabio
@since 01/06/2016
@version undefined
@param cod, String, código do cliente
@param loja, String, loja do cliente
@return boolean, se achou o cliente
/*/
method setProperties(cod,loja) class SA1Clientes

	SA1->(dbsetorder(1))
	if SA1->(dbseek(xFilial("SA1") + cod + loja ))

		::filial 	:= xFilial("SA1")
		::cod      := SA1->A1_COD
		::loja     := SA1->A1_LOJA
		::nome     := SA1->A1_NOME
		::nreduz   := SA1->A1_NREDUZ
		::pessoa   := SA1->A1_PESSOA
		::tipo     := SA1->A1_TIPO
		::ender    := SA1->A1_END
		::xcomple  := SA1->A1_XCOMPLE
		::cod_mun  := SA1->A1_COD_MUN
		::mun      := SA1->A1_MUN
		::bairro   := SA1->A1_BAIRRO
		::cep      := SA1->A1_CEP
		::est      := SA1->A1_EST
		::codpais  := SA1->A1_CODPAIS
		::pais     := SA1->A1_PAIS
		::ddi      := SA1->A1_DDI
		::ddd      := SA1->A1_DDD
		::tel      := SA1->A1_TEL
		::fax      := SA1->A1_FAX
		::tpessoa  := SA1->A1_TPESSOA
		::email    := SA1->A1_EMAIL
		::vend     := SA1->A1_VEND
		::cgc      := SA1->A1_CGC
		::inscr    := SA1->A1_INSCR
		//::url      := SA1->A1_URL
		::naturez  := SA1->A1_NATUREZ
		::xagenci  := SA1->A1_XAGENCI
		::xdesage  := SA1->A1_XDESAGE
		::xurl1    := SA1->A1_XURL1
		::xurl2    := SA1->A1_XURL2
		::xurl3    := SA1->A1_XURL3
		::xdescr1  := SA1->A1_XDESCR1
		::xvend1   := SA1->A1_XVEND1 
		::xdescr2  := SA1->A1_XDESCR2
		::xvend2   := SA1->A1_XVEND2
		::xdescr3  := SA1->A1_XDESCR3
		::xvend3   := SA1->A1_XVEND3
		::xdescr4  := SA1->A1_XDESCR4
		::xvend4   := SA1->A1_XVEND4
		::xdescr5  := SA1->A1_XDESCR5
		::xvend5   := SA1->A1_XVEND5
		::xdescr6  := SA1->A1_XDESCR6
		::xvend6   := SA1->A1_XVEND6
		::xdescr7  := SA1->A1_XDESCR7
		::xvend7   := SA1->A1_XVEND7


		return .T.
	endif

return .F.

/*/{Protheus.doc} save
Método que grava as informações executando a rotina automáttica.
Insere e atualiza registros
@author Fabio
@since 01/06/2016
@version undefined
@return string, Se vazia ocorreu tudo certo se houver informação será o log de erros
/*/
method save() class SA1Clientes

	Local aVetor		:= {}
	Local nOpc			:= 0
	Local aErroRot		:= {}
	Local ni			:= 0
	Local cStrErro		:= ""
	Private lMsErroAuto	:= .F.
	Private lMsHelpAuto	:= .T.
	Private lAutoErrNoFile	:= .T.

	aVetor:={{"A1_COD",	::cod    	,Nil},;
	{"A1_LOJA",	::loja   	,Nil},;
	{"A1_NOME",	::nome   	,Nil},;
	{"A1_NREDUZ",	::nreduz 	,Nil},;
	{"A1_PESSOA",	::pessoa 	,Nil},;
	{"A1_TIPO",	::tipo   	,Nil},;
	{"A1_END",	::ender  	,Nil},;
	{"A1_XCOMPLE",	::xcomple	,Nil},;
		{"A1_EST",	::est    	,Nil},;
	{"A1_COD_MUN",	::cod_mun	,Nil},;
	{"A1_MUN",	::mun    	,Nil},;
	{"A1_BAIRRO",	::bairro 	,Nil},;
	{"A1_CEP",	::cep    	,Nil},;
	{"A1_CODPAIS",	::codpais	,Nil},;
	{"A1_PAIS",	::pais   	,Nil},;
	{"A1_DDI",	::ddi    	,Nil},;
	{"A1_DDD",	::ddd    	,Nil},;
	{"A1_TEL",	::tel    	,Nil},;
	{"A1_FAX",	::fax    	,Nil},;
	{"A1_TPESSOA",	::tpessoa	,Nil},;
	{"A1_EMAIL",	::email  	,Nil},;
	{"A1_VEND",	::vend   	,Nil},;
	{"A1_CGC",	::cgc    	,Nil},;
	{"A1_INSCR",	::inscr  	,Nil},;
	{"A1_NATUREZ",	::naturez	,Nil},;
	{"A1_XAGENCI",	::xagenci	,Nil},;
	{"A1_XDESAGE",	::xdesage	,Nil},;
	{"A1_XURL1",	::xurl1  	,Nil},;
	{"A1_XURL2",	::xurl2  	,Nil},;
	{"A1_XURL3",	::xurl3  	,Nil},;
	{"A1_XDESCR1",	::xdescr1	,Nil},;
	{"A1_XVEND1",	::xvend1 	,Nil},;
	{"A1_XDESCR2",	::xdescr2	,Nil},;
	{"A1_XVEND2",	::xvend2 	,Nil},;
	{"A1_XDESCR3",	::xdescr3	,Nil},;
	{"A1_XVEND3",	::xvend3 	,Nil},;
	{"A1_XDESCR4",	::xdescr4	,Nil},;
	{"A1_XVEND4",	::xvend4 	,Nil},;
	{"A1_XDESCR5",	::xdescr5	,Nil},;
	{"A1_XVEND5",	::xvend5 	,Nil},;
	{"A1_XDESCR6",	::xdescr6	,Nil},;
	{"A1_XVEND6",	::xvend6 	,Nil},;
	{"A1_XDESCR7",	::xdescr7	,Nil},;
	{"A1_XVEND7",	::xvend7 	,Nil}}
	
	//{"A1_URL",	::url    	,Nil},;

	SA1->(dbsetorder(1))
	// se achar o registro - atualiza
	nOpc := iif(SA1->(dbseek(xFilial("SA1") + ::cod + ::loja )),4,3)

	MSExecAuto({|x,y| MATA030(x,y)},aVetor,nOpc) //3- Inclusão, 4- Alteração, 5- ExclA1ão
	if lMsErroAuto
		aErroRot := GetAutoGRLog()
		for ni := 1 to len(aErroRot)
			cStrErro += aErroRot[ni]
		next
	endif

return cStrErro

/*/{Protheus.doc} delReg
Deleta o registro
@author Fabio
@since 01/06/2016
@version undefined
@return string, Se vazia ocorreu tudo certo se houver informação será o log de erros
/*/
method delReg() class SA1Clientes

	Local aVetor		:= {}
	Local aErroRot		:= {}
	Local ni			:= 0
	Local cStrErro		:= ""
	Private lMsErroAuto	:= .F.
	Private lMsHelpAuto	:= .T.
	Private lAutoErrNoFile	:= .T.

	aVetor:={{"A1_COD" ,::cod ,Nil},;
	{"A1_LOJA" ,::loja ,Nil}}

	if SA1->(dbseek(xFilial("SA1") + ::cod + ::loja ))
		MSExecAuto({|x,y| MATA030(x,y)},aVetor,5) //3- InclA1ão, 4- Alteração, 5- ExclA1ão
	else
		cStrErro:= "Cliente não encontrado para exclusão"
	endif

	if lMsErroAuto
		aErroRot := GetAutoGRLog()
		for ni := 1 to len(aErroRot)
			cStrErro += aErroRot[ni]
		next
	endif

return cStrErro

/*/{Protheus.doc} GetCodSUS
Função estática que incrementa o código da tabela SUS.
Criada pois o getSXeNum não se comporta adequadamente.
@author Fabio
@since 01/06/2016
@version undefined
@param cCodSus, string, código a avaliar (se o mesmo for repetido ele incrementa)
@return string, código novo
/*/
static function GetCodSA1(cCodSus)

	Local aAreaSA1	:= SUS->(GetArea())
	Local cCodNovo  := cCodSus

	SA1->(dbsetorder(1))
	while SA1->(dbseek(xFilial("SA1") + cCodNovo))

		cCodNovo := soma1(cCodNovo)
	enddo
	RestArea(aAreaSA1)

return cCodNovo
