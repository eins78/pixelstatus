async= require('async')
f= require('lodash')
expect= require('ruler/lib/ruler')

log= require('../logger')

summarizeExpectations=(list)-> f(list).flatten().reduce()
buildResult=(isOk)-> { ok: isOk }

expectResult_with_ruler=(res, callback)->
  task= this
  targets= Object.keys(task.expect)

  if not targets.length
    log.info 'NOT OK: No expectations found!'
    return callback(null, buildResult(false))

  async.map targets, (target, nextTarget)->
    expectations= Object.keys(task.expect[target])

    async.map expectations, (expectation, nextExpectation)->
      actual= res[target]
      expected= task.expect[target][expectation]

      comparison= f.get(expect().rule(target), [expectation, expected])
      unless f.isFunction(f.get(comparison, 'test'))
        throw 'comparison not found!'

      ok= comparison.test(res)

      if ok
        log.debug "OK: '#{target}' #{expectation} #{expected}:", ok
      else
        log.verbose "NOT OK: '#{target}' #{expectation} #{expected}:", ok
        log.debug "'#{target}' actual:", actual
      # comparison is a bool and the result of this module
      # - it's not an error in control-flow sense – don't exit async!
      nextExpectation(null, ok)

    , nextTarget

  , # 'results' is a list of bools for all expectations of 'target':
  (err, results)-> callback(err, buildResult(summarizeExpectations(results)))

module.exports = expectResult_with_ruler
