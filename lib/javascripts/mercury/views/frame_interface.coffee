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
    $(@window).on('scroll', @onScroll)
    super


  initializeFrame: ->
    return if @initialized
    @initialized = true

    @setupDocument()
    @bindDocumentEvents()
    @addAllRegions()
    Mercury.trigger('initialized')
    @delay(100, @focusDefaultRegion)


  setupDocument: ->
    @window = @$frame.get(0).contentWindow
    @window.Mercury = Mercury
    @document = $(@window.document)


  hide: ->
    @$frame.css(top: 0, height: '100%')
    super


  positionForRegion: ->
    offset = super
    offset.top -= $('body', @document).scrollTop() if @$frame.length
    offset


  release: ->
    $(@window).off('scroll', @onScroll)
    super


  onScroll: =>
    @position()


  onResize: =>
    position = super
    @$frame.css(top: position.top, height: position.height) if position
