Color = require('colour.js')

module.exports = parseColor= (input)->
  do (new Color(input)).rgb255
