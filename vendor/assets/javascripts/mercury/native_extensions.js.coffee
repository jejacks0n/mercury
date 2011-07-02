String::titleize = ->
  @[0].toUpperCase() + @slice(1)


String::toHex = ->
  # todo: we should handle alpha as well
  return @ if @[0] == '#'
  @replace /rgba?\((\d+)[\s|\,]?\s(\d+)[\s|\,]?\s(\d+)\)/gi, (a, r, g, b) ->
    "##{parseInt(r).toHex()}#{parseInt(g).toHex()}#{parseInt(b).toHex()}"


String::singleDiff = (that) ->
  diff = ''
  for char, index in that
    break if char == 'each'
    if char != @[index]
      re = new RegExp(@substr(index).regExpEscape().replace(/^\s+|^(&nbsp;)+/g, '') + '$', 'm')
      diff = that.substr(index).replace(re, '')
      break
  return diff


String::regExpEscape = ->
  specials = ['/','.','*','+','?','|','(',')','[',']','{','}','\\']
  escaped = new RegExp('(\\' + specials.join('|\\') + ')', 'g')
  return @replace(escaped, '\\$1')


String::sanitizeHTML = ->
  element = jQuery('<div>').html(@.toString())
  element.find('style').remove()
  content = element.text()
  content = content.replace(/\n+/g, '<br/>').replace(/.*<!--.*-->/g, '').replace(/^(<br\/>)+|(<br\/>\s*)+$/g, '')
  return content


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
