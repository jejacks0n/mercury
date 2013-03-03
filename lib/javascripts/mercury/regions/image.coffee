class Mercury.ImageRegion extends Mercury.Region

  @supported: true

  @define 'Mercury.ImageRegion', 'image'

  tag: 'img'

  className: 'mercury-image-region'

  events:
    'dragenter': 'onDragEnter'
    'dragleave': 'onDragLeave'
    'drop': 'onDragLeave'
    'mousedown': 'simulateFocus'

  build: ->
    @el.after(@indicator = $('<div class="mercury-image-region-indicator">'))


  value: (value) ->
    if value == null || typeof(value) == 'undefined'
      @attr('src')
    else
      @attr('src', value)


  simulateFocus: (e) ->
    # workaround: Firefox doesn't properly focus an img tag when clicked.
    e.preventDefault()
    @el.trigger('focus')


  onDropFile: (files) ->
    uploader = new Mercury.Uploader([files[0]], mimeTypes: @config('regions:gallery:mimeTypes'))
    uploader.on('uploaded', => @onUploadImage(arguments...))


  onUploadImage: (file) ->
    @value(file.get('url'))
    @pushHistory()
    @focus()


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


  release: ->
    @indicator.remove()
    super

