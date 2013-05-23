require('./jquery.payment')

$           		= jQuery
$.validators    	= {}
$.validators.fn 	= {}
$.fn.validators 	= (method, args...) ->
  $.validators.fn[method].apply(this, args)


$.validators.validateCardNumber = (num) ->
        return $.payment.validateCardNumber(num)

$.validators.validateCardExpiry = (expiry_string) ->
        expiry = $.payment.cardExpiryVal(expiry_string)
        return $.payment.validateCardExpiry(expiry['month'], expiry['year'])

$.validators.validateCardCVC = (cvc, type) ->
        return $.payment.validateCardCVC(cvc, type)



$.validators.validateDate = (day, month, year) -> #day, month, year to stay consistent with expiry which is month, year
	return false if not day? or isNaN(day) or not month? or isNaN(month) or not year? or isNaN(year)
	return false unless (0 < day <= 31) and (0 < month <= 12) and (1000 < year <= 10000) #can probably use better logic for 'valid' year
	return true


# email is one of those tough things to validate, and probably best accomplished by
# sending a verification email
# $.validators.validateEmail = (email) ->
# 	return true


$.validators.validateNumber = (num) ->
	return /^\d+$/.test(num)


#can't handle extensions for now
$.validators.validatePhoneNumber = (phone_string) ->
	phone_string = phone_string.replace(/\(|\)|\s+|-/g, '')
	return false unless /^\d+$/.test(phone_string)

	# [area_code, first_three, last_four] = phone_string.match(/\d+/g)
	return phone_string.replace(/\D/g, '').length is 10 # replaces all non digits [^0-9] with ''


$.validators.validatePostalCode = (postal_code_string) ->
	postal_code_string = postal_code_string.replace(/\s+/g, '')
	return false unless /^[a-zA-Z\d]+$/.test(postal_code_string)

	# http://stackoverflow.com/questions/1146202/canada-postal-code-validation
	# apparently some letters are restricted
	# - first letter can't be D,I,O,Q,U,W,Z
	# - second letter can't be D,I,O,Q,U
	# - third letter can't be D,I,O,Q,U
	postal_code_string = postal_code_string.replace(/[^a-zA-Z\d]/g, '') #\W allows certain special characters
	/^[ABCEFGHJKLMNPRSTVXY][0-9][ABCEFGHJKLMNPRSTVWXYZ]\s?[0-9][ABCEFGHJKLMNPRSTVWXYZ][0-9]$/.test(postal_code_string.toUpperCase())



$.validators.fn.dateVal = ->
  $.validators.dateVal($(this).val())

$.validators.dateVal = (date_string) ->
	# [day, month, year] = if /[^\d\/\s]/g.test(date_string) then (NaN, NaN, NaN) else 
	
	[day, month, year] = date_string.replace(/\s/g, '').split('/', 3)

	day   = parseInt(day, 10)
	month = parseInt(month, 10)
	year  = parseInt(year, 10)

	return day: day, month: month, year: year