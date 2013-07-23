$ = jQuery
hasTextSelected = $.formance.fn.hasTextSelected

restrictOntarioDriversLicenseNumber = (e) ->
    $target = $(e.currentTarget)
    char   = String.fromCharCode(e.which)

    return unless /^[a-zA-Z\d]+$/.test(char)

    return if hasTextSelected($target)

    value = $target.val() + char
    value = value.replace(/[^a-zA-Z\d]/g, '')

    return false if value.length > 15

formatOntarioDriversLicenseNumber = (e) ->
    char = String.fromCharCode(e.which)
    return unless /^[a-zA-Z\d]+$/.test(char)

    $target = $(e.currentTarget)
    old_val = $target.val()
    val = old_val + char.toUpperCase()

    if old_val is ''
        e.preventDefault()
        $target.val(val) if /^[A-Za-z]$/.test(val)

    else if /^[A-Za-z]\d{0,3}$/.test(old_val)
        e.preventDefault()
        val = "#{val} - " if /^[A-Za-z]\d{4}$/.test(val)
        $target.val(val) if /^[A-Za-z]\d{0,4}[\s|\-]*$/.test(val)

    else if /^[A-Za-z]\d{4}[\s|\-]*\d{0,4}$/.test(old_val)
        e.preventDefault()
        val = "#{val} - " if /^[A-Za-z]\d{4}[\s|\-]*\d{5}$/.test(val)
        $target.val(val) if /^[A-Za-z]\d{4}[\s|\-]*\d{0,5}[\s|\-]*$/.test(val)


formatBackOntarioDriversLicenseNumber = (e) ->
     # If shift+backspace is pressed
    return if e.meta

    $target = $(e.currentTarget)
    value   = $target.val()

    # Return unless backspacing
    return unless e.which is 8

     # Return if focus isn't at the end of the text
    return if $target.prop('selectionStart')? and
        $target.prop('selectionStart') isnt value.length
  
    if /\d(\s|\-)+$/.test(value)
        e.preventDefault()
        $target.val(value.replace(/\d(\s|\-)+$/, ''))


formatPasteOntarioDriversLicenseNumber = (e) ->
    setTimeout =>
        $target = $(e.currentTarget)
        val = $target.val()

        [full, first5, middle5, last5] = val.match(/^([A-Za-z\d]{5})[\s|\-]*(\d{5})[\s|\-]*(\d{5})$/)
        $target.val("#{first5} - #{middle5} - #{last5}")


$.formance.fn.format_ontario_drivers_license_number = ->
    @.formance('restrictAlphaNumeric')
    @on('keypress', restrictOntarioDriversLicenseNumber)
    @on('keypress', formatOntarioDriversLicenseNumber)
    @on('keydown',  formatBackOntarioDriversLicenseNumber)
    @on('paste',  formatPasteOntarioDriversLicenseNumber)
    this

$.formance.fn.validate_ontario_drivers_license_number = ->
    val = $(this).val()
    return false unless val?
    val = val.replace(/[\s|\-]/g, '')
    return false unless /^[a-zA-Z\d]+$/.test()

    regex = /^[A-Za-z]\d{4}[\s|\-]*\d{5}[\s|\-]*\d{5}$/
    return regex.test(val)
