#include 'protheus.ch'

/*/{Protheus.doc} CRMContatoSite
(long_description)
@author fabio
@since 13/06/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMContatoSite 

	data erroAuto
	data attr
	data nFilteredRegs
	data nTotRegs
	
	method new() constructor 
	method valJson(cJson)
	method setCabFromJson(oJson,oContatoCab)
	method setEndFromJson(oJson,oEndContato)
	method setTelFromJson(oJson,oTelContato)
	method valCabec(oContatoCab)
	method valEnd(oEndContato,nLin)
	method valTel(oTelContato,nLin)
	method isInclui(oContato)
	method valExclui(oContato)
	method valVinculo(oContato)
	method save(oContato)
	method delReg(oContato)
	method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection)

endclass

/*/{Protheus.doc} new
Metodo construtor
@author fabio
@since 13/06/2016 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method new() class CRMContatoSite

	::attr 		:= {}
	::erroAuto 	:= ""
	::nFilteredRegs := 0
	::nTotRegs	:= 0
return self

method valJson(cJson) class CRMContatoSite
	
	Local ni		:= 0
	Local aAttrMand	:= {"contat","cpf","ender","email","niver","bairro"}
	
	// percorro o array de atributos mandatórios
	for ni := 1 to len(aAttrMand)

		if !(aAttrMand[ni] $ cJson)
			::erroAuto := "Atributo "+aAttrMand[ni]+ " é mandatório"
			return .F.
		endif
	next

return .T.

method setCabFromJson(oJson,oContatoCab) class CRMContatoSite
	
	if AttIsMemberOf(oJson,"contat")
		oContatoCab:contat := oJson:contat
	endif
	
	if AttIsMemberOf(oJson,"cpf")
		oContatoCab:cpf := oJson:cpf
	endif
	
	if AttIsMemberOf(oJson,"email")
		oContatoCab:email := oJson:email
	endif
	
	if AttIsMemberOf(oJson,"nivel")
		oContatoCab:nivel := oJson:nivel
	endif
	
	if AttIsMemberOf(oJson,"sexo")
		oContatoCab:sexo := oJson:sexo
	endif
	
	if AttIsMemberOf(oJson,"niver")
		oContatoCab:niver := ctod(oJson:niver)
	endif
	
	if AttIsMemberOf(oJson,"autoriz")
		oContatoCab:autoriz := oJson:autoriz
	endif
	
	if AttIsMemberOf(oJson,"civil")
		oContatoCab:civil := oJson:civil
	endif
	
	if AttIsMemberOf(oJson,"conjuge")
		oContatoCab:conjuge := oJson:conjuge
	endif
	
	if AttIsMemberOf(oJson,"filhos")
		oContatoCab:filhos := oJson:filhos
	endif
	
	if AttIsMemberOf(oJson,"nomef")
		oContatoCab:nomef := oJson:nomef
	endif
	
	if AttIsMemberOf(oJson,"ativo")
		oContatoCab:ativo := oJson:ativo
	endif
	
	if AttIsMemberOf(oJson,"funcao")
		oContatoCab:funcao := oJson:funcao
	endif
	
	if AttIsMemberOf(oJson,"status")
		oContatoCab:status := oJson:status
	endif
	
	if AttIsMemberOf(oJson,"pais")
		oContatoCab:pais := oJson:pais
	endif
	
	if AttIsMemberOf(oJson,"trata")
		oContatoCab:trata := oJson:trata
	endif
	
	if AttIsMemberOf(oJson,"natural")
		oContatoCab:natural := oJson:natural
	endif
	
	if AttIsMemberOf(oJson,"timefut")
		oContatoCab:timefut := oJson:timefut
	endif
	
	if AttIsMemberOf(oJson,"animal")
		oContatoCab:animal := oJson:animal
	endif
	
	if AttIsMemberOf(oJson,"nomeani")
		oContatoCab:nomeani := oJson:nomeani
	endif
	
	if AttIsMemberOf(oJson,"url")
		oContatoCab:url := oJson:url
	endif
	
	if AttIsMemberOf(oJson,"xurl1")
		oContatoCab:xurl1 := oJson:xurl1
	endif
	
	if AttIsMemberOf(oJson,"xurl2")
		oContatoCab:xurl2 := oJson:xurl2
	endif
	
	if AttIsMemberOf(oJson,"xurl3")
		oContatoCab:xurl3 := oJson:xurl3
	endif
	
	if AttIsMemberOf(oJson,"obs")
		oContatoCab:obs := oJson:obs
	endif
	
