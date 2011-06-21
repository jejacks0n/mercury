#Mercury.websocket =
#
#  websocket: jQuery.websocket("ws://#{jQuery.uri(window.location.href).host}:8081")
#
#
#  send: (eventName, options) ->
#    package = {}
#    package[eventName] = options
#    @websocket.send(package)
#
#
#  bind: (eventName, callback) ->
#    # todo: this will override any that are already set -- callbacks should be an array that we can push onto
#    jQuery.websocketSettings[eventName] = callback

#window.socket = jQuery.websocket(, {
#  lock: (element) ->
#    jQuery('#' + element).attr('disabled', true);
#
#  unlock: (element) ->
#    jQuery('#' + element).attr('disabled', false);
#
#  chat: (element) ->
#    jQuery('#chat').get(0).innerHTML += message + "<br/>";
#});
#
#jQuery(document).ready ->
#
#  jQuery('.shared').bind 'focus', -> window.socket.send({"lock": this.id})
#
#  jQuery('.shared').bind 'blur', -> window.socket.send({"unlock": this.id})
#
#  jQuery('.shared').bind 'keypress', (e) ->
#    window.socket.send({chat: jQuery(this).val()}) if (e.charCode == 13)
