###!
The image region is typically an image tag and what's sent back to the server on serialization is the source of that
image. It allows draging/dropping images onto itself, and maintains a history so you can undo/redo your changes. Also
allows setting the image alignment.

Configuration:
  regions:image:
    mimeTypes: ['image/jpeg']                            # file types - overrides general uploading configuration
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

  align: (val) ->
    @attr(align: val)
    Mercury.trigger('resize')


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
