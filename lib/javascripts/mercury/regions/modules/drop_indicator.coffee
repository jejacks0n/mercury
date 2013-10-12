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
    # todo: margins throw a kink into positioning this -- how would we handle auto/percents?
    pos = @$el.position()
    top: pos.top + @$el.outerHeight() / 2
    left: pos.left + @$el.outerWidth() / 2
    display: 'block'


  showDropIndicator: ->
    return if @previewing
    return if Mercury.dragHack && !@onDropSnippet
    return if !Mercury.dragHack && !@onDropItem && !@onDropFile
    @$dropIndicator.css(@dropIndicatorPosition())
    @$dropIndicator.removeClass('mercury-region-snippet-drop-indicator')
    @$dropIndicator.addClass('mercury-region-snippet-drop-indicator') if Mercury.dragHack
    @$dropIndicator.addClass('mercury-shown')


  hideDropIndicator: ->
    @$dropIndicator.removeClass('mercury-shown')
