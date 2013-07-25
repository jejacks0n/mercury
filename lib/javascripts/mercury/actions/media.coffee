#= require mercury/core/action

class Mercury.Action.Media extends Mercury.Action

  name: 'media'

  asMarkdown: ->
    # We can't specify a width or height via Markdown
    if !!@get('width') or !!@get('height') or @get('type') != 'image'
      @asHtml()
    else
      """![](#{@get('src')})"""


  asHtml: ->
    if @get('type') == 'image'
      """<img src="#{@get('src')}" align="#{@get('align')}" width="#{@get('width')}" height="#{@get('height')}"/>"""
    else
      """<iframe src="#{@get('src')}" width="#{@get('width')}" height="#{@get('height')}" frameborder="0" allowFullScreen></iframe>"""
