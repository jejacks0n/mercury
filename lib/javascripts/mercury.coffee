# Mercury dependencies and core libary.
#
#= require mercury/dependencies
#= require mercury/mercury
#
# All region types.
#
#= require mercury/regions
#
# All locales.
#
#= require mercury/locales
#
# Configuration.
#
#= require mercury/config
jQuery ->
  # when using rails we need to setup the csrf token
  $.ajaxSetup headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')}
  window.mercury = Mercury.init(frame: '#mercury_frame')

# todo:
#   allow adding/reinitializing regions
#   add list region (sort of like workflowy)
#   add canvas region (save/load as base64 image)
#   add more control to image region (resize, crop, etc.)
#   figure out how to better integrate snippets.
#   can we make editing content within snippets work better?
#   when using the iframe, rangy isn't behaving the same (doesn't work because it doesn't understand the context).
#   selections are a little wonky on undo/redo still, and sometimes in firefox they're not applying because the checksum doesn't validate.
















# Adding functionality:
#
# First, we add the buttons we want to add. We could do this in various ways, but this is one of the most straight
# forward ways to accomplish it.
Mercury.configure 'toolbars:html:custom',
  sep1:      '-'
  direction: ['RTL/LTR', icon: '0']

Mercury.Region.Html.addAction 'direction', ->
  @direction = if @direction == 'rtl' then 'ltr' else 'rtl'
  @el.data(direction: @direction).css(direction: @direction)

# For more advanced custom toolbar functionality you may consider adding a full toolbar and adding that toolbar to the
# regions that you've added the custom behavior to.
Mercury.Region.Markdown.addToolbar('advanced')
Mercury.Region.Html.addToolbar('advanced')
Mercury.configure 'toolbars:advanced',
  sep1:      '-'
  favorite:  ['favorite', icon: '1', action: ['html', '<a href="http://twitter.com/jejacks0n">jejacks0n</a>']]

