@Mercury.lightview = (url, options = {}) ->
  Mercury.lightview.show(url, options)
  return Mercury.lightview

jQuery.extend Mercury.lightview, {

  minWidth: 400

  show: (@url, @options = {}) ->
    Mercury.trigger('focus:window')
    @initialize()
    if @visible then @update() else @appear()


  initialize: ->
    return if @initialized
    @build()
    @bindEvents()
    @initialized = true


  build: ->
    @element = jQuery('<div>', {class: 'mercury-lightview loading'})
    @element.html('<h1 class="mercury-lightview-title"><span></span></h1>')
    @element.append('<div class="mercury-lightview-content"></div>')

    @overlay = jQuery('<div>', {class: 'mercury-lightview-overlay'})

    @titleElement = @element.find('.mercury-lightview-title')
    @contentElement = @element.find('.mercury-lightview-content')

    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')
    @overlay.appendTo(jQuery(@options.appendTo).get(0) ? 'body')

    @titleElement.find('span').html(@options.title)


  bindEvents: ->
    Mercury.bind 'refresh', => @resize(true)
    Mercury.bind 'resize', => @position()


  appear: ->
    @position()

    @overlay.show()
    @overlay.animate {opacity: 1}, 200, 'easeInOutSine', =>
      @setTitle()
      @element.show()
      @element.animate {opacity: 1}, 200, 'easeInOutSine', =>
        @visible = true
        @load()


  resize: (keepVisible) ->


  position: ->


  update:  ->
    @reset()
    @resize()
    @load()


  load: ->
    @element.addClass('loading')
    @setTitle()
    if Mercury.preloadedViews[@url]
      setTimeout((=> @loadContent(Mercury.preloadedViews[@url])), 10)
    else
      jQuery.ajax @url, {
        type: @options.loadType || 'get'
        data: @options.loadData
        success: (data) => @loadContent(data)
        error: =>
          @hide()
          alert("Mercury was unable to load #{@url} for the lightview.")
      }


  loadContent: (data, options = null) ->
    @initialize()
    @options = options || @options
    @setTitle()
    @loaded = true
    @element.removeClass('loading')
    @contentElement.html(data)
    @contentElement.css({display: 'none', visibility: 'hidden'})

    @options.afterLoad.call(@) if @options.afterLoad
    if @options.handler && Mercury.lightviewHandlers[@options.handler]
      Mercury.lightviewHandlers[@options.handler].call(@)

    @resize()


  setTitle: ->
    @titleElement.find('span').html(@options.title)


  reset: ->
    @titleElement.find('span').html('')
    @contentElement.html('')


  hide: ->
    Mercury.trigger('focus:frame')
    @element.hide()
    @overlay.hide()
    @reset()

    @visible = false

}