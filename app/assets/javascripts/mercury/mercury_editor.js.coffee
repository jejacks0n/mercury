# Mercury Editor is a Rails and Coffeescript based WYSIWYG editor.  Mercury
# Editor utilizes the HTML 5 ContentEditable HTML 5 spec to allow editing
# sections of a given page (instead of using iframes) and provides an editing
# experience that's as realistic as possible.  By not using iframes for the
# editable regions it allows CSS to behave naturally.
#
# Mercury Editor was written for the future, and doesn't attempt to support
# legacy implementations of document editing.
#
# Currently supported browsers are
#   - Firefox 4+
#   - Chrome 10+
#   - Safari 5+#= require_self
#
#= require_self
#= require ./utility
#= require ./history_buffer
#= require ./table_editor
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
#= require ./snippet
#= require ./snippet_toolbar
#= require ./region
#= require ./uploader
#= require_tree ./regions
#= require_tree ./dialogs
#= require_tree ./modals
#= require ./config

class MercuryEditor

  constructor: (@options = {}) ->
    throw "MercuryEditor is unsupported in this client. Supported browsers are chrome 10+, firefix 4+, and safari 5+." unless Mercury.supported
    throw "MercuryEditor can only be instantiated once" if window.mercuryInstance

    window.mercuryInstance = @
    @saveUrl = @options.saveUrl
    @regions = []
    @initializeInterface()
    Mercury.csrfToken = token if token = $('meta[name="csrf-token"]').attr('content')


  initializeInterface: ->
    @focusableElement = $('<input>', {type: 'text', style: 'position:absolute;opacity:0'}).appendTo('body')
    @iframe = $('<iframe>', {class: 'mercury-iframe', seamless: 'true', frameborder: '0', src: 'about:blank', style: 'position:absolute;top:0;width:100%;visibility:hidden'})
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
      @initializeRegions()
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
      @regions.push(new Mercury.Regions[type](region, @iframe.get(0).contentWindow))
    catch error
      alert(error) if Mercury.debug
      alert("Region type is malformed, no data-type provided, or \"#{type}\" is unknown.")


  finalizeInterface: ->
    @snippetToolbar = new Mercury.SnippetToolbar(@document)

    Mercury.hijackLinks(@document)
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


  iframeSrc: ->
    window.location.href.replace(/([http|https]:\/\/.[^\/]*)\/edit\/?(.*)/i, "$1/$2")


  save: ->
    url = @saveUrl ? @iframeSrc()
    data = @serialize()
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



# Mercury static properties and utlity methods
Mercury =
  Regions: {}
  modalHandlers: {}
  dialogHandlers: {}

  version: 1.0

  # No IE because it doesn't follow the w3c standards for designMode
  # TODO: using client detection, but should use feature detection
  supported: document.getElementById && document.designMode && !$.browser.konqueror && !$.browser.msie

  silent: true

  debug: false


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


  trigger: (eventName, options) ->
    Mercury.log(eventName, options)
    $(document).trigger("mercury:#{eventName}", options)


  log: ->
    if Mercury.debug && console
      try console.debug(arguments) catch e
