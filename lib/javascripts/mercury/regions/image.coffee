class Mercury.ImageRegion extends Mercury.Region

  @supported: true

  @define 'Mercury.ImageRegion', 'image',
    undo : 'undo'
    redo : 'redo'

  tag: 'img'

  className: 'mercury-image-region'

  dropFile: (files) ->
    uploader = new Mercury.Uploader([files[0]], mimeTypes: ['image/jpeg'])
    uploader.on('uploaded', => @updateImage(arguments...))


  updateImage: (file) ->
    @pushStack(file)
    @setSrcFromFile(file)


  setSrcFromFile: (file) ->
    return unless file
    @attr(src: file.get('url'))


  undo: ->
    @setSrcFromFile(@undoStack())


  redo: ->
    @setSrcFromFile(@redoStack())


  toJSON: ->
    name: @name
    type: @constructor.type
    data: @data()
    src: @el.attr('src')
