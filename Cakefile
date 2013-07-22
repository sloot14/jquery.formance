# Adapted from http://kgn.github.io/wheel.coffee/Cakefile.html

{spawn, exec} = require 'child_process'
{log, error} = console; print = log
fs = require 'fs'

run = (name, args...) ->
    proc = spawn(name, args)
    proc.stdout.on 'data', (buffer) -> print buffer if buffer = buffer.toString().trim()
    proc.stderr.on 'data', (buffer) -> error buffer if buffer = buffer.toString().trim()
    proc.on 'exit', (status) -> process.exit(1) if status isnt 0

shell = (cmds, callback) ->
    cmds = [cmds] if Object::toString.apply(cmds) isnt '[object Array]'
    exec cmds.join(' && '), (err, stdout, stderr) ->
        print trimStdout if trimStdout = stdout.trim()
        error stderr.trim() if err
        callback() if callback


# task 'coffee', 'Build lib/ from src/', ->
#     run 'coffee', '-co', 'lib', 'src'

task 'coffee', 'Builds lib/jquery.formance.js from src/', ->
    run 'coffee', '-j', 'lib/jquery.formance.js', '-c', 'src'

task 'watch', 'Watch src/ for changes', ->
    run 'coffee', '-wj', 'lib/jquery.formance.js', '-c', 'src'

task 'test', 'Run tests', ->
    invoke 'coffee'
    run 'mocha', '--recursive', '--compilers', 'coffee:coffee-script', '-c'

task 'bail', 'Runs tests and bails on first error', ->
    invoke 'coffee'
    run 'mocha', '--recursive', '--compilers', 'coffee:coffee-script', '-c', '-b'

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
    invoke 'coffee'
    invoke 'minify'
