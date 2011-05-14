String::titleize = -> @[0].toUpperCase() + @slice(1)


String::toHex = ->
  # todo: we should handle alpha as well
  return @ if @[0] == '#'
  @replace /rgba?\((\d+)[\s|\,]?\s(\d+)[\s|\,]?\s(\d+)\)/gi, (a, r, g, b) ->
    "##{parseInt(r).toHex()}#{parseInt(g).toHex()}#{parseInt(b).toHex()}"


String::singleDiff = (that) ->
  diff = ''
  for char in that
    if char != @[_i] # using _i is lame!
      re = new RegExp(@substr(_i).regExpEscape().replace(/^\s+|^(&nbsp;)+/g, '') + '$', 'm')
      diff = that.substr(_i).replace(re, '')
      break
  return diff


String::regExpEscape = ->
  specials = ['/','.','*','+','?','|','(',')','[',']','{','}','\\']
  escaped = new RegExp('(\\' + specials.join('|\\') + ')', 'g')
  return @replace(escaped, '\\$1')


String::sanitizeHTML = ->
  element = $('<div>').html(@.toString())
  element.find('style').remove()
  content = element.text()
  content = content.replace(/\n+/g, '<br/>').replace(/.*<!--.*-->/g, '').replace(/^(<br\/>)+|(<br\/>\s*)+$/g, '')
  return content


Number::toHex = ->
  result = @toString(16).toUpperCase()
  return if result[1] then result else "0#{result}"

