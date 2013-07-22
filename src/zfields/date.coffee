$ = jQuery

$.formance.validateDate = (day, month, year) ->
    return false if not day? or isNaN(day) or not month? or isNaN(month) or not year? or isNaN(year)
    return false unless (0 < day <= 31) and (0 < month <= 12) and (1000 < year <= 10000) #can probably use better logic for 'valid' year
    return true
