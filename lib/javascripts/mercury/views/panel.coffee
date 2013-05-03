#= require mercury/core/view
#= require mercury/views/modules/form_handler
#= require mercury/views/modules/interface_focusable
#= require mercury/views/modules/scroll_propagation
#= require mercury/views/modules/visibility_toggleable

class Mercury.Panel extends Mercury.View
  @include Mercury.View.Modules.FormHandler
  @include Mercury.View.Modules.InterfaceFocusable
  @include Mercury.View.Modules.ScrollPropagation
  @include Mercury.View.Modules.VisibilityToggleable

  @logPrefix: 'Mercury.Panel:'
  @className: 'mercury-dialog mercury-panel'

  @elements:
    content: '.mercury-panel-content'
    contentContainer: '.mercury-panel-content-container'
    titleContainer: '.mercury-panel-title'
    title: '.mercury-panel-title span'

  @events:
    'mercury:interface:hide': 'hide'
    'mercury:interface:resize': 'resize'
    'mercury:panels:hide': 'hide'
    'mousedown .mercury-panel-title em': 'prevent'
    'click .mercury-panel-title em': 'hide'

  primaryTemplate: 'panel'

  constructor: (@options = {}) ->
    @options.template ||= @template
    super(@options)
    if @hidden then @visible = false else @show()


  buildElement: ->
    @subTemplate = @options.template
    @template = @primaryTemplate
    super


  build: ->
    @addClass('loading')
    @appendTo(Mercury.interface)
    @preventScrollPropagation(@$contentContainer)


  update: (options) ->
    return unless @visible
    @options = $.extend({}, @options, options || {})
    @[key] = value for key, value of @options
    @subTemplate = @options.template
    @template = @primaryTemplate
    @$title.html(@title)
    @css(width: @width)
    content = @contentFromOptions()
    return if content == @lastContent
    @addClass('loading')
    @$content.css(visibility: 'hidden', opacity: 0, width: @width).html(content)
    @lastContent = content
    @resize(true, Mercury.interface.dimensions())
    @show(false)
    @refreshElements()


  resize: (animate = true, dimensions = null) =>
    if typeof(animate) == 'object'
      dimensions = animate
      animate = false
    clearTimeout(@showContentTimeout)
    @css(top: dimensions.top + 10, bottom: dimensions.bottom + 10) if dimensions
    @addClass('mercury-no-animation') unless animate
    titleHeight = @$titleContainer.outerHeight()
    height = @$el.height()
    @$contentContainer.css(height: height - titleHeight)
    if animate
      @showContentTimeout = @delay(300, @showContent)
    else
      @showContent(false)
    @removeClass('mercury-no-animation')


  contentFromOptions: ->
    return @renderTemplate(@subTemplate) if @subTemplate
    return @content


  showContent: (animate) ->
    clearTimeout(@contentOpacityTimeout)
    @removeClass('loading')
    @$content.css(visibility: 'visible', width: 'auto')
    if animate
      @contentOpacityTimeout = @delay(50, -> @$content.css(opacity: 1))
    else
      @$content.css(opacity: 1)


  appendTo: ->
    @log(@t('appending to mercury interface instead'))
    super(Mercury.interface)


  release: ->
    return @hide(true) if @visible
    super


  onShow: ->
    Mercury.trigger('panels:hide')


  onHide: ->
    Mercury.trigger('focus')
