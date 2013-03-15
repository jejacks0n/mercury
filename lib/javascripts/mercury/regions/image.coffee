###!
The Image region allows you to have a replaceable image region on your page. It provided the ability to drag/drop images
from the desktop -- which will get uploaded (and probably processed by your server) and will then replace the existing
image with the one that was uploaded.
###
class Mercury.ImageRegion extends Mercury.Region
  @define 'Mercury.ImageRegion', 'image'
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
    # workaround: Firefox doesn't properly focus an img tag when clicked.
    e.preventDefault()
    @el.trigger('focus')


  onDropFile: (files) ->
    uploader = new Mercury.Uploader(files, mimeTypes: @config('regions:image:mimeTypes'))
    uploader.on 'uploaded', (file) =>
      @focus()
      @handleAction('file', file)


  actions:

    file: (file) -> @value(file.get('url'))
