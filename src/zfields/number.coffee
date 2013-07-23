$ = jQuery

$.formance.fn.format_number = ->
	@.formance('restrictNumeric')
	this

$.formance.validate_number = (val) ->
	return /^\d+$/.test(val)
