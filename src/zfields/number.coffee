$ = jQuery

$.formance.fn.formatNumber = ->
	@.formance('restrictNumeric')
	this

$.formance.validateNumber = (val) ->
	return /^\d+$/.test(val)