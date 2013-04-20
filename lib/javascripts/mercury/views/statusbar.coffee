#= require mercury/core/view
#= require mercury/templates/statusbar

class Mercury.Statusbar extends Mercury.View

  @logPrefix: 'Mercury.Statusbar:'
  @className: 'mercury-statusbar'
  @template: 'statusbar'

  @events:
    'mercury:region:update': 'onRegionUpdate'
    'mercury:interface:hide': 'hide'
    'mercury:interface:show': 'show'

  @elements:
    path: '.mercury-statusbar-path'


  build: ->
    @setPath()


  setPath: (path = []) ->
    @path.html("<b>#{@t('Path:')} </b>")
    for el in path
      @path.append(el)
      @path.append(' &raquo; ') unless el == path[path.length - 1]


  show: ->
    clearTimeout(@visibilityTimeout)
    @visible = true
    @el.show()
    @visibilityTimeout = @delay(50, => @el.css(bottom: 0))


  hide: ->
    clearTimeout(@visibilityTimeout)
    @visible = false
    @el.css(bottom: -@el.height())
    @visibilityTimeout = @delay(250, => @el.hide())


  onRegionUpdate: (region) ->
    @setPath(path) if path = region.path?()
