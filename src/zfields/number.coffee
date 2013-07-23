$ = jQuery

$.formance.fn.format_number = ->
    @.formance('restrictNumeric')
    this

$.formance.fn.validate_number = ->
    val = $(this).val()
    return /^\d+$/.test(val)
