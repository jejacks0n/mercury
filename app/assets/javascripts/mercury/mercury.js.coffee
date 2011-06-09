# Mercury Editor is a Rails and Coffeescript based WYSIWYG editor.  Mercury
# Editor utilizes the HTML 5 ContentEditable HTML 5 spec to allow editing
# sections of a given page (instead of using iframes) and provides an editing
# experience that's as realistic as possible.  By not using iframes for the
# editable regions it allows CSS to behave naturally.
#
# Mercury Editor was written for the future, and doesn't attempt to support
# legacy implementations of document editing.
#
# Currently supported browsers are
#   - Firefox 4+
#   - Chrome 10+
#   - Safari 5+#= require_self
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
#= require ./config


# Mercury static properties and utlity methods
Mercury = {

  version: 1.0

  # No IE because it doesn't follow the w3c standards for designMode
  # TODO: using client detection, but should use feature detection
  supported: document.getElementById && document.designMode && !$.browser.konqueror && !$.browser.msie

  silent: false

  debug: true

  Regions: {}

  modalHandlers: {}

  dialogHandlers: {}


  beforeUnload: ->
    if Mercury.changes && !Mercury.silent
      return "You have unsaved changes.  Are you sure you want to leave without saving them first?"
    return null


  refresh: ->
    Mercury.trigger('refresh')


  bind: (eventName, callback) ->
    $(document).bind("mercury:#{eventName}", callback)


  trigger: (eventName, options) ->
    Mercury.log(eventName, options)
    $(document).trigger("mercury:#{eventName}", options)


  log: ->
    if Mercury.debug && console
      try console.debug(arguments) catch e

}