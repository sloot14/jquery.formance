require('./jquery.payment')

$ = jQuery

$.fn.formance.creditCardNumber =

	format: ->
		this.payment('formatCardNumber')
		this

	validate: ->
		val = $(this).val()
		return $.payment.validateCardNumber(num)
