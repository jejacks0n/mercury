Mercury.Region.Modules.DropItem =

  onDropItem: (e, data) ->
    [action, url] = @getActionAndUrlFromData(data)
    return unless url
    @prevent(e)
    @focus()
    @handleAction(action, url: url)


  getActionAndUrlFromData: (data) ->
    action = 'image'
    action = 'link' if data.getData('text/html') || (Mercury.support.safari && (data.types || []).indexOf('image/tiff') == -1)
    action = 'image' if url = $('<div>').html(data.getData('text/html')).find('img').attr('src')
    [action, url || data.getData('text/uri-list')]
