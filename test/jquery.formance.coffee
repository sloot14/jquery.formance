assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../lib/jquery.formance.js')

describe 'jquery.formance.js', ->

    describe 'restrictNumeric', ->

        it 'should allow digits to be entered', ->
            $field = $('<input type=text>').formance('restrictNumeric')
            $field.val('123')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $field.trigger(e)

            assert.equal $field.val(), '1234'

        it 'should restrict letters from being entered', ->
            $field = $('<input type=text>').formance('restrictNumeric')

            e = $.Event('keypress')
            e.which = 68 # 'd'
            $field.trigger(e)

            assert.equal $field.val(), ''
 
        it 'should restrict special characters from being entered', ->
            $field = $('<input type=text>').formance('restrictNumeric')

            e = $.Event('keypress')
            e.which = 189 # '-'
            $field.trigger(e)

            assert.equal $field.val(), ''


    describe 'restrictAlphaNumeric', ->

        it 'should allow digits to be entered', ->
            $field = $('<input type=text>').formance('restrictAlphaNumeric')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $field.trigger(e)

            assert.equal $field.val(), '4'

        it 'should allow letters to be entered', ->
            $field = $('<input type=text>').formance('restrictAlphaNumeric')

            e = $.Event('keypress')
            e.which = 68 # 'd'
            $field.trigger(e)

            assert.equal $field.val(), 'd'

        it 'should restrict special characters from being entered', ->
            $field = $('<input type=text>').formance('restrictAlphaNumeric')

            e = $.Event('keypress')
            e.which = 189 # '-'
            $field.trigger(e)

            assert.equal $field.val(), ''
