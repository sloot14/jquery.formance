assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'credit_card_expiry.js', ->

    describe 'format_credit_card_expiry', ->

        it 'should format month shorthand correctly', ->
            $expiry = $('<input type=text>').formance('format_credit_card_expiry')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $expiry.trigger(e)

            assert.equal '04 / ', $expiry.val()

        it 'should format forward slash shorthand correctly', ->
            $expiry = $('<input type=text>').formance('format_credit_card_expiry')
            $expiry.val('1')

            e = $.Event('keypress')
            e.which = 47 # '/'
            $expiry.trigger(e)

            assert.equal '01 / ', $expiry.val()

        it 'should only allow numbers', ->
            $expiry = $('<input type=text>').formance('format_credit_card_expiry')
            $expiry.val('1')

            e = $.Event('keypress')
            e.which = 100 # 'd'
            $expiry.trigger(e)

            assert.equal '1', $expiry.val()


    describe 'Validating an expiration date', ->

        it 'should fail expires is before the current year', ->
            currentTime = new Date()
            $expiry = $('<input type=text>').val("#{currentTime.getMonth()+1} / #{currentTime.getFullYear()-1}")
            assert.equal false, $expiry.formance('validate_credit_card_expiry')

        it 'that expires in the current year but before current month', ->
            currentTime = new Date()
            if currentTime.getMonth() isnt 0
                $expiry = $('<input type=text>').val("#{currentTime.getMonth()} / #{currentTime.getFullYear()}")
                assert.equal false, $expiry.formance('validate_credit_card_expiry')

        it 'that has an invalid month', ->
            currentTime = new Date()
            $expiry = $('<input type=text>').val("13 / #{currentTime.getFullYear()}")
            assert.equal false, $expiry.formance('validate_credit_card_expiry')

        it 'that is this year and month', ->
            currentTime = new Date()
            $expiry = $('<input type=text>').val("#{currentTime.getMonth()+1} / #{currentTime.getFullYear()}")
            assert.equal true, $expiry.formance('validate_credit_card_expiry')

        it 'that is just after this month', ->
            currentTime = new Date()
            if currentTime.getMonth() isnt 11
                $expiry = $('<input type=text>').val("#{currentTime.getMonth()+2} / #{currentTime.getFullYear()}")
                assert.equal true, $expiry.formance('validate_credit_card_expiry')
                
        it 'that is after this year', ->
            currentTime = new Date()
            $expiry = $('<input type=text>').val("#{currentTime.getMonth()+1} / #{currentTime.getFullYear()+1}")
            assert.equal true, $expiry.formance('validate_credit_card_expiry')

        it 'that has non-numbers', ->
            $expiry = $('<input type=text>').val("mm / 2013")
            assert.equal false, $expiry.formance('validate_credit_card_expiry')

            $expiry = $('<input type=text>').val("07 / yy")
            assert.equal false, $expiry.formance('validate_credit_card_expiry')

        it 'should support year shorthand', ->
            currentTime = new Date()
            $expiry = $('<input type=text>').val("01 / #{(currentTime.getFullYear()+1).toString()[2..3]}")
            assert.equal true, $expiry.formance('validate_credit_card_expiry')


    describe 'Parsing an expiry value', ->

        it 'should parse string expiry', ->
            $expiry = $('<input type=text>').val("01 / 2020")
            assert.equal (new Date(2020, 0)).getTime(), $expiry.formance('val_credit_card_expiry').getTime()

        it 'should support shorthand year', ->
            $expiry = $('<input type=text>').val("01 / 20")
            assert.equal (new Date(2020, 0)).getTime(), $expiry.formance('val_credit_card_expiry').getTime()

        it 'should return NaN when it cannot parse', ->
            $expiry = $('<input type=text>').val("01 / yy")
            assert.equal false, $expiry.formance('val_credit_card_expiry')
