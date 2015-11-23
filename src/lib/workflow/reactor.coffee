LENGTH=60

async = require('async')
f= require('lodash')

log= require('../logger')

pixel_controller= null

class Reactor
  constructor: (@pixels) ->
    return new Reactor(@pixels) unless (@ instanceof Reactor)
    pixel_controller = @pixels

  react: (result, callback) ->
    task= this

    unless typeof pixels?.set is 'function'
      callback 'reactor: no pixels connected!'

    section= task.id
    state= (if result.ok then 'ok' else 'fail')

    wanted= task[state]

    log.info "#{section}: #{state}. setting to #{wanted}"
    pixel_controller.set(section, wanted, callback)

module.exports = Reactor
