@Mercury.dialogHandlers.style = ->
  @element.find('[data-class]').click (event) =>
    className = $(event.target).data('class')
    Mercury.trigger('action', {action: 'style', value: className})
