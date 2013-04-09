Mercury.View.Modules.ToolbarDialog =

  included: ->
    @on('build', @buildToolbarDialog)


  buildToolbarDialog: ->
    @delegateEvents('dialogs:hide': -> @hide?())
