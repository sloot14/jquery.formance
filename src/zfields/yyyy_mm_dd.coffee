$ = jQuery

class DateYYYYMMDDField extends NumericFormanceField

    restrict_field_callback: (e, $target, old_val, digit, new_val) =>
        return false if new_val.length > 8

    format_field_callback: (e, $target, old_val, digit, new_val) =>
        if (/^\d{4}[\s|\/]+\d$/.test(new_val) and digit not in ['0', '1']) or
            (/^\d{4}[\s|\/]+\d{2}[\s|\/]+\d$/.test(new_val) and digit not in ['0', '1', '2', '3'])
                
                e.preventDefault()
                new_val = "#{old_val}0#{digit}"
                $target.val new_val

        if /^\d{4}$/.test(new_val) or
            /^\d{4}[\s|\/]+\d{2}$/.test(new_val)
            
                e.preventDefault()
                $target.val "#{new_val} / "

    format_forward_slash_callback: (e, $target, val) =>
        parse_month = /^(\d{4})\s\/\s(\d)$/

        if parse_month.test(val)
            [date, year, month] = val.match(parse_month)
            if month isnt '0'
                $target.val("#{year} / 0#{month} / ")

    format_backspace_callback: (e, $target, val) =>
        if /\d[\s|\/]+$/.test(val)
            e.preventDefault()
            $target.val(val.replace(/\d[\s|\/]+$/, ''))

    validate: () ->
        date_dict = @parse_date @field.val()
        date = @val()

        return no unless date? and date instanceof Date
        return no unless date.getDate() is date_dict.day
        return no unless date.getMonth()+1 is date_dict.month
        return no unless date.getFullYear() is date_dict.year
        return yes

    val: () ->
        date = @parse_date @field.val()
        
        return no if not date.day? or isNaN(date.day)
        return no if not date.month? or isNaN(date.month)
        return no if not date.year? or isNaN(date.year)
        new Date date.year, date.month-1, date.day

    parse_date: (date_string) ->
        [year, month, day] = if date_string? then date_string.replace(/\s/g, '').split('/', 3) else [NaN, NaN, NaN]
        
        # day and month have a limited set of values, but year is open ended
        # if a users wants 200 / 01 / 01 then do 0200 / 01 / 01
        year = NaN unless year? and year.length is 4

        day     = parseInt(day, 10)
        month   = parseInt(month, 10)
        year    = parseInt(year, 10)

        return day: day, month: month, year: year


$.formance.fn.format_yyyy_mm_dd = ->
    field = new DateYYYYMMDDField this
    field.format()
    this

$.formance.fn.validate_yyyy_mm_dd = ->
    field = new DateYYYYMMDDField this
    field.validate()

$.formance.fn.val_yyyy_mm_dd = ->
    field = new DateYYYYMMDDField this
    field.val()
