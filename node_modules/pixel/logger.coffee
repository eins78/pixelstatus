winston= require('winston')

# set loglevel according to how many `-v`'s
vs = (process.argv.filter (arg)-> arg == '-v').length
loglevel= switch
  when vs > 3 then 'debug'
  when vs == 2 then 'verbose'
  when vs == 1 then 'info'
  else 'warn'

module.exports= logger= new (winston.Logger)
    transports: [
      new (winston.transports.Console)
        colorize: true
        timestamp: true
        prettyPrint: true
        level: loglevel
    ]
