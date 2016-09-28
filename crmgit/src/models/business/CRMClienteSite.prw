#include 'protheus.ch'

/*/{Protheus.doc} CRMClienteSite
Classe com as lógicas de negócio da camada model.
Esta classe não persiste os dados, ela só prepara para a chamada do modelo DAO que por sua vez irá chamar a rotina automática
@author Fabio
@since 07/05/2016
@version 1.0
/*/
class CRMClienteSite 
	
	data erroAuto
	data attr
	data nFilteredRegs
	data nTotRegs
	
	method new() constructor 
	method valJson(cJson) 
	method setFromJson(oJson,oCli) 
	method valCli(oCli)
	method isInclui(oCli)
	method save(oCli)
	method delReg(oCli)
	method setFromProsp(oProspect,oJson,oCli)
	method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection)

endclass

/*/{Protheus.doc} new
Metodo construtor
@author Fabio
@since 07/05/2016 
@version 1.0
/*/
method new() class CRMClienteSite
	
	::attr 		:= {}
	::erroAuto 	:= ""
	::nFilteredRegs := 0
	::nTotRegs	:= 0
	
return self


/*/{Protheus.doc} valJson
Método que valida a string json parseada no controller (rota)
@author Fabio
@since 22/05/2016
@version undefined
@param cJson, String, Json da requisição
@param oCli, object, Objeto DAO do cliente (SA1)
/*/
method valJson(cJson,oCli) class CRMClienteSite

	Local ni		:= 0
	Local aAttrMand	:= {"nome","nreduz","tipo","ender","cod_mun","est","bairro","cep","ddd","tel","email","cgc","inscr","pais","codpais","pessoa"}
	
	// percorro o array de atributos mandatórios
	for ni := 1 to len(aAttrMand)

		if !(aAttrMand[ni] $ cJson)
			::erroAuto := "Atributo "+aAttrMand[ni]+ " é mandatório"
			return .F.
		endif
	next

return .T.



