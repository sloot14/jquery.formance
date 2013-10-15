$ = jQuery

class OntarioPhotoHealthCardNumberField extends AlphanumericFormanceField

    restrict_field_callback: (e, $target, old_val, digit, new_val) =>
        return false if new_val.length > 12

    format_field_callback: (e, $target, old_val, input, new_val) =>
        old_val = old_val.toUpperCase()
        input   = input.toUpperCase()
        new_val = new_val.toUpperCase()

        e.preventDefault()

        if /^\d{0,4}$/.test(new_val) or
            /^\d{4}[\s|\-]*\d{0,3}$/.test(new_val) or
            /^\d{4}[\s|\-]*\d{3}[\s|\-]*\d{0,3}$/.test(new_val) or
            /^\d{4}[\s|\-]*\d{3}[\s|\-]*\d{3}[\s|\-]*[A-Z]{0,2}$/i.test(new_val)

                $target.val new_val

        if /^\d{4}$/.test(new_val) or
            /^\d{4}[\s|\-]*\d{3}$/.test(new_val) or
            /^\d{4}[\s|\-]*\d{3}[\s|\-]*\d{3}$/.test(new_val)

                $target.val "#{new_val} - "

    format_backspace_callback: (e, $target, val) =>
        if /\d(\s|\-)+$/.test(val)
            e.preventDefault()
            $target.val(val.replace(/\d(\s|\-)+$/, ''))

    format_paste_callback: (e, $target, val) =>
        matched_vals = val.match(/^(\d{4})[\s|\-]*(\d{3})[\s|\-]*(\d{3})[\s|\-]*([A-Z]{2})$/i)
        if matched_vals?
            [matched, first4, second3, third3, last2] = matched_vals
            $target.val("#{first4} - #{second3} - #{third3} - #{last2}")

    validate: () ->
        val = @field.val()
        return false unless val?
        regex = /^\d{4}[\s|\-]*\d{3}[\s|\-]*\d{3}[\s|\-]*[A-Z]{2}$/i
        return regex.test(val)

$.formance.fn.format_ontario_photo_health_card_number = ->
    field = new OntarioPhotoHealthCardNumberField this
    field.format()
    this

$.formance.fn.validate_ontario_photo_health_card_number = ->
    field = new OntarioPhotoHealthCardNumberField this
    field.validate()
