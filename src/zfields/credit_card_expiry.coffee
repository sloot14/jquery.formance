$ = jQuery
hasTextSelected = $.formance.fn.hasTextSelected

restrictExpiry = (e) ->
    $target = $(e.currentTarget)
    digit   = String.fromCharCode(e.which)
    return unless /^\d+$/.test(digit)

    return if hasTextSelected($target)

    value = $target.val() + digit
    value = value.replace(/\D/g, '')

    return false if value.length > 6

formatExpiry = (e) ->
    # Only format if input is a number
    digit = String.fromCharCode(e.which)
    return unless /^\d+$/.test(digit)
  
    $target = $(e.currentTarget)
    val     = $target.val() + digit
  
    if /^\d$/.test(val) and val not in ['0', '1']
        e.preventDefault()
        $target.val("0#{val} / ")
  
    else if /^\d\d$/.test(val)
        e.preventDefault()
        $target.val("#{val} / ")

formatForwardExpiry = (e) ->
    digit = String.fromCharCode(e.which)
    return unless /^\d+$/.test(digit)
  
    $target = $(e.currentTarget)
    val     = $target.val()
  
    if /^\d\d$/.test(val)
        $target.val("#{val} / ")

formatForwardSlashExpiry = (e) ->
    slash = String.fromCharCode(e.which)
    return unless slash is '/'
  
    $target = $(e.currentTarget)
    val     = $target.val()
  
    if /^\d$/.test(val) and val isnt '0'
        $target.val("0#{val} / ")

formatBackExpiry = (e) ->
    # If shift+backspace is pressed
    return if e.meta
  
    $target = $(e.currentTarget)
    value   = $target.val()
  
    # Return unless backspacing
    return unless e.which is 8
  
    # Return if focus isn't at the end of the text
    return if $target.prop('selectionStart')? and
        $target.prop('selectionStart') isnt value.length
  
    # Remove the trailing space
    if /\d(\s|\/)+$/.test(value)
        e.preventDefault()
        $target.val(value.replace(/\d(\s|\/)*$/, ''))
    else if /\s\/\s?\d?$/.test(value)
        e.preventDefault()
        $target.val(value.replace(/\s\/\s?\d?$/, ''))



$.formance.fn.format_credit_card_expiry = ->
    @.formance('restrictNumeric')
    @on('keypress', restrictExpiry)
    @on('keypress', formatExpiry)
    @on('keypress', formatForwardSlashExpiry)
    @on('keypress', formatForwardExpiry)
    @on('keydown',  formatBackExpiry)
    this

parseCreditCardExpiry = (expiry_string) ->
    val = expiry_string.replace(/\s/g, '')
    [month, year] = val.split('/', 2)

    # Allow for year shortcut
    if year?.length is 2 and /^\d+$/.test(year)
        prefix = (new Date).getFullYear()
        prefix = prefix.toString()[0..1]
        year   = prefix + year

    month = parseInt(month, 10)
    year  = parseInt(year, 10)

    month: month, year: year


$.formance.fn.val_credit_card_expiry = ->
    expiry = parseCreditCardExpiry @.val()
    
    return no if not expiry.month? or isNaN(expiry.month)
    return no if not expiry.year? or isNaN(expiry.year)
    new Date expiry.year, expiry.month-1

$.formance.fn.validate_credit_card_expiry = ->
    expiry_date = parseCreditCardExpiry @.val()
    month = expiry_date.month
    year = expiry_date.year

    # Allow passing an object
    if typeof month is 'object' and 'month' of month
        {month, year} = month

    return false unless month and year

    month = $.trim(month)
    year  = $.trim(year)

    return false unless /^\d+$/.test(month)
    return false unless /^\d+$/.test(year)
    return false unless parseInt(month, 10) <= 12

    if year.length is 2
        prefix = (new Date).getFullYear()
        prefix = prefix.toString()[0..1]
        year   = prefix + year

    expiry      = new Date(year, month)
    currentTime = new Date

    # Months start from 0 in JavaScript
    expiry.setMonth(expiry.getMonth() - 1)

    # The cc expires at the end of the month,
    # so we need to make the expiry the first day
    # of the month after
    expiry.setMonth(expiry.getMonth() + 1, 1)

    expiry > currentTime

