assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'email.js', ->

    describe 'Validating an email address', ->

        it 'should fail if empty', ->
            $email = $('<input type=text>').val('')
            assert.equal false, $email.formance('validate_email')

        it 'should fail if it is a bunch of spaces', ->
            $email = $('<input type=text>').val('                ')
            assert.equal false, $email.formance('validate_email')

        it 'should succeed if valid', ->
            valid = [
                'john@example.com'
                'very.common@example.com'
                'a.little.lengthy.but.fine@dept.example.com'
                'disposable.style.email.with+symbol@example.com'
#                'user@[IPv6:2001:db8:1ff::a0b:dbd0]'
#                '"much.more unusual"@example.com'
#               '"very.unusual.@.unusual.com"@example.com'
#                '"very.(),:;<>[]\".VERY.\"very@\\ \"very\".unusual"@strange.example.com'
#                'postbox@com'
#                'admin@mailserver1'
                '!#$%&\'*+-/=?^_`{}|~@example.org'
#                '"()<>[]:,;@\\\"!#$%&\'*+-/=?^_`{}| ~.a"@example.org'
#                '" "@example.org'
            ]

            for email in valid
                $email = $('<input type=text>').val(email)
                console.log $email.formance('validate_email') + ', ' + email
                assert.equal true, $email.formance('validate_email')

        it 'has spaces but is valid', ->
            invalid = [
                'Abc.example.com'
#                'A@b@c@example.com'
                'a"b(c)d,e:f;g<h>i[j\k]l@example.com'
                'just"not"right@example.com'
                'this is"not\allowed@example.com'
                'this\ still\"not\\allowed@example.com'

            ]
            
            for email in invalid
                $email = $('<input type=text>').val(email)
                assert.equal false, $email.formance('validate_email')
