# Mercury / dependencies.
#= require mercury/dependencies
#= require mercury/mercury
#
# Configuration.
#= require mercury/config
#
# Locales.
#= require mercury/locales/swedish_chef.locale

jQuery ->
  # When using rails we need to setup the csrf token.
  $.ajaxSetup headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')}


# Scratch pad / regression testing
jQuery ->
  window.editor = new Mercury.Editor()
  editor.appendTo(document.body)

  uploader = $('#uploader')
  uploader.on 'dragenter', (e) -> e.preventDefault()
  uploader.on 'dragover', (e) -> e.preventDefault()
  uploader.on 'drop', (e) ->
    if e.originalEvent.dataTransfer.files.length
      e.preventDefault()
      uploader = new Mercury.Uploader(e.originalEvent.dataTransfer.files)
