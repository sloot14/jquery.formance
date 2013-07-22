# Adapted from http://kgn.github.io/wheel.coffee/Cakefile.html

{spawn, exec} = require 'child_process'
{log, error} = console; print = log
fs = require 'fs'

run = (cmd, options=[], callback) ->
    proc = spawn cmd, options
    proc.stdout.on 'data', (buffer) -> print buffer if buffer = buffer.toString().trim()
    proc.stderr.on 'data', (buffer) -> error buffer if buffer = buffer.toString().trim()
    proc.on 'exit', (status) -> callback?() if status is 0

shell = (cmds, callback) ->
    cmds = [cmds] if Object::toString.apply(cmds) isnt '[object Array]'
    exec cmds.join(' && '), (err, stdout, stderr) ->
        print trimStdout if trimStdout = stdout.trim()
        error stderr.trim() if err
        callback() if callback

build = (watch, callback) ->
    if typeof watch is 'function'
        callback = watch
        watch = false

    options = ['-j', 'lib/jquery.formance.js', '-c', 'src']
    options.unshift '-w' if watch
    run 'coffee', options, callback

test = (bail, callback) ->
    if typeof bail is 'function'
        callback = bail
        bail = false

     options =  ['--recursive', '--compilers', 'coffee:coffee-script', '-c']
     options.unshift '-b' if bail
     run 'mocha', options, callback

# task 'coffee', 'Build lib/ from src/', ->
#     run 'coffee', '-co', 'lib', 'src'

task 'coffee', 'Builds lib/jquery.formance.js from src/', ->
    build false

task 'watch', 'Watch src/ for changes', ->
    build true

task 'test', 'Run tests', ->
    build ->
        test false

task 'bail', 'Runs tests and bails on first error', ->
    build ->
        test true

task 'minify', 'Minifies any js file in the lib/ folder.', ->
    dir = 'lib'
    fs.readdir dir, (err, files) ->
        throw err if err
        for file in files
            continue if not /\.js$/.test(file) or /\.min\.js$/.test(file)

            nameparts = file.split '.'
            nameparts[nameparts.length-1] = 'min'
            nameparts.push 'js'
            newname = nameparts.join '.'
            print "minify: #{file} -> #{newname}"
                
            shell "uglifyjs --output #{dir}/#{newname} #{dir}/#{file}"

task 'build', 'Builds lib/jquery.formance.js and minifies it.', ->
    build ->
        invoke 'minify'
