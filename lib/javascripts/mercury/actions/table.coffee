#= require mercury/core/action

class Mercury.Action.Table extends Mercury.Action

  name: 'table'

  asHtml: ->
    editor = this.attributes
    editor.asHtml('<br />')
