###!

###
class Mercury.Region.Snippet extends Mercury.Region
  @define 'Mercury.Region.Snippet', 'snippet'

  @supported: true

  value: (value) ->
    if value == null || typeof(value) == 'undefined'
      @attr('src')
    else
      @attr('src', value)


  # todo: cleanup how the drop behavior is being added, this shouldn't be here
  onDropItem: ->



Mercury.Region.Snippet.addToolbar

  general:
    remove:      ['Remove Snippet']


Mercury.Region.Snippet.addAction

  remove:      -> console.debug('remove')
  snippet:     -> console.debug('snippet', arguments)
