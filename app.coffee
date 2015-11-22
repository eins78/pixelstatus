#!/usr/bin/env coffee

async= require('async')
f= require('lodash')
# setup `require('lib/foo')` with `.coffee` extension
require('coffee-script/register')

# CONFIG
config= f.defaults require('./lib/readConfig'),
  loop:  true # run it forever?
  limit: 8    # how many jobs to run at a time?
  wait:  3    # seconds to wait between checks

# lib
u= require('./lib/util')
log= require('./lib/logger')
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

# setup hardware
pixelSections = f(config.sections).map((section)->
  [section?.id, { length: section?.length }])
  .zipObject().value() # e.g. `{ foo: { length: 1 }, bar: { length: 1 } }`
PixelController= require('pixel')
pixels = PixelController(f.merge({}, config, { sections: pixelSections }))

# init hardware and start worker
worker = require('./lib/worker')
pixels.init (err)->
  if err? then throw '[wall]: pixels init failed! ' + err
  pixels.setAllSections('salmon')
  worker(config, pixels)

  # setup and init web interface and api server
  require('./lib/server')(config, pixels)


# exit handlers (shutdown lights on exit)
exitHandler= (errorOrStatus)->
  err = errorOrStatus or null
  do f.once ->
    if err?
      log.error('[wall]: error!', err)
    else
      log.info('[wall]: exiting…', if err? then err else 'ok')
    if pixels?.connected
      log.verbose '[wall]: setting black…'
      pixels.setAllSections('black')
      pixels.connected = false
  process.exit(if err? then 1 else 0)

process.on 'SIGINT', exitHandler
process.on 'exit', exitHandler
process.on 'uncaughtException', exitHandler
