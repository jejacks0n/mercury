#= require mercury/core/view
#= require mercury/views/modules/interface_focusable
#= require mercury/views/modules/toolbar_dialog
#= require mercury/views/modules/visibility_toggleable

class Mercury.ToolbarPalette extends Mercury.View
  @include Mercury.View.Modules.InterfaceFocusable
  @include Mercury.View.Modules.ToolbarDialog
  @include Mercury.View.Modules.VisibilityToggleable

  @logPrefix: 'Mercury.ToolbarPalette:'
  @className: 'mercury-dialog mercury-toolbar-palette'

  hidden: true
