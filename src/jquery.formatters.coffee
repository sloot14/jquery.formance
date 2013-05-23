require('./jquery.payment')

$           		  = jQuery
$.formatters    	= {}
$.formatters.fn 	= {}
$.fn.formatters 	= (method, args...) ->
  $.formatters.fn[method].apply(this, args)

hasTextSelected = ($target) ->
  # If some text is selected
  return true if $target.prop('selectionStart')? and
    $target.prop('selectionStart') isnt $target.prop('selectionEnd')

  # If some text is selected in IE
  return true if document?.selection?.createRange?().text

  false

restrictNumeric = (e) ->
  # Key event is for a browser shortcut
  return true if e.metaKey or e.ctrlKey

  # If keycode is a space
  return false if e.which is 32

  # If keycode is a special char (WebKit)
  return true if e.which is 0

  # If char is a special char (Firefox)
  return true if e.which < 33

  input = String.fromCharCode(e.which)

  # Char is a number or a space
  !!/[\d\s]/.test(input)

restrictAlphaNumeric = (e) ->
  # Key event is for a browser shortcut
  return true if e.metaKey or e.ctrlKey

  # If keycode is a space
  return false if e.which is 32

  # If keycode is a special char (WebKit)
  return true if e.which is 0

  # If char is a special char (Firefox)
  return true if e.which < 33

  input = String.fromCharCode(e.which)

  # Char is a number or a space
  !!/[\d\sA-Za-z]/.test(input)


# DATE FUNCTIONS
restrictDate = (e) ->
  $target = $(e.currentTarget)
  digit   = String.fromCharCode(e.which)
  return unless /^\d+$/.test(digit)

  return if hasTextSelected($target)

  value = $target.val() + digit
  value = value.replace(/\D/g, '')

  return false if value.length > 8

formatDate = (e) ->
  # Only format if input is a number
  digit = String.fromCharCode(e.which)
  return unless /^\d+$/.test(digit)

  $target = $(e.currentTarget)
  old_val = $target.val()
  val     = old_val + digit

  if /^\d$/.test(val) and digit not in ['0', '1', '2', '3']
    e.preventDefault()
    $target.val("0#{val} / ")

  else if /^\d{2}$/.test(val)
    e.preventDefault()
    $target.val("#{val} / ")

  else if /^\d{2}\s\/\s\d$/.test(val) and digit not in ['0', '1']
    e.preventDefault()
    $target.val("#{old_val}0#{digit} / ")

  else if /^\d{2}\s\/\s\d{2}$/.test(val)
    e.preventDefault()
    $target.val("#{val} / ")

formatForwardDate = (e) ->   #handles when the user enters the second digit
  digit = String.fromCharCode(e.which)
  return unless /^\d+$/.test(digit)

  $target = $(e.currentTarget)
  val     = $target.val()

  # handles when entering the 2nd and 4th digits
  if /^\d{2}$/.test(val) or /^\d{2}\s\/\s\d{2}$/.test(val)
    $target.val("#{val} / ")

formatForwardSlash = (e) ->    # handles when the user hits '/'
  slash = String.fromCharCode(e.which)
  return unless slash is '/'

  $target = $(e.currentTarget)
  val     = $target.val()

  parse_day = /^(\d)$/
  parse_month = /^(\d{2})\s\/\s(\d)$/

  if parse_day.test(val) and val isnt '0'
    $target.val("0#{val} / ")
  else if parse_month.test(val)
    [date, day, month] = val.match(parse_month)
    if month isnt '0'
      $target.val("#{day} / 0#{month} / ")

formatBackDate = (e) ->
  # If shift+backspace is pressed
  return if e.meta

  $target = $(e.currentTarget)
  value   = $target.val()

  # Return unless backspacing
  return unless e.which is 8

  # Return if focus isn't at the end of the text
  return if $target.prop('selectionStart')? and
    $target.prop('selectionStart') isnt value.length

  # Remove the trailing space
  if /\d(\s|\/)+$/.test(value)
    e.preventDefault()
    $target.val(value.replace(/\d(\s|\/)*$/, ''))
  else if /\s\/\s?\d?$/.test(value)
    e.preventDefault()
    $target.val(value.replace(/\s\/\s?\d?$/, ''))


# PHONE NUMBER FUNCTIONS
reFormatPhoneNumber = (phone_number_string) ->
  [phone_number, area_code, first3, last4] = phone_number_string.replace(/\D/g, '').match(/^(\d{0,3})?(\d{0,3})?(\d{0,4})?$/)
  
  text = ''
  text += "(#{area_code}" if area_code?
  text += ") " if area_code?.length is 3

  text += "#{first3}" if first3?
  text += " - " if first3?.length is 3

  text += "#{last4}" if last4?
  return text
  
restrictPhoneNumber = (e) ->
  $target = $(e.currentTarget)
  digit   = String.fromCharCode(e.which)
  return unless /^\d+$/.test(digit)

  return if hasTextSelected($target)

  value = $target.val() + digit
  value = value.replace(/\D/g, '')

  return false if value.length > 10

