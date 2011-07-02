class @Mercury.Statusbar

  constructor: (@options = {}) ->
    @build()
    @bindEvents()


  build: ->
    @element = jQuery('<div>', {class: 'mercury-statusbar'}).appendTo(jQuery(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    Mercury.bind 'region:update', (event, options) =>
      @setPath(options.region.path()) if options.region && jQuery.type(options.region.path) == 'function'


  height: ->
    return @element.outerHeight()


  top: ->
    return @element.offset().top


  setPath: (elements) ->
    path = []
    path.push("<a>#{element.tagName.toLowerCase()}</a>") for element in elements

    @element.html("<span><strong>Path: </strong></span>#{path.reverse().join(' &raquo; ')}")
