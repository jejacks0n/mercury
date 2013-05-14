###!

###
class Mercury.Region.Snippet extends Mercury.Region
  @include Mercury.Region.Modules.DropIndicator

  @define 'Mercury.Region.Snippet', 'snippet'

  @supported: true

  skipHistoryOn: ['undo', 'redo']


  onDropSnippet: (snippet) ->
    snippet.on 'insert', =>
      @focus()
      @handleAction('snippet', snippet)


  actions:
    snippet: (snippet) ->
      @append(snippet.render(@))
      @pushHistory()


Mercury.Region.Snippet.addToolbar

  general:
    remove:      ['Remove Snippet']


Mercury.Region.Snippet.addAction

  remove:      -> console.debug('remove')
  snippet:     -> console.debug('snippet', arguments)
