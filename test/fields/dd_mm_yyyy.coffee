assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'dd_mm_yyyy.js', ->

    describe 'formatDDMMYYYY', ->

        it 'should format day correctly single digit', ->
            $date = $('<input type=text>').formance('formatDDMMYYYY')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $date.trigger(e)

            assert.equal '04 / ', $date.val()

        it 'should format day correctly double digit', ->
            $date = $('<input type=text>').formance('formatDDMMYYYY')
            $date.val('2')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $date.trigger(e)

            assert.equal '24 / ', $date.val()

        it 'should format forward slash shorthand correctly', ->
            $date = $('<input type=text>').formance('formatDDMMYYYY')
            $date.val('1')

            e = $.Event('keypress')
            e.which = 47 # '/'
            $date.trigger(e)

            assert.equal '01 / ', $date.val()

        it 'should format month correctly single digit', ->
            $date = $('<input type=text>').formance('formatDDMMYYYY')
            $date.val('04 / ')

            e = $.Event('keypress')
            e.which = 57 # '9'
            $date.trigger(e)

            assert.equal '04 / 09 / ', $date.val()

        it 'should format day correctly double digit', ->
            $date = $('<input type=text>').formance('formatDDMMYYYY')
            $date.val('24 / 1')

            e = $.Event('keypress')
            e.which = 50 # '2'
            $date.trigger(e)

            assert.equal '24 / 12 / ', $date.val()

        it 'should format forward slash shorthand correctly', ->
            $date = $('<input type=text>').formance('formatDDMMYYYY')
            $date.val('24 / 1')

            e = $.Event('keypress')
            e.which = 47 # '/'
            $date.trigger(e)

            assert.equal '24 / 01 / ', $date.val()

        it 'should only allow numbers', ->
            $date = $('<input type=text>').formance('formatDDMMYYYY')
            $date.val('01 / 12 / ')

            e = $.Event('keypress')
            e.which = 100 # 'd'
            $date.trigger(e)

            assert.equal '01 / 12 / ', $date.val()


    describe 'Validating a date', ->
        
        it 'should pass on a valid date', ->
            $date = $('<input type=text>').val('01 / 07 / 2013')
            assert.equal true, $date.formance('validateDDMMYYYY')
    
        it 'if less than 8 digits', ->
            $date = $('<input type=text>').val('1 / 07 / 2013')
            assert.equal true, $date.formance('validateDDMMYYYY')

            $date = $('<input type=text>').val('01 / 7 / 2013')
            assert.equal true, $date.formance('validateDDMMYYYY')
            
            $date = $('<input type=text>').val('01 / 07 / 201')
            assert.equal false, $date.formance('validateDDMMYYYY')
           
        it 'if more than 8 digits', ->
            $date = $('<input type=text>').val('011 / 07 / 2013')
            assert.equal true, $date.formance('validateDDMMYYYY')
            
            $date = $('<input type=text>').val('01 / 072 / 2013')
            assert.equal false, $date.formance('validateDDMMYYYY')

            $date = $('<input type=text>').val('01 / 07 / 20133')
            assert.equal false, $date.formance('validateDDMMYYYY')

        it 'should fail when invalid string', ->
            $date = $('<input type=text>').val('dd / 07 / 2013')
            assert.equal false, $date.formance('validateDDMMYYYY')
            
            $date = $('<input type=text>').val('01 / mm / 2013')
            assert.equal false, $date.formance('validateDDMMYYYY')

            $date = $('<input type=text>').val('01 / 07 / yyyy')
            assert.equal false, $date.formance('validateDDMMYYYY')

            
    describe 'Parsing a Date', ->
        
        it 'should work on a valid string', ->
            $date = $('<input type=text>').val('01 / 07 / 2013')
            assert.equal (new Date(2013, 7-1, 1)).getTime(), $date.formance('valDDMMYYYY').getTime()
    
        it 'should fail on an invalid string', ->
            $date = $('<input type=text>').val('dd / 07 / 2013')
            assert.equal false, $date.formance('valDDMMYYYY')


