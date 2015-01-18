async= require('async')
expect= require('ruler')
log= require('./logger.js')

expectator_with_ruler= (task, res, callback)->
  async.each Object.keys(task.expect), (target, next)->
    async.each Object.keys(task.expect[target]), (expectation, next)->
      actual= res[target]
      expected= task.expect[target][expectation]
      comparator = expect().rule(target)[expectation](expected)
      unless 'function' == typeof comparator.test
        throw 'comparator not found!'
      ok= comparator.test(res)
      if ok
        log.verbose "OK: '#{target}' #{expectation} #{expected}:", ok
      else
        log.info "NOT OK: '#{target}' #{expectation} #{expected}:", ok
        log.debug actual
      # if comparison is an error, it is still the result of this module
      # because it's not an error in control-flow sense – don't exit async!
      next null, ok
    , next
  , callback

module.exports = expectator_with_ruler
