@Mercury.dialogHandlers.style = ->
  @element.find('[data-class]').on 'click', (event) =>
    className = jQuery(event.target).data('class')
    Mercury.trigger('action', {action: 'style', value: className})
