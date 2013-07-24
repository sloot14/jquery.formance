$ = jQuery
hasTextSelected = $.formance.fn.hasTextSelected

restrictDateYYYYMMDD = (e) ->
    $target = $(e.currentTarget)
    digit   = String.fromCharCode(e.which)
    return unless /^\d+$/.test(digit)

    return if hasTextSelected($target)

    value = $target.val() + digit
    value = value.replace(/\D/g, '')

    return false if value.length > 8

formatDateYYYYMMDD = (e) ->
    # Only format if input is a number
    digit = String.fromCharCode(e.which)
    return unless /^\d+$/.test(digit)

    $target = $(e.currentTarget)
    old_val = $target.val()
    val     = old_val + digit

    if /^\d{4}$/.test(val)
        e.preventDefault()
        $target.val("#{val} / ")
    else if /^\d{4}\s\/\s\d$/.test(val) and digit not in ['0', '1']
        e.preventDefault()
        $target.val("#{old_val}0#{digit} / ")
    else if /^\d{4}\s\/\s\d{2}$/.test(val)
        e.preventDefault()
        $target.val("#{val} / ")
    else if /^\d{4}\s\/\s\d{2}\s\/\s\d$/.test(val) and digit not in ['0', '1', '2', '3']
        e.preventDefault()
        $target.val("#{old_val}0#{digit}")

formatForwardDateYYYYMMDD = (e) ->
    digit = String.fromCharCode(e.which)
    return unless /^\d+$/.test(digit)

    $target = $(e.currentTarget)
    val     = $target.val()

    # handles when entering the 4th and 6th digits
    if /^\d{4}$/.test(val) or /^\d{4}\s\/\s\d{2}$/.test(val)
        $target.val("#{val} / ")

formatForwardSlashDateYYYYMMDD = (e) ->    # handles when the user hits '/'
    slash = String.fromCharCode(e.which)
    return unless slash is '/'

    $target = $(e.currentTarget)
    val     = $target.val()

    parse_month = /^(\d{4})\s\/\s(\d)$/

    if parse_month.test(val)
        [date, year, month] = val.match(parse_month)
        if month isnt '0'
            $target.val("#{year} / 0#{month} / ")

formatBackDateYYYYMMDD = (e) ->
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


$.formance.fn.format_yyyy_mm_dd = ->
    @.formance('restrictNumeric')
    @on('keypress', restrictDateYYYYMMDD)
    @on('keypress', formatDateYYYYMMDD)
    @on('keypress', formatForwardSlashDateYYYYMMDD)
    @on('keypress', formatForwardDateYYYYMMDD)
    @on('keydown',  formatBackDateYYYYMMDD)
    this

# ------------------------------
# Validating Date YYYY / MM / DD
# ------------------------------

parse_date_yyyy_mm_dd = (date_string) ->
    [year, month, day] = if date_string? then date_string.replace(/\s/g, '').split('/', 3) else [NaN, NaN, NaN]
    
    # day and month have a limited set of values, but year is open ended
    # if a users wants 200 / 01 / 01 then do 0200 / 01 / 01
    year = NaN unless year? and year.length is 4

    day     = parseInt(day, 10)
    month   = parseInt(month, 10)
    year    = parseInt(year, 10)

    return day: day, month: month, year: year
    
$.formance.fn.val_yyyy_mm_dd = ->
    date = parse_date_yyyy_mm_dd @.val()
    
    return no if not date.day? or isNaN(date.day)
    return no if not date.month? or isNaN(date.month)
    return no if not date.year? or isNaN(date.year)
    new Date date.year, date.month-1, date.day

$.formance.fn.validate_yyyy_mm_dd = ->
    date_dict = parse_date_yyyy_mm_dd @.val()
    date = @.formance('val_yyyy_mm_dd')

    return no unless date? and date instanceof Date
    return no unless date.getDate() is date_dict.day
    return no unless date.getMonth()+1 is date_dict.month
    return no unless date.getFullYear() is date_dict.year
    return yes
