$ = jQuery

$.formance.fn.format_number = ->
    @.formance('restrictNumeric')
    this

$.formance.fn.validate_number = ->
    $this = $(this)
    val = $this.val()
    length = $this.data('formance_length')
    
    return false if length and val.length isnt length
    return /^\d+$/.test(val)
