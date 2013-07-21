assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'ontario_drivers_license_number.js', ->
    
    describe 'formatOntarioDriversLicenseNumber', ->

        it 'should format first five characters correctly', ->
            $odln = $('<input type=text>').formance('formatOntarioDriversLicenseNumber')
            $odln.val('A123')

            e = $.Event('keypress')
            e.which = '52' # '4' 
            $odln.trigger(e)

            assert.equal 'A1234 - ', $odln.val()

        it 'should format middle five correctly', ->
            $odln = $('<input type=text>').formance('formatOntarioDriversLicenseNumber')
            $odln.val('A1234 - 1234')

            e = $.Event('keypress')
            e.which = '53' # '5'
            $odln.trigger(e)

            assert.equal 'A1234 - 12345 - ', $odln.val()


        it 'should allow letters as first character', ->
            $odln = $('<input type=text>').formance('formatOntarioDriversLicenseNumber')
            $odln.val('')

            e = $.Event('keypress')
            e.which = '65' # 'a'
            $odln.trigger(e)

            assert.equal 'A', $odln.val()

        it 'should not numbers as the first character', ->
            $odln = $('<input type=text>').formance('formatOntarioDriversLicenseNumber')
            $odln.val('')

            e = $.Event('keypress')
            e.which = '53' # '5'
            $odln.trigger(e)

            assert.equal '', $odln.val()

        it 'should allow digits for all characters except the first', ->
            $odln = $('<input type=text>').formance('formatOntarioDriversLicenseNumber')
            $odln.val('A')

            e = $.Event('keypress')
            e.which = '53' # '5'
            $odln.trigger(e)

            assert.equal 'A5', $odln.val()

        it 'should not allow letters for all characters except the first', ->
            $odln = $('<input type=text>').formance('formatOntarioDriversLicenseNumber')
            $odln.val('A5')

            e = $.Event('keypress')
            e.which = '65' # 'a'
            $odln.trigger(e)

            assert.equal 'A5', $odln.val()

        # add tests for backspacing


    describe 'Validating an ontario drivers license number', ->

        it 'should fail if empty', ->
            topic = $.formance.validateOntarioDriversLicenseNumber ''
            assert.equal false, topic

        it 'should fail ig it is a bunch of space', ->
            topic = $.formance.validateOntarioDriversLicenseNumber '             '
            assert.equal false, topic

        it 'should succeed if valid', ->
            topic = $.formance.validateOntarioDriversLicenseNumber 'A12341234512345'
            assert.equal true, topic

        it 'has dashes and spaces but is valid', ->
            topic = $.formance.validateOntarioDriversLicenseNumber 'A1234 - 12345 - 12345'
            assert.equal true, topic

        it 'should fail if more than 12 characters', ->
            topic = $.formance.validateOntarioDriversLicenseNumber 'A1234 - 12345 - 123456'
            assert.equal false, topic

            topic = $.formance.validateOntarioDriversLicenseNumber 'A12345 - 12345 - 12345'
            assert.equal false, topic

        it 'should fail with non alphanumeric characters', ->
            topic = $.formance.validateOntarioDriversLicenseNumber 'A1234 ;- 12/345 - 12345'
            assert.equal false, topic
