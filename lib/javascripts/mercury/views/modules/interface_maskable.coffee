Mercury.View.Modules.InterfaceMaskable =

  included: ->
    @on('build', @buildInterfaceMaskable)


  extended: ->
    @on('build', @buildInterfaceMaskable)


  buildInterfaceMaskable: ->
    @$mask = $('<div class="mercury-interface-mask">')
    @append(@$mask)
    @delegateEvents
      'mercury:interface:mask': @mask
      'mercury:interface:unmask': @unmask
      'mousedown .mercury-interface-mask': @prevent
      'mouseup .mercury-interface-mask': @prevent
      'click .mercury-interface-mask': @onMaskClick


  mask: ->
    @$mask.show()


  unmask: ->
    @$mask.hide()


  onMaskClick: (e) ->
    @prevent(e, true)
    Mercury.trigger('dialogs:hide')
