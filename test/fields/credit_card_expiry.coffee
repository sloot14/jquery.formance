assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'credit_card_expiry.js', ->

    it 'should format a credit card expiration date', ->
        format '',      52,     '04 / ',        'prepends the day with a 0 and appends a / when entering a day between 4-9'
        format '1',     47,     '01 / ',        'day shorthand'
        format '1',     100,    '1',            'entered a non digit'


    it 'should validate a credit card expiration date', ->
        currentDate = new Date()
        year = currentDate.getFullYear()
        month = currentDate.getMonth()

        # valid
        validate "#{month+1} / #{year}",                          true,      'expires this year and month'
        validate "#{month+1} / #{year+1}",                        true,      'expires next year'
        validate "#{month+1} / #{(year+1).toString()[2..3]}",     true,      'year is in shorthand form'
        if month isnt 11
            validate "#{month+2} / #{year}",                      true,      'expires next month'

        # already expired
        validate "#{month+1} / #{year-1}",    false,      'expired last year'
        if month isnt 0
            validate "#{month} / #{year}",    false,      'expired last month'

        # less than 6 digits
        validate "1 / #{year+1}",                         true,      'month is valid but less than 2 digits'
        # TODO appears to be passing here, why?
        #validate "01 / #{(year+1).toString()[1..3]}",     false,     'year is less than 4 digits but is not in shorthand form'

        # more than 6 digits
        validate "0#{month+1} / #{year}",     true,      'month is more than 2 digits but is valid'
        validate "1#{month+1} / #{year}",     false,     'month is more than 2 digits and is invalid'
        validate "#{month+1} / 0#{year}",     true,      'year is more than 4 digits but is valid'
        # TODO is it reasonable for this test to pass? If we're basing on a JS Date Object it should.
        validate "#{month+1} / 6#{year}",     true,      'year is more than 4 digits and is valid, though it is 60000 years away'

        # invalid strings
        validate 'mm / 2013',   false,      'month is not a number'
        validate '01 / yyyy',   false,      'year is not a number'


    it 'should parse a credit card expiration date', ->
        currentDate = new Date()
        year = currentDate.getFullYear()
        month = currentDate.getMonth()

        # gets the date with same month and year, but everything else is set to the beginning
        # it is the first day at 00:00:00 of the month and year specified
        expiryDate = new Date(year, month)


        val "#{month+1} / #{year}",                          expiryDate,      'retrieves expiry as a date object when valid'
        val "#{month+1} / #{(year).toString()[2..3]}",       expiryDate,      'retrieves expiry when year is in shorthand'
        val '01 / yy',                                       no,              'retrieves expiry when invalid'



format = (value, trigger, expected_value, message) ->
    $expiry = $('<input type=text>').formance('format_credit_card_expiry')
                                  .val(value)

    e = $.Event('keypress')
    e.which = trigger
    $expiry.trigger(e)

    assert.equal $expiry.val(), expected_value, message

validate = (value, valid, message) ->
    $expiry = $('<input type=text>').val(value)
    assert.equal $expiry.formance('validate_credit_card_expiry'), valid, message

val = (value, expected_value, message) ->
    expiry = $('<input type=text>').val(value).formance('val_credit_card_expiry')
    if typeof(expected_value) is 'boolean'
        assert.equal expiry, expected_value, message
    else
        assert.equal expiry.getTime(), expected_value.getTime(), message
