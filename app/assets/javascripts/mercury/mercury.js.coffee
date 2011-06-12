###
# Mercury Editor is a Coffeescript and jQuery based WYSIWYG editor.  Mercury Editor utilizes the HTML5 ContentEditable
# spec to allow editing sections of a given page (instead of using iframes) and provides an editing experience that's as
# realistic as possible.  By not using iframes for editable regions it allows CSS to behave naturally.
#
# Mercury Editor was written for the future, and doesn't attempt to support legacy implementations of document editing.
#
# Currently supported browsers are
#   - Firefox 4+
#   - Chrome 10+
#   - Safari 5+
#
# Copyright (c) 2011 Jeremy Jackson
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
###

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
      return if arguments[0] == 'hide:toolbar'
      try console.debug(arguments) catch e

}