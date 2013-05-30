require('./jquery.payment')

$ = jQuery

$.formance.fn.formatCreditCardNumber = ->
	this.payment('formatCardNumber')
	this

$.formance.validateCreditCardNumber = (num) ->
	return $.payment.validateCardNumber(num)

$.formance.creditCardType = (num) ->
	return $.payment.cardType(num)