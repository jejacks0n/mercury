# mercury init
$(window).on 'mercury:ready', ->
  Mercury.saveUrl = '/mercury/update'

$(window).bind 'mercury:saved', ->
  window.location = window.location.href.replace(/\/editor\//i, '/')