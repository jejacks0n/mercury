# Mercury dependencies and core libary.
#
#= require mercury/dependencies
#= require mercury/mercury
#
# All locales.
#
#= require mercury/locales
#
# All region types.
#
#= require mercury/regions
#
# Configuration.
#
#= require mercury/config

jQuery ->
  # when using rails we need to setup the csrf token
  $.ajaxSetup headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')}


# Scratch pad / regression testing
jQuery ->
  window.editor = new Mercury.Editor()
  editor.appendTo(document.body)

# example of extending regions to add actions for buttons or other functionality.
Mercury.MarkdownRegion.actions =
  direction: ->
    @direction = if @direction == 'rtl' then 'ltr' else 'rtl'
    @el.css(direction: @direction)
