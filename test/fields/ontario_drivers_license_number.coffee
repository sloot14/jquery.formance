assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')


describe 'ontario_drivers_license_number.js', ->
    
    it 'should format the ontario drivers license number', ->
        format '',                  52,     '',                    'first character cannot be a digit'
        format '',                  65,     'A',                   'first character is a letter'

        format 'A',                 65,     'A',                   'second character cannot be a non-digit'
        format 'A',                 52,     'A4',                  'second character is a digit'

        format 'A123',              52,     'A1234 - ',            'appends a - after the first five characters'
        format 'A1234 - 1234',      53,     'A1234 - 12345 - ',    'appends a - after the first ten characters'

        # add tests for backspacing


    it 'should validate an ontario drivers license number', ->
        validate 'A12341234512345',             yes,        'valid'
        validate 'A1234 - 12345 - 12345',       yes,        'valid with dashes and spaces'

        validate '',                            no,         'empty'
        validate '              ',              no,         'only spaces'
        validate 'A1234 - 12345 - 123456',      no,         'more than 12 characters'
        validate 'A12345 - 12345 - 12345',      no,         'more than 12 characters'
        validate 'A12345 - A2345 - 12345',      no,         'contains letters in spaces meant for digits'
        validate 'A12345 ;- 123/45 - 12345',    no,         'contains non alphanumeric charactes'



format = (value, trigger, expected_value, message) ->
    $odln = $('<input type=text>').formance('format_ontario_drivers_license_number')
                                  .val(value)

    e = $.Event('keypress')
    e.which = trigger
    $odln.trigger(e)

    assert.equal $odln.val(), expected_value, message

validate = (value, valid, message) ->
    $odln = $('<input type=text>').val(value)
    assert.equal $odln.formance('validate_ontario_drivers_license_number'), valid, message
