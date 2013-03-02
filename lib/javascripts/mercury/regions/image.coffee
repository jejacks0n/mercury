class Mercury.ImageRegion extends Mercury.Region

  @supported: true

  @define 'Mercury.ImageRegion', 'image',
    undo : 'undo'
    redo : 'redo'

  tag: 'img'

  className: 'mercury-image-region'


  build: ->
    @pushStack(@attr('src') || null)


  dropFile: (files) ->
    uploader = new Mercury.Uploader([files[0]], mimeTypes: @config('regions:gallery:mimeTypes'))
    uploader.on('uploaded', => @updateImage(arguments...))


  updateImage: (file) ->
    @setSrc(file.get('url'))
    @pushStack(@attr('src'))


  setSrc: (src) ->
    return if src == null
    @attr(src: src)


  undo: ->
    @setSrc(@undoStack())


  redo: ->
    @setSrc(@redoStack())


  toJSON: ->
    name: @name
    type: @constructor.type
    data: @data()
    src: @attr('src')
