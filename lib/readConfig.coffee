fs= require('fs')

# get path of config file from first argument
configFile= process.argv[2]
throw 'no config file!' unless configFile?

config= JSON.parse(fs.readFileSync(configFile))

throw 'no config!' unless config?
throw 'config: no sections!' unless config.sections?

module.exports = config
