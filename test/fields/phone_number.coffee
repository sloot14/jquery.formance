assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'phone_number.js', ->

    describe 'format_phone_number', ->

        it 'should format first digit correctly', ->
            $phone_number = $('<input type=text>').formance('format_phone_number')

            e = $.Event('keypress')
            e.which = 52
            $phone_number.trigger(e)

            assert.equal '(4', $phone_number.val()

        it 'should format area code correctly', ->
            $phone_number = $('<input type=text>').formance('format_phone_number')
            $phone_number.val('(61')

            e = $.Event('keypress')
            e.which = 52
            $phone_number.trigger(e)

            assert.equal '(614) ', $phone_number.val()

        it 'should format first three correctly', ->
            $phone_number = $('<input type=text>').formance('format_phone_number')
            $phone_number.val('(614) 12')

            e = $.Event('keypress')
            e.which = 52
            $phone_number.trigger(e)

            assert.equal '(614) 124 - ', $phone_number.val()

        it 'should only allow numbers', ->
            $phone_number = $('<input type=text>').formance('format_phone_number')
            $phone_number.val('(61')

            e = $.Event('keypress')
            e.which = 100 # 'd'
            $phone_number.trigger(e)

            assert.equal '(61', $phone_number.val()

        # add tests for backspacing


    describe 'Validating a phone number', ->

        it 'should fail if empty', ->
            $phone_number = $('<input type=text>').val('')
            assert.equal false, $phone_number.formance('validate_phone_number')

        it 'should fail if it is a bunch of spaces', ->
            $phone_number = $('<input type=text>').val('                ')
            assert.equal false, $phone_number.formance('validate_phone_number')

        it 'should succeed if valid', ->
            $phone_number = $('<input type=text>').val('6137384446')
            assert.equal true, $phone_number.formance('validate_phone_number')

        it 'has spaces but is valid', ->
            $phone_number = $('<input type=text>').val('613 738 4446')
            assert.equal true, $phone_number.formance('validate_phone_number')

        it 'has brackets and dashes but is valid', ->
            $phone_number = $('<input type=text>').val('(613) 738 - 4446')
            assert.equal true, $phone_number.formance('validate_phone_number')

        it 'should fail if more than 10 digits', ->
            $phone_number = $('<input type=text>').val('(123) 456 - 78901')
            assert.equal false, $phone_number.formance('validate_phone_number')

        it 'should fail if less than 10 digits', ->
            $phone_number = $('<input type=text>').val('(123) 456 - 789')
            assert.equal false, $phone_number.formance('validate_phone_number')

        it 'should fail with non digits', ->
            $phone_number = $('<input type=text>').val('(123) er456 - 789')
            assert.equal false, $phone_number.formance('validate_phone_number')
