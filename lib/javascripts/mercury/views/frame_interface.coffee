#= require mercury/views/base_interface

class Mercury.FrameInterface extends Mercury.BaseInterface

  @logPrefix: 'Mercury.FrameInterface:'
  @className: 'mercury-frame-interface'

  initialize: ->
    @$frame = $(@frame).addClass('mercury-frame-interface-frame')    # get the iframe and set the class
    unless @$frame.length                                            # fall back gracefully
      @initialized = true
      return super


  load: (json) ->
    @loadedJSON = json
    return unless @initialized
    super


  reinitialize: ->
    if @$frame.length
      @initialized = false
      @initializeFrame()
    else
      super


  bindDefaultEvents: ->
    @$frame.on 'load', =>
      @initializeFrame()
      @load(@loadedJSON)
      @$frame.off('load').on('load', => @reinitializeFrame())
    @delegateEvents('mercury:initialize': -> @initializeFrame())
    super


  bindDocumentEvents: ->
    $(@window).on('scroll', @onScroll)
    super


  initializeFrame: ->
    return if @initialized
    @initialized = true
    @regions ||= []

    @setupDocument()
    @bindDocumentEvents()
    @addAllRegions()
    @hijackLinksAndForms()
    @trigger('initialized')
    Mercury.trigger('initialized')
    @delay(100, @focusDefaultRegion)


  reinitializeFrame: ->
    if @frameLocation() # same domain
      @initialized = false
      @regions = []
      @initializeFrame()
      @load(@loadedJSON)
    else # you've navigated elsewhere.. sorry.
      alert(@t("You've left editing the page you were on, please refresh the page."))
      @release()


  frameLocation: ->
    @$frame.get(0)?.contentWindow?.location.href


  setupDocument: ->
    @window = @$frame.get(0).contentWindow
    @window.Mercury ||= Mercury
    @window.Mercury.interface = @
    @document = $(@window.document)


  hide: ->
    @$frame.css(top: 0, height: '100%')
    super


  positionForRegion: ->
    offset = super
    offset.top -= $('body', @document).scrollTop() if @$frame.length
    offset


  hijackLinksAndForms: ->
    nonHijackableClasses = @config('interface:nohijack') || []
    regionSelector = "[#{@config('regions:attribute')}]"
    for el in $('a, form', @document)
      $el = $(el)
      ignored = false
      for classname in nonHijackableClasses
        if $el.hasClass(classname)
          ignored = true
          continue
      if !ignored && (el.target == '' || el.target == '_self') && !$el.closest(regionSelector).length
        $el.attr('target', '_parent')


  release: ->
    @$frame.css(top: 0)
    $(@window).off('scroll', @onScroll)
    super
    try
      window.location.href = frameLocation if frameLocation = @frameLocation()


  onScroll: =>
    @position()


  onResize: =>
    position = super
    @$frame.css(top: position.top, height: position.height) if position
