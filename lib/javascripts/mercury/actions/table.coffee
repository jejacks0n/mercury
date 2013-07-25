#= require mercury/core/action

class Mercury.Action.Table extends Mercury.Action

  name: 'table'

  asHtml: ->
    @attributes.asHtml('<br />')