method setFromJson(oJson,oCli) class CRMClienteSite

	if AttIsMemberOf(oJson,"nome")
		oCli:nome := oJson:nome
	endif

	if AttIsMemberOf(oJson,"nreduz")
		oCli:nreduz := oJson:nreduz
	endif
	
	if AttIsMemberOf(oJson,"pessoa")
		oCli:pessoa := oJson:pessoa
	endif
	
	if AttIsMemberOf(oJson,"tipo")
		oCli:tipo := oJson:tipo
	endif
	
	if AttIsMemberOf(oJson,"ender")
		oCli:ender := oJson:ender
	endif
	
	if AttIsMemberOf(oJson,"xcomple")
		oCli:xcomple := oJson:xcomple
	endif
	
	if AttIsMemberOf(oJson,"est")
		oCli:est := oJson:est
	endif
	
	if AttIsMemberOf(oJson,"cod_mun")
		oCli:cod_mun := oJson:cod_mun
		
		CC2->(dbsetorder(1))
		if CC2->(dbseek(xFilial("CC2") + oCli:est + oCli:cod_mun))
			oCli:mun	:= CC2->CC2_MUN
		endif
	endif
	
	if AttIsMemberOf(oJson,"bairro")
		oCli:bairro := oJson:bairro
	endif

	if AttIsMemberOf(oJson,"cep")
		oCli:cep := oJson:cep
	endif
	
	if AttIsMemberOf(oJson,"codpais")
		oCli:codpais := oJson:codpais
	endif
	
	if AttIsMemberOf(oJson,"pais")
		oCli:pais := oJson:pais
	endif
	
	if AttIsMemberOf(oJson,"ddi")
		oCli:ddi := oJson:ddi
	endif
	
	if AttIsMemberOf(oJson,"ddd")
		oCli:ddd := oJson:ddd
	endif
	
	if AttIsMemberOf(oJson,"tel")
		oCli:tel := oJson:tel
	endif
	
	if AttIsMemberOf(oJson,"fax")
		oCli:fax := oJson:fax
	endif
	
	if AttIsMemberOf(oJson,"tpessoa")
		oCli:tpessoa := oJson:tpessoa
	endif
	
	if AttIsMemberOf(oJson,"email")
		oCli:email := oJson:email
	endif
	
	if AttIsMemberOf(oJson,"vend")
		oCli:vend := oJson:vend
	endif
	
	if AttIsMemberOf(oJson,"cgc")
		oCli:cgc := oJson:cgc
		oCli:cod := iif(len(alltrim(oCli:cgc))==14,"0" + substr(oCli:cgc,1,8),substr(oCli:cgc,1,9))
		oCli:loja := iif(len(alltrim(oCli:cgc))==14,substr(oCli:cgc,9,4),"0000")      
		oCli:pessoa := iif(len(alltrim(oCli:cgc))==14,"J","F")                                     
	endif

	if AttIsMemberOf(oJson,"inscr")
		oCli:inscr := oJson:inscr
	endif
	
	/*if AttIsMemberOf(oJson,"url")
		oCli:url := oJson:url
	endif*/
	
	if AttIsMemberOf(oJson,"naturez")
		oCli:naturez := oJson:naturez
	endif
	
	if AttIsMemberOf(oJson,"xagenci")
		oCli:xagenci := oJson:xagenci
		/*SA3->(dbsetorder(1))
		if SA3->(dbseek(xFilial("SA3") + oCli:xagenci))
			oCli:xdesage := SA3->A3_NOME
		endif*/
	endif
	
	if AttIsMemberOf(oJson,"xdesage")
		oCli:xdesage := oJson:xdesage
		/*SA3->(dbsetorder(1))
		if SA3->(dbseek(xFilial("SA3") + oCli:xagenci))
			oCli:xdesage := SA3->A3_NOME
		endif*/
	endif
	
	if AttIsMemberOf(oJson,"xurl1")
		oCli:xurl1 := oJson:xurl1
	endif
	
	if AttIsMemberOf(oJson,"xurl2")
		oCli:xurl2 := oJson:xurl2
	endif
	
	if AttIsMemberOf(oJson,"xurl3")
		oCli:xurl3 := oJson:xurl3
	endif

	if AttIsMemberOf(oJson,"xdescr1")
		oCli:xdescr1 := oJson:xdescr1
	endif
	
	if AttIsMemberOf(oJson,"xvend1")
		oCli:xvend1 := oJson:xvend1
	endif
	
	if AttIsMemberOf(oJson,"xdescr1")
		oCli:xdescr1 := oJson:xdescr1
	endif
	
	if AttIsMemberOf(oJson,"xvend1")
		oCli:xvend1 := oJson:xvend1
	endif
	
	if AttIsMemberOf(oJson,"xdescr2")
		oCli:xdescr2 := oJson:xdescr2
	endif
	
	if AttIsMemberOf(oJson,"xvend2")
		oCli:xvend2 := oJson:xvend2
	endif
	
	if AttIsMemberOf(oJson,"xdescr3")
		oCli:xdescr3 := oJson:xdescr3
	endif
	
	if AttIsMemberOf(oJson,"xvend3")
		oCli:xvend3 := oJson:xvend3
	endif
	
	if AttIsMemberOf(oJson,"xdescr4")
		oCli:xdescr4 := oJson:xdescr4
	endif
	
	if AttIsMemberOf(oJson,"xvend4")
		oCli:xvend4 := oJson:xvend4
	endif
	
	if AttIsMemberOf(oJson,"xdescr5")
		oCli:xdescr5 := oJson:xdescr5
	endif
	
	if AttIsMemberOf(oJson,"xvend5")
		oCli:xvend5 := oJson:xvend5
	endif
	
	if AttIsMemberOf(oJson,"xdescr6")
		oCli:xdescr6 := oJson:xdescr6
	endif
	
	if AttIsMemberOf(oJson,"xvend6")
		oCli:xvend6 := oJson:xvend6
	endif
	
	if AttIsMemberOf(oJson,"xdescr7")
		oCli:xdescr7 := oJson:xdescr7
	endif
	
	if AttIsMemberOf(oJson,"xvend8")
		oCli:xvend8 := oJson:xvend8
	endif

