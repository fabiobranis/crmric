#include 'protheus.ch'

/*/{Protheus.doc} CRMProspectSite
Classe da camada de negócios.
Processa as regras antes de persistir o Prospect
@author Fabio
@since 07/05/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class CRMProspectSite 
	
	data erroAuto
	data attr
	data nFilteredRegs
	data nTotRegs
	
	method new() constructor 
	method valJson(cJson) 
	method setFromJson(oJson,oProspect) 
	method valProsp(oProspect)
	method isInclui(oProspect)
	method isCliente(oProspect) 
	method vincCli(oProspect,oCli)
	method save(oProspect)
	method delReg(oProspect)
	method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection)

endclass

/*/{Protheus.doc} new
Metodo construtor
@author Fabio
@since 07/05/2016 
@version 1.0
@return self, objeto instanciado
/*/
method new() class CRMProspectSite
	
	::attr 		:= {}
	::erroAuto 	:= ""
	::nFilteredRegs	:= 0
	::nTotRegs	:= 0
return self

/*/{Protheus.doc} valJson
Valida se os atributos mandatórios estão no json de request
@author Fabio
@since 01/06/2016
@version undefined
@param cJson, characters, Json request
@param oProspect, object, objeto da classe DAO
@return boolean, se validou
/*/
method valJson(cJson,oProspect) class CRMProspectSite

	Local ni		:= 0
	Local aAttrMand	:= {"nome","nreduz","tipo","ender","xcodmun","est","bairro","cep","ddd","tel","email"}
	
	for ni := 1 to len(aAttrMand)

		if !(aAttrMand[ni] $ cJson)
			::erroAuto := "Atributo "+aAttrMand[ni]+ " é mandatório"
			return .F.
		endif
	next

return .T.

/*/{Protheus.doc} setFromJson
Define as propriedades da classe DAO desse business model.
@author Fabio
@since 01/06/2016
@version undefined
@param oJson, object, Json parseado
@param oProspect, object, Objeto DAO
/*/
method setFromJson(oJson,oProspect) class CRMProspectSite

	if AttIsMemberOf(oJson,"nome")
		oProspect:nome := oJson:nome
	endif
	if AttIsMemberOf(oJson,"nreduz")
		oProspect:nreduz := oJson:nreduz
	endif
	if AttIsMemberOf(oJson,"tipo")
		oProspect:tipo := oJson:tipo
	endif
	if AttIsMemberOf(oJson,"ender")
		oProspect:ender := oJson:ender
	endif
	if AttIsMemberOf(oJson,"est")
		oProspect:est := oJson:est
	endif
	if AttIsMemberOf(oJson,"xcodmun")
		oProspect:xcodmun := oJson:xcodmun
		oProspect:mun := Posicione("CC2",1,xFilial("CC2") + oProspect:est + oProspect:xcodmun, "CC2_MUN")
	endif
	if AttIsMemberOf(oJson,"bairro")
		oProspect:bairro := oJson:bairro
	endif
	if AttIsMemberOf(oJson,"cep")
		oProspect:cep := oJson:cep
	endif
	if AttIsMemberOf(oJson,"ddd")
		oProspect:ddd := oJson:ddd
	endif
	if AttIsMemberOf(oJson,"tel")
		oProspect:tel := oJson:tel
	endif
	if AttIsMemberOf(oJson,"fax")
		oProspect:fax := oJson:fax
	endif
	if AttIsMemberOf(oJson,"email")
		oProspect:email := oJson:email
	endif
	if AttIsMemberOf(oJson,"vend")
		oProspect:vend := oJson:vend
	endif
	if AttIsMemberOf(oJson,"cgc")
		oProspect:cgc := oJson:cgc
	endif
	if AttIsMemberOf(oJson,"inscr")
		oProspect:inscr := oJson:inscr
	endif
	if AttIsMemberOf(oJson,"url")
		oProspect:url := oJson:url
	endif

return

/*/{Protheus.doc} valProsp
Valida as informações contidas no DAO
@author Fabio
@since 01/06/2016
@version undefined
@param oProspect, object, objeto DAO
@return boolean, se validou
/*/
method valProsp(oProspect) class CRMProspectSite

	if empty(oProspect:nome)
		::erroAuto := "Campo razão social deve ser preenchido"
		return .F.
	endif

	if empty(oProspect:nreduz)
		::erroAuto := "Campo nome fantasia deve ser preenchido"
		return .F.
	endif

	if empty(oProspect:tipo)
		::erroAuto := "Campo tipo deve ser definido"
		return .F.
	endif

	if empty(oProspect:ender)
		::erroAuto := "Campo endereço deve ser preenchido"
		return .F.
	endif

	if empty(oProspect:xcodmun)
		::erroAuto := "Campo código do município deve ser preenchido"
		return .F.
	endif

	if empty(oProspect:bairro)
		::erroAuto := "Campo bairro deve ser preenchido"
		return .F.
	endif

	if empty(oProspect:cep)
		::erroAuto := "Campo CEP deve ser preenchido"
		return .F.
	endif

	if empty(oProspect:ddd)
		::erroAuto := "Campo DDD deve ser preenchido"
		return .F.
	endif

	if empty(oProspect:tel)
		::erroAuto := "Campo Telefone deve ser preenchido"
		return .F.
	endif

	if empty(oProspect:email)
		::erroAuto := "Campo E-Mail deve ser preenchido"
		return .F.
	endif
	
	if empty(oProspect:est)
		::erroAuto := "Campo estado deve ser preenchido"
		return .F.
	endif

	/*if empty(oProspect:vend)
	::erroAuto := "Campo Vendedor deve ser preenchido"
	return .F.	
	endif*/
	CC2->(dbsetorder(1))
	if !CC2->(dbseek(xFilial("CC2") + oProspect:est + oProspect:xcodmun))
		::erroAuto := "Município informado inválido"
		return .F.
	endif
	
	
	SA3->(dbsetorder(1))
	if !SA3->(dbseek(xFilial("SA3") + oProspect:vend)) .and. !empty(oProspect:vend)
		::erroAuto := "Vendedor informado inválido"
		return .F.
	endif

