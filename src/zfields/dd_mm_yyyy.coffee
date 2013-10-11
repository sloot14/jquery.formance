$ = jQuery

class DateDDMMMYYYYField extends NumericFormanceField

    restrict_field_callback: (e, val) =>
        return false if val.length > 8

    format_field_callback: (e, $target, old_val, digit, new_val) =>
        if /^\d$/.test(new_val) and digit not in ['0', '1', '2', '3']
            e.preventDefault()
            $target.val("0#{new_val} / ")
        else if /^\d{2}$/.test(new_val)
            e.preventDefault()
            $target.val("#{new_val} / ")
        else if /^\d{2}\s\/\s\d$/.test(new_val) and digit not in ['0', '1']
            e.preventDefault()
            $target.val("#{old_val}0#{digit} / ")
        else if /^\d{2}\s\/\s\d{2}$/.test(new_val)
            e.preventDefault()
            $target.val("#{new_val} / ")

    format_forward_callback: (e, $target, val) =>   #handles when the user enters the second digit
        # handles when entering the 2nd and 4th digits
        if /^\d{2}$/.test(val) or /^\d{2}\s\/\s\d{2}$/.test(val)
            $target.val("#{val} / ")

    format_forward_slash_callback: (e, $target, val) =>    # handles when the user hits '/'
        parse_day = /^(\d)$/
        parse_month = /^(\d{2})\s\/\s(\d)$/

        if parse_day.test(val) and val isnt '0'
            $target.val("0#{val} / ")
        else if parse_month.test(val)
            [date, day, month] = val.match(parse_month)
            if month isnt '0'
                $target.val("#{day} / 0#{month} / ")

    format_backspace_callback: (e, $target, val) =>
        # Remove the trailing space
        if /\d(\s|\/)+$/.test(val)
            e.preventDefault()
            $target.val(val.replace(/\d(\s|\/)*$/, ''))
        else if /\s\/\s?\d?$/.test(val)
            e.preventDefault()
            $target.val(val.replace(/\s\/\s?\d?$/, ''))


    validate: () ->
        date_dict = @parse_date @field.val()
        date = @val()

        return no unless date? and date instanceof Date
        return no unless date.getDate()     is date_dict.day
        return no unless date.getMonth()+1  is date_dict.month
        return no unless date.getFullYear() is date_dict.year
        return yes

    val: () ->
        date = @parse_date @field.val()

        return no if not date.day? or isNaN(date.day)
        return no if not date.month? or isNaN(date.month)
        return no if not date.year? or isNaN(date.year)
        new Date date.year, date.month-1, date.day
    
    parse_date: (date_string) ->
        [day, month, year] = if date_string? then date_string.replace(/\s/g, '').split('/', 3) else [NaN, NaN, NaN]

        # day and month have a limited set of values, but year is opened ended
        # if a user wants 01 / 01 / 200 then do 01 / 01 / 0200
        year = NaN unless year? and year.length is 4
        
        day     = parseInt(day, 10)
        month   = parseInt(month, 10)
        year    = parseInt(year, 10)

        return day: day, month: month, year: year


$.formance.fn.format_dd_mm_yyyy = ->
    field = new DateDDMMMYYYYField this
    field.format()
    this

$.formance.fn.validate_dd_mm_yyyy = ->
    field = new DateDDMMMYYYYField this
    field.validate()

$.formance.fn.val_dd_mm_yyyy = ->
    field = new DateDDMMMYYYYField this
    field.val()
