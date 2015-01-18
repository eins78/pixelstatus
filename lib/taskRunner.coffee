log= require('./logger')
runByType= require('./runners')

taskRunner= (callback) ->
  task= this
  return callback 'no task!' unless task?
  log.info "running: '#{task.id}', type='#{task.check.type}'"
  log.debug "details: '#{task.id}'", task
  
  runByType[task.check.type] task.check, (err, res)->
    if err?
      log.error('check runner error!', task.id, task.check, err)
    callback(err, res)

taskRunner.runners = Object.keys(runByType)

module.exports = taskRunner
