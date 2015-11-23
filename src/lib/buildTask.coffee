f= require('lodash')

# we only need them for validation
runners= Object.keys(require('./runners'))

module.exports = buildTask= (task, callback) ->
  # get the first key with the name of a valid runner
  runner = f.first f.compact f.map runners, (r)-> if task[r]? then r
  data = task[runner]

  # validations: TODO: use joi or something
  unless data?
    throw "task #{task?.id}: no valid runner! try one of: #{runners.join(', ')}"
  missingColorMsg = (c)-> "task #{task?.id}: missing color: #{c}!"
  throw missingColorMsg('ok') if not task.ok?
  throw missingColorMsg('fail') if not task.fail?


  f.merge {},
    f.omit(task, runner),
    { check: { data: data, type: runner } }
