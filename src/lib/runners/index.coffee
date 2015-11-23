fs= require('fs')
path= require('path')
f= require('lodash')

SUFFIX= /\.coffee$/

modules= fs.readdirSync(__dirname)
              .filter (file)-> SUFFIX.test(file)
              .filter (file)-> !/^index\.js$/.test(file)

runners= {}
f.each modules, (runner)->
  name = runner.replace(SUFFIX, '')
  runners[name]= require(path.resolve(__dirname, runner))

module.exports = runners
