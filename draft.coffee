#!/usr/bin/env coffee

LIMIT=1

fs= require('fs')
async= require('async')
u= require('./lib/util')
log= require('./lib/logger')
taskRunner= require('./lib/taskRunner')
expectResult= require('./lib/expectator')

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

reactToResult= (res, callback) ->
  f= require('lodash')
  task= this
  log.debug('results:', task?.id, res)
  
  state= (if f.reduce(f.flatten(res)) then 'ok' else 'fail')
  log.verbose('state:', task?.id, state)
  wanted= task[state]
  log.info wanted, state

  callback null

# build tasks
tasks= config?.sections
throw 'config: no tasks!' unless tasks?
tasks = tasks.map buildTask

log.info "running #{tasks.length} #{u.plural('check', tasks)}…"

# run
do run= ()->
  # run each task async:
  async.mapLimit tasks, LIMIT, (task, callback)->
      # task async workflow:
      # - each step has this=task and callback(err, res)
      # - all steps gets `res` from step before as first arg
      workflow= [taskRunner, expectResult, reactToResult]
      async.waterfall(workflow.map((step)->step.bind(task)), callback)
  , (err)->
    return log.error 'FIN: err', err if err?
    log.info 'FIN'
