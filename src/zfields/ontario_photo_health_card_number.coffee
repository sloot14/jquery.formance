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

  if /^\d{4}$/.test(val)
    e.preventDefault()
    $target.val("#{val} - ")

  else if /^\d{4}[\s|\-]*\d{3}$/.test(val)
    e.preventDefault()
    $target.val("#{val} - ")

  else if /^\d{4}[\s|\-]*\d{3}[\s|\-]*d{3}$/.test(val) 
    e.preventDefault()
    $target.val("#{val} - ")

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
  else if /\s\-\s?[A-Za-z\d]?$/.test(value)
    e.preventDefault()
    $target.val(value.replace(/\s\-\s?[A-Za-z\d]?$/, ''))

formatPasteOntarioPhotoHealthCardNumber = (e) ->
  setTimeout =>
    $target = $(e.currentTarget)
    val = $target.val()

    [full, first_four, second_three, third_three, last_two] = val.match(/^(\d{4})[\s|\-]*?(\d{3})[\s|\-]*?(\d{3})[\s|\-]*?([A-Za-z]{2})$/)  
    $target.val("#{first_four} - #{second_three} - #{third_three} - #{last_two}")


$.formance.fn.formatOntarioPhotoHealthCardNumber = ->
    @.formance('restrictAlphaNumeric')
    @on('keypress', restrictOntarioPhotoHealthCardNumber)
    @on('keypress', formatOntarioPhotoHealthCardNumber)
    @on('keydown',  formatBackOntarioPhotoHealthCardNumber)
    @on('paste',  formatPasteOntarioPhotoHealthCardNumber)
    this

$.formance.validateOntarioPhotoHealthCardNumber = (val) ->
  return false unless val?
  val = val.replace(/[\s|\-]/g, '')
  return false unless /^[a-zA-Z\d]+$/.test()

  regex = /^(\d{4})[\s|\-]*?(\d{3})[\s|\-]*?(\d{3})[\s|\-]*?([A-Za-z]{2})$/
  return regex.test(val)
		
