#= require mercury/core/view

class Mercury.ToolbarButton extends Mercury.View

  logPrefix: 'Mercury.ToolbarButton:'
  className: 'mercury-toolbar-button'

  events:
    'mousedown': -> @addClass('mercury-button-pressed')
    'mouseup': -> @el.removeClass('mercury-button-pressed')
    'mouseout': -> @el.removeClass('mercury-button-pressed')
    'click': 'triggerAction'
    'region:focus': 'onRegionFocus'
    'region:action': 'updateForRegion'
    'region:update': 'updateForRegion'

  constructor: (@name, @label, @options = {}) ->
    @action = @determineAction()
    @actionName = @determineActionName()
    @type = @determineType()
    super(@options)


  build: ->
    @attr('data-type', @type)
    @attr('data-icon', Mercury.Toolbar.icons[@icon || @name] || @icon)
    @addClass("mercury-toolbar-#{@name.toDash()}-button")
    @html("<em>#{@label}</em>")


  determineActionName: ->
    @determineAction()?[0]


  determineAction: ->
    action = @options.action || @name
    return [action] if typeof(action) == 'string'
    action


  determineType: ->
    return 'select' if @options.select
    return 'palette' if @options.palette
    return 'mode' if @options.mode


  triggerAction: ->
    Mercury.trigger(@event) if @event
    Mercury.trigger('mode', @mode) if @mode
    Mercury.trigger('action', @action...)


  onRegionFocus: (region) ->
    @delay(100, => @updateForRegion(region))


  updateForRegion: (region) ->
    @el.removeClass('mercury-button-active')
    if region.hasAction(@actionName) || @global
      @el.removeClass('mercury-button-disabled')
      @el.addClass('mercury-button-active') if region.hasContext(@name)
    else
      @el.addClass('mercury-button-disabled')