return

method valCli(oCli) class CRMClienteSite
	
	Local aEmprRic	:= {}
	
	if empty(oCli:nome)
		::erroAuto := "Campo razão social deve ser preenchido"
		return .F.
	endif

	if empty(oCli:nreduz)
		::erroAuto := "Campo nome fantasia deve ser preenchido"
		return .F.
	endif

	if empty(oCli:tipo)
		::erroAuto := "Campo tipo deve ser definido"
		return .F.
	endif
	
	if empty(oCli:cgc)
		::erroAuto := "Campo CGC deve ser definido"
		return .F.
	endif
	
	if empty(oCli:inscr)
		::erroAuto := "Campo Inscrição estadual deve ser definido"
		return .F.
	endif
	
	if empty(oCli:pais)
		::erroAuto := "Campo Código País deve ser definido"
		return .F.
	endif
	
	if empty(oCli:codpais)
		::erroAuto := "Campo País BACEN deve ser definido"
		return .F.
	endif

	if empty(oCli:ender)
		::erroAuto := "Campo endereço deve ser preenchido"
		return .F.
	endif

	if empty(oCli:cod_mun)
		::erroAuto := "Campo código do município deve ser preenchido"
		return .F.
	endif

	if empty(oCli:bairro)
		::erroAuto := "Campo bairro deve ser preenchido"
		return .F.
	endif

	if empty(oCli:cep)
		::erroAuto := "Campo CEP deve ser preenchido"
		return .F.
	endif

	if empty(oCli:ddd)
		::erroAuto := "Campo DDD deve ser preenchido"
		return .F.
	endif

	if empty(oCli:tel)
		::erroAuto := "Campo Telefone deve ser preenchido"
		return .F.
	endif

	if empty(oCli:email)
		::erroAuto := "Campo E-Mail deve ser preenchido"
		return .F.
	endif
	
	if empty(oCli:est)
		::erroAuto := "Campo estado deve ser preenchido"
		return .F.
	endif
	
	if empty(oCli:tpessoa)
		::erroAuto := "Campo que define o tipo de pessoa deve ser preenchido"
		return .F.
	endif
	
	if empty(oCli:xagenci)
		::erroAuto := "Campo que define se é agência deve ser preenchido"
		return .F.
	endif
	
	if oCli:xagenci == "1" .and. empty(oCli:xdesage)
		::erroAuto := "Este cliente é agência, preencha a descrição da agência."
		return .F.
	endif

	/*if empty(oCli:vend)
	::erroAuto := "Campo Vendedor deve ser preenchido"
	return .F.	
	endif*/
	
	ACJ->(dbsetorder(1))
	if !ACJ->(dbseek(xFilial("ACJ") + oCli:ddi)) .and. !empty(oCli:ddi)
		::erroAuto := "Código DDI não cadastrado no sistema"
		return .F.
	endif
	
	SED->(dbsetorder(1))
	if !SED->(dbseek(xFilial("SED") + oCli:naturez)) .and. !empty(oCli:naturez)
		::erroAuto := "Natureza não cadastrada no sistema"
		return .F.
	endif
	
	SA1->(dbsetorder(3))
	if SA1->(dbseek(xFilial("SA1") + oCli:cgc)) .and. ::isInclui(oCli)
		::erroAuto := "CNPJ/CPF já cadastrado no sistema"
		return .F.
	endif
	
	SA3->(dbsetorder(1))
	if !SA3->(dbseek(xFilial("SA3") + oCli:vend)) .and. !empty(oCli:vend)
		::erroAuto := "Vendedor informado inválido"
		return .F.
	endif
	
	SX5->(dbsetorder(1))
	if !SX5->(dbseek(xFilial("SX5") + "12" + oCli:est))
		::erroAuto := "UF informada inválida"
		return .F.
	endif

	CC2->(dbsetorder(1))
	if !CC2->(dbseek(xFilial("CC2") + oCli:est + oCli:cod_mun))
		::erroAuto := "Município informado inválido"
		return .F.
	endif
	
