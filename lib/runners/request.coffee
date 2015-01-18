log = require('../logger')

module.exports = runRequest= (check, callback) ->
  request= require('request')
  
  request check.data, (err, res, body)->
    log.verbose "request error", check, err if err?
    
    parsed_json= null
    try parsed_json = JSON.parse(body)
    catch error
      # ignore error, we tried parsing just in case.
    
    res= {
      error: err || ''
      output: (if parsed_json? then parsed_json else body) || ''
      status: res?.statusCode || 400,
    }
    
    callback(null, res) # ignore error in terms of control flow
