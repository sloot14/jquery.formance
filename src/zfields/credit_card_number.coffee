$ = jQuery

class CreditCardNumberField extends CreditCardField

    restrict_field_callback: (e, $target, old_val, digit, new_val) =>
        card = @card_from_number(new_val)

        if card
            new_val.length <= card.length[card.length.length - 1]
        else
            # All other cards are 16 digits long
            new_val.length <= 16

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

    set_card_type:  (e) =>
        $target  = $(e.currentTarget)
        val      = $target.val()
        cardType = @credit_card_type(val) or 'unknown'

        unless $target.hasClass(cardType)
            allTypes = (card.type for card in @cards())

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