return
method setEndFromJson(oJson,oEndContato) class CRMContatoSite

	if AttIsMemberOf(oJson,"tipo")
		oEndContato:tipo := oJson:tipo
	endif
	
	if AttIsMemberOf(oJson,"padrao")
		oEndContato:padrao := oJson:padrao
	endif
	
	if AttIsMemberOf(oJson,"ender")
		oEndContato:ender := oJson:ender
	endif
	
	if AttIsMemberOf(oJson,"cep")
		oEndContato:cep := oJson:cep
	endif
	
	if AttIsMemberOf(oJson,"bairro")
		oEndContato:bairro := oJson:bairro
	endif
	
	if AttIsMemberOf(oJson,"est")
		oEndContato:est := oJson:est
	endif
	
	if AttIsMemberOf(oJson,"mun")
		oEndContato:mun := oJson:mun
	endif
	
	if AttIsMemberOf(oJson,"mun")
		oEndContato:mun := oJson:mun
		
		CC2->(dbsetorder(1))
		if CC2->(dbseek(xFilial("CC2") + oEndContato:est + oEndContato:mun))
			oEndContato:mundes	:= CC2->CC2_MUN
		endif
	endif
	
	if AttIsMemberOf(oJson,"pais")
		oEndContato:pais := oJson:pais
	endif
	
	if AttIsMemberOf(oJson,"comp")
		oEndContato:comp := oJson:comp
	endif

return
method setTelFromJson(oJson,oTelContato) class CRMContatoSite
	
	if AttIsMemberOf(oJson,"tipo")
		oTelContato:tipo := oJson:tipo
	endif
	
	if AttIsMemberOf(oJson,"padrao")
		oTelContato:padrao := oJson:padrao
	endif
	
	if AttIsMemberOf(oJson,"ddd")
		oTelContato:ddd := oJson:ddd
	endif
	
	if AttIsMemberOf(oJson,"telefo")
		oTelContato:telefo := oJson:telefo
	endif
	
	if AttIsMemberOf(oJson,"comp")
		oTelContato:comp := oJson:comp
	endif
	
return
method valCabec(oContatoCab) class CRMContatoSite
	
	Local aAreaSU5	:= SU5->(GetArea())
	
	if empty(oContatoCab:contat)
		::erroAuto := "Nome do contato deve ser preenchido"
		return .F.
	endif
	
	if !(empty(oContatoCab:cpf))
		if !(Cgc(oContatoCab:cpf))
			::erroAuto := "CPF do contato inválido"
			return .F.
		endif
		
		SU5->(dbsetorder(8))
		if SU5->(dbseek(xFilial("SU5") + oContatoCab:cpf)) .and. (::isInclui(oContatoCab))
			::erroAuto := "CPF já cadastrado no sistema"
			return .F.
		endif
	endif
	
	if !(empty(oContatoCab:nivel))
		SX5->(dbsetorder(1))
		if !(SX5->(dbseek(xFilial("SX5") + "T6" + oContatoCab:nivel))) 
			::erroAuto := "Cargo não cadastrado no sistema, verifique a consulta de cargos"
			return .F.
		endif
	endif
	
	if empty(oContatoCab:funcao)
		if !(ExistCpo("SUM",oContatoCab:funcao))		
			::erroAuto := "Função não cadastrada no sistema, verifique a consulta de funções"
			return .F.
		endif
	endif
	
	if !(empty(oContatoCab:trata))
		SX5->(dbsetorder(1))
		if !(SX5->(dbseek(xFilial("SX5") + "AX" + oContatoCab:trata))) 
			::erroAuto := "Forma de tratamento não cadastrado no sistema, verifique a consulta de tratamentos"
			return .F.
		endif
	endif
	
	if empty(oContatoCab:animal)
		if !(ExistCpo("ZA2",oContatoCab:animal))		
			::erroAuto := "Tipo de animal não cadastrado no sistema, verifique a consulta de tipos de animais"
			return .F.
		endif
	endif
	
	RestArea(aAreaSU5)
	
return .T.
method valEnd(oEndContato,nLin) class CRMContatoSite
	
	if empty(oEndContato:tipo)
		::erroAuto := "Tipo do endereço deve ser preenchido. Linha " + cValToChar(nLin)
		return .F.
	endif
	
	if empty(oEndContato:padrao)
		::erroAuto := "Definição de endereço padrão deve ser preenchida. Linha " + cValToChar(nLin)
		return .F.
	endif
	
	SX5->(dbsetorder(1))
	if !SX5->(dbseek(xFilial("SX5") + "12" + oEndContato:est))
		::erroAuto := "UF informada inválida. Linha " + cValToChar(nLin)
		return .F.
	endif
	
	if !ExistCpo("CC2",oEndContato:est + oEndContato:mun,1)
		::erroAuto := "Código de município inválido"
		return .F.
	endif
	
	if !ExistCpo("SYA",oEndContato:pais,1)
		::erroAuto := "Código de país inválido"
		return .F.
	endif
	
