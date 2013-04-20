#= require mercury/views/base_interface

class Mercury.FrameInterface extends Mercury.BaseInterface

  @logPrefix: 'Mercury.FrameInterface:'
  @className: 'mercury-frame-interface'

  initialize: ->
    @$frame = $(@frame).addClass('mercury-frame-interface-frame')    # get the iframe and set the class
    unless @$frame.length                                            # fall back gracefully
      @initialized = true
      return super


  reinitialize: ->
    if @$frame.length
      @initialized = false
      @initializeFrame()
    else
      super


  bindDefaultEvents: ->
    @$frame.on('load', => @initializeFrame())
    @delegateEvents('mercury:initialize': -> @initializeFrame())
    super


  bindDocumentEvents: ->
    $('body', @document).on 'mousedown', -> Mercury.trigger('dialogs:hide')


  initializeFrame: ->
    return if @initialized
    @initialized = true

    @setupDocument()
    @bindDocumentEvents()
    @addAllRegions()
    Mercury.trigger('initialized')
    @delay(100, @focusDefaultRegion)


  setupDocument: ->
    contentWindow = @$frame.get(0).contentWindow
    contentWindow.Mercury = Mercury
    @document = $(contentWindow.document)
