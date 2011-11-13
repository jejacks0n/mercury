class @Mercury.PageEditor

  # options
  # saveStyle: 'form', or 'json' (defaults to json)
  # saveDataType: 'xml', 'json', 'jsonp', 'script', 'text', 'html' (defaults to json)
  # saveMethod: 'POST', or 'PUT', create or update actions on save (defaults to POST)
  # visible: boolean, if the interface should start visible or not (defaults to true)
  constructor: (@saveUrl = null, @options = {}) ->
    throw Mercury.I18n('Mercury.PageEditor is unsupported in this client. Supported browsers are chrome 10+, firefix 4+, and safari 5+.') unless Mercury.supported
    throw Mercury.I18n('Mercury.PageEditor can only be instantiated once.') if window.mercuryInstance

    @options.visible = true unless @options.visible == false
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
    @iframe.get(0).contentWindow.document.location.href = @iframeSrc()


  initializeFrame: ->
    try
      return if @iframe.data('loaded')
      @iframe.data('loaded', true)
      Mercury.notify("Opera isn't a fully supported browser, your results may not be optimal.") if jQuery.browser.opera
      @document = jQuery(@iframe.get(0).contentWindow.document)
      stylesToInject = Mercury.config.injectedStyles.replace(/{{regionClass}}/g, Mercury.config.regionClass)
      jQuery("<style mercury-styles=\"true\">").html(stylesToInject).appendTo(@document.find('head'))

      # jquery: make jQuery evaluate scripts within the context of the iframe window
      # todo: look into `context` options for ajax as an alternative -- didn't seem to work in the initial tests
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
    @buildRegion(jQuery(region)) for region in jQuery(".#{Mercury.config.regionClass}", @document)
    return unless @options.visible
    for region in @regions
      if region.focus
        region.focus()
        break


  buildRegion: (region) ->
    try
      if region.data('region')
        region = region.data('region')
      else
        type = region.data('type').titleize()
        region = new Mercury.Regions[type](region, @iframe.get(0).contentWindow)
        region.togglePreview() if @previewing
      @regions.push(region)
    catch error
      Mercury.notify(error) if Mercury.debug
      Mercury.notify('Region type is malformed, no data-type provided, or "%s" is unknown for the "%s" region.', type, region.attr('id') || 'unknown')


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
    Mercury.on 'action', (event, options) => @save() if options.action == 'save'

    @document.on 'mousedown', (event) ->
      Mercury.trigger('hide:dialogs')
      if Mercury.region
        Mercury.trigger('unfocus:regions') unless jQuery(event.target).closest(".#{Mercury.config.regionClass}").get(0) == Mercury.region.element.get(0)

    jQuery(window).on 'resize', =>
      @resize()

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


  iframeSrc: (url = null) ->
    (url ? window.location.href).replace(/([http|https]:\/\/.[^\/]*)\/editor\/?(.*)/i, "$1/$2")


  hijackLinksAndForms: ->
    for element in jQuery('a, form', @document)
      ignored = false
      for classname in Mercury.config.nonHijackableClasses || []
        if jQuery(element).hasClass(classname)
          ignored = true
          continue
      if !ignored && (element.target == '' || element.target == '_self') && !jQuery(element).closest(".#{Mercury.config.regionClass}").length
        jQuery(element).attr('target', '_top')


  beforeUnload: ->
    if Mercury.changes && !Mercury.silent
      return Mercury.I18n('You have unsaved changes.  Are you sure you want to leave without saving them first?')
    return null


  getRegionByName: (id) ->
    for region in @regions
      return region if region.name == id
    return null


  save: (callback) ->
    url = @saveUrl ? Mercury.saveURL ? @iframeSrc()
    data = @serialize()
    Mercury.log('saving', data)
    data = jQuery.toJSON(data) unless @options.saveStyle == 'form'
    method = 'PUT' if @options.saveMethod == 'PUT'
    jQuery.ajax url, {
      headers: Mercury.ajaxHeaders()
      type: method || 'POST'
      dataType: @options.saveDataType || 'json'
      data: {content: data, _method: method}
      success: =>
        callback() if callback
        Mercury.changes = false
        Mercury.trigger('saved')
      error: =>
        Mercury.notify('Mercury was unable to save to the url: %s', url)
    }


  serialize: ->
    serialized = {}
    serialized[region.name] = region.serialize() for region in @regions
    return serialized
