pixel= require('lib/pixel')
pixel.connect { strips: [4*60] }, (err, client)->
  WAIT=10000
  strip=0
  length= (client?.strips[strip]?.length)
  
  color_snake= (color, speed, callback)->
    num= 0
    loop_timeout= 1000 / (speed or 10)
    do the_loop= ->
      if num < length
        client.put_pixel(strip, num, color)
        num++
        setTimeout the_loop, loop_timeout, 
      else
        do callback if callback?
  
  setTimeout ->
    color_snake [255, 255, 255], 100, ->
      color_snake [0, 0, 0], 100
  , WAIT
