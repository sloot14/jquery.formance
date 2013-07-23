assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'credit_card_cvc.js', ->

    describe 'Validating a CVC without credit card type', ->

        it 'should fail if is empty', ->
            $cvc = $('<input type=text>').val('')
            assert.equal false, $cvc.formance('validate_credit_card_cvc')

        it 'should pass if is valid', ->
            $cvc = $('<input type=text>').val('123')
            assert.equal true, $cvc.formance('validate_credit_card_cvc')

        it 'should fail with non-digits', ->
            $cvc = $('<input type=text>').val('12e')
            assert.equal false, $cvc.formance('validate_credit_card_cvc')

        it 'should fail with less than 3 digits', ->
            $cvc = $('<input type=text>').val('12')
            assert.equal false, $cvc.formance('validate_credit_card_cvc')

        it 'should fail with more than 4 digits', ->
            $cvc = $('<input type=text>').val('12345')
            assert.equal false, $cvc.formance('validate_credit_card_cvc')

    describe 'Validating a CVC with credit card type', ->

        it 'should validate a three digit number with no card type', ->
            $cvc = $('<input type=text>').val('123')
            assert.equal true, $cvc.formance('validate_credit_card_cvc')

        it 'should validate a three digit number with card type amex', ->
            $cvc = $('<input type=text>').val('123').data('credit_card_type', 'amex')
            assert.equal true, $cvc.formance('validate_credit_card_cvc')

        it 'should validate a three digit number with card type other than amex', ->
            $cvc = $('<input type=text>').val('123').data('credit_card_type', 'visa')
            assert.equal true, $cvc.formance('validate_credit_card_cvc')

        it 'should not validate a four digit number with a card type other than amex', ->
            $cvc = $('<input type=text>').val('1234').data('credit_card_type', 'visa')
            assert.equal false, $cvc.formance('validate_credit_card_cvc')

        it 'should validate a four digit number with card type amex', ->
            $cvc = $('<input type=text>').val('1234').data('credit_card_type', 'amex')
            assert.equal true, $cvc.formance('validate_credit_card_cvc')

        it 'should not validate a number larger than 4 digits', ->
            $cvc = $('<input type=text>').val('12345')
            assert.equal false, $cvc.formance('validate_credit_card_cvc')
