winston= require('winston')

# set loglevel according to how many `-v`'s
loglevel= switch (process.argv.filter (arg)-> arg == '-v').length
  when 3 then 'debug'
  when 2 then 'verbose'
  when 1 then 'info'
  else 'warn'

module.exports= logger= new (winston.Logger)
    transports: [
      new (winston.transports.Console)
        colorize: true
        timestamp: true
        prettyPrint: true
        level: loglevel
    ]
