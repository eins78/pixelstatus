async= require('async')
expect= require('ruler')
log= require('./logger.js')

expectResult_with_ruler= (res, callback)->
  task= this
  targets= Object.keys(task.expect)
  
  async.map targets, (target, nextTarget)->
    expectations= Object.keys(task.expect[target])
    
    async.map expectations, (expectation, nextExpectation)->
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
        log.debug "'#{target}' actual:", actual
      # comparison is a bool and the result of this module
      # it's not an error in control-flow sense – don't exit async!
      nextExpectation(null, ok)
    
    , nextTarget
  
  , callback

module.exports = expectResult_with_ruler
