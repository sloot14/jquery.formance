$ = jQuery

class CreditCardCVCField extends CreditCardField

    restrict_field_callback: (e, $target, old_val, digit, new_val) =>
        return false if new_val.length > 4

    validate: () ->
        type = @field.data('credit_card_type')
        cvc = @field.val()
        cvc = $.trim(cvc)
        return false unless /^\d+$/.test(cvc)

        if type
            # Check against a explicit card type
            cvc.length in @card_from_type(type)?.cvclength
        else
            # Check against all types
            cvc.length >= 3 and cvc.length <= 4

$.formance.fn.format_credit_card_cvc = ->
    field = new CreditCardCVCField this
    field.format()
    this

$.formance.fn.validate_credit_card_cvc = ->
    field = new CreditCardCVCField this
    field.validate()
