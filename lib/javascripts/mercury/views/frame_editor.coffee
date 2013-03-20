#= require mercury/views/editor

class Mercury.FrameEditor extends Mercury.Editor

  logPrefix: 'Mercury.FrameEditor:'
  className: 'mercury-frame-editor'

  initialize: ->
    @frame = $(@frame).addClass('mercury-frame-editor-frame')        # get the iframe and set the class
    return super unless @frame.length                                # fall back gracefully


  initializeFrame: ->
    return if @initialized
    @initialized = true

    @setupDocument()
    @addAllRegions()
    Mercury.trigger('initialized')


  bindDefaultEvents: ->
    @frame.on('load', => @initializeFrame())
    Mercury.on('initialize', => @initializeFrame())
    super


  setupDocument: ->
    contentWindow = @frame.get(0).contentWindow
    contentWindow.Mercury = Mercury
    @document = $(contentWindow.document)
