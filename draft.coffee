#!/usr/bin/env coffee

LIMIT=1

fs= require('fs')
async= require('async')
u= require('./lib/util')
log= require('./lib/logger')
runner= require('./lib/runners')
expectator= require('./lib/expectator')

configFile=process.argv[2]
throw 'no config file!' unless configFile?
config= JSON.parse(fs.readFileSync configFile)
throw 'no config!' unless config?

###
  TODO:
    - check config: json-schema, overlapping ranges
    - build LED colors from assertion
    - run command with `child_process.spawn`
    - task.always - color
###

# lib
buildTask= (task) ->
  type = switch
    when task.request? then 'request'
    when task.command? then 'command'
    # when task.always? then 'dummy'
    else throw "task #{task?.id}: one of `command` or `request` required!"
  # TODO: allow object. now: {request:'foo'}, new: {request:{get:'foo'}}
  task.check = { string: task[type] }
  delete task[type]
  task.check.type = type
  task

runTask= (task, callback) ->
  return callback 'no task!' unless task?
  log.info "running: '#{task.id}', type='#{task.check.type}'"
  log.verbose task
  runner[task.check.type] task.check, (err, res)->
    if err?
      log.error('check runner error!', task)
      return callback err
    expectator(task, res, callback)


# build tasks
tasks= config?.sections
throw 'config: no tasks!' unless tasks?
tasks = tasks.map buildTask

log.info "running #{tasks.length} #{u.plural('check', tasks)}…"

# run
do run= ()->
  async.mapLimit tasks, LIMIT, runTask, (err)->
    return log.error 'FIN: err', err if err?
    log.info 'FIN'
