assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'postal_code.js', ->

    describe 'format_postal_code', ->

        it 'should format postal code correctly', ->
            $postal_code = $('<input type=text>').formance('format_postal_code')
            $postal_code.val('K1')

            e = $.Event('keypress')
            e.which = 72 # 'H'
            $postal_code.trigger(e)

            assert.equal 'K1H ', $postal_code.val()

        it 'should try to insert a letter in place of a number', ->
            $postal_code = $('<input type=text>').formance('format_postal_code')
            $postal_code.val('K1H ')

            e = $.Event('keypress')
            e.which = 72 # 'H'
            $postal_code.trigger(e)

            assert.equal 'K1H ', $postal_code.val()

        it 'should try to insert a number in place of a letter', ->
            $postal_code = $('<input type=text>').formance('format_postal_code')
            $postal_code.val('K1H 8')

            e = $.Event('keypress')
            e.which = 56 # '8'
            $postal_code.trigger(e)

            assert.equal 'K1H 8', $postal_code.val()


    describe 'Validating a postal code', ->

        it 'should fail if empty', ->
            $postal_code = $('<input type=text>').val('')
            assert.equal false, $postal_code.formance('validate_postal_code')

        it 'should fail if it is a bunch of spaces', ->
            $postal_code = $('<input type=text>').val('          ')
            assert.equal false, $postal_code.formance('validate_postal_code')

        it 'should succeed if valid', ->
            $postal_code = $('<input type=text>').val('k1h8k9')
            assert.equal true, $postal_code.formance('validate_postal_code')

            $postal_code = $('<input type=text>').val('k1h 8k9')
            assert.equal true, $postal_code.formance('validate_postal_code')

        it 'should fail if less than 6 characters', ->
            $postal_code = $('<input type=text>').val('k1h 8k')
            assert.equal false, $postal_code.formance('validate_postal_code')

            $postal_code = $('<input type=text>').val('k1 8k9')
            assert.equal false, $postal_code.formance('validate_postal_code')

        it 'should fail if more than 6 characters', ->
            $postal_code = $('<input type=text>').val('kk1h 8k9')
            assert.equal false, $postal_code.formance('validate_postal_code')

            $postal_code = $('<input type=text>').val('k1h 8k91')
            assert.equal false, $postal_code.formance('validate_postal_code')

        it 'should fail with non alphanumeric characters', ->
            $postal_code = $('<input type=text>').val('k1h-8k9')
            assert.equal false, $postal_code.formance('validate_postal_code')

            $postal_code = $('<input type=text>').val('k1hl8k9')
            assert.equal false, $postal_code.formance('validate_postal_code')
