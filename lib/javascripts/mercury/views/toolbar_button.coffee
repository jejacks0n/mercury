#= require mercury/core/view

class Mercury.ToolbarButton extends Mercury.View

  logPrefix: 'Mercury.ToolbarButton:'
  className: 'mercury-toolbar-button'

  events:
    'mousedown': (e) ->
      e.stopPropagation() if @subView && @subView.visible
      @addClass('mercury-button-pressed')
    'mouseup': -> @el.removeClass('mercury-button-pressed')
    'mouseout': -> @el.removeClass('mercury-button-pressed')
    'click': 'triggerAction'
    'region:focus': 'onRegionFocus'
    'region:action': 'onRegionUpdate'
    'region:update': 'onRegionUpdate'

  standardOptions: ['title', 'icon', 'action', 'global', 'button']

  @create: (name, label, options = {}) ->
    if options.button && Klass = Mercury["toolbar_#{options.button}".toCamelCase(true)]
      return new Klass(name, label, options)
    return new Mercury.ToolbarButton(name, label, options)


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
    @buildSubView()?.appendTo(@)


  buildSubView: ->
    if Klass = Mercury["toolbar_#{@type}".toCamelCase(true)]
      options = @options[@type]
      options = {template: options} if typeof(options) == 'string'
      return @subView = new Klass(options)


  determineAction: ->
    action = @options.action || @name
    return [action] if typeof(action) == 'string'
    action


  determineActionName: ->
    @determineAction()?[0]


  determineType: ->
    return @type if @type
    return @type = @options.type if @options.type
    types = $.extend({}, @options)
    delete(types[option]) for option in @standardOptions
    return @type = type for type, value of types


  triggerAction: ->
    return @subView.toggle() if @subView
    Mercury.trigger(@event) if @event
    Mercury.trigger('mode', @mode) if @mode
    Mercury.trigger('action', @action...)


  onRegionFocus: (region) ->
    @delay(100, => @onRegionUpdate(region))


  onRegionUpdate: (region) ->
    @el.removeClass('mercury-button-active')
    if region.hasAction(@actionName) || @global
      @el.removeClass('mercury-button-disabled')
      @el.addClass('mercury-button-active') if region.hasContext(@name)
    else
      @el.addClass('mercury-button-disabled')
