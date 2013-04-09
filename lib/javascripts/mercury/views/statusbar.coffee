#= require mercury/core/view
#= require mercury/templates/statusbar

class Mercury.Statusbar extends Mercury.View

  logPrefix: 'Mercury.Statusbar:'
  className: 'mercury-statusbar'
  template: 'statusbar'

  events:
    'region:update': 'onRegionUpdate'
    'interface:hide': 'hide'
    'interface:show': 'show'

  elements:
    path: '.mercury-statusbar-path'


  build: ->
    @setPath()


  setPath: (path = []) ->
    @path.html("<b>#{@t('Path:')} </b>")
    for el in path
      @path.append(el)
      @path.append(' &raquo; ') unless el == path[path.length - 1]


  onRegionUpdate: (region) ->
    @setPath(path) if path = region.path?()


  hide: ->
    clearTimeout(@visibilityTimeout)
    @visible = false
    @el.css(bottom: -@el.height())
    @visibilityTimeout = @delay(250, => @el.hide())


  show: ->
    clearTimeout(@visibilityTimeout)
    @visible = true
    @el.show()
    @visibilityTimeout = @delay(1, => @el.css(bottom: 0))
