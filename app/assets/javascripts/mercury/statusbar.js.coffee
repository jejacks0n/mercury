class @Mercury.Statusbar

  constructor: (@options = {}) ->
    @build()
    @bindEvents()


  build: ->
    @element = $('<div>', {class: 'mercury-statusbar'}).appendTo($(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    Mercury.bind 'region:update', (event, options) =>
      @setPath(options.region.path()) if options.region && $.type(options.region.path) == 'function'


  height: ->
    @element.outerHeight()


  setPath: (elements) ->
    path = []
    path.push("<a>#{element.tagName.toLowerCase()}</a>") for element in elements

    @element.html("<span><strong>Path: </strong></span>#{path.reverse().join(' &raquo; ')}")
