assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'postal_code.js', ->

    it 'should format the postal code', ->
        format '',          72,         'H',            'first character is a letter'
        format '',          52,         '',             'does not allow a digit as the first character'

        format 'K',         52,         'K4',           'second character is a digit'
        format 'K',         72,         'K',            'does not allow a letter as the second character'

        format 'K1',        72,         'K1H ',         'third character is a letter'
        format 'K1',        52,         'K1',           'does not allow a digit as the third character'

        format 'K1H ',      52,         'K1H 4',        'fourth character is a digit'
        format 'K1H ',      72,         'K1H ',         'does not allow a letter as the fourth character'

        format 'K1H 1',     72,         'K1H 1H',       'fifth character is a letter'
        format 'K1H 1',     52,         'K1H 1',        'does not allow a digit as the fifth character'

        format 'K1H 1H',    52,         'K1H 1H4',      'sixth character is a digit'
        format 'K1H 1H',    72,         'K1H 1H',       'does not allow a letter as the sixth character'


    it 'should validate the postal code', ->
        validate 'k1h8k9',     yes,        'valid'
        validate 'k1h 8k9',    yes,        'valid with space'
        validate 'K1H 8K9',    yes,        'valid case insensitive'

        validate 'k1h 8k',     no,         'less than 6 characters'
        validate 'k1 8k9',     no,         'less than 6 characters'

        validate 'kk1h 8k9',   no,         'more than 6 characters'
        validate 'k1h 8k99',   no,         'more than 6 characters'

        validate '',           no,         'empty'
        validate '      ',     no,         'only spaces'

        validate 'k1h-8k9',    no,         'contains non-alphanumeric characters'
        validate 'k1h-8k9',    no,         'contains non-alphanumeric characters'

 
format = (value, trigger, expected_value, message) ->
    $postal_code = $('<input type=text>').formance('format_postal_code')
                                  .val(value)

    e = $.Event('keypress')
    e.which = trigger
    $postal_code.trigger(e)

    assert.equal $postal_code.val(), expected_value, message

validate = (value, valid, message) ->
    $postal_code = $('<input type=text>').val(value)
    assert.equal $postal_code.formance('validate_postal_code'), valid, message
