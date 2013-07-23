$ = jQuery
hasTextSelected = $.formance.fn.hasTextSelected

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

cardFromNumber = (num) ->
    num = (num + '').replace(/\D/g, '')
    return card for card in cards when card.pattern.test(num)

cardFromType = (type) ->
    return card for card in cards when card.type is type
  
restrictCVC = (e) ->
	$target = $(e.currentTarget)
	digit   = String.fromCharCode(e.which)
	return unless /^\d+$/.test(digit)

	val     = $target.val() + digit
	val.length <= 4

$.formance.fn.format_credit_card_cvc = ->
	@.formance('restrictNumeric')
	@on('keypress', restrictCVC)
	this

$.formance.fn.validate_credit_card_cvc = ->
    type = $(this).data('credit_card_type')
    cvc = $(this).val()
    cvc = $.trim(cvc)
    return false unless /^\d+$/.test(cvc)

    if type
        # Check against a explicit card type
        cvc.length in cardFromType(type)?.cvcLength
    else
        # Check against all types
        cvc.length >= 3 and cvc.length <= 4

