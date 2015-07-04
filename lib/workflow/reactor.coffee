LENGTH=60

async = require('async')
f= require('lodash')

log= require('lib/logger.coffee')

pixel_controller= null

class Reactor
  constructor: (@pixels) ->
    return new Reactor(@pixels) unless (@ instanceof Reactor)
    pixel_controller = @pixels

  react: (res, callback) ->
    task= this

    unless pixels?.set?
      callback 'reactor: no pixels connected!'

    section= task?.id
    state= (if f.reduce(f.flatten(res)) then 'ok' else 'fail')
    wanted= task[state]

    log.info "#{section}: #{state}. setting to #{wanted}"
    pixel_controller.set(section, wanted, callback)

module.exports = Reactor
