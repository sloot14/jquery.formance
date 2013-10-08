assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')


describe 'credit_card_cvc.js', ->

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
# makes the test a lot clearer and legible
validate = (value, valid, message) ->
    $cvc = $('<input type=text>').val(value)
    assert.equal $cvc.formance('validate_credit_card_cvc'), valid, message

validate_with_card_type = (value, card, valid, message) ->
    $cvc = $('<input type=text>').val(value)
                                  .data('credit_card_type', card)
    assert.equal $cvc.formance('validate_credit_card_cvc'), valid, message
