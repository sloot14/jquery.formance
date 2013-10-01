$ = jQuery
hasTextSelected = $.formance.fn.hasTextSelected

formatUkSortCode = (e) ->
	digit = String.fromCharCode(e.which)
	return  unless /^\d+$/.test(digit)
	$target = $(e.currentTarget)
	old_val = $target.val()
	val = old_val + digit
	if /^\d{2}$/.test(val)
		e.preventDefault()
		return $target.val("" + val + " - ")
	else if /^\d{2}\s\-\s\d{2}$/.test(val)
		e.preventDefault()
		return $target.val("" + val + " - ")
	$target.val val.substring(0, 11)  if val.length > 11

$.formance.fn.format_uk_sort_code = (e) ->
	@formance "restrictNumeric"
	@on "keypress", formatUkSortCode
	this

$.formance.fn.validate_uk_sort_code = ->
	sortCode = $(this).val()
	return false  if sortCode.length < 12
	return false if sortCode.trim() == ''
	true