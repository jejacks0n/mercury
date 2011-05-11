#= require_self
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
#= require_tree ./regions
#= require ./config

String::titleize = -> @[0].toUpperCase() + @slice(1)
String::toHex = ->
  # todo: we should handle rgba as well
  return @ if @[0] == '#'
  @replace /rgb\((\d+)[\s|\,]?\s(\d+)[\s|\,]?\s(\d+)\)/gi, (a, r, g, b) ->
    "##{parseInt(r).toHex()}#{parseInt(g).toHex()}#{parseInt(b).toHex()}"
Number::toHex = ->
  result = @toString(16).toUpperCase()
  return if result[1] then result else "0#{result}"

class CarmentaEditor

  constructor: (@options = {}) ->
    throw "CarmentaEditor is unsupported in this client. Supported browsers are chrome 10+, firefix 4+, and safari 5+." unless Carmenta.supported
    @initializeInterface()


  initializeInterface: ->
    @iframe = $('<iframe>', {class: 'carmenta-iframe', seamless: 'true', frameborder: '0', src: 'about:blank'})
    @iframe.load => @initializeFrame()
    @iframe.attr('src', @iframeSrc())
    @iframe.appendTo('body')

    @bindEvents()

    @toolbar = new Carmenta.Toolbar(@options)
    @statusbar = new Carmenta.Statusbar(@options)


  initializeFrame: ->
    try
      return if @iframe.data('loaded')
      @iframe.data('loaded', true)
      @document = @iframe.get(0).contentWindow.document

      @regions = @initializeRegions()
      @finalizeInterface()

      @iframe.css({visibility: 'visible'})
    catch error
      alert("CarmentaEditor failed to load: #{error}\n\nPlease try refreshing.")


  initializeRegions: ->
    @buildRegion($(region)) for region in $('.carmenta-region', @document)


  buildRegion: (region) ->
#    try
      type = region.data('type').titleize()
      new Carmenta.Regions[type](region, {window: @iframe.get(0).contentWindow})
#    catch error
#      alert(error)
#      alert("Region type is malformed, no data-type provided, or \"#{type}\" is unknown.")


  finalizeInterface: ->
    Carmenta.hijackLinks(@document)
    @resize()


  bindEvents: ->
    Carmenta.bind('initialize:frame', => setTimeout(@initializeFrame, 200))

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
    $(document).trigger("carmenta:#{eventName}", arguments)
    Carmenta.log(eventName, arguments)


  log: ->
    if Carmenta.debug && console
      try console.debug(arguments) catch e


  preventer: (event) ->
    event.preventDefault()
