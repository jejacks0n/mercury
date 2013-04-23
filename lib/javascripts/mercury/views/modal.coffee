#= require mercury/core/view
#= require mercury/views/modules/singleton
#= require mercury/views/modules/toolbar_focusable
#= require mercury/views/modules/scroll_propagation

class Mercury.Modal extends Mercury.View
  @include Mercury.View.Modules.Singleton
  @include Mercury.View.Modules.ToolbarFocusable
  @include Mercury.View.Modules.ScrollPropagation

  @logPrefix: 'Mercury.Modal:'
  @className: 'mercury-modal'

  @elements:
    overlay: '.mercury-modal-overlay'
    dialog: '.mercury-modal-dialog-positioner'
    content: '.mercury-modal-dialog-content'
    contentContainer: '.mercury-modal-dialog-content-container'
    titleContainer: '.mercury-modal-dialog-title'
    title: '.mercury-modal-dialog-title span'

  @events:
    'click .mercury-modal-dialog-title em': 'release'
    'click .mercury-modal-overlay': 'release'
    'mercury:interface:hide': -> @hide(false)
    'mercury:interface:show': -> @show(false)
    'mercury:interface:resize': -> @resize(false)

  primaryTemplate: 'modal'

  constructor: (@options = {}) ->
    return instance if instance = @ensureSingleton(@primaryTemplate, arguments...)
    @options.template ||= @template
    super(@options)
    @show()


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
    @$dialog.css(width: @width)
    content = @contentFromOptions()
    return if content == @lastContent
    @addClass('loading')
    @$content.css(visibility: 'hidden', opacity: 0, width: @width).html(content)
    @lastContent = content
    @resize()
    @show(false)


  resize: (animate = true) ->
    clearTimeout(@showContentTimeout)
    @addClass('mercury-no-animation') unless animate
    @$contentContainer.css(height: 'auto')
    titleHeight = @$titleContainer.outerHeight()
    if !@width
      @$content.css(position: 'absolute')
      width = @$content.outerWidth()
      height = Math.min(@$content.outerHeight() + titleHeight, $(window).height() - 10)
      @$content.css(position: 'static')
    else
      height = Math.min(@$content.outerHeight() + titleHeight, $(window).height() - 10)
    @$dialog.css(height: height, width: width || @width)
    @$contentContainer.css(height: height - titleHeight)
    if animate
      @showContentTimeout = @delay(300, @showContent)
    else
      @showContent(false)
    @removeClass('mercury-no-animation')


  contentFromOptions: ->
    return @renderTemplate(@subTemplate) if @subTemplate
    return @content


  showContent: (animate = true) ->
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
    @removeSingleton(@primaryTemplate)
    super
