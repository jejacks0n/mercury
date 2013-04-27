#= require mercury/core/view
#= require mercury/views/modules/interface_focusable
#= require mercury/views/modules/toolbar_dialog
#= require mercury/views/modules/visibility_toggleable

class Mercury.ToolbarSelect extends Mercury.View
  @include Mercury.View.Modules.InterfaceFocusable
  @include Mercury.View.Modules.ToolbarDialog
  @include Mercury.View.Modules.VisibilityToggleable

  @logPrefix: 'Mercury.ToolbarSelect:'
  @className: 'mercury-dialog mercury-toolbar-select'

  hidden: true

  build: ->
    @appendTo(@parent || Mercury.interface)
