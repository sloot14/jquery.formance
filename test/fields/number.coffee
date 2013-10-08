assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'number.js', ->

    it 'should format the number', ->
        format '123',       52,     '1234',     'allows digits'
        format '123',       100,    '123',      'does not allow non-digits'


    it 'should format the number when the length is specified', ->
        format_with_length  '123',      4,                  52,      '1234',     'allows when less than length specified'
        format_with_length  '1234',     4,                  52,      '1234',     'does not allows when more than length specified'
        format_with_length  '123',     'unkown length',     52,      '1234',     'does not allows when more than length specified'


    it 'should validate the number', ->

        validate    '12345',        yes,    'contains only digits'
        validate    '',             no,     'empty'
        validate    '      ',       no,     'only spaces'
        validate    '123ea',        no,     'contains non-digits'

    it 'should validate the number when the length is specified', ->
        validate_with_length    '123',      4,              no,        'less than length'
        validate_with_length    '1234',     4,              yes,        'equal to length'
        validate_with_length    '12345',    4,              no,         'greater than length'
        validate_with_length    '12 45',    4,              no,         'equal to length, but it contains spaces'

        #special cases
        validate_with_length    '1234',     '4',            yes,        'length is a number but spcified as a string'
        validate_with_length    '1234',     'unknown',      no,         'length is not a number'



format = (value, trigger, expected_value, message) ->
    $number = $('<input type=text>').formance('format_number')
                                    .val(value)

    e = $.Event('keypress')
    e.which = trigger
    $number.trigger(e)

    assert.equal $number.val(), expected_value, message

format_with_length = (value, length, trigger, expected_value, message) ->
    $number = $('<input type=text>').formance('format_number')
                                    .data('formance_length', length)
                                    .val(value)

    e = $.Event('keypress')
    e.which = trigger
    $number.trigger(e)

    assert.equal $number.val(), expected_value, message

validate = (value, valid, message) ->
    $number = $('<input type=text>').val(value)
    assert.equal $number.formance('validate_number'), valid, message

validate_with_length = (value, length, valid, message) ->
    $number = $('<input type=text>').val(value)
                                    .data('formance_length', length)
    assert.equal $number.formance('validate_number'), valid, message
