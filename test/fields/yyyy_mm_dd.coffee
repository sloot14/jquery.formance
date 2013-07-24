assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'yyyy_mm_dd.js', ->

    describe 'format_yyyy_mm_dd', ->

        it 'should add forward slash after the year is entered', ->
            $date = $('<input type=text>').formance('format_yyyy_mm_dd')
            $date.val('199')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $date.trigger(e)

            assert.equal '1994 / ', $date.val()

        it 'should add forward slash after month (2-9) is entered, single digit', ->
            $date = $('<input type=text>').formance('format_yyyy_mm_dd')
            $date.val('1994 / ')

            e = $.Event('keypress')
            e.which = 57 # '9'
            $date.trigger(e)

            assert.equal '1994 / 09 / ', $date.val()

        it 'should add forward slash after the month is entered, double digit', ->
            $date = $('<input type=text>').formance('format_yyyy_mm_dd')
            $date.val('1994 / 1')

            e = $.Event('keypress')
            e.which = 50 # '2'
            $date.trigger(e)

            assert.equal '1994 / 12 / ', $date.val()

        it 'should format forward slash shorthand correctly', ->
            $date = $('<input type=text>').formance('format_yyyy_mm_dd')
            $date.val('1994 / 1')

            e = $.Event('keypress')
            e.which = 47 # '/'
            $date.trigger(e)

            assert.equal '1994 / 01 / ', $date.val()

        it 'should format day correctly, single digit', ->
            $date = $('<input type=text>').formance('format_yyyy_mm_dd')
            $date.val('1994 / 12 / ')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $date.trigger(e)

            assert.equal '1994 / 12 / 04', $date.val()

        it 'should only allow numbers', ->
            $date = $('<input type=text>').formance('format_yyyy_mm_dd')
            $date.val('1994 / 12 / ')

            e = $.Event('keypress')
            e.which = 100 # 'd'
            $date.trigger(e)

            assert.equal '1994 / 12 / ', $date.val()


    describe 'Validating a date', ->
        
        it 'should pass on a valid date', ->
            $date = $('<input type=text>').val('2013 / 07 / 01')
            assert.equal true, $date.formance('validate_yyyy_mm_dd')

        it 'if less than 8 digits', ->
            $date = $('<input type=text>').val('20 / 07 ')
            assert.equal false, $date.formance('validate_yyyy_mm_dd')

            $date = $('<input type=text>').val('201 / 07 / 01')
            assert.equal false, $date.formance('validate_yyyy_mm_dd')

            $date = $('<input type=text>').val('2013 / 7 / 01')
            assert.equal true, $date.formance('validate_yyyy_mm_dd')

            $date = $('<input type=text>').val('2013 / 07 / 1')
            assert.equal true, $date.formance('validate_yyyy_mm_dd')

        it 'if more than 8 digits', ->
            $date = $('<input type=text>').val('20133 / 07 / 01')
            assert.equal false, $date.formance('validate_yyyy_mm_dd')

            $date = $('<input type=text>').val('2013 / 072 / 01')
            assert.equal false, $date.formance('validate_yyyy_mm_dd')

            $date = $('<input type=text>').val('2013 / 07 / 011')
            assert.equal true, $date.formance('validate_yyyy_mm_dd')

        it 'should fail when invalid string', ->
            $date = $('<input type=text>').val('yyyy / 07 / 01')
            assert.equal false, $date.formance('validate_yyyy_mm_dd')

            $date = $('<input type=text>').val('2013 / mm / 01')
            assert.equal false, $date.formance('validate_yyyy_mm_dd')

            $date = $('<input type=text>').val('2013 / 07 / dd')
            assert.equal false, $date.formance('validate_yyyy_mm_dd')


    describe 'Parsing a Date', ->

        it 'should work on a valid string', ->
            $date = $('<input type=text>').val('2013 / 07 / 01')
            assert.equal (new Date(2013, 7-1, 1)).getTime(), $date.formance('val_yyyy_mm_dd').getTime()

        it 'should fail on an invalid string', ->
            $date = $('<input type=text>').val('yyyy / 07 / 01')
            assert.equal false, $date.formance('val_yyyy_mm_dd')
