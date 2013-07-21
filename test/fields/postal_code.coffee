assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'postal_code.js', ->

    describe 'formatPostalCode', ->

        it 'should format postal code correctly', ->
            $postal_code = $('<input type=text>').formance('formatPostalCode')
            $postal_code.val('K1')

            e = $.Event('keypress')
            e.which = 72 # 'H'
            $postal_code.trigger(e)

            assert.equal 'K1H ', $postal_code.val()

        it 'should try to insert a letter in place of a number', ->
            $postal_code = $('<input type=text>').formance('formatPostalCode')
            $postal_code.val('K1H ')

            e = $.Event('keypress')
            e.which = 72 # 'H'
            $postal_code.trigger(e)

            assert.equal 'K1H ', $postal_code.val()

        it 'should try to insert a number in place of a letter', ->
            $postal_code = $('<input type=text>').formance('formatPostalCode')
            $postal_code.val('K1H 8')

            e = $.Event('keypress')
            e.which = 56 # '8'
            $postal_code.trigger(e)

            assert.equal 'K1H 8', $postal_code.val()


    describe 'Validating a postal code', ->

        it 'should fail if empty', ->
            topic = $.formance.validatePostalCode ''
            assert.equal false, topic

        it 'should fail if it is a bunch of spaces', ->
            topic = $.formance.validatePostalCode '                    '
            assert.equal false, topic

        it 'should succeed if valid', ->
            topic = $.formance.validatePostalCode 'k1h8k9'
            assert.equal true, topic

            topic = $.formance.validatePostalCode 'k1h 8k9'
            assert.equal true, topic

        it 'should fail if less than 6 characters', ->
            topic = $.formance.validatePostalCode 'k1h 8k'
            assert.equal false, topic

            topic = $.formance.validatePostalCode 'k1 8k9'
            assert.equal false, topic

        it 'should fail if more than 6 characters', ->
            topic = $.formance.validatePostalCode 'kk1h 8k9'
            assert.equal false, topic

            topic = $.formance.validatePostalCode 'k1h 8k91'
            assert.equal false, topic

        it 'should fail with non alphanumeric characters', ->
            topic = $.formance.validatePostalCode 'k1h-8k9'
            assert.equal false, topic

            topic = $.formance.validatePostalCode 'k1h;8k9'
            assert.equal false, topic
