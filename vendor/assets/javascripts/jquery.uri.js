(function($) {
  $.uri = function(uri) {
    var parts = uri.match(/^((http[s]?|ftp):\/\/)?(((.+)@)?([^:\/\?#\s]+)(:(\d+))?)?(\/?[^\?#]+)?(\?([^#]+))?(#(.*))?$/i);
    parts = {scheme: parts[2], credentials: parts[5], host: parts[6], port: parts[8], path: parts[9], query: parts[11], hash: parts[13]};
    var out = {};
    out.uri = uri;
    out.scheme = (parts.scheme === undefined) ? window.location.protocol.toString().match(/^([a-z]+)/i)[1] : parts.scheme;
    out.host = (parts.host === undefined) ? (document.domain) ? document.domain : 'localhost' : parts.host;
    out.port = (parts.port === undefined) ? 80 : parts.port;
    out.credentials = (parts.credentials === undefined) ? false : parts.credentials.split(':');
    out.path = (parts.path === undefined) ? (window.location.pathname) ? window.location.pathname : '' : (parts.path == '') ? '/' : parts.path;
    out.query = (parts.query === undefined) ? (window.location.search) ? window.location.search.replace('?', '') : '' : parts.query;
    out.hash = (parts.hash === undefined) ? (window.location.hash) ? window.location.hash.replace('#') : '' : parts.hash;
    out.args = {};
    out.query.replace(/([^&=]*)=([^&=]*)/g, function (m, attr, value) {
      if (out.args[attr] === undefined) {
        out.args[attr] = value;
      } else {
        if (typeof(out.args[attr]) != 'object') out.args[attr] = [out.args[attr]];
        out.args[attr].push(value);
      }
    });
    return out;
  };
})(jQuery);