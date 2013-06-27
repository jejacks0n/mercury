#= require mercury/core/action

class Mercury.Action.Link extends Mercury.Action

  name: 'link'

  asMarkdown: ->
    """[#{@get('text')}](#{@get('url')})"""


  asHtml: ->
    target = if @get('target') then " target=\"#{@get('target')}\"" else ''
    """<a href="#{@get('url')}"#{target}>#{@get('text')}</a>"""
