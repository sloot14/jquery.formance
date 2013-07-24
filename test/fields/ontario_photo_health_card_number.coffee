assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'ontario_photo_health_card_number.js', ->

    describe 'format_ontario_photo_health_card_number', ->

        it 'should format first four digits correctly', ->
            $ophcn = $('<input type=text>').formance('format_ontario_photo_health_card_number')
            $ophcn.val('123')

            e = $.Event('keypress')
            e.which = '52'
            $ophcn.trigger(e)

            assert.equal '1234 - ', $ophcn.val()

        it 'should format second three correctly', ->
            $ophcn = $('<input type=text>').formance('format_ontario_photo_health_card_number')
            $ophcn.val('1234 - 12')

            e = $.Event('keypress')
            e.which = '51' # '3'
            $ophcn.trigger(e)

            assert.equal '1234 - 123 - ', $ophcn.val()

        it 'should format third three correctly', ->
            $ophcn = $('<input type=text>').formance('format_ontario_photo_health_card_number')
            $ophcn.val('1234 - 123 - 12')

            e = $.Event('keypress')
            e.which = '51' # '3'
            $ophcn.trigger(e)

            assert.equal '1234 - 123 - 123 - ', $ophcn.val()


        it 'should format last two correctly', ->
            $ophcn = $('<input type=text>').formance('format_ontario_photo_health_card_number')
            $ophcn.val('1234 - 123 - 123 - ')

            e = $.Event('keypress')
            e.which = '65' # 'a'
            $ophcn.trigger(e)

            assert.equal $ophcn.val(), '1234 - 123 - 123 - A'

        it 'should not allow letters in the number part', ->
            $ophcn = $('<input type=text>').formance('format_ontario_photo_health_card_number')
            $ophcn.val('12')

            e = $.Event('keypress')
            e.which = '65' # 'a'
            $ophcn.trigger(e)

            assert.equal '12', $ophcn.val()

        it 'should not allow numbers in the version code', ->
            $ophcn = $('<input type=text>').formance('format_ontario_photo_health_card_number')
            $ophcn.val('1234 - 123 - 123 - ')

            e = $.Event('keypress')
            e.which = '51' # '3'
            $ophcn.trigger(e)

            assert.equal '1234 - 123 - 123 - ', $ophcn.val()

        # add tests for backspacing


    describe 'Validating an ontario photo health card number', ->

        it 'should fail if empty', ->
            $ophcn = $('<input type=text>').val('')
            assert.equal false, $ophcn.formance('validate_ontario_photo_health_card_number')

        it 'should fail ig it is a bunch of space', ->
            $ophcn = $('<input type=text>').val('             ')
            assert.equal false, $ophcn.formance('validate_ontario_photo_health_card_number')

        it 'should succeed if valid', ->
            $ophcn = $('<input type=text>').val('1234123123AB')
            assert.equal true, $ophcn.formance('validate_ontario_photo_health_card_number')

        it 'has dashes and spaces but is valid', ->
            $ophcn = $('<input type=text>').val('1234 - 123 - 123 - AB')
            assert.equal true, $ophcn.formance('validate_ontario_photo_health_card_number')

        it 'should fail if version code is not included', ->
            $ophcn = $('<input type=text>').val('1234 - 123 - 123 - ')
            assert.equal false, $ophcn.formance('validate_ontario_photo_health_card_number')

        it 'should fail if more than 12 characters', ->
            $ophcn = $('<input type=text>').val('1234 - 123 - 123 - ABC')
            assert.equal false, $ophcn.formance('validate_ontario_photo_health_card_number')

            $ophcn = $('<input type=text>').val('1234 - 1233 - 123 - AB')
            assert.equal false, $ophcn.formance('validate_ontario_photo_health_card_number')

        it 'should fail with non alphanumeric characters', ->
            $ophcn = $('<input type=text>').val('1234; - 1233 - ;/123 -/ AB')
            assert.equal false, $ophcn.formance('validate_ontario_photo_health_card_number')
