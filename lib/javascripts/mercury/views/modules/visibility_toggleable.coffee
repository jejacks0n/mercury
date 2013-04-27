Mercury.View.Modules.VisibilityToggleable =

  included: ->
    @on('build', @buildVisibilityToggleable)


  buildVisibilityToggleable: ->
    @delegateEvents('mercury:interface:hide': -> @hide())
    if @hidden
      @visible = true
      @hide()
    else
      @show()


  toggle: ->
    if @visible then @hide() else @show()


  show: (update = true) ->
    return if @visible
    @trigger('show')
    clearTimeout(@visibilityTimout)
    @visible = true
    @$el.show()
    @visibilityTimout = @delay 50, ->
      @css(opacity: 1)
      @update?() if update


  hide: (release = false) ->
    return unless @visible
    @trigger('hide')
    clearTimeout(@visibilityTimout)
    @visible = false
    @css(opacity: 0)
    @visibilityTimout = @delay 250, ->
      @$el.hide()
      @release() if release