return .T.

/*/{Protheus.doc} isInclui
Verifica através de uma busca no banco de dados se é inclusão de registros
@author Fabio
@since 01/06/2016
@version undefined
@param oProspect, object, Objeto DAO
@return boolena, se é inclusão = .T.
@example
(examples)
@see (links_or_references)
/*/
method isInclui(oProspect) class CRMProspectSite
	
	Local aAreaSUS	:= SUS->(GetArea())
	Local lRet		:= .T.
	
	SUS->(dbsetorder(1))
	lRet := !SUS->(dbseek(xFilial("SUS") + padr(oProspect:cod,TamSx3("US_COD")[1],"") + padr(oProspect:loja,TamSx3("US_LOJA")[1],"")))
	
	RestArea(aAreaSUS)
	
return lRet

/*/{Protheus.doc} isCliente
Verifica se o prospect já foi convertido para cliente
@author Fabio
@since 01/06/2016
@version undefined
@param oProspect, object, objeto DAO
@return boolean, se foi convertido = .T.
/*/
method isCliente(oProspect) class CRMProspectSite

	Local aAreaSUS	:= SUS->(GetArea())
	Local lRet		:= .T.
	
	SUS->(dbsetorder(1))
	if SUS->(dbseek(xFilial("SUS") + padr(oProspect:cod,TamSx3("US_COD")[1],"") + padr(oProspect:loja,TamSx3("US_LOJA")[1],"")))
		lRet := !empty(SUS->US_CODCLI)
	endif
	
	RestArea(aAreaSUS)
	
return lRet

/*/{Protheus.doc} vincCli
Vincula o prospect ao um cliente
@author Fabio
@since 01/06/2016
@version undefined
@param oProspect, object, DAO do prospect
@param oCli, object, DAO do cliente
/*/
method vincCli(oProspect,oCli) class CRMProspectSite
	oProspect:vincCli(oCli)
return

/*/{Protheus.doc} save
Chama do método que grava os registros.
Serve para inclusão ou alteração.
@author Fabio
@since 01/06/2016
@version undefined
@param oProspect, object, DAO
@return boolean, se gravou
/*/
method save(oProspect) class CRMProspectSite
	// erroAuto é uma propriedade no formato string
	//contém as informações de erro, se ocorrer
	::erroAuto := oProspect:save() 
