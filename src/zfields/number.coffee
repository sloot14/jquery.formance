$ = jQuery

class NumberField extends NumericFormanceField

    #TODO get length from either maxLength or data-formance-length 

    constructor: (vars...) ->
        super       # all arguments are passed to super, vars... accepts as many arguments as supplied
        length = @field.data('formance_length')
        @field.attr('maxLength', length) if length?

    validate: () ->
        val = @field.val()
        length = @field.data('formance_length')

        return false if length? and (typeof length is 'number') and (val.length isnt length)
        if length? and typeof length is 'string' and length isnt ''
            return false if isNaN parseInt(length, 10)
            return false if val.length isnt parseInt(length, 10)
        return /^\d+$/.test(val)

$.formance.fn.format_number = ->
    field = new NumberField this
    field.format()
    this

$.formance.fn.validate_number = ->
    field = new NumberField this
    field.validate()
