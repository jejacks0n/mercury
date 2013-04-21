#= require mercury/core/view
#= require mercury/views/modules/singleton
#= require mercury/views/modules/toolbar_focusable
#= require mercury/views/modules/scroll_propagation

class Mercury.Panel extends Mercury.View
  @include Mercury.View.Modules.Singleton
  @include Mercury.View.Modules.ToolbarFocusable
  @include Mercury.View.Modules.ScrollPropagation

  @logPrefix: 'Mercury.Panel:'
  @className: 'mercury-panel'

  @elements:
    content: '.mercury-panel-content'
    contentContainer: '.mercury-panel-content-container'
    titleContainer: '.mercury-panel-title'
    title: '.mercury-panel-title span'

  @events:
    'click .mercury-panel-title em': 'release'
    'mercury:interface:hide': -> @hide(false)
    'mercury:interface:show': -> @show(false)
    'mercury:interface:resize': (e) -> @resize(false, e)
    'mercury:panels:hide': 'release'

  constructor: (@options = {}) ->
    @options.template ||= @template
    Mercury.trigger('panels:hide')
    super(@options)
    @show()


  buildElement: ->
    @subTemplate = @options.template
    @template = 'panel'
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
    @template = 'panel'
    @$title.html(@title)
    @css(width: @width)
    content = @contentFromOptions()
    return if content == @lastContent
    @addClass('loading')
    @$content.css(visibility: 'hidden', opacity: 0, width: @width).html(content)
    @lastContent = content
    @resize(true, Mercury.interface.dimensions())
    @show(false)


  resize: (animate = true, dimensions) =>
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


  show: (update = true) ->
    clearTimeout(@visibilityTimout)
    @visible = true
    @$el.show()
    @visibilityTimout = @delay 50, ->
      @css(opacity: 1)
      @update() if update


  hide: (release = true) ->
    Mercury.trigger('focus')
    clearTimeout(@visibilityTimout)
    @visible = false
    @css(opacity: 0)
    @visibilityTimout = @delay 250, ->
      @$el.hide()
      @release() if release


  release: ->
    return @hide(true) if @visible
    super
