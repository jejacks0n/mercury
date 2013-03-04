Mercury.Region.Modules.DropIndicator =

  afterBuild: ->
    @dropIndicator ||= $('<div class="mercury-region-drop-indicator"></div>')
    @el.after(@dropIndicator)
    @delegateEvents
      dragenter: 'onDragEnter'
      dragleave: 'onDragLeave'
      drop: 'onDragLeave'


  dropIndicatorPosition: ->
    pos = @el.position()
    top: pos.top + @el.outerHeight() / 2
    left: pos.left + @el.outerWidth() / 2
    display: 'block'


  onDragEnter: ->
    clearTimeout(@dropIndicatorTimer)
    @dropIndicator.css(@dropIndicatorPosition())
    @delay(1, => @dropIndicator.css(opacity: 1))


  onDragLeave: ->
    @dropIndicator.css(opacity: 0)
    @dropIndicatorTimer = @delay(500, => @dropIndicator.hide())


  release: ->
    @dropIndicator.remove()
    super
