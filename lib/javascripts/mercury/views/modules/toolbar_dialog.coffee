Mercury.View.Modules.ToolbarDialog =

  included: ->
    @on('build', @buildToolbarDialog)


  buildToolbarDialog: ->
    @delegateEvents('mercury:dialogs:hide': -> @hide?())
