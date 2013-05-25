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
    $focus = $(@createFocusableKeeper().appendTo(@$el)[0])
    @on 'release', => @clearFocusout($focus, $constrain)
    @on 'hide', => @clearFocusout($focus, $constrain)
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
    $('<input style="position:fixed;left:100%;top:20px" tabindex="-1"/><input style="position:fixed;left:100%;top:20px"/>')


  keepFocusConstrained: ($focus, $constrain) ->
    @preventFocusoutTimeout = @delay 1, =>
      return if $.contains($constrain[0], document.activeElement)
      $focus.focus()


  clearFocusout: ($focus, $constrain) ->
    clearTimeout(@preventFocusoutTimeout)
    $focus.off()
    $constrain.off('keydown').off('focusout')
