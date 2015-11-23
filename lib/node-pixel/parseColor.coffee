isNumber = require('lodash/lang/isNumber')
isString = require('lodash/lang/isString')
every = require('lodash/collection/every')
Color= require('color')

log= require('./logger')

module.exports= parseColor=(input)->
  return color = try
      Color(input).rgb()
    catch # ignore error
      null
