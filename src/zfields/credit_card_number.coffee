$ = jQuery

# Utils

defaultFormat = /(\d{1,4})/g

cards = [
  {
      type: 'maestro'
      pattern: /^(5018|5020|5038|6304|6759|676[1-3])/
      format: defaultFormat
      length: [12..19]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'dinersclub'
      pattern: /^(36|38|30[0-5])/
      format: defaultFormat
      length: [14]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'laser'
      pattern: /^(6706|6771|6709)/
      format: defaultFormat
      length: [16..19]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'jcb'
      pattern: /^35/
      format: defaultFormat
      length: [16]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'unionpay'
      pattern: /^62/
      format: defaultFormat
      length: [16..19]
      cvcLength: [3]
      luhn: false
  }
  {
      type: 'discover'
      pattern: /^(6011|65|64[4-9]|622)/
      format: defaultFormat
      length: [16]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'mastercard'
      pattern: /^5[1-5]/
      format: defaultFormat
      length: [16]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'amex'
      pattern: /^3[47]/
      format: /(\d{1,4})(\d{1,6})?(\d{1,5})?/
      length: [15]
      cvcLength: [3..4]
      luhn: true
  }
  {
      type: 'visa'
      pattern: /^4/
      format: defaultFormat
      length: [13..16]
      cvcLength: [3]
      luhn: true
  }
]

class CreditCardNumberField extends NumericFormanceField

    restrict_field_callback: (e, val) =>
        card = @card_from_number(val)

        if card
            val.length <= card.length[card.length.length - 1]
        else
            # All other cards are 16 digits long
            val.length <= 16

    format_field_callback: (e, $target, old_val, digit, new_val) =>
        card    = @card_from_number(new_val)
        length  = (old_val.replace(/\D/g, '') + digit).length

        upperLength = 16
        upperLength = card.length[card.length.length - 1] if card
        return if length >= upperLength

        if card && card.type is 'amex'
            # Amex cards are formatted differently
            re = /^(\d{4}|\d{4}\s\d{6})$/
        else
            re = /(?:^|\s)(\d{4})$/

        # If '4242' + 4
        if re.test(old_val)
            e.preventDefault()
            $target.val(old_val + ' ' + digit)

        # If '424' + 2
        else if re.test(new_val)
            e.preventDefault()
            $target.val(new_val + ' ')

    format_paste_callback: (e, $target, val) =>
        $target.val @format_credit_card_number(val)

    format_backspace_callback: (e, $target, val) =>
        # Remove the trailing space
        if /\d\s$/.test(val)
            e.preventDefault()
            $target.val(val.replace(/\d\s$/, ''))
        else if /\s\d?$/.test(val)
            e.preventDefault()
            $target.val(val.replace(/\s\d?$/, ''))

    format: () ->
        super
        @field.on('keyup', @set_card_type)
        this

    card_from_number: (num) ->
        num = (num + '').replace(/\D/g, '')
        return card for card in cards when card.pattern.test(num)

    card_from_type: (type) ->
        return card for card in cards when card.type is type

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

    set_card_type:  (e) ->
        $target  = $(e.currentTarget)
        val      = $target.val()
        cardType = @credit_card_type(val) or 'unknown'

        unless $target.hasClass(cardType)
            allTypes = (card.type for card in cards)

            $target.removeClass('unknown')
            $target.removeClass(allTypes.join(' '))

            $target.addClass(cardType)
            $target.toggleClass('identified', cardType isnt 'unknown')
            $target.trigger('payment.cardType', cardType)

    format_credit_card_number: (num) ->
        card = @card_from_number(num)
        return num unless card

        upperLength = card.length[card.length.length - 1]

        num = num.replace(/\D/g, '')
        num = num[0..upperLength]

        if card.format.global
            num.match(card.format)?.join(' ')
        else
            groups = card.format.exec(num)
            groups?.shift()
            groups?.join(' ')

    validate: () ->
        num = @field.val()
        num = (num + '').replace(/\s+|-/g, '')
        return false unless /^\d+$/.test(num)

        card = @card_from_number(num)
        return false unless card

        num.length in card.length and
            (card.luhn is false or @luhn_check(num))

$.formance.fn.format_credit_card_number = ->
    field = new CreditCardNumberField this
    field.format()
    this

$.formance.fn.validate_credit_card_number = ->
    field = new CreditCardNumberField this
    field.validate()

$.formance.credit_card_type = CreditCardNumberField.credit_card_type
