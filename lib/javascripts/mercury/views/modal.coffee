#= require mercury/core/view
#= require mercury/views/modules/form_handler
#= require mercury/views/modules/interface_focusable
#= require mercury/views/modules/scroll_propagation
#= require mercury/views/modules/visibility_toggleable

class Mercury.Modal extends Mercury.View
  @include Mercury.View.Modules.FormHandler
  @include Mercury.View.Modules.InterfaceFocusable
  @include Mercury.View.Modules.ScrollPropagation
  @include Mercury.View.Modules.VisibilityToggleable

  @logPrefix: 'Mercury.Modal:'
  @className: 'mercury-dialog mercury-modal'

  @elements:
    overlay: '.mercury-modal-overlay'
    dialog: '.mercury-modal-dialog-positioner'
    content: '.mercury-modal-dialog-content'
    contentContainer: '.mercury-modal-dialog-content-container'
    titleContainer: '.mercury-modal-dialog-title'
    title: '.mercury-modal-dialog-title span'

  @events:
    'mercury:interface:hide': -> @hide()
    'mercury:interface:resize': (dimensions) -> @resize(false, dimensions)
    'mercury:modals:hide': -> @hide()
    'click .mercury-modal-dialog-title em': -> @hide()

  primaryTemplate: 'modal'

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
    @$dialog.css(width: @width)
    content = @contentFromOptions()
    return if content == @lastContent
    @addClass('loading')
    @$content.css(visibility: 'hidden', opacity: 0, width: @width).html(content)
    @lastContent = content
    @resize()
    @show(false)
    @refreshElements()
    @delay(300, @focusFirstFocusable)


  resize: (animate = true, dimensions) ->
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
    @delay(250, -> @removeClass('mercury-no-animation'))


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
    return if @visible
    Mercury.trigger('blur')
    Mercury.trigger('modals:hide')
    @trigger('show')
    clearTimeout(@visibilityTimout)
    @visible = true
    @$el.show()
    @visibilityTimout = @delay 50, ->
      @css(opacity: 1)
      @update() if update


  hide: (release = false) ->
    return if !@visible && !release
    Mercury.trigger('focus')
    @trigger('hide')
    clearTimeout(@visibilityTimout)
    @visible = false
    @css(opacity: 0)
    @visibilityTimout = @delay 250, ->
      @$el.hide()
      @release() if release


  appendTo: ->
    @log(@t('appending to mercury interface instead'))
    super(Mercury.interface)


  release: ->
    return @hide(true) if @visible
    super
