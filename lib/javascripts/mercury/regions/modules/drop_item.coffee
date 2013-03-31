Mercury.Region.Modules.DropItem =

  onDropItem: (e, data) ->
    action = 'image'
    action = 'link' if data.getData('text/html') || (Mercury.support.safari && data.types.indexOf('image/tiff') == -1)
    action = 'image' if url = $('<div>').html(data.getData('text/html')).find('img').attr('src')
    url ||= data.getData('text/uri-list')
    if url
      e.preventDefault()
      @focus()
      @handleAction(action, url: url)
