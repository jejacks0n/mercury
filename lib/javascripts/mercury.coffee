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
  # setup the csrf token for ajax requests and rails.
  $.ajaxSetup headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')}
  Mercury.init(frame: '#mercury_frame')

# Adding functionality (toolbars)
#
# For more advanced custom toolbar functionality you may consider adding a full toolbar and adding that toolbar to the
# regions that you've added the custom behavior to. In this example we're just going to dump some HTML into any region
# that can handle HTML.
#
# First we add the toolbar to the configuration. You can read about the various button options in the README. In this
# example we embed the action information directly in the button, but this may not always be optimal and adding a more
# complex action method is advisable for more complex situations.
Mercury.configure 'toolbars:advanced',
  sep1:     '-'
  favorite: ['Favorite', icon: '1', action: ['html', '<a href="http://twitter.com/jejacks0n">jejacks0n</a>']]

# Next we add that new toolbar to the regions that we want to be able to handle it. The toolbar button will be enabled
# for any region that we add the toolbar to that also supports the HTML action.
Mercury.Region.Markdown.addToolbar('advanced')
Mercury.Region.Html.addToolbar('advanced')

# Adding functionality (data and context):
#
# This article covers how to add more complex behaviors that understand context, and are stored in data, so it can be
# serialized on save.
#
# First, we add the toolbar buttons we will need. You'll notice here that we're using an icon character, and this maps
# to a glyph that's defined in the font. You can add your own, and there's more info about that in the README. Now when
# a user sets the direction we want to track it, so we're going to store it on a data attribute that will be serialized
# on save, so we can use it later when we re-render the region.
Mercury.configure 'toolbars:markdown:custom', sep1: '-', direction: ['RTL/LTR', icon: '0']

# We add a context, so the button can highlight when it's set. This context checks to see if the region has it's
# direction set to rtl -- making this button work like a toggle button.
Mercury.Region.Markdown.addContext 'direction', -> @el.css('direction') == 'rtl'

# Next, since we're using a data attribute we need to know when that's set, and what to do when it's set. This allows us
# to restore things for the undo/redo stack.
Mercury.Region.Markdown.addData 'direction', (val) -> @el.css('direction', val || 'ltr')

# And finally, we add the action to the regions we want to understand it. You'll notice we're going through the #data
# method when setting this, which will call through to the data handler that we defined using the .addData method above.
Mercury.Region.Markdown.addAction 'direction', ->
  direction = if @data('direction') == 'rtl' then 'ltr' else 'rtl'
  @data(direction: direction)



# todo:
#   add release method to global object that cleans up the interface and restores regions.
#   figure out how to better integrate snippets.
#   can we make editing content within snippets work?
#   html/plain: when using the iframe, rangy isn't behaving the same (doesn't work because it doesn't understand the context).
#   html: selections are a little wonky on undo/redo still, and sometimes in firefox they're not applying because the checksum doesn't validate.
# todo interface:
#   better strategy for snippet management/removal -- focusable with toolbar buttons would be nice, combined with a lesser toolbar in line? (drag handle on hover, etc?)
#   add all interface elements, like modal, panel, and toolbar dialogs
#   break the region (and other required) css off so the entire thing doesn't need to be included when using frames? (overly complex for some)?
# todo regions:
#   add list region (sort of like workflowy)
#   add canvas region (save/load as base64 image)
#   add more control to image region (resize, crop)
#   finish html region
