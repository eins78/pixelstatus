module.exports = runner= {
  request: (check, callback) ->
    request= require('request')
    
    request(check.data, (err, res, body)->
      parsed_json= null
      try parsed_json = JSON.parse(body)
      catch error
        # ignore error, we tried parsing just in case.
      
      res= {
        error: err
        output: if parsed_json? then parsed_json else body
        status: res?.statusCode,
      }
      callback(err, res)
    )
  command: (check, callback) ->
    callback('not implemented', null)
}
