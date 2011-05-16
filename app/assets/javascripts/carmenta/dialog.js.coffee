class Carmenta.Dialog

  constructor: (@url, @name, @options = {}) ->
    @button = @options.for

    @build()
    @bindEvents()
    @preload()


  build: ->
    @element = $('<div>', {class: "carmenta-dialog carmenta-#{@name}-dialog loading", style: 'display:none'})
    @element.appendTo(@options.appendTo)


  bindEvents: ->
    @element.mousedown (event) -> event.stopPropagation()


  preload: ->
    @load() if @options.preload


  toggle: (element) ->
    if @visible then @hide() else @show()


  resize: ->
    @show()


  show: ->
    Carmenta.trigger('hide:dialogs', @)
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
    @element.animate {opacity: .95}, 200, 'easeInOutSine', =>
      @load(=> @resize()) unless @loaded


  hide: ->
    @element.hide()
    @visible = false


  load: (callback) ->
    return unless @url
    $.ajax @url, {
      success: (data) =>
        @loadContent(data)
        Carmenta.dialogHandlers[@name].call(@) if Carmenta.dialogHandlers[@name]
        callback() if callback
      error: =>
        @hide()
        @button.removeClass('pressed')
        alert("Carmenta was unable to load #{@url} for the #{@name} dialog.")
    }


  loadContent: (data) ->
    @loaded = true
    @element.removeClass('loading')
    @element.html(data)
