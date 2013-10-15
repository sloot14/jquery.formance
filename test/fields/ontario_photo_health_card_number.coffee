assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'ontario_photo_health_card_number.js', ->

    it 'should format the ontario photo health card number', ->
        format '123',                       52,     '1234 - ',              'appends a - after the first 4 digits'
        format '1234 - 12',                 51,     '1234 - 123 - ',        'appends a - after the first 7 digits'
        format '1234 - 123 - 12',           51,     '1234 - 123 - 123 - ',  'appends a - after the first 10 digits'

        format '1234 - 123 - 12',           65,     '1234 - 123 - 12',       'entering a letter where only digits are allowed'
        format '1234 - 123 - 123 - ',       65,     '1234 - 123 - 123 - A',  'last 2 characters are letters'
        format '1234 - 123 - 123 - ',       52,     '1234 - 123 - 123 - ',   'entering a digit where only letters are allowed'

        # add tests for backspacing

    it 'should validate an ontario photo health card number', ->
        validate '1234123123AB',            yes,        'valid'
        validate '1234 - 123 - 123 - AB',   yes,        'valid with spaces and dashes'
        validate '1234 - 123 - 12A - AB',   no,         'invalid, letters where a digit was expected'

        validate '',                        no,         'empty'
        validate '                  ',      no,         'only spaces'
        validate '1234 - 123 - 123 - ',     no,         'version code is not included'
        validate '1234 - 123 - 123 - ABC',  no,         'more than 12 characters'
        validate '1234 - 1233 - 123 - AB',  no,         'more than 12 characters'
        validate '1234 - 123; - 123 - AB',  no,         'contains non-alphanumeric characters'



format = (value, trigger, expected_value, message) ->
    $ophc = $('<input type=text>').formance('format_ontario_photo_health_card_number')
                                  .val(value)

    e = $.Event('keypress')
    e.which = trigger
    $ophc.trigger(e)

    assert.equal $ophc.val(), expected_value, message

validate = (value, valid, message) ->
    $ophc = $('<input type=text>').val(value)
    assert.equal $ophc.formance('validate_ontario_photo_health_card_number'), valid, message
