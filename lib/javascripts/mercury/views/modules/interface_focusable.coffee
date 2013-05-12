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


  preventFocusout: ($constrain) ->
    @on('release', => @clearFocusoutTimeout())
    @on('hide', => @clearFocusoutTimeout())

    $focus = @createFocusableKeeper().appendTo(@$el)
    $focus.on('blur', => @keepFocusConstrained($focus, $constrain))
    $constrain.off('focusout').on('focusout', => @keepFocusConstrained($focus, $constrain))
    $constrain.on 'keydown', (e) =>
      return unless e.keyCode == 9 # not tab
      focusables = $constrain.find(':input[tabindex != "-1"]')
      return unless focusables.length
      first = focusables[0]
      last = focusables[focusables.length - 1]
      @prevent(e, true) if (e.shiftKey && e.target == first) || (!e.shiftKey && e.target == last)


  createFocusableKeeper: ->
    $('<input style="position:fixed;top:-10000px;left:100%;width:10px;height:5px" tabindex="-1">')


  keepFocusConstrained: ($focus, $constrain) ->
    @preventFocusoutTimeout = @delay 1, =>
      return if $.contains($constrain[0], document.activeElement)
      $focus.focus()


  clearFocusoutTimeout: ->
    clearTimeout(@preventFocusoutTimeout)
