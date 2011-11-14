@Mercury.lightview = (url, options = {}) ->
  Mercury.lightview.show(url, options)
  return Mercury.lightview

jQuery.extend Mercury.lightview,
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
    @titleElement.append('<a class="mercury-lightview-close"></a>') if @options.closeButton

    @contentElement = @element.find('.mercury-lightview-content')

    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')
    @overlay.appendTo(jQuery(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    Mercury.on 'refresh', => @resize(true)
    Mercury.on 'resize', => @position() if @visible

    @overlay.on 'click', =>
      @hide() unless @options.closeButton

    @titleElement.find('.mercury-lightview-close').on 'click', =>
      @hide()

    @element.on 'ajax:beforeSend', (event, xhr, options) =>
      options.success = (content) =>
        @loadContent(content)

    jQuery(document).on 'keydown', (event) =>
       @hide() if event.keyCode == 27 && @visible


  appear: ->
    @showing = true
    @position()

    @overlay.show().css({opacity: 0})
    @overlay.animate {opacity: 1}, 200, 'easeInOutSine', =>
      @setTitle()
      @element.show().css({opacity: 0})
      @element.stop().animate {opacity: 1}, 200, 'easeInOutSine', =>
        @visible = true
        @showing = false
        @load()


  resize: (keepVisible) ->
    visibility = if keepVisible then 'visible' else 'hidden'

    viewportWidth = Mercury.displayRect.width
    viewportHeight = Mercury.displayRect.fullHeight

    titleHeight = @titleElement.outerHeight()

    width = @contentElement.outerWidth()
    width = viewportWidth - 40 if width > viewportWidth - 40 || @options.fullSize

    @contentPane.css({height: 'auto'}) if @contentPane
    @contentElement.css({height: 'auto', visibility: visibility, display: 'block'})

    height = @contentElement.outerHeight() + titleHeight
    height = viewportHeight - 20 if height > viewportHeight - 20 || @options.fullSize

    width = 300 if width < 300
    height = 150 if height < 150

    @element.stop().animate {top: ((viewportHeight - height) / 2) + 10, left: (Mercury.displayRect.width - width) / 2, width: width, height: height}, 200, 'easeInOutSine', =>
      @contentElement.css({visibility: 'visible', display: 'block'})
      if @contentPane.length
        @contentElement.css({height: height - titleHeight, overflow: 'visible'})
        controlHeight = if @contentControl.length then @contentControl.outerHeight() else 0
        @contentPane.css({height: height - titleHeight - controlHeight - 40})
        @contentPane.find('.mercury-display-pane').css({width: width - 40})
      else
        @contentElement.css({height: height - titleHeight - 30, overflow: 'auto'})


  position: ->
    viewportWidth = Mercury.displayRect.width
    viewportHeight = Mercury.displayRect.fullHeight

    @contentPane.css({height: 'auto'}) if @contentPane
    @contentElement.css({height: 'auto'})
    @element.css({width: 'auto', height: 'auto', display: 'block', visibility: 'hidden'})

    width = @contentElement.width() + 40
    height = @contentElement.height() + @titleElement.outerHeight() + 30

    width = viewportWidth - 40 if width > viewportWidth - 40 || @options.fullSize
    height = viewportHeight - 20 if height > viewportHeight - 20 || @options.fullSize

    width = 300 if width < 300
    height = 150 if height < 150

    titleHeight = @titleElement.outerHeight()
    if @contentPane && @contentPane.length
      @contentElement.css({height: height - titleHeight, overflow: 'visible'})
      controlHeight = if @contentControl.length then @contentControl.outerHeight() else 0
      @contentPane.css({height: height - titleHeight - controlHeight - 40})
      @contentPane.find('.mercury-display-pane').css({width: width - 40})
    else
      @contentElement.css({height: height - titleHeight - 30, overflow: 'auto'})

    @element.css {
      top: ((viewportHeight - height) / 2) + 10,
      left: (viewportWidth - width) / 2,
      width: width
      height: height
      display: if @visible then 'block' else 'none'
      visibility: 'visible'
    }


  update:  ->
    @reset()
    @resize()
    @load()


  load: ->
    @setTitle()
    return unless @url
    @element.addClass('loading')
    if Mercury.preloadedViews[@url]
      setTimeout(10, => @loadContent(Mercury.preloadedViews[@url]))
    else
      jQuery.ajax @url, {
        headers: Mercury.ajaxHeaders()
        type: @options.loadType || 'GET'
        data: @options.loadData
        success: (data) => @loadContent(data)
        error: =>
          @hide()
          Mercury.notify('Mercury was unable to load %s for the lightview.', @url)
      }


  loadContent: (data, options = null) ->
    @initialize()
    @options = options || @options
    @setTitle()
    @loaded = true
    @element.removeClass('loading')
    @contentElement.html(data)
    @contentElement.css({display: 'none', visibility: 'hidden'})

    # for complex lightview content, we provide panes and controls
    @contentPane = @element.find('.mercury-display-pane-container')
    @contentControl = @element.find('.mercury-display-controls')

    @options.afterLoad.call(@) if @options.afterLoad
    if @options.handler
      if Mercury.modalHandlers[@options.handler]
        Mercury.modalHandlers[@options.handler].call(@)
      else if Mercury.lightviewHandlers[@options.handler]
        Mercury.lightviewHandlers[@options.handler].call(@)

    @element.localize(Mercury.locale()) if Mercury.config.localization.enabled
    @resize()


  setTitle: ->
    @titleElement.find('span').html(Mercury.I18n(@options.title))


  reset: ->
    @titleElement.find('span').html('')
    @contentElement.html('')


  hide: ->
    return if @showing
    @options = {}
    @initialized = false

    Mercury.trigger('focus:frame')
    @element.hide()
    @overlay.hide()
    @reset()

    @visible = false
