# jQuery.formance

A general purpose library for formatting and validating form fields, based on Stripe's jQuery.payment library.
 
## Getting Started

Coming soon, in the mean time checkout the example.

## Example

Look in ```./example/index.html```

## Adding A New Field

To can create your own formatters and validators, simply add a new file under ```src/zfields/``` with the name of the field type. It is probably best to look at how the other fields were written before starting your own. You can even use them as a base. 

It is important to write tests for the new field to ensure it works as expected. Each field should have a corresponding file under ```test/fields/```.

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

```src/fields``` was renamed to ```src/zfields``` to ensure that jquery.formance.coffee is compiled first when concatenating all fields otherwise the fields wouldn't be able to access $.fn.formance.
