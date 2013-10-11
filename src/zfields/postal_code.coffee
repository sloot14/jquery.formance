$ = jQuery

class PostalCodeField extends AlphanumericFormanceField

    restrict_field_callback: (e, val) =>
        return false if val.length > 6

    format_field_callback: (e, $target, old_val, char, new_val) =>
        if old_val is ''
            e.preventDefault()
            $target.val(new_val) if /^[ABCEFGHJKLMNPRSTVXY]$/.test(new_val)

        else if /^[ABCEFGHJKLMNPRSTVXY]$/.test(old_val)
            e.preventDefault()
            $target.val(new_val) if /^[ABCEFGHJKLMNPRSTVXY][0-9]$/.test(new_val)

        else if /^[ABCEFGHJKLMNPRSTVXY][0-9]$/.test(old_val)
            e.preventDefault()
            $target.val("#{new_val} ") if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]$/.test(new_val)

        else if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s$/.test(old_val)
            e.preventDefault()
            $target.val(new_val) if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9]$/.test(new_val)

        else if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9]$/.test(old_val)
            e.preventDefault()
            $target.val(new_val) if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9][ABCEFGHJKLMNPRSTVWXYZ]$/.test(new_val)

        else if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9][ABCEFGHJKLMNPRSTVWXYZ]$/.test(old_val)
            e.preventDefault()
            $target.val(new_val) if  /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9][ABCEFGHJKLMNPRSTVWXYZ][0-9]$/.test(new_val)

    format_backspace_callback: (e, $target, val) =>
        # Removes trailing spaces,brackets and dashes when
        # hitting backspace at one of the jumps
        if /[ABCEFGHJKLMNPRSTVWXYZ](\s)+$/.test(val)
            e.preventDefault()
            $target.val(val.replace(/[ABCEFGHJKLMNPRSTVWXYZ](\s)*$/, ''))

    format_paste_callback: (e, $target, val) =>
        [full, first_part, second_part] = val.match(/^([ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ])\s?([0-9][ABCEFGHJKLMNPRSTVWXYZ][0-9])$/)
        $target.val("#{first_part} #{second_part}")

    validate: () ->
        val = @field.val()
        return false unless val?
        val = val.replace(/\s+/g, '')
        return false unless /^[a-zA-Z\d]+$/.test(val)

        # http://stackoverflow.com/questions/1146202/canada-postal-code-validation
        # apparently some letters are restricted
        # - first letter can't be D,I,O,Q,U,W,Z
        # - second letter can't be D,I,O,Q,U
        # - third letter can't be D,I,O,Q,U
        val = val.replace(/[^a-zA-Z\d]/g, '') #\W allows certain special characters
        /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9][ABCEFGHJKLMNPRSTVWXYZ][0-9]$/.test(val.toUpperCase())

$.formance.fn.format_postal_code = ->
    field = new PostalCodeField this
    field.format()
    this

$.formance.fn.validate_postal_code = ->
    field = new PostalCodeField this
    field.validate()
