assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'ontario_outdoors_card_number.js', ->

    describe 'format_ontario_outdoors_card_number', ->

        it 'should format the first 6 fixed numbers correctly', ->
            $oocn = $('<input type=text>').formance('format_ontario_outdoors_card_number')

            e = $.Event('keypress')
            e.which = 55 # '7'
            $oocn.trigger(e)

            assert.equal '708158 ', $oocn.val()

        it 'should only allow numbers', ->
            $oocn = $('<input type=text>').formance('format_ontario_outdoors_card_number')
            $oocn.val('708158 4')

            e = $.Event('keypress')
            e.which = 100 # 'd'
            $oocn.trigger(e)

            assert.equal '708158 4', $oocn.val()

        it 'should only allow numbers', ->
            $oocn = $('<input type=text>').formance('format_ontario_outdoors_card_number')

            e = $.Event('keypress')
            e.which = 100 # 'd'
            $oocn.trigger(e)

            assert.equal '', $oocn.val()

        # it 'should erase 708158 on backspace', ->
        #   $oocn = $('<input type=text>').formance('format_ontario_outdoors_card_number')
        #   $oocn.val('708158 ')

        #   e = $.Event('keypress')
        #   e.which = 8 # backspace
        #   $oocn.trigger(e)

        #   assert.equal '', $oocn.val()


    describe 'Validating an Ontario outdoors card number', ->

        it 'should fail if empty', ->
            $oocn = $('<input type=text>').val('')
            assert.equal false, $oocn.formance('validate_ontario_outdoors_card_number')

        it 'should fail if it is a bunch of spaces', ->
            $oocn = $('<input type=text>').val('               ')
            assert.equal false, $oocn.formance('validate_ontario_outdoors_card_number')

        it 'should succeed if valid', ->
            $oocn = $('<input type=text>').val('708158123456789')
            assert.equal true, $oocn.formance('validate_ontario_outdoors_card_number')

        it 'has spaces but is valid', ->
            $oocn = $('<input type=text>').val('708158 123456789')
            assert.equal true, $oocn.formance('validate_ontario_outdoors_card_number')

        it 'should fail if more than 10 digits', ->
            $oocn = $('<input type=text>').val('708158 1234567890')
            assert.equal false, $oocn.formance('validate_ontario_outdoors_card_number')

        it 'should fail if less than 10 digits', ->
            $oocn = $('<input type=text>').val('708158 12345678')
            assert.equal false, $oocn.formance('validate_ontario_outdoors_card_number')

        it 'should fail with non digits', ->
            $oocn = $('<input type=text>').val('708158 - ;123456789')
            assert.equal false, $oocn.formance('validate_ontario_outdoors_card_number')
