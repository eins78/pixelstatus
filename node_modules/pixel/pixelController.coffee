Socket = require('net').Socket
createOPCStream = require('opc')
createOPCStrand = require('opc/strand')
f = require('lodash')
u = require('utile')
assert = require('assert')

log = require('./logger')
parseColor = require('./parseColor')

# consts
DEVICE=0 # only support 1 device for now

# helpers
is_pixel_rgb_array= (data)->
  return false unless f.isArray(data)
  f.every data, (pixel)->
    return false unless f.isArray(pixel)
    f.every pixel, (color)->
      f.isNumber(color)

is_string_array=(data)-> f.every data, (color)-> f.isString(color)

sectionsTotalLength=(sections)->
  f(sections).map((section)-> section?.length).reduce((num, sum)-> sum + num)

buildPixelSections=(pixelBuffer, sections)->
  current_position= 0
  f(sections).map((section, id)->
      start= current_position
      end= current_position + section.length
      current_position = end
      return [
        id,
        {
          pixels: pixelBuffer.slice(start, end),
          length: section.length
        }
      ])
      .zipObject().value()

# # PixelControl module
class PixelControl
  constructor: (@config) ->
    return new PixelControl(@config) unless (@ instanceof PixelControl)

    # ## build config
    @config= f.defaults({
      sections: f(@config.sections).map((section, id)->
          length = parseInt(section?.length, 10)
          assert f.isNumber(length),
            "pixel: section '#{section}' has invalid `length` '#{length}'!"
          return [id, { length: length }]
        ).zipObject().value(),
      name: 'pixel',
      length: sectionsTotalLength(@config.sections)
    }, connection: { host: '127.0.0.1', port: '7890' })


    # ## setup
    # FAKE: emit = log instead of real events
    @emit= log.warn
    @connected = false
    # - create TCP connection to Open Pixel Control server
    @socket = new Socket()
    do @socket.setNoDelay
    # - create an Open Pixel Control stream and pipe it to the server
    opcStream = do createOPCStream
    opcStream.pipe(@socket)

    if @config.length > 512 # maximum of 1 fadecandy
      throw "pixel: sections total lenght #{@config.length} greater than 512!"

    # - create the 'opc strand' (a buffer representing all addressable pixels)
    log.verbose "pixel: creating strip of #{@config.length} pixels"
    pixelBuffer = createOPCStrand(@config.length)
    # - build sections by configured length from the pixelBuffer
    @pixelSections = buildPixelSections(pixelBuffer, @config.sections)

    # ## private methods
    @putPixel=(section, number, color)=>
      rgb = parseColor(color)
      log.debug 'pixel: put', section, number, color, rgb

      section = @pixelSections[section]?.pixels
      unless rgb? and section?
        throw 'wtf'

      # set pixel to internal buffer, NOT written to device!
      section.setPixel(number, rgb.r, rgb.g, rgb.b)

    @writeBuffer=-> # write the pixel buffer to the socket
      opcStream.writePixels(DEVICE, pixelBuffer.buffer)

  init: (callback)->
    do f.once =>
      connection = @config.connection
      log.info "pixels: connecting #{u.inspect(connection)}"

      @socket.on 'connect', =>
        @connected = true
        log.info "pixel: connected!"
        do callback

      @socket.on 'error', (err)=>
        err = err || "pixel: connect error!"
        log.error err
        f.once -> callback err, null

      @socket.on 'close', (hadError)=>
        @connected = false
        @emit "pixel: disconnected! #{(if hadError then 'FAIL!' else 'OK')}"

      @socket.connect(connection.port, connection.host)
      @setAllSections('black', false)
      @writeBuffer

  # usage: `pixel('test').set('green')`
  section: (name)=> [@set, @setPixels].map((method)->
    [method, f.curry(method)(name)]).zipObject()

  # usage: `pixel.setAllSections('red')`
  setAllSections: (color, write = true, callback)=>
    log.debug 'setAll', color, @pixelSections.length
    f.forOwn @pixelSections, (section, id)=>
      f.times(section.length).map (number)=> @putPixel(id, number, color)
    do @writeBuffer if write
    callback?()

  set: (section, color, callback)=>
    log.verbose 'pixel: set', section, color
    f.times(@pixelSections[section].length).map (number)=>
      @putPixel(section, number, color)
    do @writeBuffer
    callback?()

  setPixels: (section, pixels, callback)=>
    log.verbose 'pixel: setPixels', section, pixels
    unless is_pixel_rgb_array(pixels) or is_string_array(pixels)
      throw 'pixel: set: invalid data!'

    f.forOwn pixels, (color, number)=>
      @putPixel(section, number, color)
    do @writeBuffer
    callback?()

  setPixel: (section, num, color, callback)=>
    log.verbose 'pixel: setPixel', section, num, color
    @putPixel(section, num, color)
    do @writeBuffer
    callback?()

module.exports = PixelControl
