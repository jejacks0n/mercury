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

  init: ->
    @on('show', -> Mercury.trigger('interface:mask') unless @visible)
    @on('hide', -> Mercury.trigger('interface:unmask') if @visible)
