#= require_self
#= require ./utility
#= require ./history_buffer
#= require ./dialog
#= require ./statusbar
#= require ./palette
#= require ./select
#= require ./panel
#= require ./modal
#= require ./toolbar
#= require ./toolbar.button
#= require ./toolbar.button_group
#= require ./toolbar.expander
#= require ./regions/editable
#= require ./regions/snippet
#= require ./config

class CarmentaEditor

  constructor: (@options = {}) ->
    throw "CarmentaEditor is unsupported in this client. Supported browsers are chrome 10+, firefix 4+, and safari 5+." unless Carmenta.supported
    @initializeInterface()


  initializeInterface: ->
    @focusableElement = $('<input>', {type: 'text', style: 'position:absolute'}).appendTo('body')
    @iframe = $('<iframe>', {class: 'carmenta-iframe', seamless: 'true', frameborder: '0', src: 'about:blank'})
    @iframe.load => @initializeFrame()
    @iframe.attr('src', @iframeSrc())
    @iframe.appendTo('body')

    @toolbar = new Carmenta.Toolbar(@options)
    @statusbar = new Carmenta.Statusbar(@options)


  initializeFrame: ->
    try
      return if @iframe.data('loaded')
      @iframe.data('loaded', true)
      @document = $(@iframe.get(0).contentWindow.document)

      @bindEvents()
      @regions = @initializeRegions()
      @finalizeInterface()

      @iframe.css({visibility: 'visible'})
    catch error
      alert("CarmentaEditor failed to load: #{error}\n\nPlease try refreshing.")


  initializeRegions: ->
    @buildRegion($(region)) for region in $('.carmenta-region', @document)


  buildRegion: (region) ->
    try
      type = region.data('type').titleize()
      new Carmenta.Regions[type](region, {window: @iframe.get(0).contentWindow})
    catch error
      alert(error)
      alert("Region type is malformed, no data-type provided, or \"#{type}\" is unknown.")


  finalizeInterface: ->
    Carmenta.hijackLinks(@document)
    @resize()


  bindEvents: ->
    Carmenta.bind 'initialize:frame', => setTimeout(@initializeFrame, 100)
    Carmenta.bind 'focus:frame', => @iframe.focus()
    Carmenta.bind 'focus:window', => setTimeout((=> @focusableElement.focus()), 10)

    @document.mousedown -> Carmenta.trigger('hide:dialogs')

    $(window).resize => @resize()
    window.onbeforeunload = Carmenta.beforeUnload


  resize: ->
    width = $(window).width()
    height = $(window).height()
    toolbarHeight = @toolbar.height()
    statusbarHeight = @statusbar.height()

    Carmenta.displayRect = {top: toolbarHeight, left: 0, width: width, height: height - statusbarHeight - toolbarHeight}

    @iframe.css {
      top: toolbarHeight,
      width: width,
      height: height - statusbarHeight - toolbarHeight
    }

    Carmenta.trigger('resize')


  iframeSrc: ->
    window.location.href.replace(/([http|https]:\/\/.[^\/]*)\/edit\/?(.*)/i, "$1/$2")



# Carmenta static properties and utlity methods
Carmenta =
  Regions: {}

  version: 1.0
  # No IE because it doesn't follow the w3c standards for designMode
  # TODO: using client detection, but should use feature detection
  supported: document.getElementById && document.designMode && !$.browser.konqueror && !$.browser.msie
  silent: false
  debug: true


  beforeUnload: ->
    if Carmenta.changes && !Carmenta.silent
     return "You have unsaved changes.  Are you sure you want to leave without saving them first?"


  hijackLinks: (document) ->
    for link in $('a', document)
      if (link.target == '' || link.target == '_self') and !$(link).closest('.carmenta-region').length
        $(link).attr('target', '_top')


  refresh: ->
    Carmenta.trigger('refresh')


  bind: (eventName, callback) ->
    $(document).bind("carmenta:#{eventName}", callback)


  trigger: (eventName, arguments...) ->
    Carmenta.log(eventName, arguments)
    $(document).trigger("carmenta:#{eventName}", arguments)


  log: ->
    if Carmenta.debug && console
      try console.debug(arguments) catch e
