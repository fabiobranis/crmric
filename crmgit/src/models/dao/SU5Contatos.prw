#include 'protheus.ch'

/*/{Protheus.doc} SU5Contatos
(long_description)
@author fabiobranis
@since 24/04/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class SU5Contatos 


	data filial
	data codcont
	data contat
	data cpf
	data email
	data nivel
	data sexo
	data niver
	data autoriz
	data civil
	data conjuge
	data filhos
	data nomef
	data ativo
	data funcao
	data status
	data cliente
	data loja
	data prospec
	data pais
	data trata
	data natural
	data timefut
	data animal
	data nomeani
	data url
	data xurl1
	data xurl2
	data xurl3
	data obs

	// atributos ded associação simples com os objetos que irão compor os contatos
	data aTelContatos
	data aEndContatos

	method new(codcont) constructor 
	method setProperties(codcont)

	// adiciona os contatos
	method aaddEndCont(oAGAEndCont)
	method aaddTelCont(oAGBTelCont)
	method getEndPos(cCodEnd,cEntida,cCodEnt,cTipo) 
	method getTelPos(cCodTel,cEntida,cCodEnt,cTipo) 
	method altEndByPos(nPosEnd,oAGAEndCont) 
	method altTelByPos(nPosTel,oAGBTelCont) 

	// retornam uma coleção dos objetos - array
	method getEndCont()
	method getTelCont()

	method save()
	method delReg() 

endclass



/*/{Protheus.doc} new
Metodo construtor
@author fabiobranis
@since 24/04/2016 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method new(codcont,lIsList) class SU5Contatos

	default codcont := GetCodSU5(GetSxeNum("SU5","U5_CODCONT"))
	default lIsList	:= .F.

	::aTelContatos := {}
	::aEndContatos := {}
	::filial 	:= xFilial("SU5")

	if !::setProperties(codcont,lIsList)
		::codcont	:= codcont
		::contat	:= ""	
		::cpf		:= ""
		::email		:= ""
		::nivel		:= ""
		::sexo		:= ""
		::niver		:= ctod("")
		::civil		:= ""
		::conjuge	:= ""
		::filhos	:= 0
		::nomef		:= ""
		::funcao	:= ""
		::status	:= "1"
		::cliente	:= ""
		::loja		:= ""
		::prospec	:= ""
		::pais		:= ""
		::trata		:= ""
		::natural	:= ""
		::timefut	:= ""
		::animal	:= ""
		::nomeani	:= ""
		::url		:= ""
		::xurl1		:= ""
		::xurl2		:= ""
		::xurl3		:= ""
		::autoriz	:= "1"
		::ativo		:= "1"
		::obs		:= ""
	endif

return ::self

method setProperties(codcont,lIsList) class SU5Contatos

	Local oAux	:= nil

	SU5->(dbsetorder(1))
	AGA->(dbsetorder(1))
	AGB->(dbsetorder(1))

	if SU5->(dbseek(xFilial("SU5") + codcont))

		::codcont 	:= SU5->U5_CODCONT
		::contat	:= SU5->U5_CONTAT	
		::cpf		:= SU5->U5_CPF
		::email		:= SU5->U5_EMAIL
		::nivel		:= SU5->U5_NIVEL
		::sexo		:= SU5->U5_SEXO
		::niver		:= SU5->U5_NIVER
		::civil		:= SU5->U5_CIVIL
		::conjuge	:= SU5->U5_CONJUGE
		::filhos	:= SU5->U5_FILHOS
		::nomef		:= SU5->U5_NOMEF
		::funcao	:= SU5->U5_FUNCAO
		::status	:= SU5->U5_STATUS
		::cliente	:= SU5->U5_CLIENTE
		::loja		:= SU5->U5_LOJA
		::prospec	:= SU5->U5_PROSPEC
		::pais		:= SU5->U5_PAIS
		::trata		:= SU5->U5_TRATA
		::natural	:= SU5->U5_NATURAL
		::timefut	:= SU5->U5_TIMEFUT
		::animal	:= SU5->U5_ANIMAL
		::nomeani	:= SU5->U5_NOMEANI
		::url		:= SU5->U5_URL
		::xurl1		:= SU5->U5_XURL1
		::xurl2		:= SU5->U5_XURL2
		::xurl3		:= SU5->U5_XURL3
		::autoriz	:= SU5->U5_AUTORIZ
		::ativo		:= SU5->U5_ATIVO
		::obs		:= SU5->U5_OBS

		/*if !(lIsList)
		if AGA->(dbseek(xFilial("AGA") + "SU5" + codcont))
		while AGA->(!eof()) .and. alltrim(xFilial("AGA") + "SU5" + codcont) == alltrim(AGA->(AGA_FILIAL + AGA_ENTIDA + AGA_CODENT))
		oAux := nil
		oAux := AGAEnderecos():new(codcont,AGA->AGA_CODIGO)
		::aaddEndCont(oAux)
		AGA->(dbskip())
		enddo
		endif

		if AGB->(dbseek(xFilial("AGB") + "SU5" + codcont))
		while AGB->(!eof()) .and. alltrim(xFilial("AGB") + "SU5" + codcont) == alltrim(AGB->(AGB_FILIAL + AGB_ENTIDA + AGB_CODENT))
		oAux := nil
		oAux := AGBTelefones():new(codcont,AGB->AGB_CODIGO)
		::aaddTelCont(oAux)
		AGB->(dbskip())
		enddo
		endif
		endif*/
		if AGA->(dbseek(xFilial("AGA") + "SU5" + codcont))
			while AGA->(!eof()) .and. alltrim(xFilial("AGA") + "SU5" + codcont) == alltrim(AGA->(AGA_FILIAL + AGA_ENTIDA + AGA_CODENT))
				oAux := nil
				oAux := AGAEnderecos():new(codcont,AGA->AGA_CODIGO)
				::aaddEndCont(oAux)
				AGA->(dbskip())
			enddo
		endif

		if AGB->(dbseek(xFilial("AGB") + "SU5" + codcont))
			while AGB->(!eof()) .and. alltrim(xFilial("AGB") + "SU5" + codcont) == alltrim(AGB->(AGB_FILIAL + AGB_ENTIDA + AGB_CODENT))
				oAux := nil
				oAux := AGBTelefones():new(codcont,AGB->AGB_CODIGO)
				::aaddTelCont(oAux)
				AGB->(dbskip())
			enddo
		endif
		return .T.
	endif

