Carmenta.modal = (url, options) ->
  Carmenta.modal.show(url, options)
  return Carmenta.modal

$.extend Carmenta.modal, {

  minWidth: 400

  show: (@url, @options = {}) ->
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

    $(window).resize => @position()

    @overlay.click => @hide()

    @titleElement.find('a').click => @hide()
    @titleElement.mousedown(Carmenta.preventer)


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


  position: ->
    viewportWidth = $(window).width()
    viewportHeight = $(window).height()

    @contentElement.css({height: 'auto'})
    @element.css({width: 'auto', height: 'auto', display: 'block', visibility: 'hidden'})

    width = @element.width()
    height = @element.height()

    width = @minWidth if width < @minWidth
    height = viewportHeight - 20 if height > viewportHeight - 20

    @contentElement.css({height: height - @titleElement.outerHeight()})

    @element.css {
      left: (viewportWidth - width) / 2
      width: width,
      height: height,
      display: if @visible then 'block' else 'none',
      visibility: 'visible'
    }


  resize: (keepVisible) ->
    visibility = if keepVisible then 'visible' else 'hidden'
    @contentElement.css({height: 'auto', visibility: visibility, display: 'block'})

    viewportHeight = $(window).height()
    titleHeight = @titleElement.outerHeight()

    width = @contentElement.outerWidth()
    height = @contentElement.outerHeight() + titleHeight

    width = @minWidth if width < @minWidth
    height = viewportHeight - 20 if height > viewportHeight - 20

    @element.stop().animate {left: ($(window).width() - width) / 2, width: width, height: height}, 200, 'easeInOutSine', =>
      @contentElement.css({height: height - titleHeight, visibility: 'visible', display: 'block'})


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