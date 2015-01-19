#!/usr/bin/env coffee

LIMIT=32

async= require('async')
u= require('lib/util')
log= require('lib/logger')

buildTask= require('lib/buildTask')
taskRunner= require('lib/taskRunner')
expectResult= require('lib/expectator')
reactToResult= require('lib/reactor')

###
  TODO:
    - check config: json-schema, overlapping ranges
    - set LED colors from assertion for section
    - runner: command with `child_process.spawn`
    - runner: always
###

# config
config= require('lib/readConfig')
tasks= config?.sections

# kickoff
tasks.map buildTask.bind(taskRunner.runners)
log.info "running #{tasks.length} #{u.plural('check', tasks)}…"
do workflow= (tasks)->
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
