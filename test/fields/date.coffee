assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'date.js', ->

    describe 'Validating a date', ->

        it 'that is a valid day', ->
            date = new Date()
            topic = $.formance.validateDate date.getDate(), date.getMonth(), date.getFullYear()
            assert.equal true, topic

        it 'that has string numbers', ->
            date = new Date()
            topic = $.formance.validateDate date.getDate()+'', date.getMonth()+'', date.getFullYear()+''
            assert.equal true, topic

        it 'that has an invalid day', ->
            # TODO can have better logic, for example selecting 31 of february
            topic = $.formance.validateDate -1, 12, 2013
            assert.equal false, topic

            topic = $.formance.validateDate 32, 12, 2013
            assert.equal false, topic

        it 'that has an invalid month', ->
            topic = $.formance.validateDate 1, -11, 2013
            assert.equal false, topic

            topic = $.formance.validateDate 1, 13, 2013
            assert.equal false, topic

        it 'that has an invalid year', ->
            topic = $.formance.validateDate 1, 12, -2013
            assert.equal false, topic

        it 'should not support year shorthand', ->
            topic = $.formance.validateDate 1, 12, 13
            assert.equal false, topic

        it 'should fail if any value is NaN', ->
            topic = $.formance.validateDate NaN, 12, 13
            assert.equal false, topic

            topic = $.formance.validateDate 1, NaN, 13
            assert.equal false, topic

            topic = $.formance.validateDate 1, 12, NaN
            assert.equal false, topic