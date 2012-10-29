fs = require 'fs'

{print} = require 'util'
{spawn, exec} = require 'child_process'

COFFEE_FILES = [
  "jquery.slugger.coffee",
  "slugger.coffee",
  "utils.coffee"
]

task "build", "Package Slugger for distribution", ->
  fs.readFile 'VERSION', 'utf8', (err, data) ->
    throw err if err
    version = data
    emptyLib()
    compileCoffee(false, version)

task "build:tag", "Tag the git repo with the version number", ->
  fs.readFile 'VERSION', 'utf8', (err, data) ->
    throw err if err
    execute "git", ["tag", data]

task "build:development", "Watch for changes in src and update development package", ->
  compileCoffee(true)

emptyLib = ->
  execute "rm", ["-r", "lib"]

compileCoffee = (development, version = null) ->
  behavior = if development then "-w" else "-c"
  outputPath = if development then "development/lib/js" else "lib/js"
  outputFilename = "crevasse.js"
  options = [
    "-j",
    outputFilename,
    behavior,
    "-o",
    outputPath
  ]
  # Add files to compile in proper order
  options.push "src/coffee/#{file}" for file in COFFEE_FILES
  execute "coffee", options, ->
    markVersion("#{outputPath}/#{outputFilename}", version)

markVersion = (file, version) ->
  comment = """
    /*
      Slugger #{version}
      Built by Nick Giancola: https://github.com/patbenatar
      Details and source: https://github.com/patbenatar/jquery-slugger
      Demo: https://patbenatar.github.com/jquery-slugger
    */

    """
  tmpFile = "#{file}.tmp"
  exec "echo \"#{comment}\" | cat - #{file} > #{tmpFile} && mv #{tmpFile} #{file}"

execute = (command, options, callback = null) ->
  command = spawn command, options
  command.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  command.stdout.on 'data', (data) ->
    print data.toString()
  command.on 'exit', (code) ->
    callback?() if code is 0
