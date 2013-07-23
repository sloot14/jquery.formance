assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'credit_card_number.js', ->

    describe 'format_credit_card_number', ->

        it 'should format cc number correctly', ->
            $number = $('<input type=text>').formance('format_credit_card_number')
            $number.val('4242')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $number.trigger(e)

            assert.equal '4242 4', $number.val()


    describe 'Validating a card number', ->

        it 'should fail if empty', ->
            $num = $('<input type=text>').val('')
            assert.equal false, $num.formance('validate_credit_card_number')

        it 'should fail if is a bunch of spaces', ->
            $num = $('<input type=text>').val('                        ')
            assert.equal false, $num.formance('validate_credit_card_number')

        it 'should success if is valid', ->
            $num = $('<input type=text>').val('4242424242424242')
            assert.equal true, $num.formance('validate_credit_card_number')

        it 'that has dashes in it but is valid', ->
            $num = $('<input type=text>').val('4242-4242-4242-4242')
            assert.equal true, $num.formance('validate_credit_card_number')

        it 'should succeed if it has spaces in it but is valid', ->
            $num = $('<input type=text>').val('4242 4242 4242 4242')
            assert.equal true, $num.formance('validate_credit_card_number')

        it 'that does not pass the luhn checker', ->
            $num = $('<input type=text>').val('4242 4242 4242 4241')
            assert.equal false, $num.formance('validate_credit_card_number')

        it 'should fail if is more than 16 digits', ->
            $num = $('<input type=text>').val('4242 4242 4242 4242 4')
            assert.equal false, $num.formance('validate_credit_card_number')

        it 'should fail if is less than 10 digits', ->
            $num = $('<input type=text>').val('4242 4242 4')
            assert.equal false, $num.formance('validate_credit_card_number')

        it 'should fail with non-digits', ->
            $num = $('<input type=text>').val('44242424e42424241')
            assert.equal false, $num.formance('validate_credit_card_number')

        it 'should validate for all card types', ->
            $num = $('<input type=text>')

            assert $num.val('378282246310005').formance('validate_credit_card_number'), 'amex'
            assert $num.val('371449635398431').formance('validate_credit_card_number'), 'amex'
            assert $num.val('378734493671000').formance('validate_credit_card_number'), 'amex'

            assert $num.val('30569309025904').formance('validate_credit_card_number'), 'dinersclub'
            assert $num.val('38520000023237').formance('validate_credit_card_number'), 'dinersclub'

            assert $num.val('6011111111111117').formance('validate_credit_card_number'), 'discover'
            assert $num.val('6011000990139424').formance('validate_credit_card_number'), 'discover'

            assert $num.val('3530111333300000').formance('validate_credit_card_number'), 'jcb'
            assert $num.val('3566002020360505').formance('validate_credit_card_number'), 'jcb'

            assert $num.val('5555555555554444').formance('validate_credit_card_number'), 'mastercard'

            assert $num.val('4111111111111111').formance('validate_credit_card_number'), 'visa'
            assert $num.val('4012888888881881').formance('validate_credit_card_number'), 'visa'
            assert $num.val('4222222222222').formance('validate_credit_card_number'), 'visa'

            assert $num.val('6759649826438453').formance('validate_credit_card_number'), 'maestro'

            assert $num.val('6271136264806203568').formance('validate_credit_card_number'), 'unionpay'
            assert $num.val('6236265930072952775').formance('validate_credit_card_number'), 'unionpay'
            assert $num.val('6204679475679144515').formance('validate_credit_card_number'), 'unionpay'
            assert $num.val('6216657720782466507').formance('validate_credit_card_number'), 'unionpay'


    describe 'Getting a card type', ->

        it 'should return Visa that begins with 40', ->
            topic = $.formance.creditCardType '4012121212121212'
            assert.equal 'visa', topic

        it 'that begins with 5 should return MasterCard', ->
            topic = $.formance.creditCardType '5555555555554444'
            assert.equal 'mastercard', topic

        it 'that begins with 34 should return American Express', ->
            topic = $.formance.creditCardType '3412121212121212'
            assert.equal 'amex', topic

        it 'that is not numbers should return null', ->
            topic = $.formance.creditCardType 'aoeu'
            assert.equal null, topic

        it 'that has unrecognized beginning numbers should return null', ->
            topic = $.formance.creditCardType 'aoeu'
            assert.equal null, topic

        it 'should return correct type for all test numbers', ->
            assert.equal($.formance.creditCardType('378282246310005'), 'amex')
            assert.equal($.formance.creditCardType('371449635398431'), 'amex')
            assert.equal($.formance.creditCardType('378734493671000'), 'amex')

            assert.equal($.formance.creditCardType('30569309025904'), 'dinersclub')
            assert.equal($.formance.creditCardType('38520000023237'), 'dinersclub')

            assert.equal($.formance.creditCardType('6011111111111117'), 'discover')
            assert.equal($.formance.creditCardType('6011000990139424'), 'discover')

            assert.equal($.formance.creditCardType('3530111333300000'), 'jcb')
            assert.equal($.formance.creditCardType('3566002020360505'), 'jcb')

            assert.equal($.formance.creditCardType('5555555555554444'), 'mastercard')

            assert.equal($.formance.creditCardType('4111111111111111'), 'visa')
            assert.equal($.formance.creditCardType('4012888888881881'), 'visa')
            assert.equal($.formance.creditCardType('4222222222222'), 'visa')

            assert.equal($.formance.creditCardType('6759649826438453'), 'maestro')

            assert.equal($.formance.creditCardType('6271136264806203568'), 'unionpay')
            assert.equal($.formance.creditCardType('6236265930072952775'), 'unionpay')
            assert.equal($.formance.creditCardType('6204679475679144515'), 'unionpay')
            assert.equal($.formance.creditCardType('6216657720782466507'), 'unionpay')
