class Mercury.Toolbar.ButtonGroup

  constructor: (@name, @options = {}) ->
    @build()
    @bindEvents()
    return @element


  build: ->
    @element = $('<div>', {class: "mercury-button-group mercury-#{@name}-group"})
    if @options._context
      @element.addClass('disabled')


  bindEvents: ->
    Mercury.bind 'region:update', (event, options) =>
      context = Mercury.Toolbar.ButtonGroup.contexts[@name]
      if context
        if options.region && $.type(options.region.currentElement) == 'function'
          element = options.region.currentElement()
          if element.length && context.call(@, element, options.region.element)
            @element.removeClass('disabled')
          else
            @element.addClass('disabled')



# ButtonGroup contexts
Mercury.Toolbar.ButtonGroup.contexts =

  table: (node, region) -> !!node.closest('table', region).length
