# jQuery.formance

A javascript library for formatting and validating form fields, based on / inspired by Stripe's jQuery.payment library. 

Client side validation is not sufficient in any project because the javascript can be bypassed and people can submit requests directly to the server. However, that doesn't mean client side validation should be forgotten. This library is for those who care about the user experience.

## Demo

You can find a full demo [here] (http://omarshammas.com/formancejs.html).

## Fields

### Credit Card CVC

Formats the credit card cvc:

* Limits to length of 4
* Restricts input to numbers

```javascript
$('input.credit_card_cvc').formance('format_credit_card_cvc');
```

Validates the credit card cvc:

* Validates number length between 3 and 4
* Validates numbers
* Checks if the data attribute `credit_card_type` exists to check if cvc matches that card's standards. 

```javascript
$("<input value='123' />").formance('validate_credit_card_cvc');        // true
$("<input value='1234' />").formance('validate_credit_card_cvc');       // true
$("<input value='123' data-credit_card_type='amex' />").formance('validate_credit_card_cvc');   // true
$("<input value='1234' data-credit_card_type='amex' />").formance('validate_credit_card_cvc');   // true
$("<input value='12345' />").formance('validate_credit_card_cvc');      // false
```


### Credit Card Expiry

Formats the credit card expiry date in the `mm / yyyy` format:

* Limits to 6 numbers
* Restricts input to numbers
* Includes a `/` between the month & year

```javascript
$('input.credit_card_expiry').formance('format_credit_card_expiry');
```

Validates the credit card expiry date:

* Validates numbers
* Validates in the future
* Supports year shorthand `mm / yy`

```javascript
$('input.credit_card_expiry').formance('validate_credit_card_expiry');

//examples
$("<input value='05 / 20' />").formance('validate_credit_card_expiry');      // true
$("<input value='05 / 2020' />").formance('validate_credit_card_expiry');   // true
$("<input value='05 / 1900' />").formance('validate_credit_card_expiry');   // false
$("<input value='mm / 20' />").formance('validate_credit_card_expiry');    // false
```

### Credit Card Number

Formats the credit card card number:

* Limits to 16 numbers
* Restricts input to numbers
* Includes a space between every 4 digits
* American Express formatting support
* Adds a class of the card type (i.e. 'visa') to the input

```javascript
$('input.credit_card_number').formance('format_credit_card_number');
```

Validates the credit card number:

* Validates numbers
* Validates Luhn algorithm
* Validates length

```javascript
$('input.credit_card_expiry').formance('validate_credit_card_number');

//examples
$("<input value='4242424242424242' />").formance('validate_credit_card_number');   // true
$("<input value='4242 4242 4242 4242' />").formance('validate_credit_card_number');   // true
$("<input value='4242-4242-4242-4242' />").formance('validate_credit_card_number');   // true
$("<input value='4242' />").formance('validate_credit_card_number');   // false
```

This field includes a special helper function to retrieve the credit card type. It recognizes

* `visa`
* `mastercard`
* `discover`
* `amex`
* `dinersclub`
* `maestro`
* `laser`
* `unionpay`

The function will return `null` if the card type can't be determined.

```javascript
$.formance.creditCardType('4242 4242 4242 4242') // 'visa'
```

### Date dd / mm / yyyy

Formats the date in the `dd / mm / yyyy` format:

* Limits to 8 numbers
* Restricts input to numbers or slashes depending on the current state
* Includes a `/` between the day & month and month & year.
* Does NOT accept shorthand to avoid ambiguities

```javascript
$('input.dd_mm_yyyy').formance('format_dd_mm_yyyy');
```

Validates the date:

* Validates the date can be parsed.
* Validates the date actually exists so it will fail if February 30th is entered even though it passes parsing.

```javascript
$('input.dd_mm_yyyy').formance('validate_dd_mm_yyyy');
```

Date includes a helper function to retrieve the date value. *Note it does not check to see if it valid*. It simply creates a date object with the specified values which may be incorrect. For example `new Date(2013, 2-1, 30)` returns March 2nd because February does not have 30 days. You should check if it is valid before using the date. 

If the text is parsed without any errors then a Javascript Date object is returned otherwise false.

```javascript
$("<input value='01 / 07 / 2013' />").formance('val_dd_mm_yyyy');   // new Date(2013, 7-1, 1)
$("<input value='dd / 07 / 2013' />").formance('val_dd_mm_yyyy');   // false 
```

### Date yyyy / mm / dd

Similar to documentation of `dd / mm / yyyy` except the format is `yyyy / mm / dd`.

### Email Address

You cannot format an email address field because there is no structure.

Before everybody goes on a rant, I agree that the only way to validate an email address is to send it an email. However, some client side validation does not hurt especially since 99% of email addresses won't have multiple `@` symbols and be top level domains.

If you want to contribute another email validator by all means do so. It would be helpful to have multiple email validators with varying degrees of coverage. 

Validates the email address:

* Validates the email address using the algorithm specified by the data attribute `formance_algorithm`. By default the `simple` algorithm is used.
* For now there are only 2 algorithms `simple` and `complex`. 
* Simple is very lenient and as a result there can be false positives (an email is labelled a valid when it is invalid).
* Complex as the name suggests, is less forgiving and works for 99% cases, but it results in more false negatives (an email address is labelled as invalid when it is valid). 

```javascript
$("<input value='john@example.com' />").formance('validate_email');  // true
$("<input value='john@example.com' data-formance_algorithm='simple' />").formance('validate_email');  // true
$("<input value='john@example.com' data-formance_algorithm='complex' />").formance('validate_email');  // true
$("<input value='postbox@com' data-formance_algorithm='simple' />").formance('validate_email');  // true
$("<input value='postbox@com' data-formance_algorithm='complex' />").formance('validate_email');  // false
```

### Number

Formats the number:

* Restricts input to numbers 

```javascript
$('input.number').formance('format_number');
```

Validates the number:

* Validates all characters are digits
* If the `formance_length` data attribute exists, then it will check that the input length matches what was specified. It must be a number.

```javascript
$("<input value='1234' />").formance('validate_number'); // true
$("<input value='1234' data-formance_length=4 />").formance('validate_number'); // true
$("<input value='1234' data-formance_length=5 />").formance('validate_number'); // false
$("<input value='1234a' />").formance('validate_number'); // false
```

### Ontario Driver's License Number

Formats the Ontario Driver's License Number in the format `A1234 - 12345 - 12345`:

* Limits length to 1 letter and 14 numbers
* Restricts input to alphanumeric characters
* Inserts a ` - ` every 5 characters.

```javascript
$('input.odln').formance('format_ontario_drivers_license_number');
```

Validates the Ontario Driver's License Number:

* *Does NOT validate whether the driver's license number actually exists.*
* Validates length 
* Validates of the format 1 letter followed by 14 numbers

```javascript
$("<input value='A12341234512345' />").formance('validate_ontario_drivers_license_number'); // true
$("<input value='A1234 - 12345 - 12345' />").formance('validate_ontario_drivers_license_number'); // true
$("<input value='A1234 - 12345 - 123456' />").formance('validate_ontario_drivers_license_number'); // false
$("<input value='A1234 - 1234 - 12345' />").formance('validate_ontario_drivers_license_number'); // false
```

### Ontario Photo Health Card Number

Formats the Ontario Photo Health Card Number in the format `1234 - 123 - 123 - AB`:

* Limits length to 10 numbers and 2 letters
* Restricts input to alphanumeric characters
* Inserts a ` - ` after the first 4 characters, and every 3 characters going forward.

```javascript
$('input.ophcn').formance('format_ontario_photo_health_card_number');
```

Validates the Ontario Photo Health Card Number:

* *Does NOT validate whether the health card number actually exists.*
* Validates length 
* Validates of the format 10 numbers followed by 2 letters

```javascript
$("<input value='1234123123AB' />").formance('validate_ontario_photo_health_card_number'); // true
$("<input value='1234 - 123 - 123 - AB' />").formance('validate_ontario_photo_health_card_number'); // true
$("<input value='1234 - 123 - 123 - ABC' />").formance('validate_ontario_photo_health_card_number'); // false
$("<input value='12 - 123 - 123 - AB' />").formance('validate_ontario_photo_health_card_number'); // false
```

### Ontario Outdoors Card Number

Formats the Ontario Outdoors Card Number in the format `708158 123456789`:

* Limits length to 15 numbers
* Restricts input to numbers
* All numbers begin with `708158`
* Inserts a ` ` after the standard first 6 characters.

```javascript
$('input.oocn').formance('format_ontario_outdoors_card_number');
```

Validates the Ontario Outdoors Card Number:

* *Does NOT validate whether the outdoors card number actually exists.*
* Validates length 
* Validates 9 numbers after `708158`

```javascript
$("<input value='708158123456789' />").formance('validate_ontario_outdoors_card_number'); // true
$("<input value='708158 123456789' />").formance('validate_ontario_outdoors_card_number'); // true
$("<input value='708158 123456789012' />").formance('validate_ontario_outdoors_card_number'); // false
$("<input value='708158 123456' />").formance('validate_ontario_outdoors_card_number'); // false
$("<input value='708158 123456789abce' />").formance('validate_ontario_outdoors_card_number'); // false

```

### Phone Number (North America)

Formats the phone number in the `(111) 111 - 1111` format :

* Limits to 10 numbers
* Restricts inputs to numbers 
* Includes `(` and `)` around the area code
* Includes a `-` between the prefix (first 3 digits after the area code) and the line number (last 4 digits)

```javascript
$('input.phone_number').formance('format_phone_number');
```

Validates the phone number:

* *Does NOT validate whether the number actually exists.*
* Validates numbers
* Validates length (after stripping away non digit characters) 


```javascript
$("<input value='6131231234' />").formance('validate_phone_number'); // true
$("<input value='(613) 123 - 1234' />").formance('validate_phone_number'); // true
$("<input value='(613) 123 - 12345' />").formance('validate_phone_number'); // false
```

### Postal Code (Canada)

Formats the postal code in the `A1A 1A1` format: 

* Limits to 6 letters and numbers
* Restricts to alphanumeric (letters and numbers) 

According to http://stackoverflow.com/questions/1146202/canada-postal-code-validation.

* First letter can't be D,I,O,Q,U,W,Z
* Second letter can't be D,I,O,Q,U
* Third letter can't be D,I,O,Q,U

```javascript
$('input.postal_code').formance('format_postal_code');
```

Validates a postal code field:

* *Does NOT validate whether it is an actual postal code, check with Canada Post if you want to be certain.*
* Validates length (after stripping away non alphanumeric characters)
* Validates alternating letters and numbers
* First letter can't be D,I,O,Q,U,W,Z
* Second letter can't be D,I,O,Q,U
* Third letter can't be D,I,O,Q,U

```javascript
$("<input value='a1a1a1' />").formance('validate_postal_code');     // true
$("<input value='A1A 1A1' />").formance('validate_postal_code');   // true
$("<input value='a1a1' />").formance('validate_postal_code');        // false
```

## Set up Project Locally

### Installation

```
npm install -g jquery
npm install -g mocha
npm install -g coffee-script
npm install -g uglify-js
npm install https://github.com/omarshammas/jquery.formance.git
```

### Cake

Cake is the equivalent of make or rake but for Coffeescript.

```
cake coffee         # Builds lib/jquery.formance.js from src/
cake watch          # Watch src/ for changes
cake test           # Runs all tests
cake minify         # Minifies any js files in lib/
cake build          # Builds lib/jquery.formance.js and minifies it
```

### Side Notes

`src/fields` was renamed to `src/zfields` to ensure that `jquery.formance.coffee` is compiled first when concatenating all fields otherwise the fields wouldn't be able to access `$.fn.formance`.

## Contributing

Contributions are more than welcome. Together we can make this a solid library, and hopefully a friendlier web.

### Adding A New Field

To create your own field formatters and validators, simply add a new file under `src/zfields/` with the name of the field type. It is probably best to look at how the other fields were written before starting your own.

It is important to write tests for the new field to ensure it works as expected. Each field should have a corresponding file under `test/fields/`.

