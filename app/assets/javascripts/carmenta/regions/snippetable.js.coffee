#= require_self
#= require ./snippetable.snippet

class Carmenta.Regions.Snippetable
  type = 'snippetable'

  constructor: (@element) ->
    Carmenta.log('making snippetable', @element)

    @history = new Carmenta.HistoryBuffer()
