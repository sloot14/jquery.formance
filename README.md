# jQuery.formance

A javascript library for formatting and validating form fields, based/inspired by Stripe's jQuery.payment library. 

Client side validation is not sufficient in any project because the javascript can be bypassed and people can submit requests directly to the server. However, that doesn't mean client side validation should be forgotten. This library is for those who care about the user experience.

## Demo

Look in `./example/index.html`
Coming soon, in the mean time checkout the example.

## Fields

### Credit Card CVC
This field was built using Stripe's jquery.payment.js as the base.

Formats the credit card cvc

* Restricts length to 4
* Restricts input to numbers

```javascript
$('input.credit_card_cvc').formance('format_credit_card_cvc');
```

Validates the cvc

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

Formats the expiry date in the  `mm / yyyy` format.

* Includes a `/` between the month and year
* Restricts input to numbers
* Restricts length

```javascript
$('input.credit_card_expiry').formance('format_credit_card_expiry');
```

Validates the expiry date

* Validates numbers
* Validates in the future
* Supports year shorthand

```javascript
$('input.credit_card_expiry').formance('validate_credit_card_expiry');

//examples
$('<input type=text val="05 / 20" />').formance('validate_credit_card_expiry');   // true
$('<input type=text val="05 / 2020" />').formance('validate_credit_card_expiry'); // true
$('<input type=text val="05 / 1900" />').formance('validate_credit_card_expiry'); // false
$('<input type=text val="mm / 20" />').formance('validate_credit_card_expiry');   // false
```

### Credit Card Number

Formats card numbers:

* Including a space between every 4 digits
* Restricts input to numbers
* Limits to 16 numbers
* American Express formatting support
* Adds a class of the card type (i.e. 'visa') to the input

```javascript
$('input.credit_card_number').formance('format_credit_card_number');
```

Validates a card number:

* Validates numbers
* Validates Luhn algorithm
* Validates length

