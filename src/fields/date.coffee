$ = jQuery

restrictDate = (e) ->
	$target = $(e.currentTarget)
	digit   = String.fromCharCode(e.which)
	return unless /^\d+$/.test(digit)

	return if hasTextSelected($target)

	value = $target.val() + digit
	value = value.replace(/\D/g, '')

	return false if value.length > 8

formatDate = (e) ->
	# Only format if input is a number
	digit = String.fromCharCode(e.which)
	return unless /^\d+$/.test(digit)

	$target = $(e.currentTarget)
	old_val = $target.val()
	val     = old_val + digit

	if /^\d$/.test(val) and digit not in ['0', '1', '2', '3']
		e.preventDefault()
		$target.val("0#{val} / ")
	else if /^\d{2}$/.test(val)
		e.preventDefault()
		$target.val("#{val} / ")
	else if /^\d{2}\s\/\s\d$/.test(val) and digit not in ['0', '1']
		e.preventDefault()
		$target.val("#{old_val}0#{digit} / ")
	else if /^\d{2}\s\/\s\d{2}$/.test(val)
		e.preventDefault()
		$target.val("#{val} / ")

formatForwardDate = (e) ->   #handles when the user enters the second digit
	digit = String.fromCharCode(e.which)
	return unless /^\d+$/.test(digit)

	$target = $(e.currentTarget)
	val     = $target.val()

	# handles when entering the 2nd and 4th digits
	if /^\d{2}$/.test(val) or /^\d{2}\s\/\s\d{2}$/.test(val)
		$target.val("#{val} / ")

formatForwardSlash = (e) ->    # handles when the user hits '/'
	slash = String.fromCharCode(e.which)
	return unless slash is '/'

	$target = $(e.currentTarget)
	val     = $target.val()

	parse_day = /^(\d)$/
	parse_month = /^(\d{2})\s\/\s(\d)$/

	if parse_day.test(val) and val isnt '0'
		$target.val("0#{val} / ")
	else if parse_month.test(val)
		[date, day, month] = val.match(parse_month)
		if month isnt '0'
		$target.val("#{day} / 0#{month} / ")

formatBackDate = (e) ->
	# If shift+backspace is pressed
	return if e.meta

	$target = $(e.currentTarget)
	value   = $target.val()

	# Return unless backspacing
	return unless e.which is 8

	# Return if focus isn't at the end of the text
	return if $target.prop('selectionStart')? and 
		$target.prop('selectionStart') isnt value.length

	# Remove the trailing space
	if /\d(\s|\/)+$/.test(value)
		e.preventDefault()
		$target.val(value.replace(/\d(\s|\/)*$/, ''))
	else if /\s\/\s?\d?$/.test(value)
		e.preventDefault()
		$target.val(value.replace(/\s\/\s?\d?$/, ''))

$.fn.formance.date =

	format: ->
		@formatters('restrictNumeric')
		@on('keypress', restrictDate)
		@on('keypress', formatDate)
		@on('keypress', formatForwardSlash)
		@on('keypress', formatForwardDate)
		@on('keydown',  formatBackDate)
		this

	validate: ->
		val = $(this).val()
		date = @parse(val)

		return false if not date.day? or isNaN(date.day) or not date.month? or isNaN(date.month) or not date.year? or isNaN(date.year)
		return false unless (0 < date.day <= 31) and (0 < date.month <= 12) and (1000 < date.year <= 10000) #can probably use better logic for 'valid' year
		return true


	parse: (dateString) ->
		[day, month, year] = if dateString? then dateString.replace(/\s/g, '').split('/', 3) else [NaN, NaN, NaN]

		day   = parseInt(day, 10)
		month = parseInt(month, 10)
		year  = parseInt(year, 10)

		return day: day, month: month, year: year


