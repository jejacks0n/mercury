@Mercury.modalHandlers.insertCharacter = ->
  @element.find('.character').click ->
    Mercury.trigger('action', {action: 'insertHTML', value: "&#{$(@).attr('data-entity')};"})
    Mercury.modal.hide()
