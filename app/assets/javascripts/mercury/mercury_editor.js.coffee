#= require_self
#= require ./utility
#= require ./history_buffer
#= require ./table
#= require ./dialog
#= require ./palette
#= require ./select
#= require ./panel
#= require ./modal
#= require ./statusbar
#= require ./toolbar
#= require ./toolbar.button
#= require ./toolbar.button_group
#= require ./toolbar.expander
#= require_tree ./regions
#= require_tree ./dialogs
#= require_tree ./modals
#= require ./config

class MercuryEditor

  constructor: (@options = {}) ->
    throw "MercuryEditor is unsupported in this client. Supported browsers are chrome 10+, firefix 4+, and safari 5+." unless Mercury.supported

    @regions = []
    @initializeInterface()


  initializeInterface: ->
    @focusableElement = $('<input>', {type: 'text', style: 'position:absolute;opacity:0'}).appendTo('body')
    @iframe = $('<iframe>', {class: 'mercury-iframe', seamless: 'true', frameborder: '0', src: 'about:blank'})
    @iframe.load => @initializeFrame()
    @iframe.attr('src', @iframeSrc())
    @iframe.appendTo('body')

    @toolbar = new Mercury.Toolbar(@options)
    @statusbar = new Mercury.Statusbar(@options)


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
      alert("MercuryEditor failed to load: #{error}\n\nPlease try refreshing.")


  initializeRegions: ->
    @buildRegion($(region)) for region in $('.mercury-region', @document)
    for region in @regions
      if region.focus
        region.focus()
        break


  buildRegion: (region) ->
    try
      type = region.data('type').titleize()
      @regions.push(new Mercury.Regions[type](region, {window: @iframe.get(0).contentWindow}))
    catch error
      alert(error) if Mercury.debug
      alert("Region type is malformed, no data-type provided, or \"#{type}\" is unknown.")


  finalizeInterface: ->
    Mercury.editor = @
    Mercury.hijackLinks(@document)
    @resize()


  bindEvents: ->
    Mercury.bind 'initialize:frame', => setTimeout(@initializeFrame, 100)
    Mercury.bind 'focus:frame', => @iframe.focus()
    Mercury.bind 'focus:window', => setTimeout((=> @focusableElement.focus()), 10)

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


  iframeSrc: ->
    window.location.href.replace(/([http|https]:\/\/.[^\/]*)\/edit\/?(.*)/i, "$1/$2")



# Mercury static properties and utlity methods
Mercury =
  Regions: {}

  version: 1.0

  # No IE because it doesn't follow the w3c standards for designMode
  # TODO: using client detection, but should use feature detection
  supported: document.getElementById && document.designMode && !$.browser.konqueror && !$.browser.msie

  silent: false

  debug: true


  beforeUnload: ->
    if Mercury.changes && !Mercury.silent
     return "You have unsaved changes.  Are you sure you want to leave without saving them first?"


  hijackLinks: (document) ->
    for link in $('a', document)
      if (link.target == '' || link.target == '_self') and !$(link).closest('.mercury-region').length
        $(link).attr('target', '_top')


  refresh: ->
    Mercury.trigger('refresh')


  bind: (eventName, callback) ->
    $(document).bind("mercury:#{eventName}", callback)


  trigger: (eventName, arguments...) ->
    Mercury.log(eventName, arguments)
    $(document).trigger("mercury:#{eventName}", arguments)


  log: ->
    if Mercury.debug && console
      try console.debug(arguments) catch e
