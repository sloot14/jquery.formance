$ = jQuery

class EmailField extends FormanceField

    format: () ->
        # there are no formatters, because you can't format an email field
        # this function does nothing, but overrides the one in the super class
        # but this way we maintain consistency with the other fields
        this

    validate: () ->
        # http://stackoverflow.com/questions/46155/validate-email-address-in-javascript
        # the only way to validate an email address is to send it an email
        # that being said, it will surely enhance the user experience to have 
        # some client side validation
        algorithms =
            simple:  /^\S+@\S+$/
            complex: /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\ ".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA -Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

        val = @field.val()
        return false unless val?

        validator = @field.data('formance_algorithm')
        return algorithms[validator].test(val) if validator? and validator of algorithms
        return algorithms['simple'].test(val)

$.formance.fn.format_email = ->
    field = new EmailField this
    field.format()
    this

$.formance.fn.validate_email = ->
    field = new EmailField this
    field.validate()
