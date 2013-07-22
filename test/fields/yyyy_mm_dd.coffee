assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'yyyy_mm_dd.js', ->

    describe 'formatyyyymmdd', ->

        it 'should add forward slash after the year is entered', ->
            $date = $('<input type=text>').formance('formatyyyymmdd')
            $date.val('199')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $date.trigger(e)

            assert.equal '1994 / ', $date.val()

        it 'should add forward slash after month (2-9) is entered, single digit', ->
            $date = $('<input type=text>').formance('formatyyyymmdd')
            $date.val('1994 / ')

            e = $.Event('keypress')
            e.which = 57 # '9'
            $date.trigger(e)

            assert.equal '1994 / 09 / ', $date.val()

        it 'should add forward slash after the month is entered, double digit', ->
            $date = $('<input type=text>').formance('formatyyyymmdd')
            $date.val('1994 / 1')

            e = $.Event('keypress')
            e.which = 50 # '2'
            $date.trigger(e)

            assert.equal '1994 / 12 / ', $date.val()

        it 'should format forward slash shorthand correctly', ->
            $date = $('<input type=text>').formance('formatyyyymmdd')
            $date.val('1994 / 1')

            e = $.Event('keypress')
            e.which = 47 # '/'
            $date.trigger(e)

            assert.equal '1994 / 01 / ', $date.val()

        it 'should format day correctly, single digit', ->
            $date = $('<input type=text>').formance('formatyyyymmdd')
            $date.val('1994 / 12 / ')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $date.trigger(e)

            assert.equal '1994 / 12 / 04', $date.val()

        it 'should only allow numbers', ->
            $date = $('<input type=text>').formance('formatyyyymmdd')
            $date.val('1994 / 12 / ')

            e = $.Event('keypress')
            e.which = 100 # 'd'
            $date.trigger(e)

            assert.equal '1994 / 12 / ', $date.val()


    describe 'Parsing a date', ->

        it 'should parse a date string', ->
            topic = $.formance.yyyymmddVal('2013 / 07 / 01')
            assert.deepEqual {day: 1, month: 7, year: 2013}, topic

        # it is up to the validator to determine if it is a legitimate date
        it 'should parse if less than 8 digits', ->
            topic = $.formance.yyyymmddVal '2013 / 07 / 1'
            assert.deepEqual {day: 1, month: 7, year: 2013}, topic

            topic = $.formance.yyyymmddVal '201 / 07 / 01'
            assert.deepEqual {day: 1, month: 7, year: 201}, topic

        # it is up to the validator to determine if it is a legitimate date
        it 'should parse if more than 8 digits', ->
            topic = $.formance.yyyymmddVal '2013 / 07 / 011'
            assert.deepEqual {day: 11, month: 7, year: 2013}, topic

            topic = $.formance.yyyymmddVal '2013 / 072 / 01'
            assert.deepEqual {day: 1, month: 72, year: 2013}, topic

            topic = $.formance.yyyymmddVal '20133 / 07 / 01'
            assert.deepEqual {day: 1, month: 7, year: 20133}, topic

        it 'should return NaN when it cannot parse', ->
            topic = $.formance.yyyymmddVal('2013 / 07 / dd')
            assert.equal false, !!topic.day

            topic = $.formance.yyyymmddVal('2013 / mm / 01')
            assert.equal false, !!topic.month

            topic = $.formance.yyyymmddVal('yyyy / 07 / 01')
            assert.equal false, !!topic.year

            topic = $.formance.yyyymmddVal('            ')
            assert.equal false, !!topic.day
            assert.equal false, !!topic.month
            assert.equal false, !!topic.year

