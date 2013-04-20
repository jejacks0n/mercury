#= require mercury/core/view

class Mercury.ToolbarButton extends Mercury.View

  @logPrefix: 'Mercury.ToolbarButton:'
  @className: 'mercury-toolbar-button'

  @events:
    'mousedown': (e) ->
      return if @isDisabled()
      if @subview?.visible
        e.preventDefault()
        e.stopPropagation()
      @addClass('mercury-button-pressed')
    'mouseup': -> @$el.removeClass('mercury-button-pressed')
    'mouseout': -> @$el.removeClass('mercury-button-pressed')
    'click': 'triggerAction'
    'mercury:region:focus': 'onRegionFocus'
    'mercury:region:action': 'onRegionUpdate'
    'mercury:region:update': 'onRegionUpdate'

  standardOptions: ['title', 'icon', 'action', 'global', 'button']

  @create: (name, label, options = {}) ->
    if options.button && Klass = Mercury["toolbar_#{options.button}".toCamelCase(true)]
      return new Klass(name, label, options)
    if options.plugin && Klass = Mercury.getPlugin(options.plugin).Button
      return new Klass(name, label, options)
    return new Mercury.ToolbarButton(name, label, options)


  constructor: (@name, @label, @options = {}) ->
    @determineAction()
    @determineType()
    @type = @types[0]
    super(@options)


  determineAction: ->
    @action = @options.action || @name
    @action = [@action] if typeof(@action) == 'string'
    @actionName = @action[0]


  determineType: ->
    @types = []
    return @types = [@options.type] if @options.type
    @types.push(type) for type, value of @options when type not in @standardOptions


  build: ->
    @attr('data-type', @type)
    @attr('data-icon', Mercury.Toolbar.icons[@icon || @name] || @icon)
    @addClass("mercury-toolbar-#{@name.toDash()}-button")
    @html("<em>#{@label}</em>")
    @enablePlugin()
    @buildSubview()?.appendTo(@)


  buildSubview: ->
    return @subview if @subview
    if Klass = Mercury["toolbar_#{@type}".toCamelCase(true)]
      options = @options[@type]
      options = {template: options} if typeof(options) == 'string'
      return @subview = new Klass(options)


  enablePlugin: ->
    return unless @plugin
    @plugin = Mercury.getPlugin(@plugin)
    @plugin.registerButton(@)


  triggerAction: ->
    return if @isDisabled()
    @subview.toggle() if @subview
    return @plugin.trigger('button:click') if @plugin
    return if @subview
    Mercury.trigger(@event) if @event
    Mercury.trigger('mode', @mode) if @mode
    Mercury.trigger('action', @action...)


  isDisabled: ->
    @$el.closest('.mercury-button-disabled').length


  onRegionFocus: (region) ->
    @delay(100, => @onRegionUpdate(region))


  onRegionUpdate: (region) ->
    @$el.removeClass('mercury-button-active')
    if @global || @regionSupported(region)
      @$el.removeClass('mercury-button-disabled')
      @$el.addClass('mercury-button-active') if region.hasContext(@name)
    else
      @$el.addClass('mercury-button-disabled')


  regionSupported: (region) ->
    return @plugin.regionSupported(region) if @plugin
    region.hasAction(@actionName)
