assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'number.js', ->

    describe 'format_number', ->

        it 'should allow numbers', ->
            $number = $('<input />').formance('format_number')
            $number.val('123')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $number.trigger(e)

            assert.equal $number.val(), '1234'

        it 'should not allow non-digits', ->
            $number = $('<input />').formance('format_number')
            $number.val('123')

            e = $.Event('keypress')
            e.which = 100 # 'd'
            $number.trigger(e)

            assert.equal '123', $number.val()

        it 'should allow digits when less than formance length', ->
            $number = $('<input />').data('formance_length', '4')
                                    .formance('format_number')
            $number.val('123')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $number.trigger(e)

            assert.equal '1234', $number.val()

        it 'should not allow digits when more than formance length', ->
            $number = $('<input />').data('formance_length', '4')
                                    .formance('format_number')
            $number.val('1234')

            e = $.Event('keypress')
            e.which = 53 # '5'
            $number.trigger(e)

            assert.equal '1234', $number.val()

        it 'should allow digits when formance length is not a number', ->
            $number = $('<input />').data('formance_length', 'helo')
                                    .formance('format_number')
            $number.val('123')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $number.trigger(e)

            assert.equal '1234', $number.val()


    describe 'Validating a number', ->

        it 'should fail if empty',  ->
            $number = $('<input />').val('')
            assert.equal false, $number.formance('validate_number')

        it 'should fail if it is a bunch of spaces', ->
            $number = $('<input />').val('             ')
            assert.equal false, $number.formance('validate_number')

        it 'should fail with non digits', ->
            $number = $('<input />').val('12345ea')
            assert.equal false, $number.formance('validate_number')

        it 'should succeed if valid', ->
            $number = $('<input />').val('12345')
            assert.equal true, $number.formance('validate_number')

        it 'should succeed with length data attribute specified', ->
            $number = $('<input />').data('formance_length', 4)
                                    .val('1234')
            assert.equal true, $number.formance('validate_number')

        it 'should fail if data length attribute is greater than length', ->
            $number = $('<input />').data('formance_length', 4)
                                    .val('123')
            assert.equal false, $number.formance('validate_number')

        it 'should fail if data length attribute is less than length', ->
            $number = $('<input />').data('formance_length', 4)
                                    .val('12345')
            assert.equal false, $number.formance('validate_number')

        it 'should fail if there are spaces but of the correct length', ->
            $number = $('<input />').data('formance_length', 4)
                                    .val('12 34')
            assert.equal false, $number.formance('validate_number')

        it 'should succeed if formance_length is a number but as a string', ->
            $number = $('<input />').data('formance_length', '4')
                                    .val('1234')
            assert.equal true, $number.formance('validate_number')

        it 'should fail if formance_length is not a number', ->
            $number = $('<input />').data('formance_length', 'hello')
                                    .val('1234')
            assert.equal false, $number.formance('validate_number')

