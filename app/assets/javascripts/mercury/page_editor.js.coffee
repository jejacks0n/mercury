class @Mercury.PageEditor

  # options
  # saveStyle: 'form', or 'json' (defaults to json)
  # saveDataType: 'xml', 'json', 'jsonp', 'script', 'text', 'html' (defaults to json)
  # saveMethod: 'POST', or 'PUT', create or update actions on save (defaults to PUT)
  # visible: boolean, if the interface should start visible or not (defaults to true)
  constructor: (@saveUrl = null, @options = {}) ->
    throw Mercury.I18n('Mercury.PageEditor can only be instantiated once.') if window.mercuryInstance

    @options.visible = true unless (@options.visible == false || @options.visible == 'false')
    @visible = @options.visible
    @options.saveDataType = 'json' unless (@options.saveDataType == false || @options.saveDataType)

    window.mercuryInstance = @
    @regions = []
    @initializeInterface()
    Mercury.csrfToken = token if token = jQuery(Mercury.config.csrfSelector).attr('content')


  initializeInterface: ->
    @focusableElement = jQuery('<input>', {class: 'mercury-focusable', type: 'text'}).appendTo(@options.appendTo ? 'body')

    @iframe = jQuery('<iframe>', {id: 'mercury_iframe', class: 'mercury-iframe', frameborder: '0', src: 'about:blank'})
    @iframe.appendTo(jQuery(@options.appendTo).get(0) ? 'body')

    @toolbar = new Mercury.Toolbar(jQuery.extend(true, {}, @options, @options.toolbarOptions))
    @statusbar = new Mercury.Statusbar(jQuery.extend(true, {}, @options, @options.statusbarOptions))
    @resize()

    @iframe.one 'load', => @bindEvents()
    @iframe.on 'load', => @initializeFrame()
    @loadIframeSrc(null)


  initializeFrame: ->
    try
      return if @iframe.data('loaded')
      @iframe.data('loaded', true)

      # set document reference of iframe
      @document = jQuery(@iframe.get(0).contentWindow.document)

      # inject styles for document to be able to highlight regions and other tools
      jQuery("<style mercury-styles=\"true\">").html(Mercury.config.injectedStyles).appendTo(@document.find('head'))

      # jquery: make jQuery evaluate scripts within the context of the iframe window
      iframeWindow = @iframe.get(0).contentWindow
      jQuery.globalEval = (data) -> (iframeWindow.execScript || (data) -> iframeWindow["eval"].call(iframeWindow, data))(data) if (data && /\S/.test(data))

      iframeWindow.Mercury = Mercury
      iframeWindow.History = History if window.History && History.Adapter

      # (re) initialize the editor against the new document
      @bindDocumentEvents()
      @resize()
      @initializeRegions()
      @finalizeInterface()

      # trigger ready events
      Mercury.trigger('ready')
      iframeWindow.jQuery(iframeWindow).trigger('mercury:ready') if iframeWindow.jQuery
      iframeWindow.Event.fire(iframeWindow, 'mercury:ready') if iframeWindow.Event && iframeWindow.Event.fire
      iframeWindow.onMercuryReady() if iframeWindow.onMercuryReady

      @iframe.css({visibility: 'visible'})
    catch error
      Mercury.notify('Mercury.PageEditor failed to load: %s\n\nPlease try refreshing.', error)


  initializeRegions: ->
    @regions = []
    @buildRegion(jQuery(region)) for region in jQuery("[#{Mercury.config.regions.attribute}]", @document)
    return unless @visible
    for region in @regions
      if region.focus
        region.focus()
        break


  buildRegion: (region) ->
    if region.data('region')
      region = region.data('region')
    else
      type = (region.attr(Mercury.config.regions.attribute) || Mercury.config.regions.determineType?(region) || 'unknown').titleize()
      throw Mercury.I18n('Region type is malformed, no data-type provided, or "%s" is unknown for the "%s" region.', type, region.attr('id') || 'unknown') if type == 'Unknown' || !Mercury.Regions[type]
      if !Mercury.Regions[type].supported
        Mercury.notify('Mercury.Regions.%s is unsupported in this client. Supported browsers are %s.', type, Mercury.Regions[type].supportedText)
        return false
      region = new Mercury.Regions[type](region, @iframe.get(0).contentWindow)
      region.togglePreview() if @previewing
    @regions.push(region)


  finalizeInterface: ->
    @santizerElement = jQuery('<div>', {id: 'mercury_sanitizer', contenteditable: 'true', style: 'position:fixed;width:100px;height:100px;min-width:0;top:0;left:-100px;opacity:0;overflow:hidden'})
    @santizerElement.appendTo(@options.appendTo ? @document.find('body'))

    @snippetToolbar.release() if @snippetToolbar
    @snippetToolbar = new Mercury.SnippetToolbar(@document)

    @hijackLinksAndForms()
    Mercury.trigger('mode', {mode: 'preview'}) unless @visible


  bindDocumentEvents: ->
    @document.on 'mousedown', (event) ->
      Mercury.trigger('hide:dialogs')
      if Mercury.region
        Mercury.trigger('unfocus:regions') unless jQuery(event.target).closest("[#{Mercury.config.regions.attribute}]").get(0) == Mercury.region.element.get(0)

    jQuery(@document).bind 'keydown', (event) =>
      return unless event.ctrlKey || event.metaKey
      if (event.keyCode == 83) # meta+S
        Mercury.trigger('action', {action: 'save'})
        event.preventDefault()


  bindEvents: ->
    Mercury.on 'initialize:frame', => setTimeout(@initializeFrame, 100)
    Mercury.on 'focus:frame', => @iframe.focus()
    Mercury.on 'focus:window', => setTimeout((=> @focusableElement.focus()), 10)
    Mercury.on 'toggle:interface', => @toggleInterface()
    Mercury.on 'reinitialize', => @initializeRegions()
    Mercury.on 'mode', (event, options) => @previewing = !@previewing if options.mode == 'preview'
    Mercury.on 'action', (event, options) =>
      action = Mercury.config.globalBehaviors[options.action] || @[options.action]
      return unless typeof(action) == 'function'
      event.preventDefault()
      action.call(@, options)

    jQuery(window).on 'resize', =>
      @resize()

    jQuery(window).bind 'keydown', (event) =>
      return unless event.ctrlKey || event.metaKey
      if (event.keyCode == 83) # meta+S
        Mercury.trigger('action', {action: 'save'})
        event.preventDefault()

    window.onbeforeunload = @beforeUnload


  toggleInterface: ->
    if @visible
      @visible = false
      @toolbar.hide()
      @statusbar.hide()
      Mercury.trigger('mode', {mode: 'preview'}) unless @previewing
      @previewing = true
      @resize()
    else
      @visible = true
      @iframe.animate({top: @toolbar.height(true)}, 200, 'easeInOutSine', => @resize())
      @toolbar.show()
      @statusbar.show()
      Mercury.trigger('mode', {mode: 'preview'})
      @previewing = false


  resize: ->
    width = jQuery(window).width()
    height = @statusbar.top()
    toolbarHeight = @toolbar.top() + @toolbar.height()

    Mercury.displayRect = {top: toolbarHeight, left: 0, width: width, height: height - toolbarHeight, fullHeight: height}

    @iframe.css {
      top: toolbarHeight
      left: 0
      height: height - toolbarHeight
    }

    Mercury.trigger('resize')


  iframeSrc: (url = null, params = false) ->
    # remove the /editor segment of the url if it gets passed through
    url = (url ? window.location.href).replace(Mercury.config.editorUrlRegEx ?= /([http|https]:\/\/.[^\/]*)\/editor\/?(.*)/i,  "$1/$2")
    url = url.replace(/[\?|\&]mercury_frame=true/gi, '')
    url = url.replace(/\&_=\d+/gi, '')
    if params
      # add a param allowing the server to know that the request is coming from mercury
      # and add a cache busting param so we don't get stale content
      return "#{url}#{if url.indexOf('?') > -1 then '&' else '?'}mercury_frame=true&_=#{new Date().getTime()}"
    else
      return url


  loadIframeSrc: (url)->
    # clear any existing events if we are loading a new iframe to replace the existing one
    @document.off() if @document

    @iframe.data('loaded', false)
    @iframe.get(0).contentWindow.document.location.href = @iframeSrc(url, true)


  hijackLinksAndForms: ->
    for element in jQuery('a, form', @document)
      ignored = false
      for classname in Mercury.config.nonHijackableClasses || []
        if jQuery(element).hasClass(classname)
          ignored = true
          continue
      if !ignored && (element.target == '' || element.target == '_self') && !jQuery(element).closest("[#{Mercury.config.regions.attribute}]").length
        jQuery(element).attr('target', '_parent')


  beforeUnload: ->
    if Mercury.changes && !Mercury.silent
      return Mercury.I18n('You have unsaved changes.  Are you sure you want to leave without saving them first?')
    return null


  getRegionByName: (id) ->
    for region in @regions
      return region if region.name == id
    return null


  save: (callback) ->
    url = @saveUrl ? Mercury.saveUrl ? @iframeSrc()
    data = @serialize()
    data = {content: data}

    if @options.saveMethod == 'POST'
      method = 'POST'
    else
      method = 'PUT'
      data['_method'] = method

    Mercury.log('saving', data)

    options = {
      headers: Mercury.ajaxHeaders()
      type: method
      dataType: @options.saveDataType
      data: data
      success: (response) =>
        Mercury.changes = false
        Mercury.trigger('saved', response)
        callback() if typeof(callback) == 'function'
      error: (response) =>
        Mercury.trigger('save_failed', response)
        Mercury.notify('Mercury was unable to save to the url: %s', url)
    }
    if @options.saveStyle != 'form'
      options['data'] = jQuery.toJSON(data)
      options['contentType'] = 'application/json'
    jQuery.ajax url, options


  serialize: ->
    serialized = {}
    serialized[region.name] = region.serialize() for region in @regions
    return serialized

