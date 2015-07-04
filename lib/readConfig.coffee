fs= require('fs')
path= require('path')
f= require('lodash')
yaml = require('js-yaml')


# get path of config file from first argument
configFile= process.argv[2]
throw 'no config file!' unless configFile?

file= fs.readFileSync(path.join(process.cwd(), configFile))

# support json or yaml that converts to json
config= switch
  when f.endsWith(configFile, '.json')
    JSON.parse(file)
  when configFile.match /\.y(a|)ml/
    yaml.safeLoad(file)

throw 'no config!' unless config?
throw 'config: no sections!' unless config.sections?

module.exports = config