return .T.
method valTel(oTelContato,nLin) class CRMContatoSite

	if empty(oTelContato:tipo)
		::erroAuto := "Tipo do telefone deve ser preenchido. Linha " + cValToChar(nLin)
		return .F.
	endif
	
	if empty(oTelContato:padrao)
		::erroAuto := "Definição de telefone padrão deve ser preenchida. Linha " + cValToChar(nLin)
		return .F.
	endif

return .T.

/*/{Protheus.doc} isInclui
Verifica através de uma busca no banco de dados se é inclusão de registros
@author Fabio
@since 01/06/2016
@version undefined
@param oContato, object, Objeto DAO
@return boolena, se é inclusão = .T.
/*/
method isInclui(oContato) class CRMContatoSite
	
	Local aAreaSU5	:= SU5->(GetArea())
	Local lRet		:= .T.
	
	SU5->(dbsetorder(1))
	lRet := !SU5->(dbseek(xFilial("SU5") + padr(oContato:codcont,TamSx3("U5_CODCONT")[1],"")))
	
	RestArea(aAreaSU5)
	
return lRet

/*/{Protheus.doc} valExclui
Valida se pode excluir o contato
@author Fabio
@since 01/06/2016
@version undefined
@param oContato, object, Objeto DAO
@return boolena, se puder excluir = .T.
/*/
method valExclui(oContato) class CRMContatoSite
	
	Local aAreaAC8	:= AC8->(GetArea())
	Local lRet		:= .T.
	
	// verifica se o contato está vinculado a um cliente
	AC8->(dbsetorder(1))
	lRet := !AC8->(dbseek(xFilial("AC8") + oContato:codcont))
	RestArea(aAreaAC8)
	
	if !lRet
		::erroAuto := "Contato não pode ser excluído. Tem vínculo com cliente"
		return .F.
	endif
	
return .T.

/*/{Protheus.doc} valExclui
Valida se pode excluir o contato
@author Fabio
@since 01/06/2016
@version undefined
@param oContato, object, Objeto DAO
@return boolena, se puder excluir = .T.
/*/
method valVinculo(oContato) class CRMContatoSite
	
	Local aAreaAC8	:= AC8->(GetArea())
	Local lRet		:= .T.
	
	// verifica se o contato está vinculado a um cliente
	AC8->(dbsetorder(1))
	lRet := !AC8->(dbseek(xFilial("AC8") + oContato:codcont))
	RestArea(aAreaAC8)
	
	if !lRet
		::erroAuto := "Contato já tem vínculo com cliente"
		return .F.
	endif
	
return .T.


method save(oContato) class CRMContatoSite
	::erroAuto := oContato:save() 
return empty(::erroAuto)
method delReg(oContato) class CRMContatoSite
	::erroAuto := oContato:delReg()
return empty(::erroAuto)

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class CRMContatoSite

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"U5_CODCONT", "U5_CONTAT", "U5_CPF","U5_EST","U5_MUN","U5_FONE","U5_EMAIL"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"codcont")
		cWhere += "AND U5_CODCONT LIKE '%" + oJsonParam:codcont + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"contat")
		cWhere += "AND U5_CONTAT LIKE '%" + oJsonParam:contat + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"cpf")
		cWhere += "AND U5_CPF LIKE '%" + oJsonParam:cpf + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"est")
		cWhere += "AND U5_EST LIKE '%" + oJsonParam:est + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"mun")
		cWhere += "AND U5_MUN LIKE '%" + oJsonParam:mun + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"fone")
		cWhere += "AND U5_FONE LIKE '%" + oJsonParam:fone + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"email")
		cWhere += "AND U5_EMAIL LIKE '%" + oJsonParam:email + "%' "
	endif
	
	cQuery +=  " SELECT "
	cQuery +=  " (SELECT COUNT(*) FROM "+ RetSqlName("SU5") +"  TOT WHERE TOT.U5_FILIAL = '" + xFilial("SU5") + "' AND TOT.D_E_L_E_T_ = '') AS TOT_RECS, "
	cQuery +=  " (SELECT COUNT(*) FROM "+ RetSqlName("SU5") +"  TOT WHERE TOT.U5_FILIAL = '" + xFilial("SU5") +"' " + cWhere + " AND TOT.D_E_L_E_T_ = '') AS TOT_FILTER, "
	cQuery +=  " U5_CODCONT, U5_CONTAT, U5_CPF FROM "+ RetSqlName("SU5") +" SU5 "
	cQuery +=  "WHERE SU5.D_E_L_E_T_ = '' "
	cQuery +=  " AND U5_FILIAL = '" + xFilial("SU5") + "' "
	cQUery += cWhere
	cQuery +=  "ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  "OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  "FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)

	(cAliQry)->(dbgotop())
	::nTotRegs		:= (cAliQry)->TOT_RECS
	::nFilteredRegs := (cAliQry)->TOT_FILTER
	while (cAliQry)->(!(eof()))

		aadd(aRet,SU5Contatos():New((cAliQry)->U5_CODCONT,.T.))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet