#= require mercury/core/view
#= require mercury/views/modules/singleton
#= require mercury/views/modules/toolbar_focusable
#= require mercury/views/modules/scroll_propagation

class Mercury.Modal extends Mercury.View
  @include Mercury.View.Modules.Singleton
  @include Mercury.View.Modules.ToolbarFocusable
  @include Mercury.View.Modules.ScrollPropagation

  logPrefix: 'Mercury.Modal:'
  className: 'mercury-modal'
  template: 'modal'

  elements:
    overlayEl: '.mercury-modal-overlay'
    dialogEl: '.mercury-modal-dialog'
    positionerEl: '.mercury-modal-dialog-positioner'
    contentEl: '.mercury-modal-dialog-content'
    contentContainerEl: '.mercury-modal-dialog-content-container'
    titleContainerEl: '.mercury-modal-dialog-title'
    titleEl: '.mercury-modal-dialog-title span'

  events:
    'click .mercury-modal-dialog-title em': 'release'
    'click .mercury-modal-overlay': 'release'
    'interface:hide': -> @hide(false)
    'interface:show': -> @show(false)

  constructor: (@options = {}) ->
    return if @ensureSingleton(arguments...)
    super(options: @options)
    @show()


  build: ->
    @addClass('loading')
    @appendTo(Mercury.interface)
    $(window).on('resize', @resize)
    @preventScrollPropagation(@contentContainerEl)


  content: ->
    return @renderTemplate(@options.template) if @options.template
    return @options.content


  update: (options) ->
    @options = options if typeof(options) == 'object'
    @titleEl.html(@options.title)
    @positionerEl.css(width: @options.width)
    content = @content()
    return if content == @lastContent
    @addClass('loading')
    @contentEl.css(visibility: 'hidden', opacity: 0, width: @options.width).html(content)
    @lastContent = content
    @resize()


  resize: (noAnimation) =>
    @addClass('mercury-no-animation') if noAnimation
    @contentContainerEl.css(height: 'auto')
    titleHeight = @titleContainerEl.outerHeight()
    height = Math.min(@contentEl.outerHeight() + titleHeight, $(window).height() - 10)
    @positionerEl.css(height: height)
    @contentContainerEl.css(height: height - titleHeight)
    if noAnimation then @showContent(true) else @delay(300, @showContent)
    @el.removeClass('mercury-no-animation')


  showContent: (noAnimation) ->
    @el.removeClass('loading')
    @contentEl.css(visibility: 'visible', width: 'auto')
    if noAnimation then @contentEl.css(opacity: 1) else @delay(50, -> @contentEl.css(opacity: 1))


  show: (update = true) ->
    clearTimeout(@visibilityTimout)
    @visible = true
    @el.show()
    @visibilityTimout = @delay 50, ->
      @el.css(opacity: 1)
      @update() if update


  hide: (release = true) ->
    Mercury.trigger('focus')
    clearTimeout(@visibilityTimout)
    @visible = false
    @el.css(opacity: 0)
    @visibilityTimout = @delay 250, ->
      @el.hide()
      @release() if release


  release: ->
    return @hide(true) if @visible
    $(window).off('resize', @resize)
    super
