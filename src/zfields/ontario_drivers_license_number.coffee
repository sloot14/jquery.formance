$ = jQuery

class OntarioDriversLicenseNumberField extends AlphanumericFormanceField

    restrict_field_callback: (e, val) =>
        return false if val.length > 15

    format_field_callback: (e, $target, old_val, input, new_val) =>
        old_val = old_val.toUpperCase()
        input   = input.toUpperCase()
        new_val = new_val.toUpperCase()

        if /^[A-Z]$/i.test(new_val) or
            /^[A-Z]\d{0,4}$/i.test(new_val) or
            /^[A-Z]\d{4}[\s|\-]*\d{0,5}$/i.test(new_val) or
            /^[A-Z]\d{4}[\s|\-]*\d{5}[\s|\-]*\d{0,5}$/i.test(new_val)

                e.preventDefault()
                $target.val new_val

        if /^[A-Z]\d{4}$/.test(new_val) or
            /^[A-Z]\d{4}[\s|\-]*\d{5}$/.test(new_val)

                e.preventDefault()
                $target.val "#{new_val} - "

    format_backspace_callback: (e, $target, val) =>
        if /\d(\s|\-)+$/.test(val)
            e.preventDefault()
            $target.val(val.replace(/\d(\s|\-)+$/, ''))

    format_paste_callback: (e, $target, val) =>
        [full, first5, middle5, last5] = val.match(/^([A-Z\d]{5})[\s|\-]*(\d{5})[\s|\-]*(\d{5})$/i)
        $target.val("#{first5} - #{middle5} - #{last5}")

    validate: () ->
        val = @field.val()
        regex = /^[A-Z]\d{4}[\s|\-]*\d{5}[\s|\-]*\d{5}$/i
        return regex.test(val)

$.formance.fn.format_ontario_drivers_license_number = ->
    field = new OntarioDriversLicenseNumberField this
    field.format()
    this

$.formance.fn.validate_ontario_drivers_license_number = ->
    field = new OntarioDriversLicenseNumberField this
    field.validate()
