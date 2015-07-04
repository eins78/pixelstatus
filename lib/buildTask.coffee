f= require('lodash')

# we only need them for validation
runners= Object.keys(require('./runners'))

module.exports = buildTask= (task, callback) ->
  # get the first key with the name of a valid runner
  runner = f.first f.compact f.map runners, (r)-> if task[r]? then r
  data = task[runner]

  unless data?
    throw "task #{task?.id}: no valid runner! try one of: #{runners.join(', ')}"

  f.merge {},
    f.omit(task, runner),
    { check: { data: data, type: runner } }
