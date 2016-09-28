#include 'protheus.ch'

/*/{Protheus.doc} AC8ContCli
(long_description)
@author fabio
@since 05/07/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class AC8ContCli 
	
	data filial
	data filent
	data entida
	data codent
	data codcon
	
	method new(codent,codcon) constructor 
	method setProperties(codent,codcon)
	method save() 
	method delReg()
	method goToReg()
	
endclass

/*/{Protheus.doc} new
Metodo construtor
@author fabio
@since 05/07/2016 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method new(codent,codcon) class AC8ContCli
	
	default codent	:= ""
	default codcon	:= ""
	
	if !(::setProperties(codent,codcon))
	
		::filial	:= xFilial("AC8")
		::filent	:= xFilial("SA1")
		::entida	:= "SA1"
		::codent	:= codent
		::codcon	:= codcon
	
	endif
	
return

method setProperties(codent,codcon) class AC8ContCli
	
	AC8->(dbsetorder(1))
	if AC8->(dbseek(xFilial("AC8") + codcon + "SA1" + xFilial("SA1") + codent))
		::filial	:= xFilial("AC8")
		::filent	:= xFilial("SA1")
		::entida	:= AC8->AC8_ENTIDA
		::codent	:= AC8->AC8_CODENT
		::codcon	:= AC8->AC8_CODCON
		return .T.
	endif
	
return .F.

method save() class AC8ContCli
	

	AC8->(dbsetorder(1))
	if AC8->(dbseek(::filial + ::codcon + ::entida + ::filent + ::codent))

		// alteração
		RecLock( "AC8", .F. )
	else
		/**
		  * Inclui e grava os campos chave                                         ³
		  */
		RecLock( "AC8", .T. )
		AC8->AC8_FILIAL := xFilial( "AC8" )
		AC8->AC8_FILENT := xFilial( ::entida )
		AC8->AC8_ENTIDA := ::entida
		AC8->AC8_CODENT := ::codent
	endif

	/**
	 * Grava os demais campos                                                 ³
	 */
	AC8->AC8_CODCON	:= ::codcon

	AC8->( MsUnlock() )

Return .T.

method delReg() class AC8ContCli

	RecLock( "AC8", .F. )
	AC8->( dbDelete() )
	AC8->( MsUnLock() )

return

/**
 * Posiciona em um registro válido - Na tabela
 * Se não achar retorna .F.
 */
method goToReg() class AC8ContCli
	AC8->(dbsetorder(1))
return AC8->(dbseek(::filial + ::codcon + ::entida + ::filent + ::codent))