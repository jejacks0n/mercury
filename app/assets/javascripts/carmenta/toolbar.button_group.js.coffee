class Carmenta.Toolbar.ButtonGroup

  constructor: (@name, @options) ->
    @build()
    return @element


  build: ->
    @element = $('<div>', {class: "carmenta-button-group carmenta-#{@name}-group"})
    if @options._context
      @element.addClass('disabled')



# ButtonGroup contexts
Carmenta.Toolbar.ButtonGroup.contexts =

  table: (node, region) -> node.closest('table', region).length > 0
