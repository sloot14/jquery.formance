$             = jQuery
$.formance    = {}
$.formance.fn = {}
$.fn.formance = (method, args...) ->
  $.formance.fn[method].apply(this, args)


class FormanceField

    constructor: (@field) ->

    restrict_field: (e) =>
        $target = $(e.currentTarget)
        digit   = String.fromCharCode(e.which)
        return unless /^\d+$/.test(digit)

        return if @has_text_selected($target)
        
        value = $target.val() + digit
        value = value.replace(/\D/g, '')

        @restrict_field_callback(e, value)

    format_field: (e) =>
        # only format if input is a digit
        digit = String.fromCharCode(e.which)
        return unless /^\d+$/.test(digit)

        $target = $(e.currentTarget)
        old_val = $target.val()
        new_val = old_val + digit

        #TODO rename to digit to input
        @format_field_callback(e, $target, old_val, digit, new_val)
        
    format_forward: (e) =>
        # handles when the user enters the second digit
        digit = String.fromCharCode(e.which)
        return unless /^\d+$/.test(digit)

        $target = $(e.currentTarget)
        val     = $target.val()

        @format_forward_callback(e, $target, val)

    format_forward_slash: (e) =>
        slash = String.fromCharCode(e.which)
        return unless slash is '/'

        $target = $(e.currentTarget)
        val     = $target.val()

        @format_forward_slash_callback(e, $target, val)

    format_backspace: (e) =>
        # If shift+backspace is pressed
        return if e.meta

        $target = $(e.currentTarget)
        value   = $target.val()

        # Return unless backspacing
        return unless e.which is 8

        # Return if focus isn't at the end of the text
        return if $target.prop('selectionStart')? and
            $target.prop('selectionStart') isnt value.length

        @format_backspace_callback(e, $target, value)

    format: () ->
        @field.on('keypress', @restrict_numeric)
        @field.on('keypress', @restrict_field)          if @restrict_field_callback?
        @field.on('keypress', @format_field)            if @format_field_callback?
        @field.on('keypress', @format_forward)          if @format_forward_callback?
        @field.on('keypress', @format_forward_slash)    if @format_forward_slash_callback?
        @field.on('keydown',  @format_backspace)        if @format_backspace_callback?

    has_text_selected: ($target) =>
        # if some text is selected

        return true if $target.prop('selectionStart')? and
        $target.prop('selectionStart') isnt $target.prop('selectionEnd')

        # If some text is selected in IE
        return true if document?.selection?.createRange?().text

        false

    restrict: (regex, e) =>
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

        !!regex.test(input)

    restrict_numeric: (e) =>
        # Char is a number or a space
        @restrict(/[\d\s]/, e)

    restrict_alphanumeric: (e) =>
        # Char is a number, letter or space
        @restrict(/[\d\sA-Za-z]/, e)


$.formance.fn.restrictNumeric = ->
  @on('keypress', FormanceField.restrict_numeric)
  this

$.formance.fn.restrictAlphaNumeric = ->
  @on('keypress', FormanceField.restrict_alphanumeric)
  this

$.formance.fn.hasTextSelected = FormanceField.has_text_selected
