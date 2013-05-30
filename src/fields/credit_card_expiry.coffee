require('./jquery.payment')

$ = jQuery

$.formance.fn.formatCreditCardExpiry = ->
	this.payment('formatCardExpiry')
	this

$.formance.validateCreditCardExpiry = (month, year) ->
	return $.payment.validateCardExpiry(month, year)

$.formance.creditCardExpiryVal = (expiryString) ->
	$.payment.cardExpiryVal(expiryString)