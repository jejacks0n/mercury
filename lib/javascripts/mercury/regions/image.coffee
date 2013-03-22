###!
The Image region allows you to have a replaceable image region on your page. It provided the ability to drag/drop images
from the desktop -- which will get uploaded (and probably processed by your server) and will then replace the existing
image with the one that was uploaded.
###
class Mercury.Region.Image extends Mercury.Region
  @define 'Mercury.Region.Image', 'image'
  @include Mercury.Region.Modules.DropIndicator

  @supported: true

  tag: 'img'

  events:
    'mousedown': 'onMousedown'

  value: (value) ->
    if value == null || typeof(value) == 'undefined'
      @attr('src')
    else
      @attr('src', value)


  onMousedown: (e) ->
    # workaround: Firefox doesn't focus an img tag when clicked.
    e.preventDefault()
    @el.trigger('focus')


  onDropFile: (files) ->
    uploader = new Mercury.Uploader(files, mimeTypes: @config('regions:image:mimeTypes'))
    uploader.on 'uploaded', (file) =>
      @focus()
      @handleAction('file', file)


  onDropItem: (e, data) ->
    if url = $('<div>').html(data.getData('text/html')).find('img').attr('src')
      e.preventDefault()
      @focus()
      @handleAction('image', url: url)


  actions:

    file: (file) -> @value(file.get('url'))
    image: (image) -> @value(image.get('url'))
