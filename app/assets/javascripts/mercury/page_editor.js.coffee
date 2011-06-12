class Mercury.PageEditor

  constructor: (@saveUrl = null, @options = {}) ->
    throw "Mercury.PageEditor is unsupported in this client. Supported browsers are chrome 10+, firefix 4+, and safari 5+." unless Mercury.supported
    throw "Mercury.PageEditor can only be instantiated once." if window.mercuryInstance

    window.mercuryInstance = @
    @regions = []
    @initializeInterface()
    Mercury.csrfToken = token if token = $('meta[name="csrf-token"]').attr('content')


  initializeInterface: ->
    @focusableElement = $('<input>', {type: 'text', style: 'position:absolute;opacity:0'}).appendTo(@options.appendTo ? 'body')
    @iframe = $('<iframe>', {class: 'mercury-iframe', seamless: 'true', frameborder: '0', src: 'about:blank', style: 'position:absolute;top:0;width:100%;visibility:hidden'})
    @iframe.load => @initializeFrame()
    @iframe.attr('src', @iframeSrc())
    @iframe.appendTo($(@options.appendTo).get(0) ? 'body')

    @toolbar = new Mercury.Toolbar(@options)
    @statusbar = new Mercury.Statusbar(@options)


  initializeFrame: ->
    try
      return if @iframe.data('loaded')
      @iframe.data('loaded', true)
      @document = $(@iframe.get(0).contentWindow.document)
      $("<style mercury-styles=\"true\">").html(Mercury.config.injectedStyles).appendTo(@document.find('head'))

      @bindEvents()
      @initializeRegions()
      @finalizeInterface()

      @iframe.css({visibility: 'visible'})
    catch error
      alert("Mercury.PageEditor failed to load: #{error}\n\nPlease try refreshing.")


  initializeRegions: ->
    @buildRegion($(region)) for region in $('.mercury-region', @document)
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

    @hijackLinks()
    @resize()


  bindEvents: ->
    Mercury.bind 'initialize:frame', => setTimeout(@initializeFrame, 100)
    Mercury.bind 'focus:frame', => @iframe.focus()
    Mercury.bind 'focus:window', => setTimeout((=> @focusableElement.focus()), 10)

    Mercury.bind 'action', (event, options) =>
      @save() if options.action == 'save'

    @document.mousedown (event) ->
      Mercury.trigger('hide:dialogs')
      Mercury.trigger('unfocus:regions') unless $(event.target).closest('.mercury-region').get(0) == Mercury.region.element.get(0)

    $(window).resize => @resize()
    window.onbeforeunload = Mercury.beforeUnload


  resize: ->
    width = $(window).width()
    height = $(window).height()
    toolbarHeight = @toolbar.height()
    statusbarHeight = @statusbar.height()

    Mercury.displayRect = {top: toolbarHeight, left: 0, width: width, height: height - statusbarHeight - toolbarHeight}

    @iframe.css {
      top: toolbarHeight,
      width: width,
      height: height - statusbarHeight - toolbarHeight
    }

    Mercury.trigger('resize')


  iframeSrc: (url = null) ->
    (url ? window.location.href).replace(/([http|https]:\/\/.[^\/]*)\/edit\/?(.*)/i, "$1/$2")


  hijackLinks: ->
    for link in $('a', @document)
      ignored = false
      for classname in Mercury.config.ignoredLinks
        if $(link).hasClass(classname)
          ignored = true
          continue
      if !ignored && (link.target == '' || link.target == '_self') && !$(link).closest('.mercury-region').length
        $(link).attr('target', '_top')


  save: ->
    url = @saveUrl ? @iframeSrc()
    data = @serialize()
    Mercury.log('saving', data)
    data = $.toJSON(data) if Mercury.config.saveStyle == 'json'
    $.ajax url, {
      type: 'POST'
      data: {content: data}
      success: =>
        Mercury.changes = false
      error: =>
        alert("Mercury was unable to save to the url: #{url}")
    }


  serialize: ->
    serialized = {}
    serialized[region.name] = region.serialize() for region in @regions
    return serialized
