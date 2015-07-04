PixelController= require('pixel')
parseColor= require('./lib/parseColor')
Color= require('colour.js')
f= require('lodash')
async= require('async')
hertz= require('hertz')

SECTIONS= {
  one: { length: 60 },
  _one_space: { length: 4 },
  two: { length: 60 },
  _two_space: { length: 4 },
  three: { length: 60 },
  _three_space: { length: 4 },
  four: { length: 60 }
  _four_space: { length: 4 }
}

rainbowColorForPoint= (num, max, offset = 0)->
  factor=360/max
  (new Color('red')).h(((num + offset) % max)*factor).rgb255()

rainbowStrip= (length, offset = 0)->
  f.times(length).map (pixel)->
    rainbowColorForPoint(pixel, length, offset)

color_wipe= (color_or_colorfn, section, length, speed, callback)->
  if typeof color_or_colorfn is 'function'
    colorfn= color_or_colorfn
  else
    color= color_or_colorfn

  num= 0
  do the_loop=->
    if num < length
      color = colorfn(num, length) if colorfn?
      pixel.setPixel(section, num, color)
      num++
      setTimeout the_loop, hertz(speed or 10)
    else
      return do callback if callback?

strip_move= (pos, times, speed, callback)->
  full_moves= 0
  move_steps= 0
  do the_loop= ->
    if full_moves < times
      do the_move= ->
        if move_steps < LENGTH
          pattern= @pixel.pixels
          if Array.isArray(pattern)
            new_pattern= [].concat(pattern.slice(-1), pattern.slice(0,-1))
          pixel.setPixels(SECTION, new_pattern) if new_pattern?
          move_steps++
          setTimeout the_move, hertz(speed or 10)
        else
          full_moves++
          do the_loop
    else
      return do callback if callback?

wipe_list= (color_list, section, length, speed, callback)->
  list= color_list.map (color)-> f.curry(color_wipe)(color, section, length,   speed)
  async.series list, ->
    do callback if callback?

pixel= (PixelController({
  sections: SECTIONS
}))

pixel.init (err)->
  return console.error err if err
  WAIT=1
  strip=0

  setTimeout ->
    pixel.setAllSections('black')

    setTimeout ->
      pixel.set('one', 'red')
      pixel.set('two', 'yellow')
      pixel.set('three', 'green')
      pixel.set('four', 'purple')

      setTimeout ->
        pixel.set('one', 'salmon')

        setTimeout ->
          pixel.setPixels('four', rainbowStrip(60, 180))

          setTimeout ->
            color_list= [
              'red'
              'green'
              'blue'
              'white'
              'cyan'
              'magenta'
              'yellow'
              'black'
            ]
            async.forever f.curry(wipe_list)(color_list, 'one', 60, 25)
            async.forever f.curry(wipe_list)(color_list, 'two', 60, 25)
            async.forever f.curry(wipe_list)(color_list, 'three', 60, 25)
            async.forever f.curry(wipe_list)(color_list, 'four', 60, 25)
          , 2500
        , 2500
      , 2500
    , 2500
  , WAIT

  # # # or: generate rainbow and increase speed:
  # # color_list= [0..36].map (num)->
  # #   (new Color('red')).h(num*10).rgb255()
  # # speed = (100*LENGTH)


exitHandler=(err)->
  do f.once ->
    console.log 'pixeltest: exiting…', err
    if pixel?.connected
      console.log 'pixeltest: setting black…'
      pixel.setAllSections('black')
  process.exit(if err? then 1 else 0)

process.on 'SIGINT', exitHandler
process.on 'exit', exitHandler
process.on 'uncaughtException', exitHandler
