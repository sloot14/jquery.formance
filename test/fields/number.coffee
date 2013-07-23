assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'number.js', ->

    describe 'format_number', ->

        it 'should allow numbers', ->
            $number = $('<input type=text>').formance('format_number')
            $number.val('123')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $number.trigger(e)

            assert.equal $number.val(), '1234'

        it 'should not allow non-digits', ->
            $number = $('<input type=text>').formance('format_number')
            $number.val('123')

            e = $.Event('keypress')
            e.which = 100 # 'd'
            $number.trigger(e)

            assert.equal '123', $number.val()


    describe 'Validating a number', ->

        it 'should fail if empty',  ->
            $number = $('<input type=text>').val('')
            assert.equal false, $number.formance('validate_number')

        it 'should fail if it is a bunch of spaces', ->
            $number = $('<input type=text>').val('             ')
            assert.equal false, $number.formance('validate_number')

        it 'should succeed if valid', ->
            $number = $('<input type=text>').val('12345')
            assert.equal true, $number.formance('validate_number')

        it 'should fail with non digits', ->
            $number = $('<input type=text>').val('12345ea')
            assert.equal false, $number.formance('validate_number')
