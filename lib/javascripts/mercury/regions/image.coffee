class Mercury.ImageRegion extends Mercury.Region

  @supported: true

  @define 'Mercury.ImageRegion', 'image',
    undo: 'onUndo'
    redo: 'onRedo'

  tag: 'img'

  focusable: true

  className: 'mercury-image-region'

  events:
    'dragenter': 'onDragEnter'
    'dragleave': 'onDragLeave'
    'drop': 'onDragLeave'

  build: ->
    @el.after(@indicator = $('<div class="mercury-image-region-indicator">'))

    @pushStack(@attr('src') || null)


  updateImage: (file) ->
    @setSrc(file.get('url'))
    @pushStack(@attr('src'))
    @focus()


  setSrc: (src) ->
    return if src == null
    @attr(src: src)


  onDropFile: (files) ->
    uploader = new Mercury.Uploader([files[0]], mimeTypes: @config('regions:gallery:mimeTypes'))
    uploader.on('uploaded', => @updateImage(arguments...))


  onDragEnter: ->
    clearTimeout(@indicatorTimer)
    pos = @el.position()
    @indicator.css
        top: pos.top + @el.outerHeight() / 2
        left: pos.left + @el.outerWidth() / 2
        display: 'block'
    @delay(1, => @indicator.css(opacity: 1))


  onDragLeave: ->
    @indicator.css(opacity: 0)
    @indicatorTimer = @delay(500, => @indicator.hide())


  onUndo: ->
    @setSrc(@undoStack())


  onRedo: ->
    @setSrc(@redoStack())


  toJSON: ->
    name: @name
    type: @constructor.type
    data: @data()
    src: @attr('src')
