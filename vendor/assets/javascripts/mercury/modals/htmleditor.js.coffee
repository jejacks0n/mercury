@Mercury.modalHandlers.htmlEditor = ->
  # fill the text area with the content
  @element.find('textarea').val(Mercury.region.content(null, true, false))

  # replace the contents on form submit
  @element.find('form').submit (event) =>
    event.preventDefault()
    value = @element.find('textarea').val().replace(/\n/g, '')
    Mercury.trigger('action', {action: 'replaceHTML', value: value})
    @hide()
