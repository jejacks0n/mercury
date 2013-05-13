Mercury.Region.Modules.SnippetDroppable =

  included: ->
    @on('build', @buildSnippetDroppable)


  buildSnippetDroppable: ->
    @bindDropEvents() unless @onDropFile || @onDropItem


  onItemDropped: (e, data) ->
    return @onDropSnippet?(snippetName) if @hasAction('snippet') && snippetName = data.getData('snippet')
    @onDropItem(e, data)


  onDropSnippet: (snippetName) ->
    snippet = Mercury.getSnippet(snippetName, true)
    snippet.on 'insert', =>
      Mercury.focus()
      @handleAction('snippet', snippet)
