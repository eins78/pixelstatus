log= require('lib/logger')
runByType= require('lib/runners')

taskRunner= (callback) ->
  task= this
  return callback 'no task!' unless task?
  log.info "running: '#{task.id}', type='#{task.check.type}'"
  log.debug "details: '#{task.id}'", task
  
  runByType[task.check.type] task.check, (err, res)->
    if err?
      log.error('check runner error!', task.id, task.check, err)
    callback(err, res)

module.exports = taskRunner
