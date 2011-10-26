
task "web:start", "Start the server.", ->
  {exec} = require 'child_process'
  exec 'npm start', (error, stdout, stderr) ->
    console.log stdout
    console.log stderr
    console.log error if error?
