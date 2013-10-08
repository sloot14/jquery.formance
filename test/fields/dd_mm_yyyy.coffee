assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'dd_mm_yyyy.js', ->

    it 'should format the date', ->
        format '2',             52,     '24 / ',        'append a / after the day has been entered'
        format '',              52,     '04 / ',        'day shorthand, a number between 4-9'
        format '1',             47,     '01 / ',        'single digit for day followed by /'
        format '25 / 1',        50,     '25 / 12 / ',   'appends a / after the month has been entered'
        format '04 / ',         57,     '04 / 09 / ',   'single digit for month followed by /'
        format '24 / 1',        47,     '24 / 01 / ',   'month shorthand, a number between 2-9'
        format '24 / 01 / ',    100,    '24 / 01 / ',   'entered a non digit'


    it 'should validate the date', ->
        validate '01 / 07 / 2013',      true,     'valid date'
        validate '29 / 02 / 2012',      true,     'valid day, Feb 29 on a leap year'

        validate '00 / 07 / 2013',      no,       'invalid day when 0'
        validate '32 / 07 / 2013',      no,       'invalid day when above 31 (depending on the month)'
        validate '31 / 04 / 2013',      no,       'invalid day when 31 in a month with only 30'
        validate '29 / 02 / 2013',      no,       'invalid day, Feb 29 when not a leap year'
        validate '01 / 00 / 2013',      no,       'invalid month when 0'
        validate '01 / 13 / 2013',      no,       'invalid month when above 12'

        # less than 8 digits
        validate '1 / 07 / 2013',       true,     'day is valid but is less than two digits'
        validate '01 / 7 / 2013',       true,     'month is valid but is not two digits'
        # inconsistent behavior, why is this no but month and day are not?
        validate '01 / 07 / 201',       no,       'year is valid but is less than 4 digits'

        # more than 8 digits
        validate '011 / 07 / 2013',     true,     'day is more than 2 digits but is valid'
        validate '041 / 07 / 2013',     no,       'day is more than 2 digits and is invalid'
        validate '01 / 012 / 2013',     true,     'month is more than 2 digits but is valid'
        validate '01 / 072 / 2013',     no,       'month is more than 2 digits and is invalid'
        # TODO make it pass
        #validate '01 / 07 / 02013',     true,     'year is more than 4 digits but is valid'
        validate '01 / 07 / 20133',     no,       'year is more than 4 digits and is invalid'

        # missing
        validate ' / 07 / 2013',        no,       'missing day'
        validate '01 / / 2013',         no,       'missing month'
        validate '01 / 07 / ',          no,       'missing year'

        # invalid strings
        validate 'dd / 07 / 2013',      no,       'day is not a number'
        validate '01 / mm / 2013',      no,       'month is not a number'
        validate '01 / 07 / yyyy',      no,       'year is not a number'


    it 'should return the date value', ->
        val '01 / 07 / 2013',       new Date(2013, 7-1, 1),   'retrieving date value with valid input'
        val 'dd / 07 / 2013',       no,                    'retrieving date when invalid'



format = (value, trigger, expected_value, message) ->
    $date = $('<input type=text>').formance('format_dd_mm_yyyy')
                                  .val(value)

    e = $.Event('keypress')
    e.which = trigger
    $date.trigger(e)

    assert.equal $date.val(), expected_value, message

validate = (value, valid, message) ->
    $date = $('<input type=text>').val(value)
    assert.equal $date.formance('validate_dd_mm_yyyy'), valid, message

val = (value, expected_value, message) ->
    date = $('<input type=text>').val(value).formance('val_dd_mm_yyyy')
    if typeof(expected_value) is 'boolean'
        assert.equal date, expected_value, message
    else
        assert.equal date.getTime(), expected_value.getTime(), message
