assert = require('assert')
$      = require('jquery')
global.jQuery = $


require('../src/jquery.validators')

describe 'validators.js', ->
  
  # CVC validations
  describe 'Validating a CVC', ->
    it 'should fail if is empty', ->
      topic = $.validators.validateCardCVC ''
      assert.equal topic, false

    it 'should pass if is valid', ->
      topic = $.validators.validateCardCVC '123'
      assert.equal topic, true

    it 'should fail with non-digits', ->
      topic = $.validators.validateCardNumber '12e'
      assert.equal topic, false

    it 'should fail with less than 3 digits', ->
      topic = $.validators.validateCardNumber '12'
      assert.equal topic, false

    it 'should fail with more than 4 digits', ->
      topic = $.validators.validateCardNumber '12345'
      assert.equal topic, false


  describe 'Validating a date', ->
    
    it 'that is a valid day', ->
      date = new Date()
      topic = $.validators.validateDate date.getDay(), date.getMonth(), date.getFullYear()
      assert.equal topic, true

    it 'that has string numbers', ->
      date = new Date()
      topic = $.validators.validateDate date.getDay()+'', date.getMonth()+'', date.getFullYear()+''
      assert.equal topic, true

    it 'that has an invalid day', ->
      # TODO can have better logic, for example selecting 31 of february
      topic = $.validators.validateDate -1, 12, 2013
      assert.equal topic, false

      topic = $.validators.validateDate 32, 12, 2013
      assert.equal topic, false

    it 'that has an invalid month', ->
      topic = $.validators.validateDate 1, -11, 2013
      assert.equal topic, false

      topic = $.validators.validateDate 1, 13, 2013
      assert.equal topic, false

    it 'that has an invalid year', ->
      topic = $.validators.validateDate 1, 12, -2013
      assert.equal topic, false

    it 'should not support year shorthand', ->
      topic = $.validators.validateDate 1, 12, 13
      assert.equal topic, false

    it 'should fail if any value is NaN', ->
      topic = $.validators.validateDate NaN, 12, 13
      assert.equal topic, false

      topic = $.validators.validateDate 1, NaN, 13
      assert.equal topic, false

      topic = $.validators.validateDate 1, 12, NaN
      assert.equal topic, false



  describe 'Validating a number', ->
    it 'should fail if empty',  ->
      topic = $.validators.validateNumber ''
      assert.equal topic, false

    it 'should fail if it is a bunch of spaces', ->
      topic = $.validators.validateNumber '                    '
      assert.equal topic, false

    it 'should succeed if valid', ->
      topic = $.validators.validateNumber '12344'
      assert.equal topic, true

    it 'should fail with non digits', ->
      topic = $.validators.validateNumber '123zaas'
      assert.equal topic, false



  describe 'Validating an ontario photo health card number', ->
    it 'should fail if empty', ->
      topic = $.validators.validateOntarioPhotoHealthCardNumber ''
      assert.equal topic, false

    it 'should fail ig it is a bunch of space', ->
      topic = $.validators.validateOntarioPhotoHealthCardNumber '             '
      assert.equal topic, false

    it 'should succeed if valid', ->
      topic = $.validators.validateOntarioPhotoHealthCardNumber '1234123123AB'
      assert.equal topic, true
    
    it 'has dashes and spaces but is valid', ->
      topic = $.validators.validateOntarioPhotoHealthCardNumber '1234 - 123 - 123 - AB'
      assert.equal topic, true

    it 'should fail if more than 12 characters', ->
      topic = $.validators.validateOntarioPhotoHealthCardNumber '1234 - 123 - 123 - ABC'
      assert.equal topic, false
      topic = $.validators.validateOntarioPhotoHealthCardNumber '1234 - 1233 - 123 - AB'
      assert.equal topic, false

    it 'should fail with non alphanumeric characters', ->
      topic = $.validators.validateOntarioPhotoHealthCardNumber '1234; - 123 - ;/123 -/ AB'
      assert.equal topic, false



  describe 'Validating a phone number', ->
    it 'should fail if empty', ->
      topic = $.validators.validatePhoneNumber ''
      assert.equal topic, false

    it 'should fail if it is a bunch of spaces', ->
      topic = $.validators.validatePhoneNumber 

    it 'should succeed if valid', ->
      topic = $.validators.validatePhoneNumber '6137384446'
      assert.equal topic, true

    it 'has spaces but is valid', ->
      topic = $.validators.validatePhoneNumber '613 738 4446'
      assert.equal topic, true

    it 'has brackets and dashes but is valid', ->
      topic = $.validators.validatePhoneNumber '(613) 738 - 4446'
      assert.equal topic, true

    it 'should fail if more than 10 digits', ->
      topic = $.validators.validatePhoneNumber '(123) 456 - 78901'
      assert.equal topic, false

    it 'should fail if less than 10 digits', ->
      topic = $.validators.validatePhoneNumber '(123) 456 - 789'
      assert.equal topic, false

    it 'should fail with non digits', ->
      topic = $.validators.validatePhoneNumber '(123) er456 - 1232'
      assert.equal topic, false



  describe 'Validating a postal code', ->
    it 'should fail if empty', ->
      topic = $.validators.validatePostalCode ''
      assert.equal topic, false

    it 'should fail if it is a bunch of spaces', ->
      topic = $.validators.validatePostalCode '                    '
      assert.equal topic, false

    it 'should succeed if valid', ->
      topic = $.validators.validatePostalCode 'k1h8k9'
      assert.equal topic, true

      topic = $.validators.validatePostalCode 'k1h 8k9'
      assert.equal topic, true

    it 'should fail if less than 6 characters', ->
      topic = $.validators.validatePostalCode 'k1h 8k'
      assert.equal topic, false

      topic = $.validators.validatePostalCode 'k1 8k9'
      assert.equal topic, false

    it 'should fail if more than 6 characters', ->
      topic = $.validators.validatePostalCode 'kk1h 8k9'
      assert.equal topic, false

      topic = $.validators.validatePostalCode 'k1h 8k91'
      assert.equal topic, false

    it 'should fail with non alphanumeric characters', ->
      topic = $.validators.validatePostalCode 'k1h-8k9'
      assert.equal topic, false

      topic = $.validators.validatePostalCode 'k1h;8k9'
      assert.equal topic, false



  describe 'Parsing a date', ->
    it 'should parse a date string', ->
      topic = $.validators.dateVal('01 / 07 / 2013')
      assert.deepEqual topic, {day: 1, month: 7, year: 2013}

    # it is up to the validator to determine if it is a legitimate date
    it 'should parse if less than 8 digits', ->
      topic = $.validators.dateVal '1 / 07 / 2013'
      assert.deepEqual topic, {day: 1, month: 7, year: 2013}

      topic = $.validators.dateVal '01 / 07 / 201'
      assert.deepEqual topic, {day: 1, month: 7, year: 201}

    # it is up to the validator to determine if it is a legitimate date
    it 'should parse if more than 8 digits', ->
      topic = $.validators.dateVal '011 / 07 / 2013'
      assert.deepEqual topic, {day: 11, month: 7, year: 2013}

      topic = $.validators.dateVal '01 / 072 / 2013'
      assert.deepEqual topic, {day: 1, month: 72, year: 2013}

      topic = $.validators.dateVal '01 / 07 / 20133'
      assert.deepEqual topic, {day: 1, month: 7, year: 20133}

    it 'should return NaN when it cannot parse', ->
      topic = $.validators.dateVal('dd / 07 / 2013')
      assert.equal !!topic.day, false
      
      topic = $.validators.dateVal('01 / mm / 2013')
      assert.equal !!topic.month, false

      topic = $.validators.dateVal('01 / 07 / yyyy')  #not '01 / 07 / 20yy' will work
      assert.equal !!topic.year, false

      topic = $.validators.dateVal('            ')
      assert.equal !!topic.day, false
      assert.equal !!topic.month, false
      assert.equal !!topic.year, false

