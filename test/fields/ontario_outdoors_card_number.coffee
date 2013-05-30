assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../lib/formance.js')
# require('../lib/jquery.formance.js')
# require('../lib/fields/ontario_outdoors_card_number.js')


describe 'ontario_outdoors_card_number.js', ->
	
	describe 'formatOntarioOutdoorsCardNumber', ->

		it 'should format the first 6 fixed numbers correctly', ->
			$oocn = $('<input type=text>').formance('formatOntarioOutdoorsCardNumber')

			e = $.Event('keypress')
			e.which = 55 # '7'
			$oocn.trigger(e)

			assert.equal '708158 ', $oocn.val()

		it 'should only allow numbers', ->
			$oocn = $('<input type=text>').formance('formatOntarioOutdoorsCardNumber')
			$oocn.val('708158 4')

			e = $.Event('keypress')
			e.which = 100 # 'd'
			$oocn.trigger(e)

			assert.equal '708158 4', $oocn.val()

		it 'should only allow numbers', ->
			$oocn = $('<input type=text>').formance('formatOntarioOutdoorsCardNumber')

			e = $.Event('keypress')
			e.which = 100 # 'd'
			$oocn.trigger(e)

			assert.equal '', $oocn.val()

	describe 'Validating an Ontario outdoors card number', ->

		it 'should fail if empty', ->
			topic = $.formance.validateOntarioOutdoorsCardNumber ''
			assert.equal false, topic

		it 'should fail if it is a bunch of spaces', ->
			topic = $.formance.validateOntarioOutdoorsCardNumber '                  '
			assert.equal false, topic

		it 'should succeed if valid', ->
			topic = $.formance.validateOntarioOutdoorsCardNumber '708158123456789'
			assert.equal true, topic

		it 'has spaces but is valid', ->
			topic = $.formance.validateOntarioOutdoorsCardNumber '708158 123456789'
			assert.equal true, topic

		it 'should fail if more than 10 digits', ->
			topic = $.formance.validateOntarioOutdoorsCardNumber '708158 1234567890'
			assert.equal false, topic

		it 'should fail if less than 10 digits', ->
			topic = $.formance.validateOntarioOutdoorsCardNumber '708158 12345678'
			assert.equal false, topic

		it 'should fail with non digits', ->
			topic = $.formance.validateOntarioOutdoorsCardNumber '708158 - ;123456789'
			assert.equal false, topic