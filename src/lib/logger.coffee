f = require('lodash')
winston = require('winston')

# set loglevel according to how many `-v`'s
vs = f.chain(process.argv).map((arg)-> arg.split('-')).flatten().compact()
      .filter((chars)-> f.all(chars, (char)-> char is 'v'))
      .map((s)->s.length).sum().value()

loglevel = switch
  when vs is 3 or vs > 3 then 'debug'
  when vs is 2 then 'verbose'
  when vs is 1 then 'info'
  else 'warn'

module.exports= logger= new (winston.Logger)
    transports: [
      new (winston.transports.Console)
        colorize: true
        timestamp: true
        prettyPrint: true
        level: loglevel
    ]
