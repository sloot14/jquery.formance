assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../lib/jquery.formance.js')

describe 'jquery.formance.js', ->


# TODO
# looks at how to curry these methods, so we can do
# format_dd_mm_yyyy = format.curry('format_dd_mm_yyyy')

format = (field, value, trigger, expected_value, message) ->
    $field = $('<input type=text>').formance(field)
                                  .val(value)

    e = $.Event('keypress')
    e.which = trigger
    $field.trigger(e)

    assert.equal $field.val(), expected_value, message
