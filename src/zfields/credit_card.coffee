$ = jQuery

class CreditCardField extends NumericFormanceField

    default_format: () ->
        /(\d{1,4})/g

    cards: () ->
        return [
          {
              type: 'maestro'
              pattern: /^(5018|5020|5038|6304|6759|676[1-3])/
              format: @default_format()
              length: [12..19]
              cvclength: [3]
              luhn: true
          }
          {
              type: 'dinersclub'
              pattern: /^(36|38|30[0-5])/
              format: @default_format()
              length: [14]
              cvclength: [3]
              luhn: true
          }
          {
              type: 'laser'
              pattern: /^(6706|6771|6709)/
              format: @default_format()
              length: [16..19]
              cvclength: [3]
              luhn: true
          }
          {
              type: 'jcb'
              pattern: /^35/
              format: @default_format()
              length: [16]
              cvclength: [3]
              luhn: true
          }
          {
              type: 'unionpay'
              pattern: /^62/
              format: @default_format()
              length: [16..19]
              cvclength: [3]
              luhn: false
          }
          {
              type: 'discover'
              pattern: /^(6011|65|64[4-9]|622)/
              format: @default_format()
              length: [16]
              cvclength: [3]
              luhn: true
          }
          {
              type: 'mastercard'
              pattern: /^5[1-5]/
              format: @default_format()
              length: [16]
              cvclength: [3]
              luhn: true
          }
          {
              type: 'amex'
              pattern: /^3[47]/
              format: /(\d{1,4})(\d{1,6})?(\d{1,5})?/
              length: [15]
              cvclength: [3..4]
              luhn: true
          }
          {
              type: 'visa'
              pattern: /^4/
              format: @default_format()
              length: [13..16]
              cvclength: [3]
              luhn: true
          }
        ]

    card_from_number: (num) ->
        num = (num + '').replace(/\D/g, '')
        return card for card in @cards() when card.pattern.test(num)

    card_from_type: (type) ->
        return card for card in @cards() when card.type is type

    credit_card_type: (num) ->
        return null unless num
        @card_from_number(num)?.type or null

    luhn_check: (num) ->
        odd = true
        sum = 0

        digits = (num + '').split('').reverse()

        for digit in digits
            digit = parseInt(digit, 10)
            digit *= 2 if (odd = !odd)
            digit -= 9 if digit > 9
            sum += digit

        sum % 10 == 0

# TODO this needs changing
#credit_card_helper = new CreditCardField()
#$.formance.credit_card_type = credit_card_helper.credit_card_type
#$.formance.credit_card_type = credit_card_helper.credit_card_number
#$.formance.credit_card_type = credit_card_helper.card_from_number
