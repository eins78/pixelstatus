HttpRequest= require('request')
f = require('lodash')
log = require('../logger')
optionalJSONparse = require('../optional-json-parse')

module.exports = runRequest= (check, callback) ->
  HttpRequest(check.data, (err, res, body)->
    log.verbose "request err", check, err if err?
    body = optionalJSONparse(body) || ''
    callback(null,
      error: err || ''
      body: body
      json: (f.isObject(body)) && optionalJSONparse(body)
      status: res?.statusCode || 400))
