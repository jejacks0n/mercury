Mercury.View.Modules.ToolbarDialog =

  included: ->
    @on('build', @buildToolbarDialog)


  buildToolbarDialog: ->
    @delegateEvents
      'mercury:dialogs:hide': -> @hide?()
      'mercury:interface:resize': 'positionAndResize'
    @on('show', -> Mercury.trigger('interface:mask') unless @visible)
    @on('hide', -> Mercury.trigger('interface:unmask') if @visible)


  positionAndResize: (dimensions) ->
    @position(dimensions)
    @resize(false, dimensions)


  position: (dimensions) ->
    @css(top: 0, left: 0)
    par = @$el.parent()
    win = $(window)
    v = width: win.width(), height: win.height()
    e = width: @$el.outerWidth(), height: @$el.outerHeight()
    p = width: par.outerWidth(), height: par.outerHeight()
    o = par.position()

    left = 0
    left = -e.width + p.width if e.width + o.left > v.width          # off the right side of the viewport
    left -= o.left + left if o.left + left < 0                       # off the left side of the viewport

    top = p.height
    top = -e.height if e.height + o.top + p.height > v.height        # off the bottom of the viewport
    top -= o.top + top + p.height if o.top + top + p.height < 0      # off the top of the viewport

    @css(top: top, left: left)


  resize: ->
