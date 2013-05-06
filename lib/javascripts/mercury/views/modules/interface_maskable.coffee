Mercury.View.Modules.InterfaceMaskable =

  included: ->
    @on('build', @buildInterfaceMaskable) if @buildInterfaceMaskable


  extended: ->
    @on('build', @buildInterfaceMaskable) if @buildInterfaceMaskable


  buildInterfaceMaskable: ->
    @append('<div class="mercury-interface-mask"></div>')
    @elements['mask'] = '.mercury-interface-mask'
    @refreshElements()
    @delegateEvents
      'mercury:interface:mask': @mask
      'mercury:interface:unmask': @unmask
      'mousedown .mercury-interface-mask': @prevent
      'mouseup .mercury-interface-mask': @prevent
      'click .mercury-interface-mask': (e) ->
         @prevent(e, true)
         Mercury.trigger('dialogs:hide')


  mask: ->
    return unless @config('interface:maskable')
    @$mask.show()


  unmask: ->
    @$mask.hide()
