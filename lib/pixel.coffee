opc = require('open-pixel-control')
log = require('lib/logger')

module.exports = pixel=
  connect: (config, callback)->
    unless config?.strips?.length
      throw 'pixels: need config.strips!'

    client = new opc
      address: '127.0.0.1'
      port: 7890

    client.on 'connected', ->
      log.info "pixel: connected!"
      if config.strips?
        strips = config.strips.map (s)->
          if typeof s == 'number'
            client.add_strip { length: s }
      callback(null, client)
    
    client.on 'disconnected', ->
      log.warn "pixel: disconnected!"
    
    client.on 'error', ->
      log.error "pixel: error!"

    do client.connect