require('./jquery.payment')

$ = jQuery

$.formance.fn.formatCreditCardCVC = ->
	this.payment('formatCardCVC')
	this

$.formance.validateCreditCardCVC = (val, type) ->
	return $.payment.validateCardCVC(val, type)