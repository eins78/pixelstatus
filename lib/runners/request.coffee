HttpRequest= require('request')
log = require('../logger')
optionalJSONparse = require('../optional-json-parse')

module.exports = runRequest= (check, callback) ->
  HttpRequest(check.data, (err, res, body)->
    log.verbose "request err", check, err if err?
    callback(null,
      error: err || ''
      output: optionalJSONparse(body) || ''
      status: res?.statusCode || 400))
