Mercury.View.Modules.ToolbarPositionedDialog =

  included: ->
    @on('build', @buildPositionedDialog)


  buildPositionedDialog: ->
    @delegateEvents('mercury:interface:resize', @position)


  position: ->
    @css(left: 0, top: 0)
    v = width: $(window).width(), height: $(window).height()
    e = width: @$el.outerWidth(), height: @$el.outerHeight()
    p = width: @$el.parent().outerWidth(), height: @$el.parent().outerHeight()
    o = @$el.offset()

    left = 0
    left = -e.width + p.width if e.width + o.left > v.width
    left -= o.left + left if o.left + left < 0

    top = 0
    top = -e.height if e.height + o.top > v.height
    top -= o.top + top if o.top + top < 0

    @css(top: top, left: left)
