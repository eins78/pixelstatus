log= require('./logger')
runByType= require('./runners')

module.exports = taskRunner= (callback) ->
  task= this
  return callback 'no task!' unless task?
  log.info "running: '#{task.id}', type='#{task.check.type}'"
  log.verbose "details: '#{task.id}'", task
  
  runByType[task.check.type] task.check, (err, res)->
    if err?
      log.error('check runner error!', task)
    callback(err, res)
