assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../lib/jquery.formance.js')

describe 'jquery.formance.js', ->

    it 'should restrict to numeric characters', ->
        format_numeric '123',       52,        '1234',          'allows digits'
        format_numeric '123',       100,       '123',           'does not allow letters'
        format_numeric '123',       189,       '123',           'does not allow special characters'

    it 'should restrict to alphanumeric characters', ->
        format_alphanumeric '',     52,         '4',            'allows digits'
        format_alphanumeric '',     68,         'd',            'allows letters'
        format_alphanumeric '',     189,        '',             'does not allow special characters'


# TODO
# looks at how to curry these methods, so we can do
# format_numeric = format.curry('restrictNumeric')
# format_alphanumeric = format.curry('restrictAlphaNumeric')
format_numeric = (value, trigger, expected_value, message) ->
    format 'restrictNumeric', value, trigger, expected_value, message
format_alphanumeric = (value, trigger, expected_value, message) ->
    format 'restrictAlphaNumeric', value, trigger, expected_value, message

format = (field, value, trigger, expected_value, message) ->
    $field = $('<input type=text>').formance(field)
                                  .val(value)

    e = $.Event('keypress')
    e.which = trigger
    $field.trigger(e)

    assert.equal $field.val(), expected_value, message
