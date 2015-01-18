#!/usr/bin/env coffee

LIMIT=1

fs= require('fs')
async= require('async')
runner= require('./lib/runners')

config= JSON.parse(fs.readFileSync(process.argv[2]))
throw 'no config!' unless config?

###
  TODO:
    - check config: json-schema, overlapping ranges
    - run request with `request`
    - check assertions
    - build LED colors from assertion
    - run command with `child_process.spawn`
###

# lib
buildTask= (task, callback) ->
  type = switch
    when task.request? then 'request'
    when task.command? then 'command'
    else throw "task #{task?.id}: `command` or `request` is required!"
  task.check = { string: task[type] }
  delete task[type]
  task.check.type = type
  callback(task)

runTask= (task, callback) ->
  throw 'no task!' unless task?
  console.log "running: '#{task.id}', type='#{task.check.type}'"
  runner[task.check.type] task.check, callback

# run
tasks= config?.sections
throw 'config: no tasks!' unless tasks?

async.mapLimit tasks, LIMIT, async.seq(buildTask, runTask),
  (err)->
    return console.error 'FIN: err', err if err?
    console.log 'FIN'
