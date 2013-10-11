$ = jQuery

class PhoneNumberField extends AlphanumericFormanceField

    restrict_callback: (e, val) =>
        return false if value.length > 10

    format_field_callback: (e, $target, old_val, digit, new_val) =>
        e.preventDefault()
        text = @reformat_phone_number(new_val)
        $target.val(text)

    format_backspace_callback: (e, $target, val) =>
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

    format_paste_callback: (e, $target, val) =>
        text = @reformat_phone_number(val)
        $target.val(text)

    reformat_phone_number: (phone_string) ->
        phoneNumber = phone_string.replace(/\D/g, '').match(/^(\d{0,3})?(\d{0,3})?(\d{0,4})?$/)
        # return unless phoneNumber?
        [phoneNumber, areaCode, first3, last4] = phoneNumber

        text = ''
        text += "(#{areaCode}" if areaCode?
        text += ") " if areaCode?.length is 3

        text += "#{first3}" if first3?
        text += " - " if first3?.length is 3

        text += "#{last4}" if last4?
        return text

    validate: () ->
        val = @field.val()
        return false unless val?
        val = val.replace(/\(|\)|\s+|-/g, '')
        return false unless /^\d+$/.test(val)

        # [areaCode, first3, last4] = val.match(/\d+/g)
        return val.replace(/\D/g, '').length is 10 # replaces all non digits [^0-9] with ''
 

$.formance.fn.format_phone_number = ->
    field = new PhoneNumberField this
    field.format()
    this

$.formance.fn.validate_phone_number = ->
    field = new PhoneNumberField this
    field.validate()
