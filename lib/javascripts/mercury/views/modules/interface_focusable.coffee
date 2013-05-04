Mercury.View.Modules.InterfaceFocusable =

  included: ->
    @on('build', @buildInterfaceFocusable)


  buildInterfaceFocusable: ->
    return unless @revertFocusOn
    @delegateEvents
      mousedown: 'handleFocusableEvent'
      mouseup: 'handleFocusableEvent'
      click: 'handleFocusableEvent'
    @delegateRevertedFocus(@revertFocusOn)


  delegateRevertedFocus: (matcher) ->
    reverted = {}
    reverted["mousedown #{matcher}"] = 'revertInterfaceFocus'
    reverted["click #{matcher}"] = 'revertInterfaceFocus'
    @delegateEvents(reverted)


  handleFocusableEvent: (e) ->
    e.stopPropagation()
    @prevent(e) unless $(e.target).is(@focusableSelector || ':input, [tabindex]')


  revertInterfaceFocus: ->
    @delay(1, -> Mercury.trigger('focus'))
