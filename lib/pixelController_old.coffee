opc = require('open-pixel-control')
f = require('lodash')

u = require('lib/util.coffee')
log = require('lib/logger.coffee')
parseColor = require('lib/parseColor.coffee')

# "CONST"
STRIP=0
LENGTH=60

# helpers
is_pixel_rgb_array= (data)->
  return false unless f.isArray(data)
  f.every data, (pixel)->
    return false unless f.isArray(pixel)
    f.every pixel, (color)->
      f.isNumber(color)

is_string_array= (data)-> f.every data, (color)-> f.isString(color)

# module
class PixelControl
  constructor: (@config) ->
    return new PixelControl(@config) unless (@ instanceof PixelControl)
    unless @config?.strips?.length
      throw 'pixel: need config.strips!'

    f.defaults(@config, { address: '127.0.0.1', port: 7890 })
    @opc= new opc(@config)
    @connected = false
    @pixels = -> @config?.strips?[STRIP]?.pixels or []

    # tmp
    @emit= log.warn

  init: (callback)-> #f.once
    @opc.on 'connected', =>
      @connected = true
      log.info "pixel: connected!"
      if @config.strips?
        strips = @config.strips.map (s)=>
          if typeof (s=parseInt(s,10)) == 'number'
            @opc.add_strip { length: s }
      callback null

    @opc.on 'error', (err)=>
      err = err || "pixel: connect error!"
      log.error err
      f.once -> callback err, null

    @opc.on 'disconnected', =>
      @connected = false
      @emit "pixel: disconnected!"

    do @opc.connect


  get: -> @opc?.strips?[0]?.pixels

  put: (pixel_id, color)->
    color = parseColor(color) unless f.isArray(color)
    @opc.put_pixel(STRIP, pixel_id, color)

  range: (range, color)->
    console.log 'range', range
    cur= @pixels()
    unless (range?.length is 2) and range.reduce((n)-> n>=0) #and n<=cur.length
      return @emit 'pixel: range invalid or not on strip!'
    do range.reverse if range[0] > range[1]
    start= range[0]
    length= (range[1] - range[0] + 1)
    # TODO:
    # pixels= [].concat(current.slice(0, start), u.array_of(color, length), current.slice(start+length))
    # console.log pixels
    # @set(pixels, color)
    u.array_of(null, length).map =>
        @put start++, color

  rangeHuman: (range, color)->
    @range(range.map((n)->n+1), color)

  setAll: (color)->
    @set(u.array_of(color, LENGTH))

  set: (data)->
    pixels= switch
      when is_pixel_rgb_array(data)
        data
      when is_string_array(data)
        f.map data, (str)-> parseColor(str)
      else
        @emit 'pixel: data is not array of array of integers!'

    @opc.put_pixels(STRIP, pixels)


module.exports = PixelControl
