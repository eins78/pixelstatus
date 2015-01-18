f= require('lodash')
log= require('./logger')

module.exports= reactToResult= (res, callback) ->
  task= this
  log.debug('results:', task?.id, res)
  
  state= (if f.reduce(f.flatten(res)) then 'ok' else 'fail')
  log.verbose('state:', task?.id, state)
  wanted= task[state]
  log.warn "not implemented, but #{task.id} would be #{wanted} (#{state})"
  
  callback null, state
