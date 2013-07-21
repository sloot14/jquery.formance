assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'credit_card_expiry.js', ->

    describe 'formatCreditCardExpiry', ->

        it 'should format month shorthand correctly', ->
            $expiry = $('<input type=text>').formance('formatCreditCardExpiry')

            e = $.Event('keypress');
            e.which = 52 # '4'
            $expiry.trigger(e)

            assert.equal '04 / ', $expiry.val()

        it 'should format forward slash shorthand correctly', ->
            $expiry = $('<input type=text>').formance('formatCreditCardExpiry')
            $expiry.val('1')

            e = $.Event('keypress');
            e.which = 47 # '/'
            $expiry.trigger(e)

            assert.equal '01 / ', $expiry.val()

        it 'should only allow numbers', ->
            $expiry = $('<input type=text>').formance('formatCreditCardExpiry')
            $expiry.val('1')

            e = $.Event('keypress');
            e.which = 100 # 'd'
            $expiry.trigger(e)

            assert.equal '1', $expiry.val()


    describe 'Validating an expiration date', ->

        it 'should fail expires is before the current year', ->
            currentTime = new Date()
            topic = $.formance.validateCreditCardExpiry currentTime.getMonth() + 1, currentTime.getFullYear() - 1
            assert.equal false, topic

        it 'that expires in the current year but before current month', ->
            currentTime = new Date()
            topic = $.formance.validateCreditCardExpiry currentTime.getMonth(), currentTime.getFullYear()
            assert.equal false, topic

        it 'that has an invalid month', ->
            currentTime = new Date()
            topic = $.formance.validateCreditCardExpiry 13, currentTime.getFullYear()
            assert.equal false, topic

        it 'that is this year and month', ->
            currentTime = new Date()
            topic = $.formance.validateCreditCardExpiry currentTime.getMonth() + 1, currentTime.getFullYear()
            assert.equal true, topic

        it 'that is just after this month', ->
            # Remember - months start with 0 in JavaScript!
            currentTime = new Date()
            topic = $.formance.validateCreditCardExpiry currentTime.getMonth() + 1, currentTime.getFullYear()
            assert.equal true, topic

        it 'that is after this year', ->
            currentTime = new Date()
            topic = $.formance.validateCreditCardExpiry currentTime.getMonth() + 1, currentTime.getFullYear() + 1
            assert.equal true, topic

        it 'that has string numbers', ->
            currentTime = new Date()
            currentTime.setFullYear(currentTime.getFullYear() + 1, currentTime.getMonth() + 2)
            topic = $.formance.validateCreditCardExpiry currentTime.getMonth() + '', currentTime.getFullYear() + ''
            assert.equal true, topic

        it 'that has non-numbers', ->
            topic = $.formance.validateCreditCardExpiry 'h12', '3300'
            assert.equal false, topic

        it 'should fail if year or month is NaN', ->
            topic = $.formance.validateCreditCardExpiry '12', NaN
            assert.equal false, topic

        it 'should support year shorthand', ->
            assert.equal $.formance.validateCreditCardExpiry('05', '20'), true


    describe 'Parsing an expiry value', ->

        it 'should parse string expiry', ->
            topic = $.formance.creditCardExpiryVal('03 / 2025')
            assert.deepEqual {month: 3, year: 2025}, topic

        it 'should support shorthand year', ->
            topic = $.formance.creditCardExpiryVal('05/04')
            assert.deepEqual {month: 5, year: 2004}, topic

        it 'should return NaN when it cannot parse', ->
            topic = $.formance.creditCardExpiryVal('05/dd')
            assert isNaN(topic.year)