return .F.

method save() class SU5Contatos

	Local aContato := {}
	Local aEndereco := {}
	Local aTelefone := {}
	Local aAuxDados := {}
	Local nOpc			:= 0
	Local aErroRot		:= {}
	Local ni			:= 0
	local cCodPais		:= ""
	Local cStrErro		:= ""
	Private lMsErroAuto	:= .F.
	Private lMsHelpAuto	:= .T.
	Private lAutoErrNoFile	:= .T.

	SU5->(dbsetorder(1))
	AGA->(dbsetorder(1))
	AGB->(dbsetorder(1))
	// se achar o registro - atualiza
	nOpc := iif(SU5->(dbseek(xFilial("SU5") + ::codcont )),4,3)


	aadd(aContato,{"U5_FILIAL", ::filial,Nil})
	aadd(aContato,{"U5_CODCONT",::codcont, Nil})
	aadd(aContato,{"U5_CONTAT",::contat, Nil})
	aadd(aContato,{"U5_CPF",::cpf, Nil})
	aadd(aContato,{"U5_NIVEL",::nivel, Nil})
	aadd(aContato,{"U5_SEXO",::sexo, Nil})
	aadd(aContato,{"U5_NIVER",::niver, Nil})
	aadd(aContato,{"U5_CIVIL",::civil, Nil})
	aadd(aContato,{"U5_CONJUGE",::conjuge, Nil})
	aadd(aContato,{"U5_FILHOS",::filhos, Nil})
	aadd(aContato,{"U5_NOMEF",::nomef, Nil})
	aadd(aContato,{"U5_FUNCAO",::funcao, Nil})
	aadd(aContato,{"U5_STATUS",::status, Nil})
	aadd(aContato,{"U5_CLIENTE",::cliente, Nil})
	aadd(aContato,{"U5_LOJA",::loja, Nil})
	aadd(aContato,{"U5_PROSPEC",::prospec, Nil})
	//aadd(aContato,{"U5_PAIS",::pais, Nil})
	aadd(aContato,{"U5_TRATA",::trata, Nil})
	aadd(aContato,{"U5_NATURAL",::natural, Nil})
	aadd(aContato,{"U5_TIMEFUT",::timefut, Nil})
	aadd(aContato,{"U5_EMAIL",::email, Nil})
	aadd(aContato,{"U5_ANIMAL",::animal, Nil})
	aadd(aContato,{"U5_NOMEANI",::nomeani, Nil})
	aadd(aContato,{"U5_URL",::url, Nil})
	aadd(aContato,{"U5_XURL1",::xurl1, Nil})
	aadd(aContato,{"U5_XURL2",::xurl2, Nil})
	aadd(aContato,{"U5_XURL3",::xurl3, Nil})
	aadd(aContato,{"U5_AUTORIZ",::autoriz, Nil})
	aadd(aContato,{"U5_ATIVO",::ativo, Nil})
	aadd(aContato,{"U5_OBS",::obs, Nil})

	for ni := 1 to len(::aEndContatos)
		aAuxDados := {}
		if ::aEndContatos[ni]:padrao == "1"
			cCodPais := ::aEndContatos[ni]:pais
		endif
		//aadd(aAuxDados,{"AGA_CODIGO", ::aEndContatos[ni]:codigo, Nil})
		aadd(aAuxDados, {"AGA_ENTIDA", ::aEndContatos[ni]:entida, Nil})
		aadd(aAuxDados, {"AGA_CODENT", ::aEndContatos[ni]:codent, Nil})
		aadd(aAuxDados, {"AGA_TIPO", ::aEndContatos[ni]:tipo, Nil})
		aadd(aAuxDados, {"AGA_PADRAO", ::aEndContatos[ni]:padrao, Nil})
		aadd(aAuxDados, {"AGA_END", ::aEndContatos[ni]:ender	, Nil})
		aadd(aAuxDados, {"AGA_CEP", ::aEndContatos[ni]:cep, Nil})
		aadd(aAuxDados, {"AGA_BAIRRO", ::aEndContatos[ni]:bairro, Nil})
		aadd(aAuxDados, {"AGA_EST", ::aEndContatos[ni]:est, Nil})
		aadd(aAuxDados, {"AGA_MUN", ::aEndContatos[ni]:mun, Nil})
		aadd(aAuxDados, {"AGA_MUNDES", ::aEndContatos[ni]:mundes, Nil})
		aadd(aAuxDados, {"AGA_PAIS", ::aEndContatos[ni]:pais, Nil})
		aadd(aAuxDados, {"AGA_COMP", ::aEndContatos[ni]:comp, Nil})

		if AGA->(dbseek(xFilial("AGA") + padr(::aEndContatos[ni]:entida,TamSx3("AGA_ENTIDA")[1],"") + padr(::codcont,TamSx3("AGA_CODENT")[1],""))) .and. !empty(::aEndContatos[ni]:codigo)
			while AGA->(!(eof())) .and. AGA->(AGA_FILIAL + AGA_ENTIDA + AGA_CODENT) == xFilial("AGA") + padr(::aEndContatos[ni]:entida,TamSx3("AGA_ENTIDA")[1],"") + padr(::codcont,TamSx3("AGA_CODENT")[1],"")
				if alltrim(AGA->AGA_CODIGO) == alltrim(::aEndContatos[ni]:codigo)
					aadd(aAuxDados,{"AGA_CODIGO", ::aEndContatos[ni]:codigo, Nil})
					aadd(aAuxDados,{"AGA_REC_WT",AGA->(recno()),nil})
				endif
				AGA->(dbskip())
			enddo
		endif

		if ::aEndContatos[ni]:deleta
			aadd(aAuxDados,{"AUTDELETA","S",nil})
		endif

		aadd(aEndereco, aAuxDados)
	next

	for ni := 1 to len(::aTelContatos)
		aAuxDados := {}
		//aadd(aAuxDados,{"AGB_CODIGO", ::aTelContatos[ni]:codigo, Nil})
		aadd(aAuxDados, {"AGB_ENTIDA", ::aTelContatos[ni]:entida, Nil})
		aadd(aAuxDados, {"AGB_CODENT", ::aTelContatos[ni]:codent, Nil})
		aadd(aAuxDados, {"AGB_TIPO", ::aTelContatos[ni]:tipo, Nil})
		aadd(aAuxDados, {"AGB_PADRAO", ::aTelContatos[ni]:padrao, Nil})
		aadd(aAuxDados, {"AGB_DDD", ::aTelContatos[ni]:ddd, Nil})
		aadd(aAuxDados, {"AGB_TELEFO", ::aTelContatos[ni]:telefo, Nil})
		aadd(aAuxDados, {"AGB_COMP", ::aTelContatos[ni]:comp, Nil})

		if AGB->(dbseek(xFilial("AGB") + padr(::aTelContatos[ni]:entida,TamSx3("AGB_ENTIDA")[1],"") + padr(::codcont,TamSx3("AGB_CODENT")[1],""))) .and. !empty(::aTelContatos[ni]:codigo)
			while AGB->(!(eof())) .and. AGB->(AGB_FILIAL + AGB_ENTIDA + AGB_CODENT) == xFilial("AGB") + padr(::aTelContatos[ni]:entida,TamSx3("AGB_ENTIDA")[1],"") + padr(::codcont,TamSx3("AGB_CODENT")[1],"")
				if alltrim(AGB->AGB_CODIGO) == alltrim(::aTelContatos[ni]:codigo)
					aadd(aAuxDados,{"AGB_CODIGO", ::aTelContatos[ni]:codigo, Nil})
					aadd(aAuxDados,{"AGB_REC_WT",AGB->(recno()),nil})
				endif
				AGB->(dbskip())
			enddo
		endif

		if ::aTelContatos[ni]:deleta
			aadd(aAuxDados,{"AUTDELETA","S",nil})
		endif
		aadd(aTelefone, aAuxDados)

	next

	AGA->(dbsetorder(1))
	AGB->(dbsetorder(1))
	BeginTran()

	MSExecAuto({|x,y,z,a,b|TMKA070(x,y,z,a,b)},aContato,nOpc,aEndereco,aTelefone, .T.) //3- Inclusão, 4- Alteração, 5- ExclA1ão 
	if lMsErroAuto
		aErroRot := GetAutoGRLog()
		for ni := 1 to len(aErroRot)
			cStrErro += aErroRot[ni]
		next
		DisarmTransaction()
	else
		RecLock("SU5",.F.)
		SU5->U5_CODPAIS := cCodPais
		MsUnlock("SU5")
	endif
	EndTran()

