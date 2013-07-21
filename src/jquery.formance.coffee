$             = jQuery
$.formance    = {}
$.formance.fn = {}
$.fn.formance = (method, args...) ->
  $.formance.fn[method].apply(this, args)

restrictNumeric = (e) ->
  $target = $(e.target)

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
  $target = $(e.target)

  # Key event is for a browser shortcut
  return true if e.metaKey or e.ctrlKey

  # If keycode is a space
  return false if e.which is 32

  # If keycode is a special char (WebKit)
  return true if e.which is 0

  # If char is a special char (Firefox)
  return true if e.which < 33

  input = String.fromCharCode(e.which)

  # Char is a number, letter or space
  !!/[\d\sA-Za-z]/.test(input)

hasTextSelected = ($target) ->
  # If some text is selected
  return true if $target.prop('selectionStart')? and
    $target.prop('selectionStart') isnt $target.prop('selectionEnd')

  # If some text is selected in IE
  return true if document?.selection?.createRange?().text

  false


$.formance.fn.restrictNumeric = ->
  @on('keypress', restrictNumeric)
  this

$.formance.fn.restrictAlphaNumeric = ->
  @on('keypress', restrictAlphaNumeric)
  this

$.formance.fn.hasTextSelected = hasTextSelected
