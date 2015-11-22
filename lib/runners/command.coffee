execShell = require('child_process').exec
log = require('../logger')
optionalJSONparse = require('../optional-json-parse')

module.exports = runCommand= (check, callback) ->
  shell = execShell(check.data, (err, stdout, stderr)->
    log.verbose 'command err', check, err if err?
    log.verbose 'command stderr', check, stderr if stderr?
    [stdout, stderr] = [optionalJSONparse(stdout), optionalJSONparse(stderr)]
    callback(null,
      error: err || stderr || ''
      stderr: stderr || ''
      stdout: stdout || ''
      status: if err? then err.code else 0))

  shell.on('error', (err)->
    log.verbose('command err', check, err)
    callback(err or true))
