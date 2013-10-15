$ = jQuery

class CreditCardExpiryField extends NumericFormanceField

    restrict_field_callback: (e, $target, old_val, digit, new_val) =>
        return false if new_val.length > 6

    format_field_callback: (e, $target, old_val, digit, new_val) =>
        if /^\d$/.test(new_val) and new_val not in ['0', '1']
            e.preventDefault()
            $target.val("0#{new_val} / ")
      
        else if /^\d\d$/.test(new_val)
            e.preventDefault()
            $target.val("#{new_val} / ")

    format_forward_slash_callback: (e, $target, val) =>
        if /^\d$/.test(val) and val isnt '0'
            $target.val("0#{val} / ")

    format_backspace_callback: (e, $target, val) =>
        # Remove the trailing space
        if /\d(\s|\/)+$/.test(val)
            e.preventDefault()
            $target.val(val.replace(/\d(\s|\/)*$/, ''))
        else if /\s\/\s?\d?$/.test(val)
            e.preventDefault()
            $target.val(val.replace(/\s\/\s?\d?$/, ''))

    validate: () ->
        expiry_date = @parse_expiry @field.val()
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

    val: () ->
        expiry = @parse_expiry @field.val()
        
        return no if not expiry.month? or isNaN(expiry.month)
        return no if not expiry.year? or isNaN(expiry.year)
        new Date expiry.year, expiry.month-1


    parse_expiry: (expiry_string) ->
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


$.formance.fn.format_credit_card_expiry = ->
    field = new CreditCardExpiryField this
    field.format()
    this

$.formance.fn.validate_credit_card_expiry = ->
    field = new CreditCardExpiryField this
    field.validate()

$.formance.fn.val_credit_card_expiry = ->
    field = new CreditCardExpiryField this
    field.val()
