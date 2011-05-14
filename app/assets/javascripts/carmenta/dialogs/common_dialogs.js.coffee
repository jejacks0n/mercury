Carmenta.dialogHandlers =

  backcolor: ->
    @element.find('.picker, .last-picked').click (event) =>
      color = $(event.target).css('background-color')
      @element.find('.last-picked').css({background: color})
      @button.css({backgroundColor: color})
      Carmenta.trigger('action', {action: 'backcolor', value: color})


  forecolor: ->
    @element.find('.picker, .last-picked').click (event) =>
      color = $(event.target).css('background-color')
      @element.find('.last-picked').css({background: color})
      @button.css({backgroundColor: color})
      Carmenta.trigger('action', {action: 'forecolor', value: color})


  formatblock: ->
    @element.find('[data-tag]').click (event) =>
      tag = $(event.target).data('tag')
      Carmenta.trigger('action', {action: 'formatblock', value: tag})


  style: ->
    @element.find('[data-class]').click (event) =>
      className = $(event.target).attr('class')
      Carmenta.trigger('action', {action: 'style', value: className})