/*	SA3->(dbsetorder(1))
	if !SA3->(dbseek(xFilial("SA3") + oCli:xvend1)) .and. !empty(oCli:xvend1)
		::erroAuto := "Vendedor informado inválido"
		return .F.
	endif
	
	SA3->(dbsetorder(1))
	if !SA3->(dbseek(xFilial("SA3") + oCli:xdescr2)) .and. !empty(oCli:xdescr2)
		::erroAuto := "Vendedor informado inválido"
		return .F.
	endif
	
	SA3->(dbsetorder(1))
	if !SA3->(dbseek(xFilial("SA3") + oCli:xvend3)) .and. !empty(oCli:xvend3)
		::erroAuto := "Vendedor informado inválido"
		return .F.
	endif
	
	SA3->(dbsetorder(1))
	if !SA3->(dbseek(xFilial("SA3") + oCli:xvend4)) .and. !empty(oCli:xvend4)
		::erroAuto := "Vendedor informado inválido"
		return .F.
	endif
	
	SA3->(dbsetorder(1))
	if !SA3->(dbseek(xFilial("SA3") + oCli:xvend5)) .and. !empty(oCli:xvend5)
		::erroAuto := "Vendedor informado inválido"
		return .F.
	endif
	
	SA3->(dbsetorder(1))
	if !SA3->(dbseek(xFilial("SA3") + oCli:xvend6)) .and. !empty(oCli:xvend6)
		::erroAuto := "Vendedor informado inválido"
		return .F.
	endif
	
	SA3->(dbsetorder(1))
	if !SA3->(dbseek(xFilial("SA3") + oCli:xvend7)) .and. !empty(oCli:xvend7)
		::erroAuto := "Vendedor informado inválido"
		return .F.
	endif
	
	aEmprRic := FWLoadSM0()
	*/
	
	if !ExistCpo("SYA",oCli:pais,1)
		::erroAuto := "Código de país inválido"
		return .F.
	endif
	
	if !ExistCpo("CCH",oCli:codpais,1)
		::erroAuto := "Código de país do BACEN inválido"
		return .F.
	endif
	
	if !(Cgc(oCli:cgc,nil,.F.))
		::erroAuto := "CNPJ/CPF informado inválido"
		return .F.
	endif
	
	if len(alltrim(oCli:cgc)) == 14 .and. ::isInclui(oCli)
		oCli:cod := "0" + substr(oCli:cgc,1,8)
	elseif ::isInclui(oCli)
		oCli:cod := substr(oCli:cgc,1,9)
	endif
	
	if len(alltrim(oCli:cgc)) == 14 .and. ::isInclui(oCli)
		oCli:loja := substr(oCli:cgc,9,4)
	elseif ::isInclui(oCli)
		oCli:loja := "0000"
	endif
		                                     
return .T.

method isInclui(oCli) class CRMClienteSite
	
	Local aAreaSA1	:= SA1->(GetArea())
	Local lRet		:= .T.
	
	SA1->(dbsetorder(1))
	lRet := !SA1->(dbseek(xFilial("SA1") + padr(oCli:cod,TamSx3("A1_COD")[1],"") + padr(oCli:loja,TamSx3("A1_LOJA")[1],"")))
	
	RestArea(aAreaSA1)
	
return lRet

method save(oCli) class CRMClienteSite
	::erroAuto := oCli:save() 
return empty(::erroAuto)

method delReg(oCli) class CRMClienteSite
	::erroAuto := oCli:delReg()
return empty(::erroAuto)

