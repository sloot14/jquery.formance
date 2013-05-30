assert = require('assert')
$      = require('jquery')
global.jQuery = $


require('../lib/jquery.formance.js')


describe 'credit_card_number.js', ->

	describe 'formatCreditCardNumber', ->

		it 'should format cc number correctly', ->
			$number = $('<input type=text>').formance('formatCreditCardNumber')
			$number.val('4242')

			e = $.Event('keypress');
			e.which = 52 # '4'
			$number.trigger(e)

			assert.equal $number.val(), '4242 4'


	describe 'Validating a card number', ->

		it 'should fail if empty', ->
			topic = $.formance.validateCreditCardNumber ''
			assert.equal topic, false

		it 'should fail if is a bunch of spaces', ->
			topic = $.formance.validateCreditCardNumber '                 '
			assert.equal topic, false

		it 'should success if is valid', ->
			topic = $.formance.validateCreditCardNumber '4242424242424242'
			assert.equal topic, true

		it 'that has dashes in it but is valid', ->
			topic = $.formance.validateCreditCardNumber '4242-4242-4242-4242'
			assert.equal topic, true

		it 'should succeed if it has spaces in it but is valid', ->
			topic = $.formance.validateCreditCardNumber '4242 4242 4242 4242'
			assert.equal topic, true

		it 'that does not pass the luhn checker', ->
			topic = $.formance.validateCreditCardNumber '4242424242424241'
			assert.equal topic, false

		it 'should fail if is more than 16 digits', ->
			topic = $.formance.validateCreditCardNumber '42424242424242424'
			assert.equal topic, false

		it 'should fail if is less than 10 digits', ->
			topic = $.formance.validateCreditCardNumber '424242424'
			assert.equal topic, false

		it 'should fail with non-digits', ->
			topic = $.formance.validateCreditCardNumber '4242424e42424241'
			assert.equal topic, false

		it 'should validate for all card types', ->
			assert($.formance.validateCreditCardNumber('378282246310005'), 'amex')
			assert($.formance.validateCreditCardNumber('371449635398431'), 'amex')
			assert($.formance.validateCreditCardNumber('378734493671000'), 'amex')

			assert($.formance.validateCreditCardNumber('30569309025904'), 'dinersclub')
			assert($.formance.validateCreditCardNumber('38520000023237'), 'dinersclub')

			assert($.formance.validateCreditCardNumber('6011111111111117'), 'discover')
			assert($.formance.validateCreditCardNumber('6011000990139424'), 'discover')

			assert($.formance.validateCreditCardNumber('3530111333300000'), 'jcb')
			assert($.formance.validateCreditCardNumber('3566002020360505'), 'jcb')

			assert($.formance.validateCreditCardNumber('5555555555554444'), 'mastercard')

			assert($.formance.validateCreditCardNumber('4111111111111111'), 'visa')
			assert($.formance.validateCreditCardNumber('4012888888881881'), 'visa')
			assert($.formance.validateCreditCardNumber('4222222222222'), 'visa')

			assert($.formance.validateCreditCardNumber('6759649826438453'), 'maestro')

			assert($.formance.validateCreditCardNumber('6271136264806203568'), 'unionpay')
			assert($.formance.validateCreditCardNumber('6236265930072952775'), 'unionpay')
			assert($.formance.validateCreditCardNumber('6204679475679144515'), 'unionpay')
			assert($.formance.validateCreditCardNumber('6216657720782466507'), 'unionpay')


	describe 'Getting a card type', ->

		it 'should return Visa that begins with 40', ->
			topic = $.formance.creditCardType '4012121212121212'
			assert.equal topic, 'visa'

		it 'that begins with 5 should return MasterCard', ->
			topic = $.formance.creditCardType '5555555555554444'
			assert.equal topic, 'mastercard'

		it 'that begins with 34 should return American Express', ->
			topic = $.formance.creditCardType '3412121212121212'
			assert.equal topic, 'amex'

		it 'that is not numbers should return null', ->
			topic = $.formance.creditCardType 'aoeu'
			assert.equal topic, null

		it 'that has unrecognized beginning numbers should return null', ->
			topic = $.formance.creditCardType 'aoeu'
			assert.equal topic, null

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
