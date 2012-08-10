@Mercury.modal = (url, options = {}) ->
  instance = new Mercury.Modal(url, options)
  instance.show()
  return instance


class @Mercury.Modal

  constructor: (@url, @options = {}) ->


  show: (url = null, options = null) ->
    @url = url || @url
    @options = options || @options
    @options.minWidth ||= 400
    @options.ujsHandling = true unless @options.ujsHandling == false

    Mercury.trigger('focus:window')
    @initializeModal()
    if @visible then @update() else @appear()
    if @options.content
      setTimeout((=> @loadContent(@options.content)), 500)


  initializeModal: ->
    return if @initialized
    @build()
    @bindEvents()
    @initialized = true


  build: ->
    @element = jQuery('<div>', {class: 'mercury-modal loading'})
    @element.html('<h1 class="mercury-modal-title"><span></span><a>&times;</a></h1>')
    @element.append('<div class="mercury-modal-content-container"><div class="mercury-modal-content"></div></div>')

    @overlay = jQuery('<div>', {class: 'mercury-modal-overlay'})

    @titleElement = @element.find('.mercury-modal-title')
    @contentContainerElement = @element.find('.mercury-modal-content-container')

    @contentElement = @element.find('.mercury-modal-content')

    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')
    @overlay.appendTo(jQuery(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    Mercury.on 'refresh', => @resize(true)
    Mercury.on 'resize', => @position()

    @overlay.on 'click', =>
      @hide() if @options.allowHideUsingOverlay

    @titleElement.find('a').on 'click', =>
      @hide()

    if @options.ujsHandling
      @element.on 'ajax:beforeSend', (event, xhr, options) =>
        options.success = (content) =>
          @loadContent(content)

    jQuery(document).on 'keydown', (event) =>
      @hide() if event.keyCode == 27 && @visible


  appear: ->
    @showing = true
    @position()

    @overlay.show()
    @overlay.animate {opacity: 1}, 200, 'easeInOutSine', =>
      @element.css({top: -@element.height()})
      @setTitle()
      @element.show()
      @element.animate {top: 0}, 200, 'easeInOutSine', =>
        @visible = true
        @showing = false
        @load()


  resize: (keepVisible) ->
    visibility = if keepVisible then 'visible' else 'hidden'

    titleHeight = @titleElement.outerHeight()

    width = @contentElement.outerWidth()

    @contentPane.css({height: 'auto'}) if @contentPane
    @contentElement.css({height: 'auto', visibility: visibility, display: 'block'})

    height = @contentElement.outerHeight() + titleHeight

    width = @options.minWidth if width < @options.minWidth
    height = Mercury.displayRect.fullHeight if height > Mercury.displayRect.fullHeight || @options.fullHeight

    @element.stop().animate {left: (Mercury.displayRect.width - width) / 2, width: width, height: height}, 200, 'easeInOutSine', =>
      @contentElement.css({visibility: 'visible', display: 'block'})
      if @contentPane.length
        @contentElement.css({height: height - titleHeight, overflow: 'visible'})
        controlHeight = if @contentControl.length then @contentControl.outerHeight() + 10 else 0
        @contentPane.css({height: height - titleHeight - controlHeight - 20})
        @contentPane.find('.mercury-display-pane').css({width: width - 20})
      else
        @contentElement.css({height: height - titleHeight, overflow: 'auto'})


  position: ->
    viewportWidth = Mercury.displayRect.width

    @contentPane.css({height: 'auto'}) if @contentPane
    @contentElement.css({height: 'auto'})
    @element.css({width: 'auto', height: 'auto', display: 'block', visibility: 'hidden'})

    width = @element.width()
    height = @element.height()

    width = @options.minWidth if width < @options.minWidth
    height = Mercury.displayRect.fullHeight if height > Mercury.displayRect.fullHeight || @options.fullHeight

    titleHeight = @titleElement.outerHeight()
    if @contentPane && @contentPane.length
      @contentElement.css({height: height - titleHeight, overflow: 'visible'})
      controlHeight = if @contentControl.length then @contentControl.outerHeight() + 10 else 0
      @contentPane.css({height: height - titleHeight - controlHeight - 20})
      @contentPane.find('.mercury-display-pane').css({width: width - 20})
    else
      @contentElement.css({height: height - titleHeight, overflow: 'auto'})

    @element.css {
      left: (viewportWidth - width) / 2
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
      setTimeout((=> @loadContent(Mercury.preloadedViews[@url])), 10)
    else
      jQuery.ajax @url, {
        headers: Mercury.ajaxHeaders()
        type: @options.loadType || 'GET'
        data: @options.loadData
        success: (data) => @loadContent(data)
        error: =>
          @hide()
          Mercury.notify("Mercury was unable to load %s for the modal.", @url)
      }


  loadContent: (data, options = null) ->
    @initializeModal()
    @options = options || @options
    @setTitle()
    @loaded = true
    @element.removeClass('loading')
    @contentElement.html(data)
    @contentElement.css({display: 'none', visibility: 'hidden'})

    # for complex modal content, we provide panes and controls
    @contentPane = @element.find('.mercury-display-pane-container')
    @contentControl = @element.find('.mercury-display-controls')

    @options.afterLoad.call(@) if @options.afterLoad
    if @options.handler
      if typeof(@options.handler) == 'function'
        @options.handler.call(@)
      else if Mercury.modalHandlers[@options.handler]
        if typeof(Mercury.modalHandlers[@options.handler]) == 'function'
          Mercury.modalHandlers[@options.handler].call(@)
        else
          jQuery.extend(@, Mercury.modalHandlers[@options.handler])
          @initialize()
      else if Mercury.lightviewHandlers[@options.handler]
        if typeof(Mercury.lightviewHandlers[@options.handler]) == 'function'
          Mercury.lightviewHandlers[@options.handler].call(@)
        else
          jQuery.extend(@, Mercury.lightviewHandlers[@options.handler])
          @initialize()

    @element.localize(Mercury.locale()) if Mercury.config.localization.enabled
    @element.find('.modal-close').on('click', @hide)
    @resize()


  setTitle: ->
    @titleElement.find('span').html(Mercury.I18n(@options.title))
    closeButton = @titleElement.find('a')
    if @options.closeButton == false then closeButton.hide() else closeButton.show()


  serializeForm: ->
    return @element.find('form').serializeObject() || {}


  reset: ->
    @titleElement.find('span').html('')
    @contentElement.html('')


  hide: =>
    return if @showing
    @options = {}

    Mercury.trigger('focus:frame')
    @element.hide()
    @overlay.hide()
    @reset()

    @visible = false
