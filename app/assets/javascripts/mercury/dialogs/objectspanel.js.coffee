Mercury.dialogHandlers.objectspanel = ->
  # make the filter work
  @element.find('input.filter').change =>
    value = @element.find('input.filter').val()
    for snippet in @element.find('li[data-filter]')
      if LiquidMetal.score($(snippet).data('filter'), value) == 0 then $(snippet).hide() else $(snippet).show()

#  snippetList = $('snippet_list');
#  snippetList.select('img[data-snippet]').each(function(element) {
#    Event.observe(element, 'dragstart', function (e) { window.snippetDragged = element; });
#  });