return cStrErro

method delReg() class SU5Contatos

	Local aVetor := {}
	Local aErroRot		:= {}
	Local ni			:= 0
	Local cStrErro		:= ""
	Private lMsErroAuto	:= .F.
	Private lMsHelpAuto	:= .T.
	Private lAutoErrNoFile	:= .T.

	SU5->(dbsetorder(1))

	aVetor:={	{"U5_CODCONT" ,::codcont ,Nil},;
	{"U5_CONTAT" ,::contat ,Nil},;
	{"U5_EMAIL" ,::email ,Nil},;
	{"U5_NIVER" ,::niver ,Nil}}
	AGA->(dbsetorder(1))
	AGB->(dbsetorder(1))
	BeginTran()
	if SU5->(dbseek(xFilial("SU5") + ::codcont ))
		MSExecAuto({|x,y,z,a,b|TMKA070(x,y,z,a,b)},aVetor,5,{},{}, .F.) //3- Inclusão, 4- Alteração, 5- Exclusão
	else
		cStrErro := "Contato não encontrado para exclusão"
	endif

	if lMsErroAuto
		aErroRot := GetAutoGRLog()
		for ni := 1 to len(aErroRot)
			cStrErro += aErroRot[ni]
		next
		DisarmTransaction()
	endif
	EndTran()
