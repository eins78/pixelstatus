async= require('async')
expect = require('must')
f= require('lodash')
log= require('../logger')

summarizeExpectations=(list)-> f.chain(list).flatten().reduce().value()
buildResult=(isOk)-> { ok: isOk }

module.exports = expectResultWithRuler = (res, callback)->
  task= this
  list= Object.keys(task.expect)

  if not list.length
    log.info 'NOT OK: No expectations found!'
    return callback(null, buildResult(false))

  async.map list, (item, nextTarget)->
    expectations= Object.keys(task.expect[item])
    async.map expectations, (comparator, nextExpectation)->
      actual= f.get(res, item)
      expected= f.get(task.expect[item], comparator)
      result= checkExpectation(actual, expected, comparator)

      if result is true
        log.debug "OK: '#{item}' #{comparator} #{expected}:", result
      else
        log.verbose "NOT OK: '#{item}' #{comparator} #{expected}:", result
        log.debug "'#{item}' actual:", actual
      # comparison is a bool and the result of this module
      # - it's not an error in control-flow sense – don't exit async!
      nextExpectation(null, result)

    , nextTarget

  , # 'results' is a list of bools for all expectations of 'item':
  (err, results)-> callback(err, buildResult(summarizeExpectations(results)))


checkExpectation= (actual, expected, comparator)->
  # NOTE: this looks weird, but since we are using a library made for testing,
  #       an 'undefined' result means true, and a throw means false!
  # TODO: comparator validation (on task level)
  try
    # like `f.invoke([expect(201)], 'at.least', 200)`
    f.chain([expect(actual)]).invoke(comparator, expected).any().value()
    true
  catch error
    log.debug error
    false
