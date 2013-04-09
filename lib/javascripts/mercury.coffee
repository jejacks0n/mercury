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
# Additional functionality.
#
# you can require any files that add additional functionality to Mercury here.
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


# todo:
#   make toolbar view element classes easier to setup. eg. select -> ToolbarSelect etc. -- provide example.
#   make toolbar dialogs to hide with certain events -- mousedown when it's not a button with it's subview showing.
#   consider switching to using a mask for toolbar dialogs (that cover the entire viewport) instead of mousedown on body.
#   make region use the shadow dom if possible/configured to do so.
#   spend some time making what's in work really well on ios.
#   work on modal -- and lightview.
#   work on panel.
#   potentially rename toolbar_palette and toolbar_select into just select/palette so that others could more easily be added.
#   would a routing-esque system be useful for determining what toolbar view to open for things like selects, palettes, modals etc.?
#   figure out how to better integrate snippets.
#   can we make editing content within snippets work?
#   html/plain: when using the iframe, rangy isn't behaving the same (doesn't work because it doesn't understand the context).
#   html: selections are a little wonky on undo/redo still, and sometimes in firefox they're not applying because the checksum doesn't validate.
# todo interface:
#   better strategy for snippet management/removal -- focusable with toolbar buttons would be nice, combined with a lesser toolbar in line? (drag handle on hover, etc?)
#   add all interface elements, like modal, panel, and toolbar dialogs
# todo regions:
#   add list region (sort of like workflowy)
#   add canvas region (save/load as base64 image)
#   add more control to image region (resize, crop)
#   finish html region
