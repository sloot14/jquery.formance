assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

VALID_EMAILS = [
    'john@example.com'
    'very.common@example.com'
    'a.little.lengthy.but.fine@dept.example.com'
    'disposable.style.email.with+symbol@example.com'
#   'user@[IPv6:2001:db8:1ff::a0b:dbd0]'
#   '"much.more unusual"@example.com'
#   '"very.unusual.@.unusual.com"@example.com'
#   '"very.(),:;<>[]\".VERY.\"very@\\ \"very\".unusual"@strange.example.com'
#   'postbox@com'
#   'admin@mailserver1'
    '!#$%&\'*+-/=?^_`{}|~@example.org'
#   '"()<>[]:,;@\\\"!#$%&\'*+-/=?^_`{}| ~.a"@example.org'
#   '" "@example.org'
]

INVALID_EMAILS = [
#    'Abc.example.com'
#   'A@b@c@example.com'
    'a"b(c)d,e:f;g<h>i[j\k]l@example.com'
    'just"not"right@example.com'
#    'this is"not\allowed@example.com'
#    'this\ still\"not\\allowed@example.com'
]


describe 'email.js', ->

    describe 'Validating an email address', ->

        it 'should fail if empty', ->
            $email = $('<input>').val('')
            assert.equal false, $email.formance('validate_email')

        it 'should fail if it is a bunch of spaces', ->
            $email = $('<input>').val('                ')
            assert.equal false, $email.formance('validate_email')

        it 'should succeed with valid emails', ->
            for email in VALID_EMAILS
                $email = $('<input>').val(email)
                assert.equal true, $email.formance('validate_email')
        
        it 'should succeed with invalid emails, (using the simple algorithm) has false nagatives', ->
            for email in INVALID_EMAILS
                $email = $('<input>').val(email)
                assert.equal true, $email.formance('validate_email')

# complex algorithm                
        it 'should succeed with valid emails using the complex algorithm', ->
            for email in VALID_EMAILS
                $email = $('<input>').val(email)
                                     .data('formance_algorithm', 'complex')
                assert.equal true, $email.formance('validate_email')
 
        it 'should fail with invalid emails using the complex algorithm', ->
            for email in INVALID_EMAILS
                $email = $('<input>').val(email)
                                     .data('formance_algorithm', 'complex')
                assert.equal false, $email.formance('validate_email')
                
# algorithm that does not exist
        it 'should resort to simple algorithm if it can\'t find the algorithm specified', ->
            for email in INVALID_EMAILS
                $email = $('<input>').val(email)
                                     .data('formance_algorithm', 'does_not_exist')
                assert.equal true, $email.formance('validate_email')
