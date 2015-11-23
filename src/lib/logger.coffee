f = require('lodash')
logger = require('npmlog')

# set loglevel according to how many `-v`'s
vs = f.chain(process.argv).map((arg)-> arg.split('-')).flatten().compact()
      .filter((chars)-> f.all(chars, (char)-> char is 'v'))
      .map((s)->s.length).sum().value()

loglevel = switch
  when vs is 3 or vs > 3 then 'silly'
  when vs is 2 then 'verbose'
  when vs is 1 then 'info'
  else 'warn'

logger.level = loglevel
module.exports= logger
