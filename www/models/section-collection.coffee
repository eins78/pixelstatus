Collection = require('ampersand-rest-collection')
Section = require('coffee!./section.coffee')

module.exports = Collection.extend
  url: ()-> @parent.url + 'sections/'

  model: Section
