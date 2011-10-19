class @Mercury.PageEditor

  # options
  # saveStyle: 'form', or 'json' (defaults to json)
  # saveMethod: 'POST', or 'PUT', create or update actions on save (defaults to POST)
  # visible: boolean, if the interface should start visible or not (defaults to true)
  constructor: (@saveUrl = null, @options = {}) ->
    throw "Mercury.PageEditor is unsupported in this client. Supported browsers are chrome 10+, firefix 4+, and safari 5+." unless Mercury.supported
    throw "Mercury.PageEditor can only be instantiated once." if window.mercuryInstance

    @options.visible = true unless @options.visible == false
    @visible = @options.visible

    window.mercuryInstance = @
    @regions = []
    @initializeInterface()
    Mercury.csrfToken = token if token = jQuery(Mercury.config.csrfSelector).attr('content')


  initializeInterface: ->
    @focusableElement = jQuery('<input>', {type: 'text', style: 'position:absolute;opacity:0'}).appendTo(@options.appendTo ? 'body')
    @iframe = jQuery('<iframe>', {id: 'mercury_iframe', class: 'mercury-iframe', seamless: 'true', frameborder: '0', src: 'about:blank'})
    @iframe.appendTo(jQuery(@options.appendTo).get(0) ? 'body')

    @iframe.load => @initializeFrame()
    @iframe.get(0).contentWindow.document.location.href = @iframeSrc()

    @toolbar = new Mercury.Toolbar(@options)
    @statusbar = new Mercury.Statusbar(@options)


  initializeFrame: ->
    try
      return if @iframe.data('loaded')
      @iframe.data('loaded', true)
      alert("Opera isn't a fully supported browser, your results may not be optimal.") if jQuery.browser.opera
      @document = jQuery(@iframe.get(0).contentWindow.document)
      jQuery("<style mercury-styles=\"true\">").html(Mercury.config.injectedStyles).appendTo(@document.find('head'))

      # jquery: make jQuery evaluate scripts within the context of the iframe window -- note that this means that we
      # can't use eval in mercury (eg. script tags in ajax responses) because it will eval in the wrong context (you can
      # use top.Mercury though, if you keep it in mind)
      # todo: look into `context` options for ajax as an alternative
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
      alert("Mercury.PageEditor failed to load: #{error}\n\nPlease try refreshing.")


  initializeRegions: ->
    @buildRegion(jQuery(region)) for region in jQuery('.mercury-region', @document)
    return unless @options.visible
    for region in @regions
      if region.focus
        region.focus()
        break


  buildRegion: (region) ->
    try
      type = region.data('type').titleize()
      @regions.push(new Mercury.Regions[type](region, @iframe.get(0).contentWindow))
    catch error
      alert(error) if Mercury.debug
      alert("Region type is malformed, no data-type provided, or \"#{type}\" is unknown.")


  finalizeInterface: ->
    @snippetToolbar = new Mercury.SnippetToolbar(@document)
    jQuery('<div>', { id: 'mercury-sanitizer', contenteditable: 'true', style: 'position:absolute;top:-1000px;left:-1000px;opacity:0;' }).appendTo(@document.find('body'))

    @hijackLinksAndForms()
    Mercury.trigger('mode', {mode: 'preview'}) unless @options.visible


  bindEvents: ->
    Mercury.bind 'initialize:frame', => setTimeout(@initializeFrame, 1000)
    Mercury.bind 'focus:frame', => @iframe.focus()
    Mercury.bind 'focus:window', => setTimeout((=> @focusableElement.focus()), 10)

    Mercury.bind 'toggle:interface', => @toggleInterface()

    Mercury.bind 'action', (event, options) =>
       @save() if options.action == 'save'

    @document.mousedown (event) ->
      Mercury.trigger('hide:dialogs')
      if Mercury.region
        Mercury.trigger('unfocus:regions') unless jQuery(event.target).closest('.mercury-region').get(0) == Mercury.region.element.get(0)

    jQuery(window).resize => @resize()
    window.onbeforeunload = @beforeUnload


  toggleInterface: ->
    if @visible
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
      if !ignored && (element.target == '' || element.target == '_self') && !jQuery(element).closest('.mercury-region').length
        jQuery(element).attr('target', '_top')


  beforeUnload: ->
    if Mercury.changes && !Mercury.silent
      return "You have unsaved changes.  Are you sure you want to leave without saving them first?"
    return null


  getRegionByName: (id) ->
    for region in @regions
      return region if region.name == id
    return null


  save: ->
    url = @saveUrl ? Mercury.saveURL ? @iframeSrc()
    data = @serialize()
    Mercury.log('saving', data)
    data = jQuery.toJSON(data) unless @options.saveStyle == 'form'
    method = 'PUT' if @options.saveMethod == 'PUT'
    jQuery.ajax url, {
      type: method || 'POST'
      dataType: 'json'
      headers: @saveHeaders()
      data: {content: data, _method: method}
      success: =>
        Mercury.changes = false
      error: =>
        alert("Mercury was unable to save to the url: #{url}")
    }


  saveHeaders: ->
    headers = {}
    headers[Mercury.config.csrfHeader] = Mercury.csrfToken
    return headers


  serialize: ->
    serialized = {}
    serialized[region.name] = region.serialize() for region in @regions
    return serialized
