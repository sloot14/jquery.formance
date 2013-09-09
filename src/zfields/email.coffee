$ = jQuery
hasTextSelected = $.formance.fn.hasTextSelected

# there are no formatters, because you can't
# really format an email field.
$.formance.fn.format_email = ->
    this

$.formance.fn.validate_email = ->
    # http://stackoverflow.com/questions/46155/validate-email-address-in-javascript
    # the only way to validate an email address is to send it an email
    # that being said, it will surely enhance the user experience to have 
    # some client side validation
    algorithms =
        simple:  /^\S+@\S+$/
        complex: /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\ ".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA -Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

    $this = $(this)
    val = $this.val()
    return false unless val?

    validator = $this.data('formance_algorithm')
    return algorithms[validator].test(val) if validator? and validator of algorithms
    return algorithms['simple'].test(val)
