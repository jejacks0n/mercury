###!

###
class Mercury.Region.Snippet extends Mercury.Region
  @include Mercury.Region.Modules.SnippetDroppable

  @define 'Mercury.Region.Snippet', 'snippet'

  @supported: true

  value: (value) ->
    if value == null || typeof(value) == 'undefined'
      @attr('src')
    else
      @attr('src', value)


  actions:
    snippet: (snippet) -> @append(snippet.render(@))


Mercury.Region.Snippet.addToolbar

  general:
    remove:      ['Remove Snippet']


Mercury.Region.Snippet.addAction

  remove:      -> console.debug('remove')
  snippet:     -> console.debug('snippet', arguments)
