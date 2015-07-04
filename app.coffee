#!/usr/bin/env coffee

# consts
LIMIT=2  # how many jobs to run at a time?
LOOP=true # run it forever?
WAIT=3    # seconds to wait between checks

# deps
async= require('async')
f= require('lodash')

# setup `require('lib/foo')` with `.coffee` extension
require('coffee-script/register')


u= require('./lib/util')
log= require('./lib/logger')

# lib
buildTask= require('./lib/buildTask')
# workflow
taskRunner= require('./lib/workflow/taskRunner')
expectator= require('./lib/workflow/expectator')
Reactor= require('./lib/workflow/reactor')

###
  TODO:
    - check config: json-schema, overlapping ranges
    - set LED colors from assertion for section
    - runner: command with `child_process.spawn`
    - runner: always
###

# config
config= require('./lib/readConfig')
sections= config?.sections
pixelSections = f(sections).map((section)->
  [section?.id, { length: section?.length }])
  .zipObject().value() # e.g. `{ foo: { length: 1 }, bar: { length: 1 } }`


wait= (fn, seconds = 60) ->
  seconds = seconds
  log.info "[wall]: waiting #{seconds} seconds…"
  setTimeout fn, seconds*1000

loop_if_configured= (fn)-> if LOOP and fn then async.forever(fn) else do fn

# kickoff
tasks= sections.map buildTask
log.info "[wall]: running #{tasks.length} #{u.plural('task', tasks)}…"

PixelController= require('pixel')
pixels = PixelController(f.merge({}, config, { sections: pixelSections }))
reactor = Reactor(pixels)

pixels.init (err)->
  if err?
    throw '[wall]: pixels init failed! ' + err
  pixels.setAllSections('salmon')
  loop_if_configured (next)->
    # run each task async:
    async.mapLimit tasks, LIMIT, (task, callback)->
        # task async workflow:
        # - each step has this=task and callback(err, res)
        # - all steps gets `res` from step before as first arg
        workflow= [taskRunner, expectator, reactor.react]
        async.waterfall(workflow.map((step)->step.bind(task)), callback)
    , (err)->
      log.error('[wall]: error', err) if err?
      if next?
        wait(next, WAIT)
      else
        process.exit(0)

exitHandler=(err)->
  do f.once ->
    log.info '[wall]: exiting…', if err? then err else 'ok'
    if pixels?.connected
      log.verbose '[wall]: setting black…'
      pixels.setAllSections('black')
      pixels.connected = false
  process.exit(if err? then 1 else 0)

process.on 'SIGINT', exitHandler
# process.on 'exit', exitHandler
process.on 'uncaughtException', exitHandler
