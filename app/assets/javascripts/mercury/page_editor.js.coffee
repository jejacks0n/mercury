class @Mercury.PageEditor

  # options
  # saveStyle: 'form', or 'json' (defaults to json)
  # saveDataType: 'xml', 'json', 'jsonp', 'script', 'text', 'html' (defaults to json)
  # saveMethod: 'POST', or 'PUT', create or update actions on save (defaults to POST)
  # visible: boolean, if the interface should start visible or not (defaults to true)
  constructor: (@saveUrl = null, @options = {}) ->
    throw Mercury.I18n('Mercury.PageEditor can only be instantiated once.') if window.mercuryInstance

    @options.visible = true unless (@options.visible == false || @options.visible == 'no')
    @options.saveDataType = 'json' unless (@options.saveDataType == false || @options.saveDataType)
    @visible = @options.visible

    window.mercuryInstance = @
    @regions = []
    @initializeInterface()
    Mercury.csrfToken = token if token = jQuery(Mercury.config.csrfSelector).attr('content')


  initializeInterface: ->
    @focusableElement = jQuery('<input>', {class: 'mercury-focusable', type: 'text'}).appendTo(@options.appendTo ? 'body')

    @iframe = jQuery('<iframe>', {id: 'mercury_iframe', class: 'mercury-iframe', seamless: 'true', frameborder: '0', src: 'about:blank'})
    @iframe.appendTo(jQuery(@options.appendTo).get(0) ? 'body')

    @toolbar = new Mercury.Toolbar(@options)
    @statusbar = new Mercury.Statusbar(@options)
    @resize()

    @iframe.on 'load', => @initializeFrame()
    @iframe.get(0).contentWindow.document.location.href = @iframeSrc(null, true)


  initializeFrame: ->
    try
      return if @iframe.data('loaded')
      @iframe.data('loaded', true)
      Mercury.notify("Opera isn't a fully supported browser, your results may not be optimal.") if jQuery.browser.opera
      @document = jQuery(@iframe.get(0).contentWindow.document)
      stylesToInject = Mercury.config.injectedStyles.replace(/{{regionClass}}/g, Mercury.config.regions.className)
      jQuery("<style mercury-styles=\"true\">").html(stylesToInject).appendTo(@document.find('head'))

      # jquery: make jQuery evaluate scripts within the context of the iframe window
      iframeWindow = @iframe.get(0).contentWindow
      jQuery.globalEval = (data) -> (iframeWindow.execScript || (data) -> iframeWindow["eval"].call(iframeWindow, data))(data) if (data && /\S/.test(data))

      iframeWindow.Mercury = Mercury
      iframeWindow.History = History if window.History && History.Adapter

      @bindEvents()
      @resize()
      @initializeRegions()
      @finalizeInterface()
      Mercury.trigger('ready')
      jQuery(iframeWindow).trigger('mercury:ready')
      iframeWindow.Event.fire(iframeWindow, 'mercury:ready') if iframeWindow.Event && iframeWindow.Event.fire
      iframeWindow.onMercuryReady() if iframeWindow.onMercuryReady

      @iframe.css({visibility: 'visible'})
    catch error
      Mercury.notify('Mercury.PageEditor failed to load: %s\n\nPlease try refreshing.', error)


  initializeRegions: ->
    @regions = []
    @buildRegion(jQuery(region)) for region in jQuery(".#{Mercury.config.regions.className}", @document)
    return unless @options.visible
    for region in @regions
      if region.focus
        region.focus()
        break


  buildRegion: (region) ->
    if region.data('region')
      region = region.data('region')
    else
      type = (
        region.data('type') ||
        ( jQuery.type(Mercury.config.regions.determineType) == 'function' && Mercury.config.regions.determineType(region) ) ||
        'unknown'
      ).titleize()
      throw Mercury.I18n('Region type is malformed, no data-type provided, or "%s" is unknown for the "%s" region.', type, region.attr('id') || 'unknown') if type == 'Unknown' || !Mercury.Regions[type]
      if !Mercury.Regions[type].supported
        Mercury.notify('Mercury.Regions.%s is unsupported in this client. Supported browsers are %s.', type, Mercury.Regions[type].supportedText)
        return false
      region = new Mercury.Regions[type](region, @iframe.get(0).contentWindow)
      region.togglePreview() if @previewing
    @regions.push(region)


  finalizeInterface: ->
    @santizerElement = jQuery('<div>', {id: 'mercury_sanitizer', contenteditable: 'true', style: 'position:fixed;width:100px;height:100px;top:0;left:-100px;opacity:0;overflow:hidden'})
    @santizerElement.appendTo(@options.appendTo ? @document.find('body'))

    @snippetToolbar = new Mercury.SnippetToolbar(@document)

    @hijackLinksAndForms()
    Mercury.trigger('mode', {mode: 'preview'}) unless @options.visible


  bindEvents: ->
    Mercury.on 'initialize:frame', => setTimeout(100, @initializeFrame)
    Mercury.on 'focus:frame', => @iframe.focus()
    Mercury.on 'focus:window', => setTimeout(10, => @focusableElement.focus())
    Mercury.on 'toggle:interface', => @toggleInterface()
    Mercury.on 'reinitialize', => @initializeRegions()
    Mercury.on 'mode', (event, options) => @previewing = !@previewing if options.mode == 'preview'
    Mercury.on 'action', (event, options) =>
      action = Mercury.config.globalBehaviors[options.action] || @[options.action]
      return unless typeof(action) == 'function'
      options.already_handled = true
      action.call(@, options)

    @document.on 'mousedown', (event) ->
      Mercury.trigger('hide:dialogs')
      if Mercury.region
        Mercury.trigger('unfocus:regions') unless jQuery(event.target).closest(".#{Mercury.config.regions.className}").get(0) == Mercury.region.element.get(0)

    jQuery(window).on 'resize', =>
      @resize()

    jQuery(@document).bind 'keydown', (event) =>
      return unless event.ctrlKey || event.metaKey
      if (event.keyCode == 83) # meta+S
        Mercury.trigger('action', {action: 'save'})
        event.preventDefault()

    jQuery(window).bind 'keydown', (event) =>
      return unless event.ctrlKey || event.metaKey
      if (event.keyCode == 83) # meta+S
        Mercury.trigger('action', {action: 'save'})
        event.preventDefault()

    window.onbeforeunload = @beforeUnload


  toggleInterface: ->
    if @visible
      Mercury.trigger('mode', {mode: 'preview'}) if @previewing
      @visible = false
      @toolbar.hide()
      @statusbar.hide()
    else
      @visible = true
      @toolbar.show()
      @statusbar.show()
    Mercury.trigger('mode', {mode: 'preview'})
    @resize()


  resize: ->
    width = jQuery(window).width()
    height = @statusbar.top()
    toolbarHeight = @toolbar.height()

    Mercury.displayRect = {top: toolbarHeight, left: 0, width: width, height: height - toolbarHeight, fullHeight: height}

    @iframe.css {
      top: toolbarHeight
      left: 0
      height: height - toolbarHeight
    }

    Mercury.trigger('resize')


  iframeSrc: (url = null, params = false) ->
    url = (url ? window.location.href).replace(Mercury.config.editorUrlRegEx ?= /([http|https]:\/\/.[^\/]*)\/editor\/?(.*)/i,  "$1/$2")
    url = url.replace(/[\?|\&]mercury_frame=true/gi, '')
    if params
      return "#{url}#{if url.indexOf('?') > -1 then '&' else '?'}mercury_frame=true"
    else
      return url


  hijackLinksAndForms: ->
    for element in jQuery('a, form', @document)
      ignored = false
      for classname in Mercury.config.nonHijackableClasses || []
        if jQuery(element).hasClass(classname)
          ignored = true
          continue
      if !ignored && (element.target == '' || element.target == '_self') && !jQuery(element).closest(".#{Mercury.config.regions.className}").length
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
    Mercury.log('saving', data)
    data = jQuery.toJSON(data) unless @options.saveStyle == 'form'
    method = 'PUT' if @options.saveMethod == 'PUT'
    jQuery.ajax url, {
      headers: Mercury.ajaxHeaders()
      type: method || 'POST'
      dataType: @options.saveDataType,
      data: {content: data, _method: method}
      success: =>
        Mercury.changes = false
        Mercury.trigger('saved')
        callback() if typeof(callback) == 'function'
      error: (response) =>
        Mercury.trigger('save_failed', response)
        Mercury.notify('Mercury was unable to save to the url: %s', url)
    }


  serialize: ->
    serialized = {}
    serialized[region.name] = region.serialize() for region in @regions
    return serialized
