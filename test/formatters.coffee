assert = require('assert')
$      = require('jquery')
global.jQuery = $


require('../src/jquery.formatters')

describe 'formatters.js', ->
	
	describe 'formatDate', ->
		it 'should format day correctly single digit', ->
			$date = $('<input type=text>').formatters('formatDate')

			e = $.Event('keypress')
			e.which = 52 # '4'
			$date.trigger(e)

			assert.equal $date.val(), '04 / '

		it 'should format day correctly double digit', ->
			$date = $('<input type=text>').formatters('formatDate')
			$date.val('2')

			e = $.Event('keypress')
			e.which = 52 # '4'
			$date.trigger(e)

			assert.equal $date.val(), '24 / '

		it 'should format forward slash shorthand correctly', ->
			$date = $('<input type=text>').formatters('formatDate')
			$date.val('1')

			e = $.Event('keypress');
			e.which = 47 # '/'
			$date.trigger(e)

			assert.equal $date.val(), '01 / '

		it 'should format month correctly single digit', ->
			$date = $('<input type=text>').formatters('formatDate')
			$date.val('04 / ')

			e = $.Event('keypress')
			e.which = 57 # '9'
			$date.trigger(e)

			assert.equal $date.val(), '04 / 09 / '

		it 'should format day correctly double digit', ->
			$date = $('<input type=text>').formatters('formatDate')
			$date.val('24 / 1')

			e = $.Event('keypress')
			e.which = 50 # '2'
			$date.trigger(e)

			assert.equal $date.val(), '24 / 12 / '

		it 'should format forward slash shorthand correctly', ->
			$date = $('<input type=text>').formatters('formatDate')
			$date.val('24 / 1')

			e = $.Event('keypress');
			e.which = 47 # '/'
			$date.trigger(e)

			assert.equal $date.val(), '24 / 01 / '

		it 'should only allow numbers', ->
			$date = $('<input type=text>').formatters('formatDate')
			$date.val('01 / 12 / ')

			e = $.Event('keypress');
			e.which = 100 # 'd'
			$date.trigger(e)

			assert.equal $date.val(), '01 / 12 / '


	describe 'formatNumber', ->
		it 'should only allow numbers', ->
			$number = $('<input type=text>').formatters('formatPhoneNumber')
			$number.val('123')

			e = $.Event('keypress');
			e.which = 100 # 'd'
			$number.trigger(e)

			assert.equal $number.val(), '123'




	describe 'formatOntarioHealthCardNumber', ->
		it 'should format first four digits correctly', ->
			$ophc_number = $('<input type=text>').formatters('formatOntarioHealthCardNumber')
			$ophc_number.val('123')

			e = $.Event('keypress')
			e.which = '52'
			$ophc_number.trigger(e)

			assert.equal $ophc_number.val(), '1234 - '

		it 'should format second three correctly', ->
			$ophc_number = $('<input type=text>').formatters('formatOntarioHealthCardNumber')
			$ophc_number.val('1234 - 12')

			e = $.Event('keypress')
			e.which = '51' # '3'
			$ophc_number.trigger(e)

			assert.equal $ophc_number.val(), '1234 - 123 - '

		it 'should format third three correctly', ->
			$ophc_number = $('<input type=text>').formatters('formatOntarioHealthCardNumber')
			$ophc_number.val('1234 - 123 - 12')

			console.log 'herere ------------- '
			console.log $ophc_number.val()

			e = $.Event('keypress')
			e.which = '51' # '3'
			$ophc_number.trigger(e)


			console.log $ophc_number.val()


			assert.equal $ophc_number.val(), '1234 - 123 - 123 - '

		# it 'should only allow alphanumeric characters', ->

		# it 'should only allow letters for last 2 characters', -> 

		# add tests for backspacing



	describe 'formatPhoneNumber', ->
		it 'should format first digit correctly', ->
			$phone_number = $('<input type=text>').formatters('formatPhoneNumber')

			e = $.Event('keypress')
			e.which = '52'
			$phone_number.trigger(e)

			assert.equal $phone_number.val(), '(4'

		it 'should format area code correctly', ->
			$phone_number = $('<input type=text>').formatters('formatPhoneNumber')
			$phone_number.val('(61')

			e = $.Event('keypress')
			e.which = '52'
			$phone_number.trigger(e)

			assert.equal $phone_number.val(), '(614) '

		it 'should format first three correctly', ->
			$phone_number = $('<input type=text>').formatters('formatPhoneNumber')
			$phone_number.val('(614) 12')

			e = $.Event('keypress')
			e.which = '52'
			$phone_number.trigger(e)

			assert.equal $phone_number.val(), '(614) 124 - '

		it 'should only allow numbers', ->
			$phone_number = $('<input type=text>').formatters('formatPhoneNumber')
			$phone_number.val('(61')

			e = $.Event('keypress');
			e.which = 100 # 'd'
			$phone_number.trigger(e)

			assert.equal $phone_number.val(), '(61'

		# add tests for backspacing


	describe 'formatPostalCode', ->
		it 'should format postal code correctly', ->
			$postal_code = $('<input type=text>').formatters('formatPostalCode')
			$postal_code.val('K1')

			e = $.Event('keypress')
			e.which = 72 # 'H'
			$postal_code.trigger(e)

			assert.equal $postal_code.val(), 'K1H '

		it 'should try to insert a letter in place of a number', ->
			$postal_code = $('<input type=text>').formatters('formatPostalCode')
			$postal_code.val('K1H ')

			e = $.Event('keypress')
			e.which = 72 # 'H'
			$postal_code.trigger(e)

			assert.equal $postal_code.val(), 'K1H '

		it 'should try to insert a number in place of a letter', ->
			$postal_code = $('<input type=text>').formatters('formatPostalCode')
			$postal_code.val('K1H 8')

			e = $.Event('keypress')
			e.which = 56 # '8'
			$postal_code.trigger(e)

			assert.equal $postal_code.val(), 'K1H 8'	