return cStrErro

method aaddEndCont(oAGAEndCont) class SU5Contatos
	aadd(::aEndContatos,oAGAEndCont)
return
method aaddTelCont(oAGBTelCont) class SU5Contatos
	aadd(::aTelContatos,oAGBTelCont)
return

method getEndCont() class SU5Contatos
return ::aEndContatos

method getTelCont() class SU5Contatos
return ::aTelContatos

method getEndPos(cCodEnd,cEntida,cCodEnt,cTipo) class SU5Contatos

	Local nPosRet	:= 0
	Local ni		:= 0

	for ni := 1 to len(::aEndContatos)
		if alltrim(::aEndContatos[ni]:codigo) == alltrim(cCodEnd) .and. alltrim(::aEndContatos[ni]:entida) == alltrim(cEntida) .and. alltrim(::aEndContatos[ni]:codent) == alltrim(cCodEnt) .and. alltrim(::aEndContatos[ni]:tipo) == alltrim(cTipo) 
			nPosRet := ni
		endif
	next

return nPosRet

method getTelPos(cCodTel,cEntida,cCodEnt,cTipo) class SU5Contatos

	Local nPosRet	:= 0
	Local ni		:= 0

	for ni := 1 to len(::aTelContatos)
		if alltrim(::aTelContatos[ni]:codigo) == alltrim(cCodTel) .and. alltrim(::aTelContatos[ni]:entida) == alltrim(cEntida) .and. alltrim(::aTelContatos[ni]:codent) == alltrim(cCodEnt) .and. alltrim(::aTelContatos[ni]:tipo) == alltrim(cTipo)
			nPosRet := ni
		endif
	next

return nPosRet

method altEndByPos(nPosEnd,oAGAEndCont) class SU5Contatos

	if nPosEnd <= 0
		return .F.
	endif

	::aEndContatos[nPosEnd] := oAGAEndCont

return .T.

method altTelByPos(nPosTel,oAGBTelCont) class SU5Contatos

	if nPosTel <= 0
		return .F.
	endif

	::aTelContatos[nPosTel] := oAGBTelCont

return .T.

static function GetCodSU5(cCodSu5)

	Local aAreaSU5	:= SU5->(GetArea())
	Local cCodNovo  := cCodSu5

	SU5->(dbsetorder(1))
	while SU5->(dbseek(xFilial("SU5") + cCodNovo))

		cCodNovo := soma1(cCodNovo)
	enddo
	RestArea(aAreaSU5)

return cCodNovo