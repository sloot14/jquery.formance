$ = jQuery

$.fn.formance.number =

	format: ->
		@formatters('restrictNumeric')
		this

	validate: ->
		val = $(this).val()
		return /^\d+$/.test(val)
