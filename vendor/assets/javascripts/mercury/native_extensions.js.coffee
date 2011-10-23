String::titleize = ->
  @[0].toUpperCase() + @slice(1)


String::toHex = ->
  # todo: we should handle alpha as well
  return @ if @[0] == '#'
  @replace /rgba?\((\d+)[\s|\,]?\s(\d+)[\s|\,]?\s(\d+)\)/gi, (a, r, g, b) ->
    "##{parseInt(r).toHex()}#{parseInt(g).toHex()}#{parseInt(b).toHex()}"


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


# make setTimeout not suck for coffeescript
window.originalSetTimeout = window.setTimeout
window.setTimeout = (arg1, arg2) ->
  if typeof(arg1) == 'number' then window.originalSetTimeout(arg2, arg1) else window.originalSetTimeout(arg1, arg2)
