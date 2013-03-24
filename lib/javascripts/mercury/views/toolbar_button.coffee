#= require mercury/core/view

class Mercury.ToolbarButton extends Mercury.View

  logPrefix: 'Mercury.ToolbarButton:'
  className: 'mercury-toolbar-button'

  events:
    'mousedown': -> @addClass('active')
    'mouseup': -> @el.removeClass('active')
    'mouseout': -> @el.removeClass('active')

  constructor: (@name, @optionsArray) ->
    @type = 'select' if @name == 'style' || @name == 'block'
    @type = 'palette' if @name == 'color' || @name == 'bgcolor'
    @type = 'mode' if @name == 'preview'
    super


  build: ->
    @addClass('active') if @name == 'bold'
    @attr('data-type', @type) if @type
    @attr('data-action', @name.toDash())
    @addClass("mercury-toolbar-#{@name.toDash()}-button")
    @html("<em>#{@optionsArray[0]}</em>")
