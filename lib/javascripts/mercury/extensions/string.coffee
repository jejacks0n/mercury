#= require mercury/extensions/number

String::trim = ->
  @replace(/^\s+|\s+$/g, '')


String::toCamelCase = (first = false) ->
  if first
    @toTitleCase().replace(/([\-|_][a-z])/g, ($1) -> $1.toUpperCase().replace(/[\-|_]/, ''))
  else
    @replace(/([\-|_][a-z])/g, ($1) -> $1.toUpperCase().replace(/[\-|_]/, ''))


String::toDash = ->
  @replace(/([A-Z])/g, ($1) -> "-#{$1.toLowerCase()}").replace(/^-+|-+$/g, '')


String::toUnderscore = ->
  @replace(/([A-Z])/g, ($1) -> "_#{$1.toLowerCase()}").replace(/^_+|_+$/g, '')


String::toTitleCase = ->
  @[0].toUpperCase() + @slice(1)


String::toHex = ->
  return @toString() if @[0] == '#'
  @replace /rgb(a)?\(([0-9|%]+)[\s|,]?\s?([0-9|%]+)[\s|,]?\s?([0-9|%]+)[\s|,]?\s?([0-9|.|%]+\s?)?\)/gi, (x, alpha, r, g, b, a) ->
    "##{parseInt(r).toHex()}#{parseInt(g).toHex()}#{parseInt(b).toHex()}"


String::regExpEscape = ->
  specials = ['/','.','*','+','?','|','(',')','[',']','{','}','\\']
  escaped = new RegExp('(\\' + specials.join('|\\') + ')', 'g')
  @replace(escaped, '\\$1')


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
  result
