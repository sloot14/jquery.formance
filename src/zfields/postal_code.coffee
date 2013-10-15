$ = jQuery

class PostalCodeField extends AlphanumericFormanceField

    restrict_field_callback: (e, $target, old_val, input, new_val) =>
        return false if new_val.length > 6

    format_field_callback: (e, $target, old_val, input, new_val) =>

        e.preventDefault()
        $target.val(new_val)        if /^[ABCEFGHJKLMNPRSTVXY]$/i.test(new_val)
        $target.val(new_val)        if /^[ABCEFGHJKLMNPRSTVXY][0-9]$/i.test(new_val)
        $target.val("#{new_val} ")  if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]$/i.test(new_val)
        $target.val(new_val)        if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s*[0-9]$/i.test(new_val)
        $target.val(new_val)        if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s*[0-9][ABCEFGHJKLMNPRSTVWXYZ]$/i.test(new_val)
        $target.val(new_val)        if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s*[0-9][ABCEFGHJKLMNPRSTVWXYZ][0-9]$/i.test(new_val)

    format_backspace_callback: (e, $target, val) =>
        if /[ABCEFGHJKLMNPRSTVWXYZ]\s+$/i.test(val)
            e.preventDefault()
            $target.val(val.replace(/[ABCEFGHJKLMNPRSTVWXYZ]\s+$/i, ''))

    format_paste_callback: (e, $target, val) =>
        [full, first_part, second_part] = val.match(/^([ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ])\s*([0-9][ABCEFGHJKLMNPRSTVWXYZ][0-9])$/i)
        $target.val("#{first_part} #{second_part}")

    validate: () ->
        val = @field.val()
        return false unless val?

        # http://stackoverflow.com/questions/1146202/canada-postal-code-validation
        # apparently some letters are restricted
        # - first letter can't be D,I,O,Q,U,W,Z
        # - second letter can't be D,I,O,Q,U
        # - third letter can't be D,I,O,Q,U
        /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s*[0-9][ABCEFGHJKLMNPRSTVWXYZ][0-9]$/i.test(val)

$.formance.fn.format_postal_code = ->
    field = new PostalCodeField this
    field.format()
    this

$.formance.fn.validate_postal_code = ->
    field = new PostalCodeField this
    field.validate()
