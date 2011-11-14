@Mercury.modalHandlers.insertCharacter = ->
  @element.find('.character').on 'click', (event) =>
    Mercury.trigger('action', {action: 'insertHTML', value: "&#{jQuery(event.target).attr('data-entity')};"})
    @hide()
