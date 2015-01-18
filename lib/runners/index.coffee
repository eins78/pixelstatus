module.exports = runner= {
  request: (check, callback) ->
    require('request')(check.string, (err, res, body)->
      res= {
        error: err
        output: body
        status: res?.statusCode,
      }
      callback(err, res)
    )
  command: (check, callback) ->
    callback('not implemented', null)
}
