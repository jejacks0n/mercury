#= require mercury/views/base_interface

class Mercury.FrameInterface extends Mercury.BaseInterface

  logPrefix: 'Mercury.FrameInterface:'
  className: 'mercury-frame-interface'

  initialize: ->
    @frame = $(@frame).addClass('mercury-frame-interface-frame')     # get the iframe and set the class
    unless @frame.length                                             # fall back gracefully
      @initialized = true
      return super


  bindDefaultEvents: ->
    @frame.on('load', => @initializeFrame())
    Mercury.on('initialize', => @initializeFrame())
    super


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
