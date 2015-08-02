Model = require('ampersand-model')
SectionCollection = require('coffee!./section-collection.coffee')

module.exports = Model.extend
  # TODO: set from input, name PixelServer, make collection…
  url: 'http://localhost:7891/api/'

  props:
    title: 'string'

  collections:
    sections: SectionCollection

  fetchInitialData: ()->
    this.fetch()
    this.sections.fetch()
