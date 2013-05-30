assert = require('assert')
$      = require('jquery')
global.jQuery = $


require('../lib/jquery.formance.js')


describe 'ontario_photo_health_card_number.js', ->
	

	describe 'formatOntarioPhotoHealthCardNumber', ->
		
		it 'should format first four digits correctly', ->
			$ophcn = $('<input type=text>').formance('formatOntarioPhotoHealthCardNumber')
			$ophcn.val('123')

			e = $.Event('keypress')
			e.which = '52'
			$ophcn.trigger(e)

			assert.equal $ophcn.val(), '1234 - '

		it 'should format second three correctly', ->
			$ophcn = $('<input type=text>').formance('formatOntarioPhotoHealthCardNumber')
			$ophcn.val('1234 - 12')

			e = $.Event('keypress')
			e.which = '51' # '3'
			$ophcn.trigger(e)

			assert.equal $ophcn.val(), '1234 - 123 - '

		it 'should format third three correctly', ->
			$ophcn = $('<input type=text>').formance('formatOntarioPhotoHealthCardNumber')
			$ophcn.val('1234 - 123 - 12')

			e = $.Event('keypress')
			e.which = '51' # '3'
			$ophcn.trigger(e)

			assert.equal $ophcn.val(), '1234 - 123 - 123 - '

		# it 'should only allow alphanumeric characters', ->

		# it 'should only allow letters for last 2 characters', -> 

		# add tests for backspacing


	describe 'Validating an ontario photo health card number', ->

		it 'should fail if empty', ->
			topic = $.formance.validateOntarioPhotoHealthCardNumber ''
			assert.equal topic, false

		it 'should fail ig it is a bunch of space', ->
			topic = $.formance.validateOntarioPhotoHealthCardNumber '             '
			assert.equal topic, false

		it 'should succeed if valid', ->
			topic = $.formance.validateOntarioPhotoHealthCardNumber '1234123123AB'
			assert.equal topic, true

		it 'has dashes and spaces but is valid', ->
			topic = $.formance.validateOntarioPhotoHealthCardNumber '1234 - 123 - 123 - AB'
			assert.equal topic, true

		it 'should fail if more than 12 characters', ->
			topic = $.formance.validateOntarioPhotoHealthCardNumber '1234 - 123 - 123 - ABC'
			assert.equal topic, false
	
			topic = $.formance.validateOntarioPhotoHealthCardNumber '1234 - 1233 - 123 - AB'
			assert.equal topic, false

		it 'should fail with non alphanumeric characters', ->
			topic = $.formance.validateOntarioPhotoHealthCardNumber '1234; - 123 - ;/123 -/ AB'
			assert.equal topic, false