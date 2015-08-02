Hapi= require('hapi')
Joi= require('joi')
Boom = require('boom')

f= require('lodash')
Color= require('color')

module.exports= (config, pixelController)->
  server = new Hapi.Server({
    connections:
      routes: { cors: true }
  })

  server.connection
    host: 'localhost'
    port: 7891

  server.route
    method: 'GET'
    path: '/{param*}'
    config:
      description: 'Show the web interface',
      tags: ['ui']
    handler:
      directory: { path: './www/dist', index: true, listing: false }

  server.route # TMP testing/debugging
    method: 'GET'
    path: '/api/config'
    config:
      description: 'API: get config',
      tags: ['api']
    handler: (_req, reply)-> reply(JSON.stringify(config, 0, 2))

  server.route
    method: 'GET'
    path: '/api/'
    config:
      description: 'Get API entry point',
      tags: ['ui']
    handler: (_req, reply)-> reply({
      title: config.title
      sections_url: 'sections/'
    })

  server.route
    method: 'GET'
    path: '/api/sections/'
    config:
      description: 'API: list all sections',
      tags: ['api']
    handler: (request, reply)->
      sections = f(config.sections).map (s)-> {id: s.id}
      reply(JSON.stringify(sections, 0, 2))

  server.route
    method: 'GET'
    path: '/api/sections/{section}'
    config:
      description: 'API: get a section',
      tags: ['api']
    handler: (request, reply)->
      section = f(config.sections).find id: request.params.section
      section.color = section.ok # hack
      reply(JSON.stringify(section, 0, 2))

  server.route
    method: 'PATCH'
    path: '/api/sections/{section}'
    config:
      description: 'API: set one or more properties of a section',
      tags: ['api']
      validate:
        params:
          section: Joi.string().regex(/[a-zA-Z0-9_\-]/)
        payload: Joi.object().length(1).keys
          color: (Joi.string().required().min(1).max(32)
                  .regex(/[a-zA-Z0-9\#\s\(\)\%\,]/))

    handler: (request, reply)->
      section= request.params.section
      color= request.payload?.color

      unless (f(config.sections).find(id: section))?
        return reply(Boom.notFound('Section not found: ' + section))

      valid_color = try
          Color(color).rgb()
        catch # ignore error
          null

      unless valid_color?
        return reply(Boom.badData('Not a color: ' + color))

      pixelController.set section, valid_color, ()->
        reply("section '" + section + "' set to '" + color + "'!\n")


  server.start ->
    console.log('Server running at:', server.info.uri)
