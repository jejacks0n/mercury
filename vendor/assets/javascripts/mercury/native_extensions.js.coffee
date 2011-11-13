String::titleize = ->
  @[0].toUpperCase() + @slice(1)


String::toHex = ->
  # todo: we should handle alpha as well
  return @ if @[0] == '#'
  @replace /rgba?\((\d+)[\s|\,]?\s(\d+)[\s|\,]?\s(\d+)\)/gi, (a, r, g, b) ->
    "##{parseInt(r).toHex()}#{parseInt(g).toHex()}#{parseInt(b).toHex()}"


String::regExpEscape = ->
  specials = ['/','.','*','+','?','|','(',')','[',']','{','}','\\']
  escaped = new RegExp('(\\' + specials.join('|\\') + ')', 'g')
  return @replace(escaped, '\\$1')


String::printf = ->
  chunks = @split('%')
  result = chunks[0]
  re = /^([sdf])([\s\S%]*)$/
  offset = 0
  for chunk, index in chunks
    p = re.exec(chunk)
    if index == 0 || !p || arguments[index] == null
      if index > 1
        offset += 2
        result += "%#{chunk}"
      continue
    arg = arguments[(index - 1) - offset]
    switch p[1]
      when 's' then result += arg
      when 'd', 'i' then result += parseInt(arg.toString(), 10)
      when 'f' then result += parseFloat(arg)
    result += p[2]
  return result


Number::toHex = ->
  result = @toString(16).toUpperCase()
  return if result[1] then result else "0#{result}"


Number::toBytes = ->
  bytes = parseInt(@)
  i = 0
  while 1023 < bytes
    bytes /= 1024
    i += 1
  return if i then "#{bytes.toFixed(2)}#{['', ' kb', ' Mb', ' Gb', ' Tb', ' Pb', ' Eb'][i]}" else "#{bytes} bytes"


# make setTimeout not suck for coffeescript
window.originalSetTimeout = window.setTimeout
window.setTimeout = (arg1, arg2) ->
  if typeof(arg1) == 'number' then window.originalSetTimeout(arg2, arg1) else window.originalSetTimeout(arg1, arg2)
