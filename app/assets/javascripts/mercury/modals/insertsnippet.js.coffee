Mercury.modalHandlers.insertsnippet = ->
  @element.find('form').submit (event) =>
    event.preventDefault()
    snippet = Mercury.Snippet.create('example', @element.find('form').serializeObject())
    Mercury.trigger('action', {action: 'insertsnippet', value: snippet})
    @hide()
