Carmenta.modal = (url, options) ->
  Carmenta.modal.show(url, options)
  return Carmenta.modal

$.extend Carmenta.modal, {

  minWidth: 400

  show: (@url, @options = {}) ->
    Carmenta.trigger('focus:window')
    @initialize()
    if @visible then @update() else @appear()


  initialize: ->
    return if @initialized
    @build()
    @bindEvents()
    @initialized = true


  build: ->
    @element = $('<div>', {class: 'carmenta-modal loading'})
    @element.html('<h1 class="carmenta-modal-title"><span></span><a>&times;</a></h1><div class="carmenta-modal-content-container"><div class="carmenta-modal-content"></div></div>')

    @overlay = $('<div>', {class: 'carmenta-modal-overlay'})

    @titleElement = @element.find('.carmenta-modal-title')
    @contentContainerElement = @element.find('.carmenta-modal-content-container')
    @contentElement = @element.find('.carmenta-modal-content')

    @element.appendTo(@options.appendTo || 'body')
    @overlay.appendTo(@options.appendTo || 'body')

    @titleElement.find('span').html(@options.title)


  bindEvents: ->
    Carmenta.bind 'refresh', => @resize(true)
    Carmenta.bind 'resize', => @position()

    @overlay.click => @hide()

    @titleElement.find('a').click => @hide()


  appear: ->
    @position()

    @overlay.show()
    @overlay.animate {opacity: 1}, 200, 'easeInOutSine', =>
      @element.css({top: -@element.height()})
      @setTitle()
      @element.show()
      @element.animate {top: 0}, 200, 'easeInOutSine', =>
        @visible = true
        @load()


  resize: (keepVisible) ->
    visibility = if keepVisible then 'visible' else 'hidden'
    @contentElement.css({height: 'auto', visibility: visibility, display: 'block'})

    viewportHeight = $(window).height()
    titleHeight = @titleElement.outerHeight()

    width = @contentElement.outerWidth()
    height = @contentElement.outerHeight() + titleHeight

    width = @minWidth if width < @minWidth
    height = viewportHeight - 20 if height > viewportHeight - 20 || @options.fullHeight

    @element.stop().animate {left: ($(window).width() - width) / 2, width: width, height: height}, 200, 'easeInOutSine', =>
      @contentElement.css({visibility: 'visible', display: 'block'})
      if @contentPane.length
        @contentElement.css({height: height - titleHeight, overflow: 'visible'})
        controlHeight = if @contentControl.length then @contentControl.outerHeight() else 0
        @contentPane.css({height: height - titleHeight - controlHeight - 20})
        @contentPane.find('.carmenta-modal-pane').css({width: width - 40})
      else
        @contentElement.css({height: height - titleHeight, overflow: 'auto'})


  position: ->
    viewportWidth = $(window).width()
    viewportHeight = $(window).height()

    @contentPane.css({height: 'auto'}) if @contentPane
    @contentElement.css({height: 'auto'})
    @element.css({width: 'auto', height: 'auto', display: 'block', visibility: 'hidden'})

    width = @element.width()
    height = @element.height()

    width = @minWidth if width < @minWidth
    height = viewportHeight - 20 if height > viewportHeight - 20 || @options.fullHeight

    titleHeight = @titleElement.outerHeight()
    if @contentPane && @contentPane.length
      @contentElement.css({height: height - titleHeight, overflow: 'visible'})
      controlHeight = if @contentControl.length then @contentControl.outerHeight() else 0
      @contentPane.css({height: height - titleHeight - controlHeight - 20})
    else
      @contentElement.css({height: height - titleHeight, overflow: 'auto'})

    @element.css {
      left: (viewportWidth - width) / 2
      width: width,
      height: height,
      display: if @visible then 'block' else 'none',
      visibility: 'visible'
    }


  update:  ->
    @reset()
    @resize()
    @load()


  load: ->
    @element.addClass('loading')
    @setTitle()
    $.ajax @url, {
      success: (data) => @loadContent(data)
      error: =>
        @hide()
        alert("Carmenta was unable to load #{@url} for the modal.")
    }


  loadContent: (data, options) ->
    @options = options || @options
    @setTitle()
    @loaded = true
    @element.removeClass('loading')
    @contentElement.html(data)
    @contentElement.css({display: 'none', visibility: 'hidden'})

    # for complex modal content, we provide panes and controls
    @contentPane = @element.find('.carmenta-modal-pane-container')
    @contentControl = @element.find('.carmenta-modal-controls')

    @options.afterLoad.call(@) if @options.afterLoad
    if @options.handler && Carmenta.modalHandlers[@options.handler]
      Carmenta.modalHandlers[@options.handler].call(@)

    @resize()


  setTitle: ->
    @titleElement.find('span').html(@options.title)


  reset: ->
    @titleElement.find('span').html('')
    @contentElement.html('')


  hide: ->
    @element.hide()
    @overlay.hide()
    @reset()

    @visible = false

}