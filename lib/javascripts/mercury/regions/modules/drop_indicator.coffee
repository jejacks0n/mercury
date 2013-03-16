Mercury.Region.Modules.DropIndicator =

  included: ->
    @dropIndicator = $('<div class="mercury-region-drop-indicator"></div>')

    @on('build', @buildDropIndicator)
    @on('release', @releaseDropIndicator)


  buildDropIndicator: ->
    @el.after(@dropIndicator)

    @delegateEvents @focusable,
      dragenter: 'showDropIndicator'
      dragleave: 'hideDropIndicator'
      drop: 'hideDropIndicator'


  releaseDropIndicator: ->
    @dropIndicator.remove()


  dropIndicatorPosition: ->
    pos = @el.position()
    top: pos.top + @el.outerHeight() / 2
    left: pos.left + @el.outerWidth() / 2
    display: 'block'


  showDropIndicator: ->
    return if @previewing
    clearTimeout(@dropIndicatorTimer)
    @dropIndicator.css(@dropIndicatorPosition())
    @delay(1, => @dropIndicator.css(opacity: 1))


  hideDropIndicator: ->
    @dropIndicator.css(opacity: 0)
    @dropIndicatorTimer = @delay(500, => @dropIndicator.hide())
