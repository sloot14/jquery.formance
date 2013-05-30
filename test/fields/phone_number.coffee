assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../lib/formance.js')
# require('../lib/jquery.formance.js')
# require('../lib/fields/phone_number.js')


describe 'phone_number.js', ->

	describe 'formatPhoneNumber', ->

		it 'should format first digit correctly', ->
			$phone_number = $('<input type=text>').formance('formatPhoneNumber')

			e = $.Event('keypress')
			e.which = '52'
			$phone_number.trigger(e)

			assert.equal '(4', $phone_number.val()

		it 'should format area code correctly', ->
			$phone_number = $('<input type=text>').formance('formatPhoneNumber')
			$phone_number.val('(61')

			e = $.Event('keypress')
			e.which = '52'
			$phone_number.trigger(e)

			assert.equal '(614) ', $phone_number.val()

		it 'should format first three correctly', ->
			$phone_number = $('<input type=text>').formance('formatPhoneNumber')
			$phone_number.val('(614) 12')

			e = $.Event('keypress')
			e.which = '52'
			$phone_number.trigger(e)

			assert.equal '(614) 124 - ', $phone_number.val()

		it 'should only allow numbers', ->
			$phone_number = $('<input type=text>').formance('formatPhoneNumber')
			$phone_number.val('(61')

			e = $.Event('keypress');
			e.which = 100 # 'd'
			$phone_number.trigger(e)

			assert.equal '(61', $phone_number.val()

		# add tests for backspacing


	describe 'Validating a phone number', ->

		it 'should fail if empty', ->
			topic = $.formance.validatePhoneNumber ''
			assert.equal false, topic

		it 'should fail if it is a bunch of spaces', ->
			topic = $.formance.validatePhoneNumber '                  '
			assert.equal false, topic

		it 'should succeed if valid', ->
			topic = $.formance.validatePhoneNumber '6137384446'
			assert.equal true, topic

		it 'has spaces but is valid', ->
			topic = $.formance.validatePhoneNumber '613 738 4446'
			assert.equal true, topic

		it 'has brackets and dashes but is valid', ->
			topic = $.formance.validatePhoneNumber '(613) 738 - 4446'
			assert.equal true, topic

		it 'should fail if more than 10 digits', ->
			topic = $.formance.validatePhoneNumber '(123) 456 - 78901'
			assert.equal false, topic

		it 'should fail if less than 10 digits', ->
			topic = $.formance.validatePhoneNumber '(123) 456 - 789'
			assert.equal false, topic

		it 'should fail with non digits', ->
			topic = $.formance.validatePhoneNumber '(123) er456 - 1232'
			assert.equal false, topic

