$ = jQuery
hasTextSelected = $.formance.fn.hasTextSelected

restrictPostalCode = (e) ->
    $target = $(e.currentTarget)
    char   = String.fromCharCode(e.which)

    return unless /^[a-zA-Z\d]+$/.test(char)

    return if hasTextSelected($target)

    value = $target.val() + char
    value = value.replace(/[^a-zA-Z\d]/g, '')

    return false if value.length > 6

formatPostalCode = (e) ->
    char = String.fromCharCode(e.which)
    return unless /^[a-zA-Z\d]+$/.test(char)

    $target = $(e.currentTarget)
    old_val = $target.val()
    val = old_val + char.toUpperCase()

    if old_val is ''
        e.preventDefault()
        $target.val(val) if /^[ABCEFGHJKLMNPRSTVXY]$/.test(val)

    else if /^[ABCEFGHJKLMNPRSTVXY]$/.test(old_val)
        e.preventDefault()
        $target.val(val) if /^[ABCEFGHJKLMNPRSTVXY][0-9]$/.test(val)

    else if /^[ABCEFGHJKLMNPRSTVXY][0-9]$/.test(old_val)
        e.preventDefault()
        $target.val("#{val} ") if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]$/.test(val)

    else if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s$/.test(old_val)
        e.preventDefault()
        $target.val(val) if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9]$/.test(val)

    else if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9]$/.test(old_val)
        e.preventDefault()
        $target.val(val) if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9][ABCEFGHJKLMNPRSTVWXYZ]$/.test(val)
  
    else if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9][ABCEFGHJKLMNPRSTVWXYZ]$/.test(old_val)
        e.preventDefault()
        $target.val(val) if  /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9][ABCEFGHJKLMNPRSTVWXYZ][0-9]$/.test(val)

formatBackPostalCode = (e) ->
    # If shift+backspace is pressed
    return if e.meta
  
    $target = $(e.currentTarget)
    value   = $target.val()
  
    # Return unless backspacing
    return unless e.which is 8
  
    # Return if focus isn't at the end of the text
    return if $target.prop('selectionStart')? and
        $target.prop('selectionStart') isnt value.length
  
    # Removes trailing spaces,brackets and dashes when
    # hitting backspace at one of the jumps
    if /[ABCEFGHJKLMNPRSTVWXYZ](\s)+$/.test(value)
        e.preventDefault()
        $target.val(value.replace(/[ABCEFGHJKLMNPRSTVWXYZ](\s)*$/, ''))

formatPastePostalCode = (e) ->
    setTimeout => # it takes a bit of time for the paste event to add the input, so wait a bit
        $target = $(e.currentTarget)
        val = $target.val()

        [full, first_part, second_part] = val.match(/^([ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ])\s?([0-9][ABCEFGHJKLMNPRSTVWXYZ][0-9])$/)
        $target.val("#{first_part} #{second_part}")


$.formance.fn.format_postal_code = ->
    @.formance('restrictAlphaNumeric')
    @on('keypress', restrictPostalCode)
    @on('keypress', formatPostalCode)
    @on('keydown',  formatBackPostalCode)
    @on('paste',    formatPastePostalCode)
    this

$.formance.fn.validate_postal_code = ->
    val = $(this).val()
    return false unless val?
    val = val.replace(/\s+/g, '')
    return false unless /^[a-zA-Z\d]+$/.test(val)

    # http://stackoverflow.com/questions/1146202/canada-postal-code-validation
    # apparently some letters are restricted
    # - first letter can't be D,I,O,Q,U,W,Z
    # - second letter can't be D,I,O,Q,U
    # - third letter can't be D,I,O,Q,U
    val = val.replace(/[^a-zA-Z\d]/g, '') #\W allows certain special characters
    /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9][ABCEFGHJKLMNPRSTVWXYZ][0-9]$/.test(val.toUpperCase())
