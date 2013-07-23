assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'ontario_drivers_license_number.js', ->
    
    describe 'format_ontario_drivers_license_number', ->

        it 'should format first five characters correctly', ->
            $odln = $('<input type=text>').formance('format_ontario_drivers_license_number')
            $odln.val('A123')

            e = $.Event('keypress')
            e.which = '52' # '4' 
            $odln.trigger(e)

            assert.equal 'A1234 - ', $odln.val()

        it 'should format middle five correctly', ->
            $odln = $('<input type=text>').formance('format_ontario_drivers_license_number')
            $odln.val('A1234 - 1234')

            e = $.Event('keypress')
            e.which = '53' # '5'
            $odln.trigger(e)

            assert.equal 'A1234 - 12345 - ', $odln.val()


        it 'should allow letters as first character', ->
            $odln = $('<input type=text>').formance('format_ontario_drivers_license_number')
            $odln.val('')

            e = $.Event('keypress')
            e.which = '65' # 'a'
            $odln.trigger(e)

            assert.equal 'A', $odln.val()

        it 'should not numbers as the first character', ->
            $odln = $('<input type=text>').formance('format_ontario_drivers_license_number')
            $odln.val('')

            e = $.Event('keypress')
            e.which = '53' # '5'
            $odln.trigger(e)

            assert.equal '', $odln.val()

        it 'should allow digits for all characters except the first', ->
            $odln = $('<input type=text>').formance('format_ontario_drivers_license_number')
            $odln.val('A')

            e = $.Event('keypress')
            e.which = '53' # '5'
            $odln.trigger(e)

            assert.equal 'A5', $odln.val()

        it 'should not allow letters for all characters except the first', ->
            $odln = $('<input type=text>').formance('format_ontario_drivers_license_number')
            $odln.val('A5')

            e = $.Event('keypress')
            e.which = '65' # 'a'
            $odln.trigger(e)

            assert.equal 'A5', $odln.val()

        # add tests for backspacing


    describe 'Validating an ontario drivers license number', ->

        it 'should fail if empty', ->
            $odln = $('<input type=text>').val('')
            assert.equal false, $odln.formance('validate_ontario_drivers_license_number')

        it 'should fail ig it is a bunch of space', ->
            $odln = $('<input type=text>').val('            ')
            assert.equal false, $odln.formance('validate_ontario_drivers_license_number')

        it 'should succeed if valid', ->
            $odln = $('<input type=text>').val('A12341234512345')
            assert.equal true, $odln.formance('validate_ontario_drivers_license_number')

        it 'has dashes and spaces but is valid', ->
            $odln = $('<input type=text>').val('A1234 - 12345 - 12345')
            assert.equal true, $odln.formance('validate_ontario_drivers_license_number')

        it 'should fail if more than 12 characters', ->
            $odln = $('<input type=text>').val('A1234 - 12345 - 123456')
            assert.equal false, $odln.formance('validate_ontario_drivers_license_number')

            $odln = $('<input type=text>').val('A12345 - 12345 - 12345')
            assert.equal false, $odln.formance('validate_ontario_drivers_license_number')

        it 'should fail with non alphanumeric characters', ->
            $odln = $('<input type=text>').val('A1234 ;- 12/345 - 12345')
            assert.equal false, $odln.formance('validate_ontario_drivers_license_number')
