assert= require('assert')
f= require('lodash')
utile= require('utile')

util= f.merge utile,
  assert: assert

  plural: (string, count)->
    number = switch typeof count
      when 'number' then count
      when 'string' then parseInt(count, 10)
      when 'object' then count.length
    if number > 1
      return "#{string}s"
    string

  array_of: (obj, length) ->
    (f.map new Array(length), -> obj)

module.exports = util