```javascript
$('input.credit_card_expiry').formance('validate_credit_card_number');

//examples
$('<input type=text val="4242 4242 4242 4242" />').formance('validate_credit_card_number');   // true
$('<input type=text val="4242-4242-4242-4242" />').formance('validate_credit_card_expiry');   // true
$('<input type=text val="4242424242424242" />').formance('validate_credit_card_number');      // true
$('<input type=text val="4242 42" />').formance('validate_credit_card_number');   // false
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

Formats date in `dd / mm / yyyy` format:

* Restricts inputs to numbers or slashes depending on the current state
* Limits to 8 numbers
* Does NOT accept shorthand to avoid ambiguities
* Include smart helper if current state and `4` is entered the resulting value would be `04 / ` since there is no day starting with 4 in a month.

```javascript
$('input.dd_mm_yyyy').formance('format_dd_mm_yyyy');
```

Validates a date:

* Ensures the date can be legitamitely parsed.
* Validates the date actually exists so it will fail if February 30th is entered.

```javascript
$('input.dd_mm_yyyy').formance('validate_dd_mm_yyyy');
```

Date includes a helper function to retrieve the date val. *Note it does not check to see if it valid.*. It simply creates a date object with the specified values which may be incorrect. For example `new Date(2013, 2-1, 30)` returns March 2nd because February does not have 30 days. You should check if it is valid before using the date. If the text is parsed without any errors then a Javascript Date object is returned otherwise false.

```javascript
$('<input type=text val="01 / 07 / 2013" />').formance('val_dd_mm_yyyy');   // new Date(2013, 7-1, 1)
$('<input type=text val="dd / 07 / 2013" />').formance('val_dd_mm_yyyy');   // false 
```


### Date yyyy / mm / dd

Formats date in `yyyy / mm / dd`. Refer to documentation of Date dd / mm / yyyy.


### Email Address

You cannot format an email field because there is no structure.

Before everybody goes on a rant, I'm with you the only way to validate an email address is to send it an email. However, some client side validation does not hurt especially since 99% of email addresses won't have `@` symbols and be top level domains.

If you want to contribute another email validator by all means do so. It would be helpful to have a naive validation and some more complex ones available in the library.

Validates an email:

```javascript
$('<input type=text val="john@example.com" />').formance('validate_email');
```

Note that this fails in many odd and unusual cases. Refer to `tests/fields/email.coffee` and see the uncommented ones. These are obviously not exhaustive tests, and were retrieved from Wikipedia.

### Number

Formats number fields:

* Restricts inputs to numbers 

```javascript
$('input.number').formance('format_number');
```

Validates a number field:

* Validates all characters are digits
* If the `formance_length` data attribute exists, then it will check that the input length matches what was specified. 

```javascript
$('<input type=text value='1234' />').formance('validate_number'); // true
$('<input type=text value='1234' data-formance_length=4 />').formance('validate_number'); // true
$('<input type=text value='1234' data-formance_length=5 />').formance('validate_number'); // false
$('<input type=text value='1234a' />').formance('validate_number'); // false
```

### Phone Number (North America)

Formats phone number fields:

* Restricts inputs to numbers 
* Formats as `(111) 111 - 1111`

```javascript
$('input.phone_number').formance('format_phone_number');
```

Validates a number field:

* Validates there are 10 digits (after stripping away non digits characters).
* Does NOT validate whether the number actually exists.

```javascript
$('<input type=text value='6131231234' />').formance('validate_phone_number'); // true
$('<input type=text value='(613) 123 - 1234' />').formance('validate_phone_number'); // true
$('<input type=text value='12345678901' />').formance('validate_phone_number'); // false
$('<input type=text value='(613) 123 - 12345' />').formance('validate_phone_number'); // true
```

### Postal Code (Canada)

Formats Postal Code fields based on http://stackoverflow.com/questions/1146202/canada-postal-code-validation.

* Restricts to the format `A1A 1A1` 
* Restricts to alphanumeric (letters and numbers) 
* First letter can't be D,I,O,Q,U,W,Z
* Second letter can't be D,I,O,Q,U
* Third letter can't be D,I,O,Q,U

```javascript
$('input.postal_code').formance('format_postal_code');
```

Validates a postal code field:

* Does NOT validate whether it is an actual postal code, check with Canada Post if you want to be certain.
* Validates of the format `a1a1a1`, alternating letter and number for length of 6
* First letter can't be D,I,O,Q,U,W,Z
* Second letter can't be D,I,O,Q,U
* Third letter can't be D,I,O,Q,U

```javascript
$('<input type=text value='a1a1a1' />').formance('validate_postal_code'); // true
$('<input type=text value='A1A 1A1' />').formance('validate_postal_code'); // true
$('<input type=text value='a1a1' />').formance('validate_postal_code'); // false
```

### Ontario Driver's License
Docs coming soon, but you probably get the gist of how this should work by now.
### Ontario Health Card
Docs coming soon.
### Ontario Outdoors Card
Docs coming soon.


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

Cake is the equivalent of make and rake for coffeescript, and provides the following tasks.

```
cake coffee         # Builds lib/jquery.formance.js from src/
cake watch          # Watch src/ for changes
cake test           # Runs all tests
cake minify         # Minifies any js files in lib/
cake build          # Builds lib/jquery.formance.js and minifies it
```

### Side Notes

`src/fields` was renamed to `src/zfields` to ensure that jquery.formance.coffee is compiled first when concatenating all fields otherwise the fields wouldn't be able to access $.fn.formance.

## Contributing

Contributions are more than welcome. Together we can make this a solid library, and hopefully a friendlier web.

### Adding A New Field

To create your own field formatters and validators, simply add a new file under `src/zfields/` with the name of the field type. It is probably best to look at how the other fields were written before starting your own. You can even use them as a base. 

It is important to write tests for the new field to ensure it works as expected. Each field should have a corresponding file under `test/fields/`.




