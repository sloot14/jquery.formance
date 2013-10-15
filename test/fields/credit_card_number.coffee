assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')


describe 'credit_card_number.js', ->

    it 'should format credit card number', ->
        format '4242',               52,         '4242 4',              'appends a space after the first 4 digits'
        format '4242 4242',          52,         '4242 4242 4',         'appends a space after the first 8 digits'
        format '4242 4242 4242',     52,         '4242 4242 4242 4',    'appends a space after the first 12 digits'


    it 'should validate a credit card number', ->
        validate '4242424242424242',        yes,        'contains only spaces'
        validate '4242-4242-4242-4242',     yes,        'contains dashes but is valid'
        validate '4242 4242 4242 4242',     yes,        'contains spaces but is valid'

        validate '4242 4242 4242 4241',     no,         'fails the luhn checker'
        validate '4242 4242 4242 4242 4',   no,         'more than 16 digits'
        validate '4242 4242 4',             no,         'less than 10 digits'

        # special cases
        validate '',                        no,         'empty'
        validate '                ',        no,         'only spaces'
        validate '4424 2424 e4242 4241',    no,         'contains non-digits'


    it 'should validate the credit card number and will check that it returns the expected card type', ->
        # amex begins 37
        validate_number_and_check_card_type '378282246310005',      'amex'
        validate_number_and_check_card_type '371449635398431',      'amex'
        validate_number_and_check_card_type '378734493671000',      'amex'

        validate_number_and_check_card_type '30569309025904',       'dinersclub'
        validate_number_and_check_card_type '38520000023237',       'dinersclub'

        validate_number_and_check_card_type '6011111111111117',     'discover'
        validate_number_and_check_card_type '6011000990139424',     'discover'

        validate_number_and_check_card_type '3530111333300000',     'jcb'
        validate_number_and_check_card_type '3566002020360505',     'jcb'

        # master card begins with 5
        validate_number_and_check_card_type '5555555555554444',     'mastercard'

        # visa begins 4
        validate_number_and_check_card_type '4111111111111111',     'visa'
        validate_number_and_check_card_type '4012888888881881',     'visa'
        validate_number_and_check_card_type '4222222222222',        'visa'

        validate_number_and_check_card_type '6759649826438453',     'maestro'

        validate_number_and_check_card_type '6271136264806203568',   'unionpay'
        validate_number_and_check_card_type '6236265930072952775',   'unionpay'
        validate_number_and_check_card_type '6204679475679144515',   'unionpay'
        validate_number_and_check_card_type '6216657720782466507',   'unionpay'


    it 'should fail when asking for card type when dealing with special cases', ->
        # special cases
        check_card_type 'aeou',         'unknown',         'invalid card number'
        check_card_type '9999',         'unknown',         'has unrecognixed beginning numbers'



format = (value, trigger, expected_value, message) ->
    $number = $('<input type=text>').formance('format_credit_card_number')
                                  .val(value)

    e = $.Event('keypress')
    e.which = trigger
    $number.trigger(e)

    assert.equal $number.val(), expected_value, message

validate_number_and_check_card_type = (value, card) ->
    validate            value,      yes,    "#{card} - #{value}"
    check_card_type     value,      card,   "#{card} - #{value}"

validate = (value, valid, message) ->
    $number = $('<input type=text>').val(value)
    assert.equal $number.formance('validate_credit_card_number'), valid, message

check_card_type = (value, card, message) ->
    $number = $('<input type=text>').formance('format_credit_card_number')
                                    .val(value)
                                    .trigger( $.Event('keyup') )
    assert.equal $number.hasClass(card),    yes,     "#{card} - #{value}"
