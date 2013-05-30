require('./jquery.payment')

$ = jQuery

$.fn.formance.creditCardCVC =

	format: ->
		this.payment('formatCardExpiry')
		this

	validate: ->
		val = $(this).val()
		type = null # TODO credit card type, not passed in
		return $.payment.validateCardCVC(val, type)

	parse: (expiryString) ->
		$.payment.cardExpiryVal(expiryString)