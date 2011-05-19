class Carmenta.Toolbar.ButtonGroup

  constructor: (@name, @options = {}) ->
    @build()
    @bindEvents()
    return @element


  build: ->
    @element = $('<div>', {class: "carmenta-button-group carmenta-#{@name}-group"})
    if @options._context
      @element.addClass('disabled')


  bindEvents: ->
    Carmenta.bind 'region:update', (event, options) =>
      context = Carmenta.Toolbar.ButtonGroup.contexts[@name]
      if context
        if options.region && $.type(options.region.currentElement) == 'function'
          if context.call(@, options.region.currentElement(), options.region.element)
            @element.removeClass('disabled')
          else
            @element.addClass('disabled')



# ButtonGroup contexts
Carmenta.Toolbar.ButtonGroup.contexts =

  table: (node, region) -> !!node.closest('table', region).length
