# Configuration.
#------------------------------------------------------------------------------
#= require mercury/config
#
# Mercury dependencies and core libary.
#------------------------------------------------------------------------------
#= require mercury/dependencies
#= require mercury/mercury
#
# All region types.
#------------------------------------------------------------------------------
#= require mercury/regions
#
# All locales.
#------------------------------------------------------------------------------
#= require mercury/locales
#
# Additional functionality.
#------------------------------------------------------------------------------
# You can require any files that add additional functionality to Mercury here.
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


Mercury.Region.Markdown.addToolbar 'color', color: ['Color', plugin: 'color']
Mercury.Region.Markdown.addToolbar 'block', block: ['Block', plugin: 'blocks']

# todo:
#   provide top level Mercury.focus and blur methods that trigger the event so the pattern is nicer.
#   migrate all toolbar button subviews into a more standard usage (show/hide, etc.)
#   adjust all place where the uploader is instantiated to use the configuration.
#   port jQuery.extend into module so we can use that within instances (which is where it's mostly used).
#   provide aloha editor look alike toolbar and toolbar behavior (but better).
#   spend time making sure focus is working well and dialed before moving forward.
#   migrate existing locale content into new locales and document missing values.
#   make region use the shadow dom if possible/configured to do so.
#   spend some time making what's in work really well on ios.
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
#   polish markdown region (if you're not dead from the html reigon)
