# jQuery.formance

A general purpose library for formatting and validating form fields, based on Stripe's jQuery.payment library.

## Installation

```
npm install jquery
npm install mocha
npm install coffeescript
npm install https://github.com/omarshammas/jquery.formance.git
```

Make sure your node path is setup correctly.

```
export NODE_PATH=/usr/local/lib/node_modules
```

## Cake

Cake is the equivalent of make and rake for coffeescript, and accepts the following commands.

```
cake build
cake watch
cake test
```

## Compiling

You can compile the coffeescript files into a single file (formance.js) using

```
coffee --join lib/formance.js --compile src/*
```


## Side Notes

src/fields was renamed to src/zfields to ensure that jquery.formance.coffee was compiled first otherwise the fields wouldn't be able to access $.fn.formance.

