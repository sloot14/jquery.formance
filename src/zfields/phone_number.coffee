$ = jQuery
hasTextSelected = $.formance.fn.hasTextSelected

reFormatPhoneNumber = (phoneNumberString) ->
    phoneNumber = phoneNumberString.replace(/\D/g, '').match(/^(\d{0,3})?(\d{0,3})?(\d{0,4})?$/)
    # return unless phoneNumber?
    [phoneNumber, areaCode, first3, last4] = phoneNumber

    text = ''
    text += "(#{areaCode}" if areaCode?
    text += ") " if areaCode?.length is 3

    text += "#{first3}" if first3?
    text += " - " if first3?.length is 3

    text += "#{last4}" if last4?
    return text
  
restrictPhoneNumber = (e) ->
    $target = $(e.currentTarget)
    digit   = String.fromCharCode(e.which)
    return unless /^\d+$/.test(digit)

    return if hasTextSelected($target)

    value = $target.val() + digit
    value = value.replace(/\D/g, '')

    return false if value.length > 10

formatPhoneNumber = (e) ->
    digit = String.fromCharCode(e.which)
    return unless /^\d+$/.test(digit)

    $target = $(e.currentTarget)
    val = $target.val() + digit

    text = reFormatPhoneNumber(val)

    e.preventDefault()
    $target.val(text)

formatBackPhoneNumber = (e) ->
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
    if /\(\d$/.test(value)
        e.preventDefault()
        $target.val('')
    else if /\d\)(\s)+$/.test(value)
        e.preventDefault()
        $target.val(value.replace(/\d\)(\s)*$/, ''))
    else if /\d(\s|\-)+$/.test(value)
        e.preventDefault()
        $target.val(value.replace(/\d(\s|\-)+$/, ''))

formatPastePhoneNumber = (e) ->
  setTimeout =>  # it takes a bit of time for the paste event to add the input, so wait a bit
    $target = $(e.currentTarget)
    val = $target.val()

    text = reFormatPhoneNumber(val)
    $target.val(text)


$.formance.fn.format_phone_number = ->
    @.formance('restrictNumeric')
    @on('keypress', restrictPhoneNumber)
    @on('keypress', formatPhoneNumber)
    @on('keydown',  formatBackPhoneNumber)
    @on('paste',  formatPastePhoneNumber)
    this

$.formance.fn.validate_phone_number = ->
    val = $(this).val()
    return false unless val?
    val = val.replace(/\(|\)|\s+|-/g, '')
    return false unless /^\d+$/.test(val)

    # [areaCode, first3, last4] = val.match(/\d+/g)
    return val.replace(/\D/g, '').length is 10 # replaces all non digits [^0-9] with ''
