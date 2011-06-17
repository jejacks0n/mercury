@Mercury.dialogHandlers.style = ->
  @element.find('[data-class]').click (event) =>
    className = $(event.target).attr('class')
    Mercury.trigger('action', {action: 'style', value: className})
