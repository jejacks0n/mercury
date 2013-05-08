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


  preventFocusout: ($el, handler) ->
    @on('release', => @clearFocusoutTimeout())
    @on('hide', => @clearFocusoutTimeout())

    if handler then $el.off('focusout').on 'focusout', =>
      @preventFocusoutTimeout = @delay 150, ->
        return if @_activeElementIsBody()
        return if $.contains($el[0], document.activeElement)
        handler.call(@)

    $el.on 'keydown', (e) =>
      return unless e.keyCode == 9 # not tab
      focusables = $el.find(':input[tabindex != "-1"]')
      return unless focusables.length
      first = focusables[0]
      last = focusables[focusables.length - 1]
      @prevent(e, true) if (e.shiftKey && e.target == first) || (!e.shiftKey && e.target == last)


  clearFocusoutTimeout: ->
    clearTimeout(@preventFocusoutTimeout)


  _activeElementIsBody: ->
    document.activeElement == document.body
