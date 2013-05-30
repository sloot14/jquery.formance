require('./jquery.payment')

$ = jQuery

$.fn.formance.creditCardExpiry =

	format: ->
		this.payment('formatCardExpiry')
		this

	validate: ->
		val = $(this).val()
		expiry = @parse(val)
		return $.payment.validateCardExpiry(expiry.month, expiry.year)

	parse: (expiryString) ->
		$.payment.cardExpiryVal(expiryString)