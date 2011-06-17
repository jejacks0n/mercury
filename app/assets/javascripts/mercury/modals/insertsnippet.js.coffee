@Mercury.modalHandlers.insertsnippet = ->
  @element.find('form').submit (event) =>
    event.preventDefault()
    if Mercury.snippet
      snippet = Mercury.snippet
      snippet.setOptions(@element.find('form').serializeObject())
      Mercury.snippet = null
    else
      snippet = Mercury.Snippet.create('example', @element.find('form').serializeObject())
    Mercury.trigger('action', {action: 'insertsnippet', value: snippet})
    @hide()
