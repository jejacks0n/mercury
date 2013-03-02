# Mercury / dependencies.
#
#= require mercury/dependencies
#= require mercury/mercury
#
# Region types.
#
#= require mercury/regions
#
# Configuration.
#
#= require mercury/config
#
# Locales.
#
#= require mercury/locales/swedish_chef.locale
#
jQuery ->
  # When using rails we need to setup the csrf token.
  $.ajaxSetup headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')}


# Scratch pad / regression testing
jQuery ->
  window.editor = new Mercury.Editor()
  editor.appendTo(document.body)
