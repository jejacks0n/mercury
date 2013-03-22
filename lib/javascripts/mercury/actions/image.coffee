#= require mercury/core/action

class Mercury.Action.Image extends Mercury.Action

  name: 'image'

  asHtml: ->
    """<img src="#{@get('url')}">"""
