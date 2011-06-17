@Mercury.dialogHandlers.objectspanel = ->
  # make the filter work
  @element.find('input.filter').keyup =>
    value = @element.find('input.filter').val()
    for snippet in @element.find('li[data-filter]')
      if LiquidMetal.score($(snippet).data('filter'), value) == 0 then $(snippet).hide() else $(snippet).show()

  # when an element is dragged, set it so we have a global object
  @element.find('img[data-snippet]').bind 'dragstart', (event) ->
    Mercury.snippet = $(@).data('snippet')
