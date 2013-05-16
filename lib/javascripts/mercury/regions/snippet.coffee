###!

###
class Mercury.Region.Snippet extends Mercury.Region
  @include Mercury.Region.Modules.DropIndicator

  @define 'Mercury.Region.Snippet', 'snippet'

  @supported: true

  skipHistoryOn: ['undo', 'redo']


  onDropSnippet: (snippet) ->
    snippet.on 'rendered', (view) =>
      @focus()
      @handleAction('snippet', snippet, view)


Mercury.Region.Snippet.addToolbar

  general:
    remove:      ['Remove Snippet']


Mercury.Region.Snippet.addAction

  remove:      -> console.debug('remove')

  snippet: (snippet) ->
    @append(snippet.getRenderedView(@))
    @pushHistory()
