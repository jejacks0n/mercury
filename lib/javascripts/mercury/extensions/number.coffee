Number::toHex = ->
  result = @toString(16).toUpperCase()
  return if result[1] then result else "0#{result}"


Number::toBytes = ->
  measures = ['', ' kb', ' Mb', ' Gb', ' Tb', ' Pb', ' Eb']
  bytes = parseInt(@)
  i = 0
  while 1023 < bytes
    bytes /= 1024
    i += 1
  return if i then "#{bytes.toFixed(2)}#{measures[i]}" else "#{bytes} bytes"
