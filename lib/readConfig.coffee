fs= require('fs')

configFile= process.argv[2]
throw 'no config file!' unless configFile?

config= JSON.parse(fs.readFileSync configFile)
throw 'no config!' unless config?
throw 'config: no sections!' unless config.sections?

module.exports = config
