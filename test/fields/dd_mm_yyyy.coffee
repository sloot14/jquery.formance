assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'dd_mm_yyyy.js', ->

    describe 'formatddmmyyyy', ->

        it 'should format day correctly single digit', ->
            $date = $('<input type=text>').formance('formatddmmyyyy')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $date.trigger(e)

            assert.equal '04 / ', $date.val()

        it 'should format day correctly double digit', ->
            $date = $('<input type=text>').formance('formatddmmyyyy')
            $date.val('2')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $date.trigger(e)

            assert.equal '24 / ', $date.val()

        it 'should format forward slash shorthand correctly', ->
            $date = $('<input type=text>').formance('formatddmmyyyy')
            $date.val('1')

            e = $.Event('keypress');
            e.which = 47 # '/'
            $date.trigger(e)

            assert.equal '01 / ', $date.val()

        it 'should format month correctly single digit', ->
            $date = $('<input type=text>').formance('formatddmmyyyy')
            $date.val('04 / ')

            e = $.Event('keypress')
            e.which = 57 # '9'
            $date.trigger(e)

            assert.equal '04 / 09 / ', $date.val()

        it 'should format day correctly double digit', ->
            $date = $('<input type=text>').formance('formatddmmyyyy')
            $date.val('24 / 1')

            e = $.Event('keypress')
            e.which = 50 # '2'
            $date.trigger(e)

            assert.equal '24 / 12 / ', $date.val()

        it 'should format forward slash shorthand correctly', ->
            $date = $('<input type=text>').formance('formatddmmyyyy')
            $date.val('24 / 1')

            e = $.Event('keypress');
            e.which = 47 # '/'
            $date.trigger(e)

            assert.equal '24 / 01 / ', $date.val()

        it 'should only allow numbers', ->
            $date = $('<input type=text>').formance('formatddmmyyyy')
            $date.val('01 / 12 / ')

            e = $.Event('keypress');
            e.which = 100 # 'd'
            $date.trigger(e)

            assert.equal '01 / 12 / ', $date.val()


    describe 'Parsing a date', ->

        it 'should parse a date string', ->
            topic = $.formance.ddmmyyyyVal('01 / 07 / 2013')
            assert.deepEqual {day: 1, month: 7, year: 2013}, topic

        # it is up to the validator to determine if it is a legitimate date
        it 'should parse if less than 8 digits', ->
            topic = $.formance.ddmmyyyyVal '1 / 07 / 2013'
            assert.deepEqual {day: 1, month: 7, year: 2013}, topic

            topic = $.formance.ddmmyyyyVal '01 / 07 / 201'
            assert.deepEqual {day: 1, month: 7, year: 201}, topic

        # it is up to the validator to determine if it is a legitimate date
        it 'should parse if more than 8 digits', ->
            topic = $.formance.ddmmyyyyVal '011 / 07 / 2013'
            assert.deepEqual {day: 11, month: 7, year: 2013}, topic

            topic = $.formance.ddmmyyyyVal '01 / 072 / 2013'
            assert.deepEqual {day: 1, month: 72, year: 2013}, topic

            topic = $.formance.ddmmyyyyVal '01 / 07 / 20133'
            assert.deepEqual {day: 1, month: 7, year: 20133}, topic

        it 'should return NaN when it cannot parse', ->
            topic = $.formance.ddmmyyyyVal('dd / 07 / 2013')
            assert.equal false, !!topic.day

            topic = $.formance.ddmmyyyyVal('01 / mm / 2013')
            assert.equal false, !!topic.month

            topic = $.formance.ddmmyyyyVal('01 / 07 / yyyy')  #not '01 / 07 / 20yy' will work
            assert.equal false, !!topic.year

            topic = $.formance.ddmmyyyyVal('            ')
            assert.equal false, !!topic.day
            assert.equal false, !!topic.month
            assert.equal false, !!topic.year

