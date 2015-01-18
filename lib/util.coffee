module.exports = util=
  plural: (string, count)->
    number = switch typeof count
      when 'number' then count
      when 'string' then parseInt(count, 10)
      when 'object' then count.length
    if number > 1
      return "#{string}s"
    string
