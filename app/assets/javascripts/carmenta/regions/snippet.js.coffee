class Carmenta.Regions.Snippet
  type = 'snippet'

  constructor: (@element) ->
    Carmenta.log('making snippetable', @element)

    @history = new Carmenta.HistoryBuffer()
