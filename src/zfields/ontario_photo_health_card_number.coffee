$ = jQuery
hasTextSelected = $.formance.fn.hasTextSelected

restrictOntarioPhotoHealthCardNumber = (e) ->
    $target = $(e.currentTarget)
    char   = String.fromCharCode(e.which)
  
    return unless /^[a-zA-Z\d]+$/.test(char)
  
    return if hasTextSelected($target)
  
    value = $target.val() + char
    value = value.replace(/[^a-zA-Z\d]/g, '')
  
    return false if value.length > 12

formatOntarioPhotoHealthCardNumber = (e) ->
    char = String.fromCharCode(e.which)
    return unless /^[a-zA-Z\d]+$/.test(char)

    $target = $(e.currentTarget)
    old_val = $target.val()
    val = old_val + char.toUpperCase()

    if /^\d{0,3}$/.test(old_val)
        e.preventDefault()
        val = "#{val} - " if /^\d{4}$/.test(val)
        $target.val(val) if /^\d{0,4}[\s|\-]*$/.test(val)

    else if /^\d{4}[\s|\-]*\d{0,2}$/.test(old_val)
        e.preventDefault()
        val = "#{val} - " if /^\d{4}[\s|\-]*\d{3}$/.test(val)
        $target.val(val) if /^\d{4}[\s|\-]*\d{0,3}[\s|\-]*$/.test(val)

    else if /^\d{4}[\s|\-]*\d{3}[\s|\-]*\d{0,2}$/.test(old_val)
        e.preventDefault()
        val = "#{val} - " if /^\d{4}[\s|\-]*\d{3}[\s|\-]*\d{3}$/.test(val)
        $target.val(val) if /^\d{4}[\s|\-]*\d{3}[\s|\-]*\d{0,3}[\s|\-]*$/.test(val)

    else if /^\d{4}[\s|\-]*\d{3}[\s|\-]*\d{3}[\s|\-]*[A-Za-z]{0,1}$/.test(old_val)
        e.preventDefault()
        $target.val(val) if /^\d{4}[\s|\-]*\d{3}[\s|\-]*\d{3}[\s|\-]*[A-Za-z]{0,2}$/.test(val)


formatBackOntarioPhotoHealthCardNumber = (e) ->
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


formatPasteOntarioPhotoHealthCardNumber = (e) ->
    setTimeout =>
        $target = $(e.currentTarget)
        val = $target.val()
    
        [full, first4, second3, third3, last2] = val.match(/^(\d{4})[\s|\-]*(\d{3})[\s|\-]*(\d{3})[\s|\-]*([A-Za-z]{2})$/)
        $target.val("#{first4} - #{second3} - #{third3} - #{last2}")


$.formance.fn.format_ontario_photo_health_card_number = ->
    @.formance('restrictAlphaNumeric')
    @on('keypress', restrictOntarioPhotoHealthCardNumber)
    @on('keypress', formatOntarioPhotoHealthCardNumber)
    @on('keydown',  formatBackOntarioPhotoHealthCardNumber)
    @on('paste',  formatPasteOntarioPhotoHealthCardNumber)
    this

$.formance.fn.validate_ontario_photo_health_card_number = ->
    val = $(this).val()
    return false unless val?
    val = val.replace(/[\s|\-]/g, '')
    return false unless /^[a-zA-Z\d]+$/.test()

    regex = /^\d{4}[\s|\-]*\d{3}[\s|\-]*\d{3}[\s|\-]*[A-Za-z]{2}$/
    return regex.test(val)
