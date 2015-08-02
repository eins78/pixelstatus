async= require('async')

u= require('./util')
log= require('./logger')
buildTask= require('./buildTask')

# workflow
Reactor= require('./workflow/reactor')
taskRunner= require('./workflow/taskRunner')
expectator= require('./workflow/expectator')

# helpers
wait= (fn, seconds = 60) ->
  seconds = seconds
  log.info "[wall]: waiting #{seconds} seconds…"
  setTimeout fn, seconds*1000

loop_if= (bool, fn)-> if bool and fn then async.forever(fn) else do fn

# module
module.exports = (config, pixels)->
  sections= config?.sections
  workflow= [
    taskRunner,
    expectator,
    Reactor(pixels).react
  ]

  tasks= sections.map buildTask
  log.info "[wall]: running #{tasks.length} #{u.plural('task', tasks)}…"

  loop_if config.loop, (next)->
    # run each task async:
    async.mapLimit tasks, config.limit, (task, callback)->
        # task async workflow:
        # - each step has this=task and callback(err, res)
        # - all steps gets `res` from step before as first arg

        async.waterfall(workflow.map((step)->step.bind(task)), callback)
    , (err)->
      log.error('[wall]: error', err) if err?
      if next?
        wait(next, config.wait)
      else
        process.exit(0)
