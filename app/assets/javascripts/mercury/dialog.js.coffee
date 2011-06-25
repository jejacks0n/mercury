class @Mercury.Dialog

  constructor: (@url, @name, @options = {}) ->
    @button = @options.for

    @build()
    @bindEvents()
    @preload()


  build: ->
    @element = jQuery('<div>', {class: "mercury-dialog mercury-#{@name}-dialog loading", style: 'display:none'})
    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    @element.mousedown (event) -> event.stopPropagation()


  preload: ->
    @load() if @options.preload


  toggle: (element) ->
    if @visible then @hide() else @show()


  resize: ->
    @show()


  show: ->
    Mercury.trigger('hide:dialogs', @)
    @visible = true
    if @loaded
      @element.css({width: 'auto', height: 'auto'})
      @position(@visible)
      @appear()
    else
      @position()
      @appear()


  position: (keepVisible) ->


  appear: ->
    @element.css({display: 'block', opacity: 0})
    @element.animate {opacity: 0.95}, 200, 'easeInOutSine', =>
      @load(=> @resize()) unless @loaded


  hide: ->
    @element.hide()
    @visible = false


  load: (callback) ->
    return unless @url
    if Mercury.preloadedViews[@url]
      @loadContent(Mercury.preloadedViews[@url])
      Mercury.dialogHandlers[@name].call(@) if Mercury.dialogHandlers[@name]
      callback() if callback
    else
      jQuery.ajax @url, {
        success: (data) =>
          @loadContent(data)
          Mercury.dialogHandlers[@name].call(@) if Mercury.dialogHandlers[@name]
          callback() if callback
        error: =>
          @hide()
          @button.removeClass('pressed') if @button
          alert("Mercury was unable to load #{@url} for the #{@name} dialog.")
      }


  loadContent: (data) ->
    @loaded = true
    @element.removeClass('loading')
    @element.html(data)
