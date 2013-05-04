Mercury.View.Modules.VisibilityToggleable =

  included: ->
    @on('build', @buildVisibilityToggleable)


  buildVisibilityToggleable: ->
    @delegateEvents('mercury:interface:hide': 'hide')
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
    @onShow?()
    @visible = true
    @$el.show()
    @visibilityTimout = @delay 50, ->
      @css(opacity: 1)
      @update?() if update && typeof(update) == 'boolean'


  hide: (release) ->
    return unless @visible
    release = null unless typeof(release) == 'boolean'
    release ?= @releaseOnHide
    @trigger('hide')
    clearTimeout(@visibilityTimout)
    @onHide?()
    @visible = false
    @css(opacity: 0)
    @visibilityTimout = @delay 250, ->
      @$el.hide()
      @release() if release
