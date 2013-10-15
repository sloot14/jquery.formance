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

    formance_file_name = get_formance_file_name()
    options = ['-j', 'lib/' + formance_file_name, '-c', 'src']
    options.unshift '-w' if watch
    run 'coffee', options, () ->
        shell "cd lib && ln -fs " + formance_file_name + " jquery.formance.js", callback

test = (bail, callback) ->
    if typeof bail is 'function'
        callback = bail
        bail = false

     options =  ['--recursive', '--compilers', 'coffee:coffee-script', '-c']
     options.unshift '-b' if bail
     run 'mocha', options, callback

get_version = () ->
    data = fs.readFileSync 'package.json', 'utf8'
    data = JSON.parse(data)
    return data.version

get_formance_file_name = () ->
    'jquery.formance-' + get_version() + '.js'

add_min_to_file_name = (file_name) ->
    nameparts = file_name.split '.'
    nameparts[nameparts.length-1] = 'min'
    nameparts.push 'js'
    nameparts.join '.'


# task 'coffee', 'Build lib/ from src/', ->
#     run 'coffee', '-co', 'lib', 'src'

task 'version', 'Returns the version of formance', ->
    console.log get_version()

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

            new_name = add_min_to_file_name(file)
            print "minify: #{file} -> #{new_name}"
    
            if file is 'jquery.formance.js'
                shell "cd #{dir} && ln -fs #{add_min_to_file_name(get_formance_file_name())} #{new_name}"
            else
                shell "cd #{dir} && uglifyjs --output #{new_name} #{file}"

task 'build', 'Builds lib/jquery.formance.js and minifies it.', ->
    build ->
        invoke 'minify'
