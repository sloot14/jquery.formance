assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'yyyy_mm_dd.js', ->

    it 'should format yyyy_mm_dd', ->
        format '199',                52,         '1994 / ',           'appends a / after the first 4 digits'

        format '1994 / 1',           50,         '1994 / 12 / ',      'appends a / after the first 6 digits'
        format '1994 / ',            57,         '1994 / 09 / ',      'month shorthand, a number between 2-9'
        format '1994 / 1',           47,         '1994 / 01 / ',      'single digit for month followde by a /'

        format '1995 / 01 / ',       57,         '1995 / 01 / 09',    'day shorthand, a number between 4-9'
        format '1996 / 01 / ',       49,         '1996 / 01 / 1',     'entering 1st digit for day'
        format '1997 / 01 / 0',      52,         '1996 / 01 / 04',    'entering 2nd digit for day'

        format '1994 / 01 / 0',      100,        '1994 / 01 / 0',     'does not allow non-digits'


    it 'should validate yyyy_mm_dd', ->
        validate '2013 / 07 / 01',          yes,        'valid date'
        validate '2012 / 02 / 29',          yes,        'valid day, Feb 29 on a leap year'

        validate '2012 / 02 / 00',          no,         'invalid day when 0'
        validate '2012 / 07 / 32',          no,         'invalid day when above 31 (depending on the month)'
        validate '2012 / 04 / 31',          no,         'invalid day when 31 in a month with only 30'
        validate '2013 / 02 / 29',          no,         'invalid day, Feb 29 when not a leap year'
        validate '2013 / 00 / 29',          no,         'invalid month when 0'
        validate '2013 / 13 / 29',          no,         'invalid month when above 12'

        # less than 8 digits
        validate '201 / 07 / 01',           no,        'year is valid but is less than 4 digits'
        validate '2010 / 7 / 01',           yes,       'month is valid but is less than 2 digits'
        validate '2010 / 07 / 1',           yes,       'day is valid but is less than 2 digits'
        
        # more than 8 digits
        #validate '02010 / 07 / 01',         yes,        'year is more than 4 digits but is valid'
        validate '12010 / 07 / 01',         no,         'year is more than 4 digits and is invalid'
        validate '2010 / 012 / 01',         yes,        'month is more than 2 digits but is valid'
        validate '2010 / 072 / 01',         no,         'month is more than 2 digits and is invalid'
        validate '2010 / 07 / 011',         yes,        'day is more than 2 digits but is valid'
        validate '2010 / 07 / 401',         no,         'day is more than 2 digits and is invalid'

        # missing
        validate '/ 07 / 01',               no,         'missing year'
        validate '2010 / / 01',             no,         'missing month'
        validate '2010 / 01 /',             no,         'missing day'

        # invalid strings
        validate 'yyyy / 07 / 01',          no,         'year is not a number'
        validate '2010 / mm / 01',          no,         'month is not a number'
        validate '2010 / 07 / dd',          no,         'day is not a number'


    it 'should return the date value', ->
        val '2013 / 07 / 01',       new Date(2013, 7-1, 1),     'retrieving date value with valid input'
        val 'yyyy / 07 / 01',       no,                         'retrieving date when invalid'



format = (value, trigger, expected_value, message) ->
    $date = $('<input type=text>').formance('format_yyyy_mm_dd')
                                  .val(value)

    e = $.Event('keypress')
    e.which = trigger
    $date.trigger(e)

    assert.equal $date.val(), expected_value, message

validate = (value, valid, message) ->
    $date = $('<input type=text>').val(value)
    assert.equal $date.formance('validate_yyyy_mm_dd'), valid, message

val = (value, expected_value, message) ->
    date = $('<input type=text>').val(value).formance('val_yyyy_mm_dd')
    if typeof(expected_value) is 'boolean'
        assert.equal date, expected_value, message
    else
        assert.equal date.getTime(), expected_value.getTime(), message
