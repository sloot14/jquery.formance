assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'number.js', ->

    describe 'formatNumber', ->

        it 'should allow numbers', ->
            $number = $('<input type=text>').formance('formatNumber')
            $number.val('123')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $number.trigger(e)

            assert.equal $number.val(), '1234'

        it 'should not allow non-digits', ->
            $number = $('<input type=text>').formance('formatNumber')
            $number.val('123')

            e = $.Event('keypress')
            e.which = 100 # 'd'
            $number.trigger(e)

            assert.equal '123', $number.val()


    describe 'Validating a number', ->

        it 'should fail if empty',  ->
            topic = $.formance.validateNumber ''
            assert.equal false, topic

        it 'should fail if it is a bunch of spaces', ->
            topic = $.formance.validateNumber '                    '
            assert.equal false, topic

        it 'should succeed if valid', ->
            topic = $.formance.validateNumber '12344'
            assert.equal true, topic

        it 'should fail with non digits', ->
            topic = $.formance.validateNumber '123zaas'
            assert.equal false, topic
