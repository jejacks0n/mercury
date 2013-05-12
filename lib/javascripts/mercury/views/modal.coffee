#= require mercury/core/view
#= require mercury/views/modules/form_handler
#= require mercury/views/modules/interface_focusable
#= require mercury/views/modules/scroll_propagation
#= require mercury/views/modules/visibility_toggleable
#= require mercury/templates/modal

class Mercury.Modal extends Mercury.View
  @include Mercury.View.Modules.FormHandler
  @include Mercury.View.Modules.InterfaceFocusable
  @include Mercury.View.Modules.ScrollPropagation
  @include Mercury.View.Modules.VisibilityToggleable

  @logPrefix: 'Mercury.Modal:'
  @className: 'mercury-dialog mercury-modal'

  @elements:
    dialog: '.mercury-modal-dialog-positioner'
    content: '.mercury-modal-dialog-content'
    contentContainer: '.mercury-modal-dialog-content-container'
    titleContainer: '.mercury-modal-dialog-title'
    title: '.mercury-modal-dialog-title span'

  @events:
    'mercury:interface:resize': 'resize'
    'mercury:modals:hide': 'hide'
    'click .mercury-modal-dialog-title em': 'hide'

  primaryTemplate: 'modal'
  releaseOnHide: true

  buildElement: ->
    @releaseOnHide = false if @hidden
    @negotiateTemplate()
    super


  build: ->
    @appendTo() # always Mercury.interface
    @preventScrollPropagation(@$contentContainer)
    @preventFocusout(@$contentContainer, @focusFirstFocusable)


  negotiateTemplate: ->
    @options.template ||= @template
    @subTemplate = @options.template
    @template = @primaryTemplate


  update: (options) ->
    return unless @visible && @updateForOptions(options)
    @resize()
    @show(false)
    @refreshElements()
    @trigger('update')
    @delay(300, @focusFirstFocusable)


  updateForOptions: (options) ->
    @options = $.extend({}, @options, options || {})
    @[key] = value for key, value of @options
    @negotiateTemplate()
    @$title.html(@t(@title))
    @setWidth(@width)
    content = @contentFromOptions()
    return false if content == @lastContent && @width == @lastWidth
    @addClass('loading')
    @lastContent = content
    @lastWidth = @width
    @$content.css(visibility: 'hidden', opacity: 0, width: @width).html(content)
    @localize(@$content)
    return true


  setWidth: (width) ->
    @$dialog.css(width: width)


  resize: (animate = true, dimensions = null) ->
    return unless @visible
    clearTimeout(@showContentTimeout)
    if typeof(animate) == 'object'
      dimensions = animate
      animate = false
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
    @$content.css(visibility: 'visible', width: 'auto', display: 'block')
    if animate
      @contentOpacityTimeout = @delay(50, -> @$content.css(opacity: 1))
    else
      @$content.css(opacity: 1)


  appendTo: ->
    super(Mercury.interface)


  release: ->
    return @hide(true) if @visible
    super


  onShow: ->
    Mercury.trigger('blur')
    Mercury.trigger('modals:hide')


  onHide: ->
    Mercury.trigger('focus')
    @delay 250, ->
      @lastWidth = null
      @$dialog.css(height: '', width: '')
      @$contentContainer.css(height: '')
      @$content.hide()
