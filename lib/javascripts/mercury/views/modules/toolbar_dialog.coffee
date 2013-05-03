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
    @css(left: 0, top: 0)
    v = width: $(window).width(), height: $(window).height()
    e = width: @$el.outerWidth(), height: @$el.outerHeight()
    p = width: @$el.parent().outerWidth(), height: @$el.parent().outerHeight()
    o = @$el.parent().position()

    left = 0
    left = -e.width + p.width if e.width + o.left > v.width
    left -= o.left + left if o.left + left < 0

    top = 0
    top = -e.height if e.height + o.top + p.height > v.height
    top -= o.top + top + p.height if o.top + top + p.height < 0

    @css(top: top, left: left)


  resize: (animate = true, dimensions) ->
