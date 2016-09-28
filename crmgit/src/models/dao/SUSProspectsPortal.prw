#include 'protheus.ch'

/*/{Protheus.doc} SUSProspectsPortal
Classe do modelo DAO que representa os prospects tabela SUS
@author fabiobranis
@since 23/04/2016
@version 1.0
/*/
class SUSProspectsPortal 

	data filial
	data cod
	data loja
	data nome
	data nreduz
	data tipo
	data ender
	data xcodmun
	data mun
	data bairro
	data cep
	data est
	data ddd
	data tel
	data fax
	data email
	data vend
	data cgc
	data inscr
	data codcli
	data lojacli
	data dtconv
	data url

	method new(cod,loja) constructor
	method setProperties(cod,loja)
	method save()
	method delReg()
	method vincCli(oCli)

endclass

/*/{Protheus.doc} new
Metodo construtor
@author fabiobranis
@since 23/04/2016 
@version 1.0
@param cod, String, Código do prospect
@param loja, String, Loja do prospect
@return self, Objeto instanciado
/*/
method new(cod,loja) class SUSProspectsPortal

	default cod = GetCodSUS(GetSxeNum("SUS","US_COD"))
	default loja = "01"

	::filial 	:= xFilial("SUS")

	// se for enviado parãmetro de código eu gero as propriedades no sentido de busca
	if !(::setProperties(cod,loja))
		::cod		:= cod
		::loja		:= loja
		::nome		:= ""
		::nreduz	:= ""
		::tipo		:= ""
		::ender		:= ""
		::xcodmun	:= ""
		::mun		:= ""
		::bairro	:= ""
		::cep		:= ""
		::est		:= ""
		::ddd		:= ""
		::tel		:= ""
		::fax		:= ""
		::email		:= ""
		::vend		:= ""
		::cgc		:= ""
		::inscr		:= ""
		::codcli	:= ""
		::lojacli	:= ""
		::dtconv	:= ctod("")
		::url		:= ""

	endif

return self

