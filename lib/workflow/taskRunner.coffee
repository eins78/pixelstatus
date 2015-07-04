log= require('../logger')
runByType= require('../runners')

# runs a single `task` with appropriate `runner` for it's type `type`
taskRunner= (callback) ->
  task= this
  return callback 'no task!' unless task?
  log.info "#{task.id}: running. type='#{task.check.type}'"
  log.debug "#{task.id}: details", task

  runByType[task.check.type] task.check, (err, res)->
    if err?
      log.error('check runner error!', task.id, task.check, err)
    callback(err, res)

module.exports = taskRunner
