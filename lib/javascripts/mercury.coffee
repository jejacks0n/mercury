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
#
# Initialize Mercury.
jQuery ->
  # First do anything nessicary for Ajax requests to be successful -- in our case we need the csrf token for Rails.
  $.ajaxSetup headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')}

  # To initialize Mercury call Mercury.init. This will use the interface configuration and instantiate the configured
  # interface, which in turn instantiates the interface elements and regions. In our demo we allow using an iframe
  # (which should be provided by you and in the dom), and if the iframe isn't available the standard non-iframe
  # interface will be used.
  #
  # For more information about the Mercury API, you might want to check the developer_toolbar in examples. It contains
  # examples for creating / releasing / deleting dynamic regions, saving, toggling the interface, keeping Mercury
  # focused, how you can use the Mercury Core library as a framework to build a custom interface etc.
  Mercury.init(frame: '#mercury_frame')


# Adding functionality - Toolbars and Actions
#
# For custom toolbar functionality you can create a toolbar and add it to regions that you've added the associated
# custom action to. In this example we're just going to dump some HTML into any region that can handle HTML.
#
# First we add the toolbar to the configuration. You can read about the various button options in the README. In this
# example we embed the action information directly in the button, but this may not always be optimal and adding a more
# complex action method is advisable for more complex situations. You can override any toolbar button or group using the
# same technique, just naming it the same as what you want to replace.
#
# You'll notice here that we're using an icon character on the button, which maps to a glyph that's defined in the font.
# You can add your own, and there's more info about that in the README.
Mercury.configure 'toolbars:links',
  sep:      '-'
  favorite: ['Favorite', icon: '1', action: ['html', '<a href="http://twitter.com/jejacks0n">jejacks0n</a>']]

# Next we add the new toolbar to the regions that we want to be able to handle it. The toolbar button will be added and
# enabled for any region that we add the toolbar to and that also supports the HTML action. For regions that don't
# support the HTML action it will appear disabled.
Mercury.Region.Markdown.addToolbar('links')
Mercury.Region.Html.addToolbar('links')


# Adding functionality - Data and Context
#
# This example covers how to add more complex behaviors that understand context and are stored in the element data, so
# it can be serialized on save.
#
# First, we add the toolbar buttons we'll need. When a user sets the direction we want to track what it is, so we're
# going to store it in the element data -- which we can use use later when we render the region from the server.
Mercury.Region.Markdown.addToolbar 'custom', sep: '-', direction: ['RTL/LTR', icon: '0']

# To have the button highlight under various conditions we need to add a context. The button will highlight when it's
# context is true. Our context simply checks to see if the region has it's direction set to rtl -- which makes our
# button work like a toggle.
Mercury.Region.Markdown.addContext 'direction', -> @el.css('direction') == 'rtl'

# Next, since we're using a data attribute we need to know what to do when it's set. This allows us to restore things
# from the undo/redo stack. Initially this handler will be called with null, and you're expected to set a default --
# which allows specifying defaults as well as resetting it in the case when it's removed.
Mercury.Region.Markdown.addData 'direction', (val) -> @el.css('direction', val || 'ltr')

# And finally we add the action. You'll notice we're going through the #data method when setting this, which will call
# through to the data handler that we defined using the .addData method above. If you attempt to set the element data
# directly you will get inconsistent and unexpected results.
Mercury.Region.Markdown.addAction 'direction', ->
  direction = if @data('direction') == 'rtl' then 'ltr' else 'rtl'
  @data(direction: direction)


# Adding functionality - Getting and Replacing Selections
#
# In this example we'll work with getting and replacing the selection.
#
# Like the previous examples we need a toolbar button / group that we can interact with. It's advisable to always
# include a separator in your toolbars so they don't clump together with other toolbar buttons.
Mercury.Region.Markdown.addToolbar 'calculations', sep: '-', calc: ['Calculate', icon: '2']

# Now we just have to add the action that attempts to calculate the given selection. In this case we replace the
# selection with whatever was evaled -- note, this also allows for javascript injection, so is intended as an example
# only.
Mercury.Region.Markdown.addAction 'calc', ->
  try @replaceSelection(eval(@getSelection().text))
  catch e
    @notify('Unable to calcuate the selection -- try selecting a math equation')



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
