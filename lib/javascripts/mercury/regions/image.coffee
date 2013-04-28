###!
The Image region allows you to have a replaceable image region on your page. It provided the ability to drag/drop images
from the desktop -- which will get uploaded (and probably processed by your server) and will then replace the existing
image with the one that was uploaded. You can change the image alignment, which will be provided in the data on
serialization to the server.
###
class Mercury.Region.Image extends Mercury.Region
  @define 'Mercury.Region.Image', 'image'
  @include Mercury.Region.Modules.DropIndicator
  @include Mercury.Region.Modules.DropItem

  @supported: true
  @tag: 'img'

  @events:
    'mousedown': 'onMousedown'

  value: (value) ->
    if value == null || typeof(value) == 'undefined'
      @attr('src')
    else
      @attr('src', value)


  onMousedown: (e) ->
    # workaround: Firefox doesn't focus an img tag when clicked.
    @prevent(e)
    @$el.trigger('focus')


  onDropFile: (files) ->
    uploader = new Mercury[@config('interface:uploader')](files, mimeTypes: @config('regions:image:mimeTypes'))
    uploader.on 'uploaded', (file) =>
      @focus()
      @handleAction('file', file)


Mercury.Region.Image.addToolbar

  general:
    crop:        ['Crop Image']
    resize:      ['Resize Image']
  alignment:
    alignLeft:   ['Align Left']
    alignRight:  ['Align Right']
    alignTop:    ['Align Top']
    alignMiddle: ['Align Middle']
    alignBottom: ['Align Bottom']
    alignNone:   ['Align None']


Mercury.Region.Image.addData

  align: (val) -> @attr(align: val)


Mercury.Region.Image.addAction

  alignLeft:   -> @data(align: 'left')
  alignRight:  -> @data(align: 'right')
  alignTop:    -> @data(align: 'top')
  alignMiddle: -> @data(align: 'middle')
  alignBottom: -> @data(align: 'bottom')
  alignNone:   -> @data(align: null)
  file: (file) -> @handleAction('image', url: file.get('url')) if file.isImage()
  image: (img) -> @value(img.get('url'))


Mercury.Region.Image.addContext

  alignLeft:   -> @data('align') == 'left'
  alignRight:  -> @data('align') == 'right'
  alignTop:    -> @data('align') == 'top'
  alignMiddle: -> @data('align') == 'middle'
  alignBottom: -> @data('align') == 'bottom'
  alignNone:   -> !@data('align')
