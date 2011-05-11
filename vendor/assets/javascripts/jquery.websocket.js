/*
 * jQuery Web Sockets Plugin v0.0.1
 * http://code.google.com/p/jquery-websocket/
 *
 * This document is licensed as free software under the terms of the
 * MIT License: http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright (c) 2010 by shootaroo (Shotaro Tsubouchi).
 */
(function($){
  $.websocketSettings = {
    open: function(){},
    close: function(){},
    message: function(){},
    options: {},
    events: {}
  };

  $.websocket = function(url, s) {
    var ws = WebSocket ? new WebSocket(url) : {
      send: function() { return false },
      close: function() {}
    };

    $(ws).bind('open', $.websocketSettings.open);
    $(ws).bind('close', $.websocketSettings.close);
    $(ws).bind('message', $.websocketSettings.message);
    $(ws).bind('message', function(e) {
      var json = $.evalJSON(e.originalEvent.data);

      if (json['wsinitialize']) {
        this.sid = json['wsinitialize'];
        return;
      }

      if (json['sid'] == this.sid) return;

      for (var action in json.message) {
        var f = $.websocketSettings[action];
        if (f) f.call(this, json.message[action]);
      }
    });

    ws._settings = $.extend($.websocketSettings, s);
    ws._send = ws.send;
    ws.send = function(m) {
      return this._send($.toJSON(m));
    };

    $(window).unload(function() {
      ws.close();
      ws = null;
    });

    return ws;
  };
})(jQuery);
