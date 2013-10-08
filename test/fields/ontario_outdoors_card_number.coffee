assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'ontario_outdoors_card_number.js', ->

    it 'should format the ontario outdoors card number', ->
        format '',              55,         '708158 ',      'appends 708158, the customary first 6 numbers when leading with a 7'
        format '',              52,         '708158 4',     'appends 708158 plus to the number entered'
        format '',              100,        '',             'only allows digits'
        format '708158 4',      100,        '708158 4',     'only allows digits'
        #format '708158 ',       8,          '',             'backspace when only the first 6 digits remaining'

    it 'should validate the ontario outdoors card number', ->
        validate '708158123456789',     yes,         'valid'
        validate '708158 123456789',    yes,         'valid with spaces'

        validate '',                    no,         'empty'
        validate '          ',          no,         'only spaces'
        validate '123456 1234567890',   no,         'invalid first 6 character, expected 708158'
        validate '708158 1234567890',   no,         'more than 16 digits'
        validate '708158 12345678',     no,         'less than 16 digits'
        validate '708158 - ;12345678',  no,         'contains non digits'


format = (value, trigger, expected_value, message) ->
    $oocn = $('<input type=text>').formance('format_ontario_outdoors_card_number')
                                  .val(value)

    e = $.Event('keypress')
    e.which = trigger
    $oocn.trigger(e)

    assert.equal $oocn.val(), expected_value, message

validate = (value, valid, message) ->
    $oocn = $('<input type=text>').val(value)
    assert.equal $oocn.formance('validate_ontario_outdoors_card_number'), valid, message
