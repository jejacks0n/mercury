#
#= require mercury_dependencies/jquery-1.6
#= require mercury_dependencies/jquery-ui-1.8.13.custom
#= require mercury_dependencies/jquery.additions
#= require mercury_dependencies/liquidmetal
#= require mercury_dependencies/showdown
#
#= require_self
#= require ./native_extensions
#= require ./page_editor
#= require ./history_buffer
#= require ./table_editor
#= require ./dialog
#= require ./palette
#= require ./select
#= require ./panel
#= require ./modal
#= require ./statusbar
#= require ./toolbar
#= require ./toolbar.button
#= require ./toolbar.button_group
#= require ./toolbar.expander
#= require ./tooltip
#= require ./snippet
#= require ./snippet_toolbar
#= require ./region
#= require ./uploader
#= require_tree ./regions
#= require_tree ./dialogs
#= require_tree ./modals
#

jQuery.extend Mercury, {
  version: '0.1.3'

  # No IE support yet because it doesn't follow the W3C standards for HTML5 contentEditable (aka designMode).
  supported: document.getElementById && document.designMode && !jQuery.browser.konqueror && !jQuery.browser.msie

  # Mercury object namespaces
  Regions: {}
  modalHandlers: {}
  dialogHandlers: {}
  preloadedViews: {}

  # Custom event and logging methods
  bind: (eventName, callback) ->
    jQuery(document).bind("mercury:#{eventName}", callback)


  trigger: (eventName, options) ->
    Mercury.log(eventName, options)
    jQuery(document).trigger("mercury:#{eventName}", options)


  log: ->
    if Mercury.debug && console
      return if arguments[0] == 'hide:toolbar' || arguments[0] == 'show:toolbar'
      try console.debug(arguments) catch e

}