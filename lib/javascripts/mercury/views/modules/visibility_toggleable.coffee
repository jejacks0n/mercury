Mercury.View.Modules.VisibilityToggleable =

  included: ->
    @on('build', @buildVisibilityToggleable)


  buildVisibilityToggleable: ->
    @visible ||= false
    @hide() unless @visible
    @delegateEvents
      'interface:hide': 'hide'


  toggle: ->
    if @visible then @hide() else @show()


  hide: ->
    clearTimeout(@visibilityTimeout)
    @visible = false
    @el.css(opacity: 0)
    @visibilityTimeout = @delay(100, => @el.hide())


  show: ->
    clearTimeout(@visibilityTimeout)
    @visible = true
    @el.show()
    @visibilityTimeout = @delay(1, => @el.css(opacity: 1))
