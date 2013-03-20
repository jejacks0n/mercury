#= require mercury/views/editor

class Mercury.FrameEditor extends Mercury.Editor

  logPrefix: 'Mercury.FrameEditor:'
  className: 'mercury-frame-editor'

  initialize: ->
    @frame = $(@frame).addClass('mercury-frame-editor-frame')        # get the iframe and set the class
    return super unless @frame.length                                # fall back gracefully

    Mercury.on 'initialize', => @initializeFrame()
    @frame.on 'load', => @initializeFrame()


  initializeFrame: ->
    return if @initialized
    @initialized = true

    @setupDocument()
    @addAllRegions()
    Mercury.trigger('initialized')


  setupDocument: ->
    contentWindow = @frame.get(0).contentWindow
    contentWindow.Mercury = Mercury
    @document = $(contentWindow.document)
