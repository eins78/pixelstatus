module.exports= optionalJSONparse=(input)->
  return (try JSON.parse(input)) or input or ''
