Mercury.View.Modules.FilterableList =

  included: ->
    @on('show', @buildFilterable)


  buildFilterable: ->
    return @$('input.mercury-filter').hide() unless LiquidMetal
    @delegateEvents
      'keyup input.mercury-filter': @onFilter # todo: this could go away eventually
      'search input.mercury-filter': @onFilter


  onFilter: (e) ->
    value = $(e.target).val()
    for item in @$('li[data-filter]')
      if LiquidMetal.score((item = $(item)).data('filter'), value) <= 0.5 then item.hide() else item.show()
