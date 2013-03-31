###!
The Image region allows you to have a replaceable image region on your page. It provided the ability to drag/drop images
from the desktop -- which will get uploaded (and probably processed by your server) and will then replace the existing
image with the one that was uploaded.
###
Mercury.configure 'toolbars:image',
  general:
    crop:        ['Crop Image']
    resize:      ['Resize Image']
    sep1:        '-'
  alignment:
    alignLeft:   ['Align Left']
    alignRight:  ['Align Right']
    alignTop:    ['Align Top']
    alignMiddle: ['Align Middle']
    alignBottom: ['Align Bottom']
    alignNone:   ['Align None']


class Mercury.Region.Image extends Mercury.Region
  @define 'Mercury.Region.Image', 'image'
  @include Mercury.Region.Modules.DropIndicator
  @include Mercury.Region.Modules.DropItem

  @supported: true

  tag: 'img'

  events:
    'mousedown': 'onMousedown'

  value: (value) ->
    if value == null || typeof(value) == 'undefined'
      @attr('src')
    else
      @attr('src', value)


  setAlignment: (alignment) ->
    @el.data(align: alignment).attr(align: alignment)


  onMousedown: (e) ->
    # workaround: Firefox doesn't focus an img tag when clicked.
    e.preventDefault()
    @el.trigger('focus')


  onDropFile: (files) ->
    uploader = new Mercury.Uploader(files, mimeTypes: @config('regions:image:mimeTypes'))
    uploader.on 'uploaded', (file) =>
      @focus()
      @handleAction('file', file)


Mercury.Region.Image.addAction

  alignLeft:   -> @setAlignment('left')
  alignRight:  -> @setAlignment('right')
  alignTop:    -> @setAlignment('top')
  alignMiddle: -> @setAlignment('middle')
  alignBottom: -> @setAlignment('bottom')
  alignNone:   -> @setAlignment(null)

  file: (file) ->
    @handleAction('image', url: file.get('url')) if file.isImage()

  image: (image) ->
    @value(image.get('url'))


Mercury.Region.Image.addContext

  alignLeft:   -> @el.attr('align') == 'left'
  alignRight:  -> @el.attr('align') == 'right'
  alignTop:    -> @el.attr('align') == 'top'
  alignMiddle: -> @el.attr('align') == 'middle'
  alignBottom: -> @el.attr('align') == 'bottom'
  alignNone:   -> !@el.attr('align')
