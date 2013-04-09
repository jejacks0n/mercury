Mercury.View.Modules.ToolbarFocusable =

  included: ->
    @on('build', @buildToolbarFocusable)


  buildToolbarFocusable: ->
    @delegateEvents
      'mousedown': (e) -> e.stopPropagation() # keep the button from getting the event.
      'mouseup': (e) -> e.stopPropagation() # keep the button from getting the event.
