winston= require('winston')

module.exports= logger= new (winston.Logger)
    transports: [
      new (winston.transports.Console)
        colorize: true
    ]
