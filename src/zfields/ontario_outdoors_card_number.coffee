$ = jQuery
hasTextSelected = $.formance.fn.hasTextSelected

restrictOntarioOutdoorsCardNumber = (e) ->
    $target = $(e.currentTarget)
    digit   = String.fromCharCode(e.which)
    return unless /^\d+$/.test(digit)

    return if hasTextSelected($target)

    value = $target.val() + digit
    value = value.replace(/\D/g, '')

    return false if value.length > 15

formatOntarioOutdoorsCardNumber = (e) ->
    digit = String.fromCharCode(e.which)
    return unless /^\d+$/.test(digit)

    $target = $(e.currentTarget)
    old_val = $target.val()
    val = $target.val() + digit

    if old_val is ''
        e.preventDefault()
        val = if /^7$/.test(val) then "708158 " else "708158 #{val}"
        $target.val(val)

    else if /^\d{5}$/.test(old_val)
        e.preventDefault()
        val = "#{val} " if /^\d{6}$/.test(val)
        target.val(val) if /^\d{6}\s*$/.test(val)


formatBackOntarioOutdoorsCardNumber = (e) ->
     # If shift+backspace is pressed
    return if e.meta

    $target = $(e.currentTarget)
    value   = $target.val()

    # Return unless backspacing
    return unless e.which is 8

     # Return if focus isn't at the end of the text
    return if $target.prop('selectionStart')? and
        $target.prop('selectionStart') isnt value.length

    if /708158\s+$/.test(value)
        e.preventDefault()
        $target.val(value.replace(/708158\s+$/, ''))


formatPasteOntarioOutdoorsCardNumber = (e) ->
    setTimeout =>
        $target = $(e.currentTarget)
        val = $target.val()

        [full, first6, last9] = val.match(/^(\d{6})\s*(\d{9})$/)
        $target.val("#{first6} #{last9}")


$.formance.fn.format_ontario_outdoors_card_number = ->
    @.formance('restrictNumeric')
    @on('keypress', restrictOntarioOutdoorsCardNumber)
    @on('keypress', formatOntarioOutdoorsCardNumber)
    @on('keydown',  formatBackOntarioOutdoorsCardNumber)
    @on('paste',  formatPasteOntarioOutdoorsCardNumber)
    this

$.formance.fn.validate_ontario_outdoors_card_number = ->
    val = $(this).val()
    return false unless val?
    val = val.replace(/\s/g, '')
    return false unless /^\d+$/.test(val)

    regex = /^708158\s*\d{9}$/
    return regex.test(val)
