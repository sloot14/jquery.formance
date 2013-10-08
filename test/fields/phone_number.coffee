assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'phone_number.js', ->

    it 'should format the phone number', ->
        format '',                  52,       '(4',               'appends a ( after the first digit'
        format '(61',               52,       '(614) ',           'appends a ) after the first 3 digits'
        format '(614) 12',          52,       '(614) 124 - ',     'appends a - after the first 6 digits'

        format '(614) 12',          100,      '(614) 12',         'does not allow non-digits'

    it 'should validate the phone number', ->
        validate '6131231234',          yes,        'valid'
        validate '613 123 1234',        yes,        'valid with spaces'
        validate '(613) 123 - 1234',    yes,        'valid with brackets and dashes'

        validate '',                    no,         'empty'
        validate '          ',          no,         'only spaces'
        validate '(123) 12 - 1234',     no,         'less than 10 digits'
        validate '(123) 123 - 12345',   no,         'more than 10 digits'
        validate '(123) 123e - 12345',  no,         'contains non-digits'



format = (value, trigger, expected_value, message) ->
    $phone_number = $('<input type=text>').formance('format_phone_number')
                                  .val(value)

    e = $.Event('keypress')
    e.which = trigger
    $phone_number.trigger(e)

    assert.equal $phone_number.val(), expected_value, message

validate = (value, valid, message) ->
    $phone_number = $('<input type=text>').val(value)
    assert.equal $phone_number.formance('validate_phone_number'), valid, message
