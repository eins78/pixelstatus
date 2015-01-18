pixel= require('./lib/pixel')
pixel.connect {}, (err, client)->
  strip=0
  length= (client?.strips[strip]?.length)
  num= 0
  do the_loop= ->
    if num < length
      client.put_pixel(strip, num, [255, 255, 255])
      num++
      setTimeout the_loop, 100
