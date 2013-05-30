assert = require('assert')
$      = require('jquery')
global.jQuery = $


require('../lib/jquery.formance.js')


describe 'credit_card_cvc.js', ->
	
	describe 'Validating a CVC without credit card type', ->
		it 'should fail if is empty', ->
			topic = $.formance.validateCreditCardCVC ''
			assert.equal topic, false

		it 'should pass if is valid', ->
			topic = $.formance.validateCreditCardCVC '123'
			assert.equal topic, true

		it 'should fail with non-digits', ->
			topic = $.formance.validateCreditCardCVC '12e'
			assert.equal topic, false

		it 'should fail with less than 3 digits', ->
			topic = $.formance.validateCreditCardCVC '12'
			assert.equal topic, false

		it 'should fail with more than 4 digits', ->
			topic = $.formance.validateCreditCardCVC '12345'
			assert.equal topic, false

	describe 'Validating a CVC with credit card type', ->

		it 'should validate a three digit number with no card type', ->
			topic = $.formance.validateCreditCardCVC('123')
			assert.equal topic, true

		it 'should validate a three digit number with card type amex', ->
			topic = $.formance.validateCreditCardCVC('123', 'amex')
			assert.equal topic, true

		it 'should validate a three digit number with card type other than amex', ->
			topic = $.formance.validateCreditCardCVC('123', 'visa')
			assert.equal topic, true

		it 'should not validate a four digit number with a card type other than amex', ->
			topic = $.formance.validateCreditCardCVC('1234', 'visa')
			assert.equal topic, false

		it 'should validate a four digit number with card type amex', ->
			topic = $.formance.validateCreditCardCVC('1234', 'amex')
			assert.equal topic, true

		it 'should not validate a number larger than 4 digits', ->
			topic = $.formance.validateCreditCardCVC('12344')
			assert.equal topic, false