method setFromProsp(oProspect,oJson,oCli) class CRMClienteSite
	
	if AttIsMemberOf(oProspect,"nome")
		oCli:nome := oProspect:nome
	endif

	if AttIsMemberOf(oProspect,"nreduz")
		oCli:nreduz := oProspect:nreduz
	endif

	if AttIsMemberOf(oJson,"tipo")
		oCli:tipo := oJson:tipo
	endif
	
	if AttIsMemberOf(oProspect,"cgc")
		oCli:cgc := oProspect:cgc
		oCli:cod := iif(len(alltrim(oCli:cgc))==14,"0" + substr(oCli:cgc,1,8),substr(oCli:cgc,1,9))
		oCli:loja := iif(len(alltrim(oCli:cgc))==14,substr(oCli:cgc,9,4),"0000")      
		oCli:pessoa := iif(len(alltrim(oCli:cgc))==14,"J","F")                                     
	endif

	if AttIsMemberOf(oProspect,"inscr")
		oCli:inscr := oProspect:inscr
	endif
	
	if AttIsMemberOf(oProspect,"ender")
		oCli:ender := oProspect:ender
	endif

	if AttIsMemberOf(oProspect,"bairro")
		oCli:bairro := oProspect:bairro
	endif

	if AttIsMemberOf(oProspect,"cep")
		oCli:cep := oProspect:cep
	endif

	if AttIsMemberOf(oProspect,"est")
		oCli:est := oProspect:est
	endif
	
	if AttIsMemberOf(oProspect,"xcodmun")
		oCli:cod_mun := oProspect:xcodmun
		
		CC2->(dbsetorder(1))
		if CC2->(dbseek(xFilial("CC2") + oCli:est + oCli:cod_mun))
			oCli:mun	:= CC2->CC2_MUN
		endif
	endif
	
	if AttIsMemberOf(oJson,"pais")
		oCli:pais := oJson:pais
	endif
	
	if AttIsMemberOf(oJson,"ddi")
		oCli:ddi := oJson:ddi
	endif
	
	if AttIsMemberOf(oProspect,"ddd")
		oCli:ddd := oProspect:ddd
	endif

	if AttIsMemberOf(oProspect,"tel")
		oCli:tel := oProspect:tel
	endif
	
	
	if AttIsMemberOf(oJson,"xcomple")
		oCli:xcomple := oJson:xcomple
	endif
	
	if AttIsMemberOf(oJson,"codpais")
		oCli:codpais := oJson:codpais
	endif

	if AttIsMemberOf(oProspect,"email")
		oCli:email := oProspect:email
	endif

	if AttIsMemberOf(oProspect,"vend")
		oCli:vend := oProspect:vend
	endif
	
	if AttIsMemberOf(oProspect,"fax")
		oCli:fax := oProspect:fax
	endif
	
	if AttIsMemberOf(oJson,"tpessoa")
		oCli:tpessoa := oJson:tpessoa
	endif
	
	if AttIsMemberOf(oJson,"naturez")
		oCli:naturez := oJson:naturez
	endif
	
	if AttIsMemberOf(oJson,"xagenci")
		oCli:xagenci := oJson:xagenci
		/*SA3->(dbsetorder(1))
		if SA3->(dbseek(xFilial("SA3") + oCli:xagenci))
			oCli:xdesage := SA3->A3_NOME
		endif*/
	endif
	
	if AttIsMemberOf(oJson,"xdesage")
		oCli:xdesage := oJson:xdesage
		/*SA3->(dbsetorder(1))
		if SA3->(dbseek(xFilial("SA3") + oCli:xagenci))
			oCli:xdesage := SA3->A3_NOME
		endif*/
	endif
	
	if AttIsMemberOf(oJson,"xurl1")
		oCli:xurl1 := oJson:xurl1
	endif
	
	if AttIsMemberOf(oJson,"xurl2")
		oCli:xurl2 := oJson:xurl2
	endif
	
	if AttIsMemberOf(oJson,"xurl3")
		oCli:xurl3 := oJson:xurl3
	endif

	if AttIsMemberOf(oJson,"xdescr1")
		oCli:xdescr1 := oJson:xdescr1
	endif
	
	if AttIsMemberOf(oJson,"xvend1")
		oCli:xvend1 := oJson:xvend1
	endif
	
	if AttIsMemberOf(oJson,"xdescr1")
		oCli:xdescr1 := oJson:xdescr1
	endif
	
	if AttIsMemberOf(oJson,"xvend1")
		oCli:xvend1 := oJson:xvend1
	endif
	
	if AttIsMemberOf(oJson,"xdescr2")
		oCli:xdescr2 := oJson:xdescr2
	endif
	
	if AttIsMemberOf(oJson,"xvend2")
		oCli:xvend2 := oJson:xvend2
	endif
	
	if AttIsMemberOf(oJson,"xdescr3")
		oCli:xdescr3 := oJson:xdescr3
	endif
	
	if AttIsMemberOf(oJson,"xvend3")
		oCli:xvend3 := oJson:xvend3
	endif
	
	if AttIsMemberOf(oJson,"xdescr4")
		oCli:xdescr4 := oJson:xdescr4
	endif
	
	if AttIsMemberOf(oJson,"xvend4")
		oCli:xvend4 := oJson:xvend4
	endif
	
	if AttIsMemberOf(oJson,"xdescr5")
		oCli:xdescr5 := oJson:xdescr5
	endif
	
	if AttIsMemberOf(oJson,"xvend5")
		oCli:xvend5 := oJson:xvend5
	endif
	
	if AttIsMemberOf(oJson,"xdescr6")
		oCli:xdescr6 := oJson:xdescr6
	endif
	
	if AttIsMemberOf(oJson,"xvend6")
		oCli:xvend6 := oJson:xvend6
	endif
	
	if AttIsMemberOf(oJson,"xdescr7")
		oCli:xdescr7 := oJson:xdescr7
	endif
	
	if AttIsMemberOf(oJson,"xvend8")
		oCli:xvend8 := oJson:xvend8
	endif
	
	
