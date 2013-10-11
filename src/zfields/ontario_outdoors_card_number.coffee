$ = jQuery

class OntarioOutdoorsCardNumberField extends NumericFormanceField

    restrict_callback: (e, val) =>
        return false if value.length > 15

    format_field_callback: (e, $target, old_val, digit, new_val) =>
        if old_val is ''
            e.preventDefault()
            val = if /^7$/.test(new_val) then "708158 " else "708158 #{new_val}"
            $target.val(val)

        else if /^\d{5}$/.test(old_val)
            e.preventDefault()
            val = "#{new_val} " if /^\d{6}$/.test(new_val)
            target.val(val) if /^\d{6}\s*$/.test(val)

    format_backspace_callback: (e, $target, val) =>
        if /708158\s+$/.test(val)
            e.preventDefault()
            $target.val(val.replace(/708158\s+$/, ''))

    format_paste_callback: (e, $target, val) =>
        [full, first6, last9] = val.match(/^(\d{6})\s*(\d{9})$/)
        $target.val("#{first6} #{last9}")

    validate: () ->
        val = @field.val()
        return false unless val?
        regex = /^708158\s*\d{9}$/
        return regex.test(val)

$.formance.fn.format_ontario_outdoors_card_number = ->
    field = new OntarioOutdoorsCardNumberField this
    field.format()
    this

$.formance.fn.validate_ontario_outdoors_card_number = ->
    field = new OntarioOutdoorsCardNumberField this
    field.validate()
