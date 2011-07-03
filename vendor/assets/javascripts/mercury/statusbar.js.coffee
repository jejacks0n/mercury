class @Mercury.Statusbar

  constructor: (@options = {}) ->
    @visible = @options.visible
    @build()
    @bindEvents()


  build: ->
    @element = jQuery('<div>', {class: 'mercury-statusbar'})
    @element.css({visibility: 'hidden', height: 0}) unless @visible
    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    Mercury.bind 'region:update', (event, options) =>
      @setPath(options.region.path()) if options.region && jQuery.type(options.region.path) == 'function'


  height: ->
    @element.outerHeight()


  top: ->
    if @visible then @element.offset().top else @element.offset().top + @element.outerHeight()


  setPath: (elements) ->
    path = []
    path.push("<a>#{element.tagName.toLowerCase()}</a>") for element in elements

    @element.html("<span><strong>Path: </strong></span>#{path.reverse().join(' &raquo; ')}")
