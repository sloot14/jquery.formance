$          		= jQuery
$.formance	  = {}
$.formance.fn = {}
$.fn.formance = (method, args...) ->
  $.formance.fn[method].apply(this, args)

restrictNumeric = (e) ->

  console.log 'restrictNumeric triggered'
  $target = $(e.target)
  console.log '"' + $target.val() + '"'
  return true

  # Key event is for a browser shortcut
  return true if e.metaKey or e.ctrlKey

  # If keycode is a space
  return false if e.which is 32

  # If keycode is a special char (WebKit)
  return true if e.which is 0

  # If char is a special char (Firefox)
  return true if e.which < 33

  input = String.fromCharCode(e.which)

  console.log !!/[\d\s]/.test(input)

  # Char is a number or a space
  !!/[\d\s]/.test(input)

restrictAlphaNumeric = (e) ->
  
  console.log 'restrictAlphaNumeric triggered'
  $target = $(e.target)
  console.log '"' + $target.val() + '"'
  return true

  # Key event is for a browser shortcut
  return true if e.metaKey or e.ctrlKey

  # If keycode is a space
  return false if e.which is 32

  # If keycode is a special char (WebKit)
  return true if e.which is 0

  # If char is a special char (Firefox)
  return true if e.which < 33

  input = String.fromCharCode(e.which)

  console.log !!/[\d\sA-Za-z]/.test(input)

  # Char is a number or a space
  !!/[\d\sA-Za-z]/.test(input)

hasTextSelected = ($target) ->
  # If some text is selected
  return true if $target.prop('selectionStart')? and
    $target.prop('selectionStart') isnt $target.prop('selectionEnd')

  # If some text is selected in IE
  return true if document?.selection?.createRange?().text

  false


$.formance.fn.restrictNumeric = ->
  console.log 'Setting up keypress listener for restrictNumeric'
  @on('keypress', restrictNumeric)
  this

$.formance.fn.restrictAlphaNumeric = ->
  console.log 'Setting up keypress listener for restrictAlphaNumeric'
  @on('keypress', restrictAlphaNumeric)
  this

$.formance.fn.hasTextSelected = hasTextSelected