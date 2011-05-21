#Mercury.websocket =
#
#  websocket: $.websocket("ws://#{$.uri(window.location.href).host}:8081")
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
#    $.websocketSettings[eventName] = callback

#window.socket = $.websocket(, {
#  lock: (element) ->
#    $('#' + element).attr('disabled', true);
#
#  unlock: (element) ->
#    $('#' + element).attr('disabled', false);
#
#  chat: (element) ->
#    $('#chat').get(0).innerHTML += message + "<br/>";
#});
#
#$(document).ready ->
#
#  $('.shared').bind 'focus', -> window.socket.send({"lock": this.id})
#
#  $('.shared').bind 'blur', -> window.socket.send({"unlock": this.id})
#
#  $('.shared').bind 'keypress', (e) ->
#    window.socket.send({chat: $(this).val()}) if (e.charCode == 13)
