Mercury.Region.Modules.DropIndicator =

  included: ->
    @on('build', @buildDropIndicator)
    @on('release', @releaseDropIndicator)


  buildDropIndicator: ->
    @$el.after(@$dropIndicator = $('<div class="mercury-region-drop-indicator"></div>'))
    @delegateEvents
      dragenter: 'showDropIndicator'
      dragover: 'showDropIndicator'
      dragleave: 'hideDropIndicator'
      drop: 'hideDropIndicator'


  releaseDropIndicator: ->
    @$dropIndicator.remove()


  dropIndicatorPosition: ->
    pos = @$el.position()
    top: pos.top + @$el.outerHeight() / 2
    left: pos.left + @$el.outerWidth() / 2
    display: 'block'


  showDropIndicator: ->
    return if @previewing || @dropIndicatorVisible
    @dropIndicatorVisible = true
    clearTimeout(@dropIndicatorTimer)
    @$dropIndicator.css(@dropIndicatorPosition())
    @delay(50, => @$dropIndicator.css(opacity: 1))


  hideDropIndicator: ->
    @dropIndicatorVisible = false
    @$dropIndicator.css(opacity: 0)
    @dropIndicatorTimer = @delay(500, => @$dropIndicator.hide())