return empty(::erroAuto)

/*/{Protheus.doc} delReg
Chama o método que deleta os registros
@author Fabio
@since 01/06/2016
@version undefined
@param oProspect, object, DAO
@return boolean, se deletou
/*/
method delReg(oProspect) class CRMProspectSite
	// erroAuto é uma propriedade no formato string
	//contém as informações de erro, se ocorrer
	::erroAuto := oProspect:delReg()
return empty(::erroAuto)

/*/{Protheus.doc} getList
Monta uma lista, conforme os parâmetros.
@author Fabio
@since 01/06/2016
@version undefined
@param oJsonParam, object, objeto com os parâmetros do modelo
@param nPage, numeric, número da página
@param nPageLength, numeric, tamanho da página
@param nOrder, numeric, ordem
@param cDirection, characters, direção da ordenação
@return array, array com os registros de acordo com os filtros
/*/
method getList(oJsonParam,nPage,nPageLength,nOrder,cDirection) class CRMProspectSite

	local cQuery 		:= ""
	local cAliQry		:= GetNextAlias()
	local aArea			:= GetArea()
	local aOrder		:= {"US_COD", "US_LOJA", "US_NREDUZ", "US_CGC"}
	local aRet			:= {}
	local cWhere		:= ""
	default nOrder 		:= 1
	default nPageLength	:= 10
	default nPage 		:= 1
	default cDirection	:= "ASC"
	
	if AttIsMemberOf(oJsonParam,"cod")
		cWhere += " AND US_COD LIKE '%" + oJsonParam:cod + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"loja")
		cWhere += " AND US_LOJA LIKE '%" + oJsonParam:loja + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"nreduz")
		cWhere += " AND US_NREDUZ LIKE '%" + oJsonParam:nreduz + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"mun")
		cWhere += " AND US_MUN LIKE '%" + oJsonParam:mun + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"est")
		cWhere += " AND US_EST LIKE '%" + oJsonParam:est + "%' "
	endif
	
	if AttIsMemberOf(oJsonParam,"cgc")
		cWhere += " AND US_CGC LIKE '%" + oJsonParam:cgc + "%' "
	endif

	cQuery +=  " SELECT "
	cQuery +=  " (SELECT COUNT(*) FROM "+ RetSqlName("SUS") +"  TOT WHERE TOT.US_FILIAL = '" + xFilial("SUS") + "' AND TOT.D_E_L_E_T_ = '') AS TOT_RECS, "
	cQuery +=  " (SELECT COUNT(*) FROM "+ RetSqlName("SUS") +"  TOT WHERE TOT.US_FILIAL = '" + xFilial("SUS") + "' " + cWhere + " AND TOT.D_E_L_E_T_ = '') AS TOT_FILTER, "
	cQuery +=  " US_COD, US_LOJA, US_NREDUZ, US_CGC FROM "+ RetSqlName("SUS") +" SUS "
	cQuery +=  " WHERE SUS.D_E_L_E_T_ = '' "
	cQuery +=  " AND US_FILIAL = '" + xFilial("SUS") + "' "
	cQuery += cWhere
	cQuery +=  " ORDER BY " + aOrder[nOrder] + space(1) + cDirection + space(1)
	cQuery +=  " OFFSET ((" + cValToChar(nPage) + " - 1) * "+ cValToChar(nPageLength) +") ROWS "
	cQuery +=  " FETCH NEXT " +cValToChar(nPageLength)+ " ROWS ONLY "

	MPSysOpenQuery(cQuery,cAliQry)
	dbselectarea(cAliQry)
	
	(cAliQry)->(dbgotop())
	::nTotRegs		:= (cAliQry)->TOT_RECS
	::nFilteredRegs := (cAliQry)->TOT_FILTER
	while (cAliQry)->(!(eof()))

		aadd(aRet,SUSProspectsPortal():New((cAliQry)->US_COD,(cAliQry)->US_LOJA))
		(cAliQry)->(dbskip())
	enddo

	if select(cAliQry) <> 0
		(cAliQry)->(dbclosearea())
	endif
	RestArea(aArea)
return aRet