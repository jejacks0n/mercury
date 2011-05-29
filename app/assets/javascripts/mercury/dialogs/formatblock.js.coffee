Mercury.dialogHandlers.formatblock = ->
  @element.find('[data-tag]').click (event) =>
    tag = $(event.target).data('tag')
    Mercury.trigger('action', {action: 'formatblock', value: tag})
