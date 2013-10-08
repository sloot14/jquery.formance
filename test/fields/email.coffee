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
    'Abc.example.com'
#   'A@b@c@example.com'
#    'a"b(c)d,e:f;g<h>i[j\k]l@example.com'
#    'just"not"right@example.com'
#    'this is"not\allowed@example.com'
#    'this\ still\"not\\allowed@example.com'
]

describe 'email.js', ->


    it 'should validate an email address using the default algorithm', ->
        for email in VALID_EMAILS
            validate email,         yes,        email
        for email in INVALID_EMAILS
            validate email,         no,         email
        validate '',                no,         'empty'
        validate '         ',       no,         'only spaces'


     it 'should validate using the complex algorithm', ->
        for email in VALID_EMAILS
            validate_with_algorithm     email,      'complex',          yes,        email
        for email in INVALID_EMAILS
            validate_with_algorithm     email,      'complex',          no,         email


     it 'should validate using the default when the specified algorithm is not recognized', ->
         for email in INVALID_EMAILS
             validate_with_algorithm    email,     'does_not_exist',    no,         email


validate = (value, valid, message) ->
    $email = $('<input type=text>').val(value)
    assert.equal $email.formance('validate_email'), valid, message

validate_with_algorithm = (value, algorithm, valid, message) ->
    $email = $('<input>').val(value)
                         .data('formance_algorithm', algorithm)
    assert.equal $email.formance('validate_email'), valid, message