formatPhoneNumber = (e) ->
  digit = String.fromCharCode(e.which)
  return unless /^\d+$/.test(digit)

  $target = $(e.currentTarget)
  val = $target.val() + digit

  text = reFormatPhoneNumber(val)

  e.preventDefault()
  $target.val(text)

formatBackPhoneNumber = (e) ->
  # If shift+backspace is pressed
  return if e.meta

  $target = $(e.currentTarget)
  value   = $target.val()

  # Return unless backspacing
  return unless e.which is 8

  # Return if focus isn't at the end of the text
  return if $target.prop('selectionStart')? and
    $target.prop('selectionStart') isnt value.length

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

formatPastePhoneNumber = (e) ->
  setTimeout =>  # it takes a bit of time for the paste event to add the input, so wait a bit
    $target = $(e.currentTarget)
    val = $target.val()

    text = reFormatPhoneNumber(val)
    $target.val(text)


# POSTAL CODE FUNCTIONS

restrictPostalCode = (e) ->
  $target = $(e.currentTarget)
  char   = String.fromCharCode(e.which)

  return unless /^[a-zA-Z\d]+$/.test(char)

  return if hasTextSelected($target)

  value = $target.val() + char
  value = value.replace(/[^a-zA-Z\d]/g, '')

  return false if value.length > 6

formatPostalCode = (e) ->
  char = String.fromCharCode(e.which)
  return unless /^[a-zA-Z\d]+$/.test(char)

  $target = $(e.currentTarget)
  old_val = $target.val()
  val = old_val + char.toUpperCase()

  if old_val is ''
    e.preventDefault()
    $target.val(val) if /^[ABCEFGHJKLMNPRSTVXY]$/.test(val)

  else if /^[ABCEFGHJKLMNPRSTVXY]$/.test(old_val)
    e.preventDefault()
    $target.val(val) if /^[ABCEFGHJKLMNPRSTVXY][0-9]$/.test(val)

  else if /^[ABCEFGHJKLMNPRSTVXY][0-9]$/.test(old_val)
    e.preventDefault()
    $target.val("#{val} ") if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]$/.test(val)

  else if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s$/.test(old_val)
    e.preventDefault()
    $target.val(val) if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9]$/.test(val)

  else if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9]$/.test(old_val)
    e.preventDefault()
    $target.val(val) if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9][ABCEFGHJKLMNPRSTVWXYZ]$/.test(val)

  else if /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9][ABCEFGHJKLMNPRSTVWXYZ]$/.test(old_val)
    e.preventDefault()
    $target.val(val) if  /^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9][ABCEFGHJKLMNPRSTVWXYZ][0-9]$/.test(val)

formatBackPostalCode = (e) ->
  # If shift+backspace is pressed
  return if e.meta

  $target = $(e.currentTarget)
  value   = $target.val()

  # Return unless backspacing
  return unless e.which is 8

  # Return if focus isn't at the end of the text
  return if $target.prop('selectionStart')? and
    $target.prop('selectionStart') isnt value.length

  # Removes trailing spaces,brackets and dashes when
  # hitting backspace at one of the jumps
  if /[ABCEFGHJKLMNPRSTVWXYZ](\s)+$/.test(value)
    e.preventDefault()
    $target.val(value.replace(/[ABCEFGHJKLMNPRSTVWXYZ](\s)*$/, ''))

formatPastePostalCode = (e) ->
  setTimeout => # it takes a bit of time for the paste event to add the input, so wait a bit
    $target = $(e.currentTarget)
    val = $target.val()

    [full, first_part, second_part] = val.match(/^([ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ])\s?([0-9][ABCEFGHJKLMNPRSTVWXYZ][0-9])$/)
    $target.val("#{first_part} #{second_part}")

# FORMATTERS

$.formatters.fn.formatCardNumber = ->
  @.payment('formatCardNumber')
  this

$.formatters.fn.formatCardExpiry = ->
  @.payment('formatCardExpiry')
  this

$.formatters.fn.formatCardCVC = ->
  @.payment('formatCardCVC')
  this

$.formatters.fn.formatDate = ->
  @formatters('restrictNumeric')
  @on('keypress', restrictDate)
  @on('keypress', formatDate)
  @on('keypress', formatForwardSlash)
  @on('keypress', formatForwardDate)
  @on('keydown',  formatBackDate)
  this

# $.formatters.fn.formatEmail = ->
# 	this

$.formatters.fn.formatNumber = ->
  @formatters('restrictNumeric')
  this

$.formatters.fn.formatPhoneNumber = ->
  @formatters('restrictNumeric')
  @on('keypress', restrictPhoneNumber)
  @on('keypress', formatPhoneNumber)
  @on('keydown',  formatBackPhoneNumber)
  @on('paste', formatPastePhoneNumber)
  this

$.formatters.fn.formatPostalCode = ->
  @formatters('restrictAlphaNumeric')
  @on('keypress', restrictPostalCode)
  @on('keypress', formatPostalCode)
  @on('keydown', formatBackPostalCode)
  @on('paste', formatPastePostalCode)
  this

$.formatters.fn.restrictNumeric = ->
  @on('keypress', restrictNumeric)
  this
$.formatters.fn.restrictAlphaNumeric = ->
  @on('keypress', restrictAlphaNumeric)
  this
