f= require('lodash')

module.exports = buildTask= (task, callback) ->
  runners= this
  type = f.first f.compact f.map runners, (r)-> if task[r]? then r
  check= { data: task[type] }
  unless check?
    throw "task #{task?.id}: no valid runner! #{runners.join(', ')}"
  
  task.check = check
  delete task[type]
  task.check.type = type
  
  task
