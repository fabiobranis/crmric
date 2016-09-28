#include 'protheus.ch'

/*/{Protheus.doc} CRMResp
Classe que monta todas as respostas da API Rest.
Recebe as propriedades dos objetos e transforma em json
@author Fabio
@since 15/05/2016
@version 1.0
/*/
class CRMResp 
	
	/**
	 * Atributo que define o status da resposta
	 */
	data status
	
	/**
	 *Atributo que define o array body da resposta json. 
	 *É um array relaciondo ao array properties pelas posições das colunas dos objetos
	 *e se relaciona com o array posarray pelas linhas
	 */
	data body
	
	/**
	 * Atributo que define as propriedades dos objetos da resposta
	 */
	data properties 
	
	/**
	 * Atributo que define a qual objeto pertence cada linha do atributo properties
	 */
	data posarray
	
	
	/**
	 * Atributo que dfine se é uma lista
	 */
	data isList
	
	/**
	 *Atributo que define o número de registros que a lista possui
	 */
	data nRegs 
	
	/**
	 *Atributo que define o número de registros filtrados que a lista possui
	 */
	data nFiltered
	/**
	 *Atributo que define o tamanho da página
	 */
	data nPageLength
	
	/**
	 *Atributo que define a página atual
	 */
	data nPage 
	
	method new(status,body,properties,posarray,isList) constructor 
	method addBody(oBody)
	method addProperties(aProperties)
	method toJson()

endclass

/*/{Protheus.doc} new
Metodo construtor
@author Fabio
@since 15/05/2016 
@version 1.0
/*/
method new(status,properties,posarray,isList) class CRMResp
	
	Local ni			:= 0
	default status 		:= 0
	default properties 	:= {}
	default isList		:= .F.
	
	::status 		:= status
	::body 			:= {}
	::properties 	:= {}
	::posarray		:= {}
	::isList 		:= isList
	::nRegs			:= 0
	::nPageLength	:= 0
	::nPage			:= 0
	
	// as propriedades são incluídas como linhas
	if len(properties) > 0
		aadd(::properties,properties)
	endif
	
	// array que associa as posições das propriedades
	::posarray := posarray
	
	// inicializo o array de corpo da resposta de acordo com o número de objetos a retornar
	::body := array(len(posarray))
	
	for ni := 1 to len(::body)
		::body[ni] := {}
	next
	
return self

/*/{Protheus.doc} addBody
Método que adiciona as linhas do corpo da resposta
@author Fabio
@since 22/05/2016
@version undefined
@param cPosArray, characters, Identificação da posiçã (linha) no array de resposta
@param oBody, object, Objeto que será adcionado ao corpo
/*/
method addBody(cPosArray,oBody) class CRMResp
	
	Local nPos := ascan(::posarray,cPosArray) // verifico qual a linha que pertence pela denominação da posição

	if nPos > 0
		if len(::body) >= nPos
			aadd(::body[nPos],oBody)
		endif
	endif
	
return

/*/{Protheus.doc} addProperties
Método que adiciona as propriedades dos objetos
@author Fabio
@since 22/05/2016
@version undefined
@param aProperties, array, array de propriedades
/*/
method addProperties(aProperties) class CRMResp
	
	aadd(::properties,aProperties) 
return

/*/{Protheus.doc} toJson
mètodo que constrói a string json de resposta de acordo com a estrutura do objeto
@author Fabio
@since 22/05/2016
@version undefined
@return String, Json formatado de acordo com as propriedades do objeto
/*/
method toJson() class CRMResp

	Local cJson 	:= ""
	Local cJsAux	:= ""
	Local cStrAux	:= ""
	Local ni,nj,nx	:= 0
	
	// início da string no formato json
	cJson := '{"status": ' + cValToChar(::status) + ', '
	
	cJson += ' "body":{'
	
	if ::isList
		cJson += '"filteredRecords" : ' + cValtoChar(::nFiltered) + ', '
		cJson += '"totalRecords" : ' + cValtoChar(::nRegs) + ', '
		cJson += '"pageLength" : ' + cValtoChar(::nPageLength) + ', '
		cJson += '"pageNumber" : ' + cValtoChar(::nPage) + ', '
	endif
	
	// percorro as definições de tipos do objeto
	for ni := 1 to len(::posarray)
		cJsAux := ''
		// percorro os objetos que pertencem ao tipo - linhas do body
		for nx := 1 to len(::body[ni])
			// faço o parser para uma string com base no objeto
			cStrAux := FWJsonSerialize(::body[ni][nx],.F.,.T.)
			// percorro as propriedades para montar o retorno, transformando as propriedades json em letras minusculas
			for nj := 1 to len(::properties[ni])
				cStrAux := strtran(cStrAux,upper('"'+::properties[ni][nj]+'"'),'"'+::properties[ni][nj]+'"')
			next
			cJsAux += cStrAux + iif(nx < len(::body[ni]),',','')
		next
		// finalizo a posição do array - se for a última passada finaliza o json
		cJson += '"' + ::posarray[ni] + '"' + ': ' + iif(len(::body[ni]) > 1,'[','') + cJsAux + iif(ni < len(::properties),',', iif(len(::body[ni]) > 1,']','') + '}}')
	next

return cJson