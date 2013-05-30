assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../lib/formance.js')
# require('../lib/jquery.formance.js')
# require('../lib/fields/date.js')


describe 'date.js', ->

	describe 'formatDate', ->

		it 'should format day correctly single digit', ->
			$date = $('<input type=text>').formance('formatDate')

			e = $.Event('keypress')
			e.which = 52 # '4'
			$date.trigger(e)

			assert.equal $date.val(), '04 / '

		it 'should format day correctly double digit', ->
			$date = $('<input type=text>').formance('formatDate')
			$date.val('2')

			e = $.Event('keypress')
			e.which = 52 # '4'
			$date.trigger(e)

			assert.equal $date.val(), '24 / '

		it 'should format forward slash shorthand correctly', ->
			$date = $('<input type=text>').formance('formatDate')
			$date.val('1')

			e = $.Event('keypress');
			e.which = 47 # '/'
			$date.trigger(e)

			assert.equal $date.val(), '01 / '

		it 'should format month correctly single digit', ->
			$date = $('<input type=text>').formance('formatDate')
			$date.val('04 / ')

			e = $.Event('keypress')
			e.which = 57 # '9'
			$date.trigger(e)

			assert.equal $date.val(), '04 / 09 / '

		it 'should format day correctly double digit', ->
			$date = $('<input type=text>').formance('formatDate')
			$date.val('24 / 1')

			e = $.Event('keypress')
			e.which = 50 # '2'
			$date.trigger(e)

			assert.equal $date.val(), '24 / 12 / '

		it 'should format forward slash shorthand correctly', ->
			$date = $('<input type=text>').formance('formatDate')
			$date.val('24 / 1')

			e = $.Event('keypress');
			e.which = 47 # '/'
			$date.trigger(e)

			assert.equal $date.val(), '24 / 01 / '

		it 'should only allow numbers', ->
			$date = $('<input type=text>').formance('formatDate')
			$date.val('01 / 12 / ')

			e = $.Event('keypress');
			e.which = 100 # 'd'
			$date.trigger(e)

			assert.equal $date.val(), '01 / 12 / '


	describe 'Validating a date', ->

		it 'that is a valid day', ->
			date = new Date()
			topic = $.formance.validateDate date.getDay(), date.getMonth(), date.getFullYear()
			assert.equal topic, true

		it 'that has string numbers', ->
			date = new Date()
			topic = $.formance.validateDate date.getDay()+'', date.getMonth()+'', date.getFullYear()+''
			assert.equal topic, true

		it 'that has an invalid day', ->
			# TODO can have better logic, for example selecting 31 of february
			topic = $.formance.validateDate -1, 12, 2013
			assert.equal topic, false

			topic = $.formance.validateDate 32, 12, 2013
			assert.equal topic, false

		it 'that has an invalid month', ->
			topic = $.formance.validateDate 1, -11, 2013
			assert.equal topic, false

			topic = $.formance.validateDate 1, 13, 2013
			assert.equal topic, false

		it 'that has an invalid year', ->
			topic = $.formance.validateDate 1, 12, -2013
			assert.equal topic, false

		it 'should not support year shorthand', ->
			topic = $.formance.validateDate 1, 12, 13
			assert.equal topic, false

		it 'should fail if any value is NaN', ->
			topic = $.formance.validateDate NaN, 12, 13
			assert.equal topic, false

			topic = $.formance.validateDate 1, NaN, 13
			assert.equal topic, false

			topic = $.formance.validateDate 1, 12, NaN
			assert.equal topic, false


	describe 'Parsing a date', ->

		it 'should parse a date string', ->
			topic = $.formance.dateVal('01 / 07 / 2013')
			assert.deepEqual topic, {day: 1, month: 7, year: 2013}

		# it is up to the validator to determine if it is a legitimate date
		it 'should parse if less than 8 digits', ->
			topic = $.formance.dateVal '1 / 07 / 2013'
			assert.deepEqual topic, {day: 1, month: 7, year: 2013}

			topic = $.formance.dateVal '01 / 07 / 201'
			assert.deepEqual topic, {day: 1, month: 7, year: 201}

		# it is up to the validator to determine if it is a legitimate date
		it 'should parse if more than 8 digits', ->
			topic = $.formance.dateVal '011 / 07 / 2013'
			assert.deepEqual topic, {day: 11, month: 7, year: 2013}

			topic = $.formance.dateVal '01 / 072 / 2013'
			assert.deepEqual topic, {day: 1, month: 72, year: 2013}

			topic = $.formance.dateVal '01 / 07 / 20133'
			assert.deepEqual topic, {day: 1, month: 7, year: 20133}

		it 'should return NaN when it cannot parse', ->
			topic = $.formance.dateVal('dd / 07 / 2013')
			assert.equal !!topic.day, false

			topic = $.formance.dateVal('01 / mm / 2013')
			assert.equal !!topic.month, false

			topic = $.formance.dateVal('01 / 07 / yyyy')  #not '01 / 07 / 20yy' will work
			assert.equal !!topic.year, false

			topic = $.formance.dateVal('            ')
			assert.equal !!topic.day, false
			assert.equal !!topic.month, false
			assert.equal !!topic.year, false