return

method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class CRMClienteSite

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"A1_COD", "A1_LOJA", "A1_NREDUZ", "A1_CGC"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"cod")
		cWhere += "AND A1_COD LIKE '%" + oJsonParam:cod + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"loja")
		cWhere += "AND A1_LOJA LIKE '%" + oJsonParam:loja + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"nreduz")
		cWhere += "AND A1_NREDUZ LIKE '%" + oJsonParam:nreduz + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"mun")
		cWhere += "AND A1_MUN LIKE '%" + oJsonParam:mun + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"est")
		cWhere += "AND A1_EST LIKE '%" + oJsonParam:est + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"cgc")
		cWhere += "AND A1_CGC LIKE '%" + oJsonParam:cgc + "%' "
	endif
	
	cQuery +=  " SELECT "
	cQuery +=  " (SELECT COUNT(*) FROM "+ RetSqlName("SA1") +"  TOT WHERE TOT.A1_FILIAL = '" + xFilial("SA1") + "' AND TOT.D_E_L_E_T_ = '') AS TOT_RECS, "
	cQuery +=  " (SELECT COUNT(*) FROM "+ RetSqlName("SA1") +"  TOT WHERE TOT.A1_FILIAL = '" + xFilial("SA1")  +"' " + cWhere + " AND TOT.D_E_L_E_T_ = '') AS TOT_FILTER, "
	cQuery +=  " A1_COD, A1_LOJA, A1_NREDUZ, A1_CGC FROM "+ RetSqlName("SA1") +" SA1 "
	cQuery +=  " WHERE SA1.D_E_L_E_T_ = '' "
	cQuery +=  " AND A1_FILIAL = '" + xFilial("SA1") + "' "
	cQUery += cWhere
	cQuery +=  " ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  " OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  " FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)
	
	(cAliQry)->(dbgotop())
	::nTotRegs		:= (cAliQry)->TOT_RECS
	::nFilteredRegs := (cAliQry)->TOT_FILTER
	while (cAliQry)->(!(eof()))

		aadd(aRet,SA1Clientes():New((cAliQry)->A1_COD,(cAliQry)->A1_LOJA))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet
