#= require mercury/core/view
#= require mercury/templates/statusbar

class Mercury.Statusbar extends Mercury.View

  @logPrefix: 'Mercury.Statusbar:'
  @className: 'mercury-statusbar'
  @template: 'statusbar'

  @elements:
    path: '.mercury-statusbar-path'

  @events:
    'mercury:interface:hide': 'hide'
    'mercury:interface:show': 'show'
    'mercury:region:update': 'onRegionUpdate'
    'mousedown': 'onMousedown'

  build: ->
    @setPath()


  setPath: (path = []) ->
    @$path.html("<b>#{@t('Path:')} </b>")
    for el in path
      @$path.append(el)
      @$path.append(' &raquo; ') unless el == path[path.length - 1]


  show: ->
    return if Mercury.interface.floating && @visible
    clearTimeout(@visibilityTimeout)
    @visible = true
    @$el.show()
    @visibilityTimeout = @delay(50, => @css(bottom: 0))


  hide: ->
    return if Mercury.interface.floating
    clearTimeout(@visibilityTimeout)
    @visible = false
    @css(bottom: -@$el.height())
    @visibilityTimeout = @delay(250, => @$el.hide())


  height: ->
    @$el.outerHeight()


  onMousedown: (e) ->
    @prevent(e)
    Mercury.trigger('dialogs:hide')
    Mercury.trigger('focus')


  onRegionUpdate: (region) ->
    @setPath(path) if path = region.path?()
