$             = jQuery
$.formance    = {}
$.formance.fn = {}
$.fn.formance = (method, args...) ->
  $.formance.fn[method].apply(this, args)


class FormanceField

    constructor: (@field, @regex, @replace_regex) ->

    restrict_field: (e) =>
        input   = String.fromCharCode(e.which)
        return unless @regex.test(input)

        $target = $(e.currentTarget)
        old_val = $target.val()
        new_val = old_val + input
        new_val = new_val.replace(@replace_regex, '')

        return if @has_text_selected($target)

        @restrict_field_callback(e, $target, old_val, input, new_val)

    format_field: (e) =>
        input = String.fromCharCode(e.which)
        return unless @regex.test(input)

        $target = $(e.currentTarget)
        old_val = $target.val()
        new_val = old_val + input
        
        return if @end_of_text($target)

        @format_field_callback(e, $target, old_val, input, new_val)
        
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
        val = $target.val()

        # Return unless backspacing
        return unless e.which is 8

        return if @end_of_text($target)

        @format_backspace_callback(e, $target, val)

    format_paste: (e) =>
        setTimeout => # it takes a bit of time for the paste event to add the input, so wait a bit
            $target = $(e.currentTarget)
            val = $target.val()

            @format_paste_callback(e, $target, val)

    format: () ->
        @field.on('keypress', @restrict_field)          if @restrict_field_callback?
        @field.on('keypress', @format_field)            if @format_field_callback?
        @field.on('keypress', @format_forward_slash)    if @format_forward_slash_callback?
        @field.on('keydown',  @format_backspace)        if @format_backspace_callback?
        @field.on('paste',    @format_paste)            if @format_paste_callback?

    end_of_text: ($target) =>
        # is focus at the end of the text
        $target.prop('selectionStart')? and
            $target.prop('selectionStart') isnt $target.val().length

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


class NumericFormanceField extends FormanceField

    constructor: (@field) ->
        super @field, /^\d+$/, /\D/g

    restrict_numeric: (e) =>
        # Char is a number or a space
        @restrict(/[\d\s]/, e)

    format: () ->
        @field.on('keypress', @restrict_numeric)
        super

class AlphanumericFormanceField extends FormanceField

    constructor: (@field) ->
        super @field, /^[A-Za-z\d]+$/, /[^A-Za-z\d]/g

    restrict_alphanumeric: (e) =>
        # Char is a number, letter or space
        @restrict(/[\d\sA-Za-z]/, e)

    format: () ->
        @field.on('keypress', @restrict_alphanumeric)
        super
