assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')


describe 'credit_card_cvc.js', ->
    it 'should format the cvc', ->
        format '123',       52,        '1234',      'allows digits'
        format '123',       100,       '123',       'does not allow non-digits'

    it 'should validate the cvc', ->
        validate '123',         yes,        'valid cvc'
        validate '12',          no,         'less than 3 digits'
        validate '12345',       no,         'more than 4 digits'

        # special cases
        validate '',            no,         'empty cvc'
        validate '    ',        no,         'cvc with no digits only spaces'
        validate '123e',        no,         'cvc containing non-digits'


    it 'should validate the cvc when provided with a card type', ->
        validate_with_card_type '123',     'amex',     yes,    'valid 3 digit amex cvc code'
        validate_with_card_type '1234',    'amex',     yes,    'valid 4 digit amex cvc code'
        validate_with_card_type '123',     'visa',     yes,    'valid visa'
        validate_with_card_type '1234',    'visa',     no,     'invalid visa 4 digit cvc code'



# helper functions
format = (value, trigger, expected_value, message) ->
    $cvc = $('<input type=text>').formance('format_credit_card_cvc')
                                .val(value)
    e = $.Event('keypress')
    e.which = trigger
    $cvc.trigger(e)

    assert.equal $cvc.val(), expected_value, message

validate = (value, valid, message) ->
    $cvc = $('<input type=text>').val(value)
    assert.equal $cvc.formance('validate_credit_card_cvc'), valid, message

validate_with_card_type = (value, card, valid, message) ->
    $cvc = $('<input type=text>').val(value)
                                  .data('credit_card_type', card)
    assert.equal $cvc.formance('validate_credit_card_cvc'), valid, message
