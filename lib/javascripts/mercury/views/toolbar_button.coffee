#= require mercury/core/view

class Mercury.ToolbarButton extends Mercury.View

  logPrefix: 'Mercury.ToolbarButton:'
  className: 'mercury-toolbar-button'

  constructor: (@name, @optionsArray) ->
    @type = 'select' if @name == 'style' || @name == 'block'
    @type = 'palette' if @name == 'color' || @name == 'bgcolor'
    super


  build: ->
    @attr('data-type', @type) if @type
    @attr('data-action', @name.toDash())
    @addClass("mercury-toolbar-#{@name.toDash()}-button")
    @html("<em>#{@optionsArray[0]}</em>")