/*/{Protheus.doc} setProperties
Define as propriedades da instancia, caso ache no banco de dados
@author Fabio
@since 01/06/2016
@version undefined
@param cod, String, código do prospect
@param loja, String, loja do prospect
@return boolean, se achou o prospect
/*/
method setProperties(cod,loja) class SUSProspectsPortal

	SUS->(dbsetorder(1))
	if SUS->(dbseek(xFilial("SUS") + cod + loja ))

		::cod		:= SUS->US_COD
		::loja		:= SUS->US_LOJA
		::nome		:= SUS->US_NOME
		::nreduz	:= SUS->US_NREDUZ
		::tipo		:= SUS->US_TIPO
		::ender		:= SUS->US_END
		::xcodmun	:= SUS->US_XCODMUN
		::mun		:= SUS->US_MUN
		::bairro	:= SUS->US_BAIRRO
		::cep		:= SUS->US_CEP
		::est		:= SUS->US_EST
		::ddd		:= SUS->US_DDD
		::tel		:= SUS->US_TEL
		::fax		:= SUS->US_FAX
		::email		:= SUS->US_EMAIL
		::vend		:= SUS->US_VEND
		::cgc		:= SUS->US_CGC
		::inscr		:= SUS->US_INSCR
		::codcli	:= SUS->US_CODCLI
		::lojacli	:= SUS->US_LOJACLI
		::dtconv	:= SUS->US_DTCONV
		::url		:= SUS->US_URL
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
method save() class SUSProspectsPortal

	Local aVetor		:= {}
	Local nOpc			:= 0
	Local aErroRot		:= {}
	Local ni			:= 0
	Local cStrErro		:= ""
	Private lMsErroAuto	:= .F.
	Private lMsHelpAuto	:= .T.
	Private lAutoErrNoFile	:= .T.

	aVetor:={{"US_COD" ,::cod ,Nil},;
	{"US_LOJA" ,::loja ,Nil},;
	{"US_NOME" ,::nome ,Nil},;
	{"US_NREDUZ" ,::nreduz ,Nil},;
	{"US_TIPO" ,::tipo ,Nil},;
	{"US_END" ,::ender ,Nil},;
	{"US_EST" ,::est ,Nil},;
	{"US_XCODMUN" ,::xcodmun ,Nil},;
	{"US_MUN" ,::mun ,Nil},;
	{"US_BAIRRO" ,::bairro ,Nil},;
	{"US_CEP" ,::cep ,Nil},;
	{"US_DDD" ,::ddd ,Nil},;
	{"US_TEL" ,::tel ,Nil},;
	{"US_FAX" ,::fax ,Nil},;
	{"US_EMAIL" ,::email ,Nil},;
	{"US_VEND" ,::vend ,Nil},;
	{"US_CGC" ,::cgc ,Nil},;
	{"US_URL" ,::url ,Nil},;
	{"US_INSCR" ,::inscr ,Nil}}

	SUS->(dbsetorder(1))
	// se achar o registro - atualiza
	nOpc := iif(SUS->(dbseek(xFilial("SUS") + ::cod + ::loja )),4,3)

	MSExecAuto({|x,y| TMKA260(x,y)},aVetor,nOpc) //3- Inclusão, 4- Alteração, 5- Exclusão
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
method delReg() class SUSProspectsPortal

	Local aVetor		:= {}
	Local aErroRot		:= {}
	Local ni			:= 0
	Local cStrErro		:= ""
	Private lMsErroAuto	:= .F.
	Private lMsHelpAuto	:= .T.
	Private lAutoErrNoFile	:= .T.

	aVetor:={{"US_COD" ,::cod ,Nil},;
	{"US_LOJA" ,::loja ,Nil}}

	if SUS->(dbseek(xFilial("SUS") + ::cod + ::loja ))
		MSExecAuto({|x,y| TMKA260(x,y)},aVetor,5) //3- Inclusão, 4- Alteração, 5- Exclusão
	else
		cStrErro := "Prospect não encontrado para exclusão"
	endif

	if lMsErroAuto
		aErroRot := GetAutoGRLog()
		for ni := 1 to len(aErroRot)
			cStrErro += aErroRot[ni]
		next
	endif

return cStrErro

/*/{Protheus.doc} vincCli
Vincula um cliente ao prospect, avaliando se o mesmo existe na base
@author Fabio
@since 01/06/2016
@version undefined
@param oCli, object, Objeto do cliente
/*/
method vincCli(oCli) class SUSProspectsPortal
	Local aAreaSUS	:= SUS->(GetArea())

	SUS->(dbsetorder(1))
	if SUS->(dbseek(xFilial("SUS") + padr(::cod,TamSx3("US_COD")[1],"") + padr(::loja,TamSx3("US_LOJA")[1],"")))
		RecLock("SUS",.F.)
		SUS->US_CODCLI := oCLi:cod
		SUS->US_LOJACLI := oCli:loja
		SUS->US_DTCONV := dDataBase
		MsUnlock("SUS")
	endif

	RestArea(aAreaSUS)
return

/*/{Protheus.doc} GetCodSUS
Função estática que incrementa o código da tabela SUS.
Criada pois o getSXeNum não se comporta adequadamente.
@author Fabio
@since 01/06/2016
@version undefined
@param cCodSus, string, código a avaliar (se o mesmo for repetido ele incrementa)
@return string, código novo
/*/
static function GetCodSUS(cCodSus)

	Local aAreaSUS	:= SUS->(GetArea())
	Local cCodNovo  := cCodSus

	SUS->(dbsetorder(1))
	while SUS->(dbseek(xFilial("SUS") + cCodNovo))

		cCodNovo := soma1(cCodNovo)
	enddo
	RestArea(aAreaSUS)

return cCodNovo
