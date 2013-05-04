#= require mercury/views/modal
#= require mercury/templates/lightview

class Mercury.Lightview extends Mercury.Modal

  @logPrefix: 'Mercury.Lightview:'
  @className: 'mercury-dialog mercury-lightview'

  @elements:
    dialog: '.mercury-lightview-dialog-positioner'
    content: '.mercury-lightview-dialog-content'
    contentContainer: '.mercury-lightview-dialog-content-container'
    titleContainer: '.mercury-lightview-dialog-title'
    title: '.mercury-lightview-dialog-title span'

  @events:
    'mercury:interface:hide': 'hide'
    'mercury:interface:resize': 'resize'
    'mercury:modals:hide': 'hide'
    'click .mercury-lightview-dialog-title em': 'hide'

  primaryTemplate: 'lightview'
  releaseOnHide: true

  build: ->
    super
    @defaultPosition()


  defaultPosition: ->
    @$dialog.css(marginTop: ($(window).height() - 75) / 2)


  resize: (animate = true, dimensions = null) ->
    return unless @visible
    clearTimeout(@showContentTimeout)
    if typeof(animate) == 'object'
      dimensions = animate
      animate = false
    @addClass('mercury-no-animation') unless animate
    @$contentContainer.css(height: 'auto')
    @$content.css(width: Math.min(@$content.outerWidth(), $(window).width()))
    titleHeight = @$titleContainer.outerHeight()
    height = Math.min(@$content.outerHeight() + titleHeight, $(window).height())
    @$dialog.css(marginTop: ($(window).height() - height) / 2, height: height)
    @$content.css(width: 'auto')
    @$contentContainer.css(height: height - titleHeight)
    if animate
      @showContentTimeout = @delay(300, @showContent)
    else
      @showContent(false)
    @removeClass('mercury-no-animation')


  onHide: ->
    super
    @delay(250, @defaultPosition)

