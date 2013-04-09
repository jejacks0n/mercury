
/*!
Mercury Editor is a Coffeescript and jQuery based WYSIWYG editor released under the MIT License.
Documentation and other useful information can be found at https://github.com/jejacks0n/mercury

Copyright (c) 2013 Jeremy Jackson
*/


(function() {

  this.Mercury || (this.Mercury = {});

  Mercury.configuration = {
    logging: {
      enabled: false,
      notifier: 'console'
    },
    localization: {
      enabled: true,
      preferred: 'en-US'
    },
    uploading: {
      enabled: true,
      saveUrl: '/mercury/uploads',
      saveName: 'file',
      mimeTypes: ['image/jpeg', 'image/gif', 'image/png'],
      maxSize: 5242880
    },
    templates: {
      enabled: true,
      prefixUrl: '/mercury/templates'
    },
    "interface": {
      enabled: true,
      "class": 'FrameInterface',
      toolbar: 'Toolbar',
      statusbar: 'Statusbar',
      silent: false,
      shadowed: false
    },
    toolbars: {
      floating: false,
      style: 'standard',
      primary: {
        save: [
          'Save', {
            title: 'Save this page',
            event: 'save',
            global: true
          }
        ],
        preview: [
          'Preview', {
            title: 'Preview this page',
            mode: 'preview',
            global: true
          }
        ],
        sep1: ' ',
        undo: [
          'Undo', {
            title: 'Undo your last action'
          }
        ],
        redo: [
          'Redo', {
            title: 'Redo your last action'
          }
        ],
        sep2: '-',
        link: [
          'Link', {
            title: 'Insert Link'
          }
        ],
        file: [
          'Media', {
            title: 'Insert Media and Files (images, videos, etc.)'
          }
        ],
        table: [
          'Table', {
            title: 'Insert Table'
          }
        ],
        character: [
          'Character', {
            title: 'Special Characters'
          }
        ],
        snippets: [
          'Snippet', {
            title: 'Snippet Panel'
          }
        ],
        sep3: ' ',
        history: [
          'History', {
            title: 'Page Version History',
            global: true
          }
        ],
        notes: [
          'Notes', {
            title: 'Page Notes',
            global: true
          }
        ]
      }
    },
    regions: {
      attribute: 'data-mercury',
      options: 'data-region-options',
      identifier: 'id',
      gallery: {
        mimeTypes: ['image/jpeg']
      },
      html: {
        mimeTypes: false
      },
      image: {
        mimeTypes: ['image/jpeg']
      },
      markdown: {
        autoSize: true,
        mimeTypes: false,
        wrapping: true,
        sanitize: false,
        breaks: true
      },
      plain: {
        actions: true
      },
      text: {
        autoSize: true,
        stripTags: true,
        wrapping: false
      }
    }
  };

}).call(this);
(function() {

  this.JST || (this.JST = {});

  JST['/mercury/templates/statusbar'] = function(scope) {
    return "<div class=\"mercury-statusbar-about\">\n  <a href=\"https://github.com/jejacks0n/mercury\" target=\"_blank\">Mercury Editor v" + Mercury.version + "</a>\n</div>\n<div class=\"mercury-statusbar-path\"></div>";
  };

}).call(this);
(function() {

  this.JST || (this.JST = {});

  JST['/mercury/templates/uploader'] = function(scope) {
    return "<div class=\"mercury-uploader-dialog\">\n  <div class=\"mercury-uploader-preview\"><b><img/></b></div>\n  <div class=\"mercury-uploader-details\"></div>\n  <div class=\"mercury-uploader-progress\">\n    <span></span>\n    <div class=\"mercury-uploader-indicator\"><div><b>0%</b></div></div>\n  </div>\n</div>";
  };

}).call(this);
(function() {

  this.JST || (this.JST = {});

  JST['/mercury/templates/block_types'] = function(scope) {
    return "<ul>\n</ul>";
  };

}).call(this);
(function() {

  this.JST || (this.JST = {});

  JST['/mercury/templates/color_palette'] = function(scope) {
    return "<ul>\n  <li data-value=\"#FFFFFF\" style=\"background:#FFFFFF\"></li>\n  <li data-value=\"#FFCCCC\" style=\"background:#FFCCCC\"></li>\n  <li data-value=\"#FFCC99\" style=\"background:#FFCC99\"></li>\n  <li data-value=\"#FFFF99\" style=\"background:#FFFF99\"></li>\n  <li data-value=\"#FFFFCC\" style=\"background:#FFFFCC\"></li>\n  <li data-value=\"#99FF99\" style=\"background:#99FF99\"></li>\n  <li data-value=\"#99FFFF\" style=\"background:#99FFFF\"></li>\n  <li data-value=\"#CCFFFF\" style=\"background:#CCFFFF\"></li>\n  <li data-value=\"#CCCCFF\" style=\"background:#CCCCFF\"></li>\n  <li data-value=\"#FFCCFF\" style=\"background:#FFCCFF\"></li>\n  <li data-value=\"#CCCCCC\" style=\"background:#CCCCCC\"></li>\n  <li data-value=\"#FF6666\" style=\"background:#FF6666\"></li>\n  <li data-value=\"#FF9966\" style=\"background:#FF9966\"></li>\n  <li data-value=\"#FFFF66\" style=\"background:#FFFF66\"></li>\n  <li data-value=\"#FFFF33\" style=\"background:#FFFF33\"></li>\n  <li data-value=\"#66FF99\" style=\"background:#66FF99\"></li>\n  <li data-value=\"#33FFFF\" style=\"background:#33FFFF\"></li>\n  <li data-value=\"#66FFFF\" style=\"background:#66FFFF\"></li>\n  <li data-value=\"#9999FF\" style=\"background:#9999FF\"></li>\n  <li data-value=\"#FF99FF\" style=\"background:#FF99FF\"></li>\n  <li data-value=\"#C0C0C0\" style=\"background:#C0C0C0\"></li>\n  <li data-value=\"#FF0000\" style=\"background:#FF0000\"></li>\n  <li data-value=\"#FF9900\" style=\"background:#FF9900\"></li>\n  <li data-value=\"#FFCC66\" style=\"background:#FFCC66\"></li>\n  <li data-value=\"#FFFF00\" style=\"background:#FFFF00\"></li>\n  <li data-value=\"#33FF33\" style=\"background:#33FF33\"></li>\n  <li data-value=\"#66CCCC\" style=\"background:#66CCCC\"></li>\n  <li data-value=\"#33CCFF\" style=\"background:#33CCFF\"></li>\n  <li data-value=\"#6666CC\" style=\"background:#6666CC\"></li>\n  <li data-value=\"#CC66CC\" style=\"background:#CC66CC\"></li>\n  <li data-value=\"#999999\" style=\"background:#999999\"></li>\n  <li data-value=\"#CC0000\" style=\"background:#CC0000\"></li>\n  <li data-value=\"#FF6600\" style=\"background:#FF6600\"></li>\n  <li data-value=\"#FFCC33\" style=\"background:#FFCC33\"></li>\n  <li data-value=\"#FFCC00\" style=\"background:#FFCC00\"></li>\n  <li data-value=\"#33CC00\" style=\"background:#33CC00\"></li>\n  <li data-value=\"#00CCCC\" style=\"background:#00CCCC\"></li>\n  <li data-value=\"#3366FF\" style=\"background:#3366FF\"></li>\n  <li data-value=\"#6633FF\" style=\"background:#6633FF\"></li>\n  <li data-value=\"#CC33CC\" style=\"background:#CC33CC\"></li>\n  <li data-value=\"#666666\" style=\"background:#666666\"></li>\n  <li data-value=\"#990000\" style=\"background:#990000\"></li>\n  <li data-value=\"#CC6600\" style=\"background:#CC6600\"></li>\n  <li data-value=\"#CC9933\" style=\"background:#CC9933\"></li>\n  <li data-value=\"#999900\" style=\"background:#999900\"></li>\n  <li data-value=\"#009900\" style=\"background:#009900\"></li>\n  <li data-value=\"#339999\" style=\"background:#339999\"></li>\n  <li data-value=\"#3333FF\" style=\"background:#3333FF\"></li>\n  <li data-value=\"#6600CC\" style=\"background:#6600CC\"></li>\n  <li data-value=\"#993399\" style=\"background:#993399\"></li>\n  <li data-value=\"#333333\" style=\"background:#333333\"></li>\n  <li data-value=\"#660000\" style=\"background:#660000\"></li>\n  <li data-value=\"#993300\" style=\"background:#993300\"></li>\n  <li data-value=\"#996633\" style=\"background:#996633\"></li>\n  <li data-value=\"#666600\" style=\"background:#666600\"></li>\n  <li data-value=\"#006600\" style=\"background:#006600\"></li>\n  <li data-value=\"#336666\" style=\"background:#336666\"></li>\n  <li data-value=\"#000099\" style=\"background:#000099\"></li>\n  <li data-value=\"#333399\" style=\"background:#333399\"></li>\n  <li data-value=\"#663366\" style=\"background:#663366\"></li>\n  <li data-value=\"#000000\" style=\"background:#000000\"></li>\n  <li data-value=\"#330000\" style=\"background:#330000\"></li>\n  <li data-value=\"#663300\" style=\"background:#663300\"></li>\n  <li data-value=\"#663333\" style=\"background:#663333\"></li>\n  <li data-value=\"#333300\" style=\"background:#333300\"></li>\n  <li data-value=\"#003300\" style=\"background:#003300\"></li>\n  <li data-value=\"#003333\" style=\"background:#003333\"></li>\n  <li data-value=\"#000066\" style=\"background:#000066\"></li>\n  <li data-value=\"#330099\" style=\"background:#330099\"></li>\n  <li data-value=\"#330033\" style=\"background:#330033\"></li>\n  <li class=\"last-picked\">Last Color Picked</li>\n</ul>";
  };

}).call(this);
(function() {

  this.JST || (this.JST = {});

  JST['/mercury/templates/styles_select'] = function(scope) {
    return "<ul>\n  <li class=\"red\" data-value=\"red\">Red Text</li>\n  <li class=\"blue\" data-value=\"blue\">Blue Text</li>\n  <li class=\"highlight\" data-value=\"highlight\">Highlighted</li>\n</ul>";
  };

}).call(this);
(function() {

  Number.prototype.toHex = function() {
    var result;
    result = this.toString(16).toUpperCase();
    if (result[1]) {
      return result;
    } else {
      return "0" + result;
    }
  };

  Number.prototype.toBytes = function() {
    var bytes, i, measures;
    measures = ['', ' kb', ' Mb', ' Gb', ' Tb', ' Pb', ' Eb'];
    bytes = parseInt(this);
    i = 0;
    while (1023 < bytes) {
      bytes /= 1024;
      i += 1;
    }
    if (i) {
      return "" + (bytes.toFixed(2)) + measures[i];
    } else {
      return "" + bytes + " bytes";
    }
  };

}).call(this);
(function() {

  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, '');
  };

  String.prototype.toCamelCase = function(first) {
    if (first == null) {
      first = false;
    }
    if (first) {
      return this.toTitleCase().replace(/([\-|_][a-z])/g, function($1) {
        return $1.toUpperCase().replace(/[\-|_]/, '');
      });
    } else {
      return this.replace(/([\-|_][a-z])/g, function($1) {
        return $1.toUpperCase().replace(/[\-|_]/, '');
      });
    }
  };

  String.prototype.toDash = function() {
    return this.replace(/([A-Z])/g, function($1) {
      return "-" + ($1.toLowerCase());
    }).replace(/^-+|-+$/g, '');
  };

  String.prototype.toUnderscore = function() {
    return this.replace(/([A-Z])/g, function($1) {
      return "_" + ($1.toLowerCase());
    }).replace(/^_+|_+$/g, '');
  };

  String.prototype.toTitleCase = function() {
    return this[0].toUpperCase() + this.slice(1);
  };

  String.prototype.toHex = function() {
    if (this[0] === '#') {
      return this.toString();
    }
    return this.replace(/rgb(a)?\(([0-9|%]+)[\s|,]?\s?([0-9|%]+)[\s|,]?\s?([0-9|%]+)[\s|,]?\s?([0-9|.|%]+\s?)?\)/gi, function(x, alpha, r, g, b, a) {
      return "#" + (parseInt(r).toHex()) + (parseInt(g).toHex()) + (parseInt(b).toHex());
    });
  };

  String.prototype.regExpEscape = function() {
    var escaped, specials;
    specials = ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'];
    escaped = new RegExp('(\\' + specials.join('|\\') + ')', 'g');
    return this.replace(escaped, '\\$1');
  };

  String.prototype.printf = function() {
    var arg, chunk, chunks, index, offset, p, re, result, _i, _len;
    chunks = this.split('%');
    result = chunks[0];
    re = /^([sdf])([\s\S%]*)$/;
    offset = 0;
    for (index = _i = 0, _len = chunks.length; _i < _len; index = ++_i) {
      chunk = chunks[index];
      p = re.exec(chunk);
      if (index === 0 || !p || arguments[index] === null) {
        if (index > 1) {
          offset += 2;
          result += "%" + chunk;
        }
        continue;
      }
      arg = arguments[(index - 1) - offset];
      switch (p[1]) {
        case 's':
          result += arg;
          break;
        case 'd':
        case 'i':
          result += parseInt(arg.toString(), 10);
          break;
        case 'f':
          result += parseFloat(arg);
      }
      result += p[2];
    }
    return result;
  };

}).call(this);
(function() {
  var __slice = [].slice;

  this.Mercury || (this.Mercury = {});

  Mercury.I18n = {
    __locales__: {},
    define: function(name, mapping) {
      return this.__locales__[name] = mapping;
    },
    locale: function() {
      var sub, top, _ref, _ref1, _ref2;
      if (this.__determined__) {
        return this.__determined__;
      }
      if (!((_ref = Mercury.configuration.localization) != null ? _ref.enabled : void 0)) {
        return [{}, {}];
      }
      _ref2 = (this.clientLocale() || ((_ref1 = Mercury.configuration.localization) != null ? _ref1.preferred : void 0)).split('-'), top = _ref2[0], sub = _ref2[1];
      top = this.__locales__[top];
      if (top && sub) {
        sub = top["_" + (sub.toUpperCase()) + "_"];
      }
      return this.__determined__ = [top || {}, sub || {}];
    },
    t: function() {
      var args, source, sub, top, translated, _ref;
      source = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      _ref = Mercury.I18n.locale(), top = _ref[0], sub = _ref[1];
      translated = (sub[source] || top[source] || source || '').toString();
      if (args.length) {
        return translated.printf.apply(translated, args);
      }
      return translated;
    },
    clientLocale: function() {
      var _ref;
      return (_ref = navigator.language) != null ? _ref.toString() : void 0;
    }
  };

  Mercury.I18n.Module = {
    t: Mercury.I18n.t
  };

}).call(this);
(function() {
  var __slice = [].slice;

  this.Mercury || (this.Mercury = {});

  Mercury.Logger = {
    logPrefix: 'Mercury:',
    log: function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (!((_ref = Mercury.configuration.logging) != null ? _ref.enabled : void 0)) {
        return;
      }
      if (this.logPrefix) {
        args.unshift(this.logPrefix);
      }
      return typeof console !== "undefined" && console !== null ? typeof console.debug === "function" ? console.debug.apply(console, args) : void 0 : void 0;
    },
    notify: function(msg) {
      var _ref, _ref1;
      if (this.logPrefix) {
        msg = "" + this.logPrefix + " " + msg;
      }
      if (((_ref = Mercury.configuration.logging) != null ? _ref.notifier : void 0) === 'console') {
        try {
          return console.error(msg);
        } catch (e) {

        }
      } else if (((_ref1 = Mercury.configuration.logging) != null ? _ref1.notifier : void 0) === 'alert') {
        return alert(msg);
      }
      throw new Error(msg);
    }
  };

}).call(this);
(function() {

  this.Mercury || (this.Mercury = {});

  Mercury.Module = (function() {
    var moduleKeywords;

    moduleKeywords = ['included', 'extended', 'private'];

    Module.extend = function(object) {
      var method, module, name, _ref;
      if (!object) {
        throw new Error('extend expects an object');
      }
      module = object.Module || object;
      for (name in module) {
        method = module[name];
        if (moduleKeywords.indexOf(name) > -1) {
          continue;
        }
        this[name] = method;
      }
      return (_ref = module.extended) != null ? _ref.apply(this) : void 0;
    };

    Module.include = function(object) {
      var method, module, name, _ref;
      if (!object) {
        throw new Error('include expects an object');
      }
      module = object.Module || object;
      for (name in module) {
        method = module[name];
        if (moduleKeywords.indexOf(name) > -1) {
          continue;
        }
        this.prototype[name] = method;
      }
      return (_ref = module.included) != null ? _ref.apply(this.prototype) : void 0;
    };

    Module.proxy = function(callback) {
      var _this = this;
      return function() {
        return callback.apply(_this, arguments);
      };
    };

    function Module() {
      this.__handlers__ = $.extend({}, this.__handlers__);
      if (typeof this.init === "function") {
        this.init.apply(this, arguments);
      }
    }

    Module.prototype.proxy = function(callback) {
      var _this = this;
      return function() {
        return callback.apply(_this, arguments);
      };
    };

    return Module;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  this.Mercury || (this.Mercury = {});

  Mercury.Action = (function(_super) {

    __extends(Action, _super);

    Action.include(Mercury.I18n);

    Action.include(Mercury.Logger);

    Action.create = function(name, attrsOrOther) {
      var klass;
      if (attrsOrOther == null) {
        attrsOrOther = {};
      }
      if ($.isPlainObject(attrsOrOther)) {
        klass = name.toCamelCase(true);
        if (Mercury.Action[klass]) {
          return new Mercury.Action[klass](attrsOrOther);
        }
        return new Mercury.Action(name, attrsOrOther);
      } else {
        return attrsOrOther;
      }
    };

    function Action() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.name || (this.name = args.shift());
      this.attributes = args.pop() || {};
      Action.__super__.constructor.apply(this, arguments);
    }

    Action.prototype.get = function(key) {
      return this.attributes[key];
    };

    return Action;

  })(Mercury.Module);

}).call(this);
(function() {
  var __slice = [].slice;

  this.Mercury || (this.Mercury = {});

  Mercury.Config = {
    get: function(path) {
      var config, part, _i, _len, _ref;
      config = Mercury.configuration || (Mercury.configuration = {});
      try {
        if (path) {
          _ref = path.split(':');
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            part = _ref[_i];
            config = config[part];
          }
        }
      } catch (e) {
        return;
      }
      return config;
    },
    set: function() {
      var args, config, merge, part, parts, path, value;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      path = args.shift();
      value = args.pop();
      merge = args.pop();
      if (!value && typeof path === 'object') {
        return Mercury.configuration = path;
      }
      config = Mercury.configuration || (Mercury.configuration = {});
      parts = path.split(':');
      part = parts.shift();
      while (part) {
        if (parts.length === 0) {
          if (merge && typeof config[part] === 'object') {
            config[part] = $.extend(true, config[part], value);
          } else {
            config[part] = value;
          }
          return config[part];
        }
        config = config[part] ? config[part] : config[part] = {};
        part = parts.shift();
      }
    }
  };

  Mercury.Config.Module = {
    config: Mercury.Config.get
  };

}).call(this);
(function() {
  var __slice = [].slice;

  this.Mercury || (this.Mercury = {});

  Mercury.Events = {
    on: function(events, handler) {
      var calls, name, _i, _len;
      events = events.split(' ');
      calls = this.__handlers__ || (this.__handlers__ = {});
      for (_i = 0, _len = events.length; _i < _len; _i++) {
        name = events[_i];
        calls[name] || (calls[name] = []);
        calls[name].push(handler);
      }
      return this;
    },
    one: function(events, handler) {
      return this.on(events, function() {
        this.off(events, arguments.callee);
        return handler.apply(this, arguments);
      });
    },
    off: function(event, handler) {
      var h, i, list, _i, _len, _ref;
      if (!event) {
        this.__handlers__ = {};
        return this;
      }
      if (!(list = (_ref = this.__handlers__) != null ? _ref[event] : void 0)) {
        return this;
      }
      if (!handler) {
        delete this.__handlers__[event];
        return this;
      }
      for (i = _i = 0, _len = list.length; _i < _len; i = ++_i) {
        h = list[i];
        if (!(h === handler)) {
          continue;
        }
        list = list.slice();
        list.splice(i, 1);
        this.__handlers__[event] = list;
        break;
      }
      return this;
    },
    trigger: function() {
      var args, event, handler, list, _i, _len, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      event = args.shift();
      if (typeof this.log === "function") {
        this.log(event, args);
      }
      if (!(list = (_ref = this.__handlers__) != null ? _ref[event] : void 0)) {
        return false;
      }
      for (_i = 0, _len = list.length; _i < _len; _i++) {
        handler = list[_i];
        if (handler.apply(this, args) === false) {
          break;
        }
      }
      return true;
    }
  };

}).call(this);
(function() {

  this.Mercury || (this.Mercury = {});

  Mercury.Stack = {
    included: function() {
      this.stackPosition = 0;
      this.maxStackLength = 200;
      return this.stack = [];
    },
    pushStack: function(value) {
      if (value === null || this.stackEquality(value)) {
        return;
      }
      this.stack = this.stack.slice(0, this.stackPosition + 1);
      this.stack.push(value);
      if (this.stack.length > this.maxStackLength) {
        this.stack.shift();
      }
      return this.stackPosition = this.stack.length - 1;
    },
    stackEquality: function(value) {
      return JSON.stringify(this.stack[this.stackPosition]) === JSON.stringify(value);
    },
    undoStack: function() {
      if (this.stackPosition < 1) {
        return null;
      }
      this.stackPosition -= 1;
      return this.stack[this.stackPosition];
    },
    redoStack: function() {
      if (this.stackPosition >= this.stack.length - 1) {
        return null;
      }
      this.stackPosition += 1;
      return this.stack[this.stackPosition];
    }
  };

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Mercury || (this.Mercury = {});

  Mercury.Model = (function(_super) {

    __extends(Model, _super);

    Model.extend(Mercury.Config);

    Model.extend(Mercury.Events);

    Model.include(Mercury.Config);

    Model.include(Mercury.Events);

    Model.include(Mercury.I18n);

    Model.include(Mercury.Logger);

    Model.include(Mercury.Stack);

    Model.prototype.logPrefix = 'Mercury.Model:';

    Model.idCounter = 1;

    Model.define = function(className, urlPrefix) {
      this.className = className;
      this.urlPrefix = urlPrefix;
      this.logPrefix = this.prototype.logPrefix = "" + this.className + ":";
      this.records = {};
      this.off();
      return this;
    };

    Model.url = function(record) {
      return this.urlPrefix;
    };

    Model.find = function(id) {
      var record;
      record = this.records[id];
      if (!record && ("" + id).match(/^\d+/)) {
        return this.find("c" + id);
      }
      if (!record) {
        throw new Error("" + this.className + " found no records with the ID '" + id + "'");
      }
      return record;
    };

    Model.all = function() {
      var id, record, _ref, _results;
      _ref = this.records;
      _results = [];
      for (id in _ref) {
        record = _ref[id];
        _results.push(record);
      }
      return _results;
    };

    Model.count = function() {
      return this.all().length;
    };

    Model.toJSON = function() {
      return this.all();
    };

    Model.contains = function(id) {
      try {
        return this.find(id);
      } catch (e) {
        return false;
      }
    };

    Model.uid = function(prefix) {
      var uid;
      if (prefix == null) {
        prefix = '';
      }
      uid = prefix + this.idCounter++;
      if (this.contains(uid)) {
        uid = this.uid(prefix);
      }
      return uid;
    };

    function Model(attrs) {
      if (attrs == null) {
        attrs = {};
      }
      this.attributes = {};
      this.errors = {};
      this.set(attrs);
      this.cid = this.constructor.uid('c');
      Model.__super__.constructor.apply(this, arguments);
    }

    Model.prototype.validate = function() {};

    Model.prototype.save = function(options) {
      var defaultOptions,
        _this = this;
      if (options == null) {
        options = {};
      }
      if (!this.isValid()) {
        return false;
      }
      defaultOptions = {
        method: this.isNew() ? 'POST' : 'PUT',
        url: this.constructor.url(this),
        accepts: 'application/json',
        cache: false,
        data: this.toJSON(),
        success: function(json) {
          _this.id = json.id;
          if (_this.id) {
            _this.constructor.records[_this.id] = _this;
          }
          _this.set(json);
          _this.trigger('save');
          return typeof _this.saveSuccess === "function" ? _this.saveSuccess.apply(_this, arguments) : void 0;
        },
        error: function(xhr) {
          _this.trigger('error');
          _this.notify(_this.t('Unable to process response: %s', xhr.status));
          return typeof _this.saveError === "function" ? _this.saveError.apply(_this, arguments) : void 0;
        }
      };
      return $.ajax($.extend(defaultOptions, options));
    };

    Model.prototype.toJSON = function() {
      return $.extend(true, {}, this.attributes);
    };

    Model.prototype.isNew = function() {
      return !this.exists();
    };

    Model.prototype.isValid = function() {
      var name, value, _ref;
      this.errors = {};
      this.validate();
      _ref = this.errors;
      for (name in _ref) {
        value = _ref[name];
        return false;
      }
      return true;
    };

    Model.prototype.addError = function(attr, message) {
      var _base;
      return ((_base = this.errors)[attr] || (_base[attr] = [])).push(message);
    };

    Model.prototype.errorMessages = function() {
      var attr, errors, value, _ref;
      if (this.isValid()) {
        return false;
      }
      errors = [];
      _ref = this.errors;
      for (attr in _ref) {
        value = _ref[attr];
        errors.push("" + (value.join(', ')));
      }
      return errors.join('\n');
    };

    Model.prototype.get = function(key) {
      return this.attributes[key];
    };

    Model.prototype.set = function(key, value) {
      var attrs, _results;
      attrs = {};
      if (typeof key === 'object') {
        attrs = key;
      } else {
        attrs[key] = value;
      }
      this.pushStack(this.toJSON());
      _results = [];
      for (key in attrs) {
        value = attrs[key];
        _results.push(this.attributes[key] = value);
      }
      return _results;
    };

    Model.prototype.exists = function() {
      return this.id && this.id in this.constructor.records;
    };

    return Model;

  })(Mercury.Module);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  this.Mercury || (this.Mercury = {});

  Mercury.View = (function(_super) {

    __extends(View, _super);

    View.include(Mercury.Config);

    View.include(Mercury.Events);

    View.include(Mercury.I18n);

    View.include(Mercury.Logger);

    View.Modules = {};

    View.prototype.logPrefix = 'Mercury.View:';

    View.prototype.eventSplitter = /^(\S+)\s*(.*)$/;

    View.prototype.tag = 'div';

    function View(options) {
      var key, value, _ref;
      this.options = options != null ? options : {};
      _ref = this.options;
      for (key in _ref) {
        value = _ref[key];
        this[key] = value;
      }
      this.buildElement();
      this.elements || (this.elements = this.constructor.elements);
      this.events || (this.events = this.constructor.events);
      if (typeof this.build === "function") {
        this.build();
      }
      this.trigger('build');
      if (this.events) {
        this.delegateEvents(this.events);
      }
      if (this.elements) {
        this.refreshElements();
      }
      View.__super__.constructor.apply(this, arguments);
      this.trigger('init');
    }

    View.prototype.buildElement = function() {
      if (!this.el) {
        this.el = document.createElement(this.tag);
      }
      this.el = $(this.el);
      this.$el = this.el;
      this.attr(this.attributes);
      this.addClass(this.className);
      if (this.template) {
        return this.html(this.renderTemplate(this.template));
      }
    };

    View.prototype.$ = function(selector) {
      return $(selector, this.el);
    };

    View.prototype.addClass = function(className) {
      return this.el.addClass(className);
    };

    View.prototype.attr = function(key, value) {
      if (key && arguments.length === 1) {
        return this.el.attr(key);
      }
      return this.el.attr(key, value);
    };

    View.prototype.html = function(element) {
      if (!arguments.length) {
        return this.el.html();
      }
      this.el.html((element != null ? element.el : void 0) || element);
      this.refreshElements();
      return this.el;
    };

    View.prototype.append = function() {
      var e, elements, _ref;
      elements = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      elements = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = elements.length; _i < _len; _i++) {
          e = elements[_i];
          _results.push(e.el || e);
        }
        return _results;
      })();
      (_ref = this.el).append.apply(_ref, elements);
      this.refreshElements();
      return this.el;
    };

    View.prototype.appendTo = function(element) {
      this.el.appendTo(element.el || element);
      return this.el;
    };

    View.prototype.delay = function(ms, callback) {
      var _this = this;
      return setTimeout((function() {
        return callback.call(_this);
      }), ms);
    };

    View.prototype.refreshElements = function() {
      var key, value, _ref, _results;
      _ref = this.elements;
      _results = [];
      for (key in _ref) {
        value = _ref[key];
        _results.push(this[key] = this.$(value));
      }
      return _results;
    };

    View.prototype.renderTemplate = function(path, options) {
      var template;
      if (options == null) {
        options = null;
      }
      template = JST["/mercury/templates/" + path];
      if (this.config('templates:enabled') && !template) {
        template = this.fetchTemplate(path);
      }
      if (typeof template === 'function') {
        return template(options || this);
      }
      return template;
    };

    View.prototype.fetchTemplate = function(path) {
      var template;
      template = null;
      $.ajax({
        url: [this.config('templates:prefixUrl'), path].join('/'),
        async: false,
        success: function(content) {
          return template = content;
        }
      });
      return template;
    };

    View.prototype.release = function() {
      this.trigger('release');
      this.el.remove();
      return this.off();
    };

    View.prototype.delegateEvents = function(el, events) {
      var event, key, match, method, selector, _ref, _results,
        _this = this;
      if (arguments.length === 1) {
        events = el;
        el = this.el;
      }
      _results = [];
      for (key in events) {
        method = events[key];
        if (typeof method === 'function') {
          method = (function(method) {
            return function() {
              method.apply(_this, arguments);
              return true;
            };
          })(method);
        } else {
          if (method.indexOf(':') > -1) {
            method = method.replace(/^mercury:/, '');
            method = (function(method) {
              return function() {
                Mercury.trigger(method, _this);
                return true;
              };
            })(method);
          } else if (!this[method]) {
            throw new Error("" + method + " doesn't exist");
          } else {
            method = (function(method) {
              return function() {
                _this[method].apply(_this, arguments);
                return true;
              };
            })(method);
          }
        }
        if (key.indexOf(':') > -1) {
          Mercury.on(key.replace(/^mercury:/, ''), method);
          continue;
        }
        _ref = key.match(this.eventSplitter), match = _ref[0], event = _ref[1], selector = _ref[2];
        _results.push(el.on(event, selector || null, method));
      }
      return _results;
    };

    return View;

  })(Mercury.Module);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  this.Mercury || (this.Mercury = {});

  Mercury.Region = (function(_super) {

    __extends(Region, _super);

    Region.extend(Mercury.Config);

    Region.extend(Mercury.Events);

    Region.extend(Mercury.I18n);

    Region.extend(Mercury.Logger);

    Region.include(Mercury.Stack);

    Region.Modules = {};

    Region.supported = true;

    Region.logPrefix = 'Mercury.Region:';

    Region.type = 'unknown';

    Region.defaultActions = {
      undo: 'onUndo',
      redo: 'onRedo'
    };

    Region.define = function(className, type, actions) {
      this.className = className;
      this.type = type;
      if (actions == null) {
        actions = {};
      }
      this.logPrefix = this.prototype.logPrefix = "" + this.className + ":";
      this.prototype.actions = $.extend(this.prototype.actions, actions);
      this.prototype.toolbars = [this.type];
      this.off();
      return this;
    };

    Region.create = function(el) {
      var type;
      el = $(el);
      type = el.attr(this.config('regions:attribute'));
      if (!type) {
        this.notify(this.t('region type not provided'));
      }
      type = ("" + type).toLowerCase().toCamelCase(true);
      if (!Mercury.Region[type]) {
        this.notify(this.t('unknown "%s" region type, falling back to base region', type));
      }
      return new (Mercury.Region[type] || Mercury.Region)(el);
    };

    Region.addAction = function(action, handler) {
      var actions;
      if (typeof action === 'object') {
        actions = action;
      } else {
        actions = {};
        actions[action] = handler;
      }
      return this.actions = $.extend(this.actions || {}, actions);
    };

    Region.addContext = function(context, handler) {
      var contexts;
      if (typeof context === 'object') {
        contexts = context;
      } else {
        contexts = {};
        contexts[context] = handler;
      }
      return this.context = $.extend(this.context || {}, contexts);
    };

    Region.addData = function(attr, handler) {
      var dataAttrs;
      if (typeof attr === 'object') {
        dataAttrs = attr;
      } else {
        dataAttrs = {};
        dataAttrs[attr] = handler;
      }
      return this.dataAttrs = $.extend(this.dataAttrs || {}, dataAttrs);
    };

    Region.addToolbar = function(name, obj) {
      var path;
      if (obj == null) {
        obj = {};
      }
      if (typeof name === 'object') {
        obj = name;
        name = this.type;
      }
      path = name === this.type ? "toolbars:" + name : "toolbars:" + this.type + ":" + name;
      return Mercury.configure(path, obj);
    };

    function Region(el, options) {
      this.el = el;
      this.options = options != null ? options : {};
      if (this.el && $(this.el).data('region')) {
        return false;
      }
      if (!this.constructor.supported) {
        this.notify(this.t('is unsupported in this browser'));
        return false;
      }
      if (this.el.data) {
        this.options = $.extend({}, JSON.parse(this.el.attr(this.config('regions:options')) || '{}'), options);
      }
      this.context = $.extend({}, this.constructor.context, this.context);
      this.dataAttrs = $.extend({}, this.constructor.dataAttrs, this.dataAttrs);
      this.actions || (this.actions = {});
      if (typeof this.beforeBuild === "function") {
        this.beforeBuild();
      }
      Region.__super__.constructor.call(this, this.options);
      if (!this.focusable) {
        this.attr({
          tabindex: 0
        });
      }
      this.name || (this.name = this.el.attr(this.config('regions:identifier')));
      this.previewing || (this.previewing = false);
      this.focused || (this.focused = false);
      this.focusable || (this.focusable = this.el);
      this.skipHistoryOn || (this.skipHistoryOn = ['redo']);
      this.changed || (this.changed = false);
      this.setInitialData();
      if (typeof this.afterBuild === "function") {
        this.afterBuild();
      }
      this.el.data({
        region: this
      });
      if (!this.name) {
        this.notify(this.t('no name provided for the "%s" region, falling back to random', this.constructor.type));
        this.name = "" + this.constructor.type + (Math.floor(Math.random() * 10000));
      }
      this.addRegionClassname();
      if (!this.skipHistoryOnInitialize) {
        this.pushHistory();
      }
      this.bindDefaultEvents();
      this.initialValue = JSON.stringify(this.toJSON());
    }

    Region.prototype.setInitialData = function() {
      var attr, handler, obj, _ref, _results;
      _ref = this.dataAttrs;
      _results = [];
      for (attr in _ref) {
        handler = _ref[attr];
        obj = {};
        obj[attr] = this.el.data(attr) || null;
        _results.push(this.data(obj));
      }
      return _results;
    };

    Region.prototype.addRegionClassname = function() {
      return this.addClass("mercury-" + this.constructor.type + "-region");
    };

    Region.prototype.trigger = function(event) {
      Region.__super__.trigger.apply(this, arguments);
      return Mercury.trigger("region:" + event, this);
    };

    Region.prototype.hasAction = function(action) {
      return !!this.actions[action];
    };

    Region.prototype.hasContext = function(context) {
      if (!this.context[context]) {
        return false;
      }
      return !!this.context[context].call(this, context);
    };

    Region.prototype.handleAction = function(name, options) {
      var action, _ref;
      if (options == null) {
        options = {};
      }
      if (!this.focused || this.previewing) {
        return;
      }
      if (!(this.skipHistoryOn.indexOf(name) > -1)) {
        this.pushHistory();
      }
      action = Mercury.Action.create(name, options);
      if ((_ref = this.actions[name]) != null) {
        _ref.call(this, action);
      }
      this.trigger('action', action);
      return true;
    };

    Region.prototype.handleMode = function() {
      var args, mode, _name;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      mode = args.shift();
      return typeof this[_name = ("toggle_" + mode).toCamelCase()] === "function" ? this[_name].apply(this, args) : void 0;
    };

    Region.prototype.togglePreview = function() {
      this.previewing = !this.previewing;
      this.trigger('preview', this.previewing);
      if (this.previewing) {
        this.blur();
        this.focusable.removeAttr('tabindex');
      } else {
        this.focusable.attr({
          tabindex: 0
        });
      }
      return typeof this.onTogglePreview === "function" ? this.onTogglePreview() : void 0;
    };

    Region.prototype.pushHistory = function(keyCode) {
      var knownKeyCode, pushNow,
        _this = this;
      if (keyCode == null) {
        keyCode = null;
      }
      if (keyCode) {
        knownKeyCode = [13, 46, 8].indexOf(keyCode);
      }
      if (keyCode === null || (knownKeyCode >= 0 && knownKeyCode !== this.lastKeyCode)) {
        pushNow = true;
      }
      this.lastKeyCode = knownKeyCode;
      clearTimeout(this.historyTimeout);
      if (pushNow) {
        return this.pushStack(this.toStack());
      } else {
        return this.historyTimeout = this.delay(2500, function() {
          return _this.pushStack(_this.toStack());
        });
      }
    };

    Region.prototype.focus = function() {
      this.focused = true;
      this.focusable.focus();
      return typeof this.onFocus === "function" ? this.onFocus() : void 0;
    };

    Region.prototype.blur = function() {
      this.focused = false;
      this.focusable.blur();
      return typeof this.onBlur === "function" ? this.onBlur() : void 0;
    };

    Region.prototype.value = function(value) {
      if (value == null) {
        value = null;
      }
      if (value === null || typeof value === 'undefined') {
        return this.html();
      } else {
        return this.html(value);
      }
    };

    Region.prototype.data = function(key, value) {
      var data, obj;
      if (typeof key === 'string' && arguments.length === 1 || arguments.length === 0) {
        data = this.el.data(key);
        if (arguments.length === 0) {
          data = $.extend({}, data);
          delete data.region;
          delete data.mercury;
        }
        return data != null ? data : null;
      }
      obj = key;
      if (typeof key === 'string') {
        obj = {};
        obj[key] = value;
      }
      this.setData(obj);
      return this.el;
    };

    Region.prototype.setData = function(obj) {
      var attr, value, _ref, _results;
      this.el.data(obj);
      _results = [];
      for (attr in obj) {
        value = obj[attr];
        _results.push((_ref = this.dataAttrs[attr]) != null ? typeof _ref.call === "function" ? _ref.call(this, value) : void 0 : void 0);
      }
      return _results;
    };

    Region.prototype.snippets = function() {
      return {};
    };

    Region.prototype.hasChanges = function() {
      return this.changed || this.initialValue !== JSON.stringify(this.toJSON());
    };

    Region.prototype.onSave = function() {
      this.initialValue = JSON.stringify(this.toJSON());
      return this.changed = false;
    };

    Region.prototype.onUndo = function() {
      return this.fromStack(this.undoStack());
    };

    Region.prototype.onRedo = function() {
      return this.fromStack(this.redoStack());
    };

    Region.prototype.toStack = function() {
      return this.toJSON();
    };

    Region.prototype.fromStack = function(val) {
      if (val) {
        return this.fromJSON(val);
      }
    };

    Region.prototype.toJSON = function(forSave) {
      if (forSave == null) {
        forSave = false;
      }
      return {
        name: this.name,
        type: this.constructor.type,
        value: this.value(),
        data: this.data(),
        snippets: this.snippets()
      };
    };

    Region.prototype.fromJSON = function(json) {
      if (typeof json === 'string') {
        json = JSON.parse(json);
      }
      if (json.value) {
        this.value(json.value);
      }
      if (json.data) {
        return this.data(json.data);
      }
    };

    Region.prototype.release = function() {
      this.el.data({
        region: null
      });
      this.el.removeClass("mercury-" + this.constructor.type + "-region");
      this.focusable.removeAttr('tabindex');
      this.trigger('release');
      this.el.off();
      this.focusable.off();
      this.off();
      return this.blur();
    };

    Region.prototype.bindDefaultEvents = function() {
      var _this = this;
      Mercury.on('action', function() {
        return _this.handleAction.apply(_this, arguments);
      });
      Mercury.on('mode', function() {
        return _this.handleMode.apply(_this, arguments);
      });
      Mercury.on('save', function() {
        return _this.onSave();
      });
      this.delegateActions($.extend(true, this.constructor.actions, this.constructor.defaultActions, this.actions || (this.actions = {})));
      this.bindFocusEvents();
      this.bindKeyEvents();
      this.bindMouseEvents();
      if (this.onDropFile || this.onDropItem) {
        return this.bindDropEvents();
      }
    };

    Region.prototype.bindFocusEvents = function() {
      var _this = this;
      return this.delegateEvents(this.focusable, {
        focus: function() {
          _this.focused = true;
          _this.trigger('focus');
          return typeof _this.onFocus === "function" ? _this.onFocus() : void 0;
        },
        blur: function() {
          _this.focused = false;
          _this.trigger('blur');
          return typeof _this.onBlur === "function" ? _this.onBlur() : void 0;
        }
      });
    };

    Region.prototype.bindKeyEvents = function() {
      var _this = this;
      return this.delegateEvents(this.focusable, {
        keyup: function() {
          return _this.trigger('update');
        },
        keydown: function(e) {
          if (!(e.metaKey && e.keyCode === 90)) {
            return;
          }
          e.preventDefault();
          if (e.shiftKey) {
            return _this.handleAction('redo');
          } else {
            return _this.handleAction('undo');
          }
        }
      });
    };

    Region.prototype.bindMouseEvents = function() {
      var _this = this;
      return this.delegateEvents(this.focusable, {
        mouseup: function() {
          return _this.trigger('update');
        }
      });
    };

    Region.prototype.bindDropEvents = function() {
      var _this = this;
      return this.delegateEvents(this.el, {
        dragenter: function(e) {
          return e.preventDefault();
        },
        dragover: function(e) {
          if (!(_this.editableDropBehavior && Mercury.support.webkit)) {
            return e.preventDefault();
          }
        },
        drop: function(e) {
          var data;
          if (_this.previewing) {
            return;
          }
          data = e.originalEvent.dataTransfer;
          if (data.files.length && _this.onDropFile) {
            e.preventDefault();
            return _this.onDropFile(data.files);
          } else if (_this.onDropItem) {
            return _this.onDropItem(e, data);
          }
        }
      });
    };

    Region.prototype.delegateActions = function(actions) {
      var key, method, _results;
      _results = [];
      for (key in actions) {
        method = actions[key];
        if (typeof method !== 'function') {
          if (!this[method]) {
            throw new Error("" + method + " doesn't exist");
          }
          method = this[method];
        }
        _results.push(this.actions[key] = method);
      }
      return _results;
    };

    return Region;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.BaseInterface = (function(_super) {

    __extends(BaseInterface, _super);

    BaseInterface.prototype.logPrefix = 'Mercury.BaseInterface:';

    BaseInterface.prototype.tag = 'mercury';

    BaseInterface.prototype.events = {
      'mousedown': 'focusActiveRegion',
      'focusout': 'focusActiveRegion',
      'mercury:focus': 'focusActiveRegion',
      'region:focus': 'onRegionFocus',
      'region:release': 'onRegionRelease',
      'mercury:reinitialize': 'reinitialize'
    };

    function BaseInterface() {
      var _this = this;
      if (parent !== window && parent.Mercury) {
        this.log(this.t('is already defined in parent frame'));
        return;
      }
      BaseInterface.__super__.constructor.apply(this, arguments);
      this.regions || (this.regions = []);
      $(window).on('beforeunload', function() {
        return _this.onUnload();
      });
      this.initialize();
      this.buildInterface();
      this.bindDefaultEvents();
      this.el.removeClass('loading');
      Mercury.trigger('initialized');
    }

    BaseInterface.prototype.build = function() {
      if (!this.el) {
        this.el = document.createElement(this.tag);
      }
      this.el = $(this.el);
      this.$el = this.el;
      this.attr(this.attributes);
      return this.addClass(this.className);
    };

    BaseInterface.prototype.init = function() {
      $('body').before(this.el);
      this.makeShadowed();
      if (this.template) {
        this.html(this.renderTemplate(this.template));
      }
      return this.addClass('loading');
    };

    BaseInterface.prototype.initialize = function() {
      return this.addAllRegions();
    };

    BaseInterface.prototype.reinitialize = function() {
      this.initialize();
      return this.focusActiveRegion();
    };

    BaseInterface.prototype.buildInterface = function() {
      this.buildToolbar();
      this.buildStatusbar();
      return this.focusDefaultRegion();
    };

    BaseInterface.prototype.makeShadowed = function() {
      if (!(this.config('interface:shadowed') && this.el.get(0).webkitCreateShadowRoot)) {
        return;
      }
      this.shadow = $(this.el.get(0).webkitCreateShadowRoot());
      this.shadow.get(0).applyAuthorStyles = true;
      this.shadow.append(this.el = $(document.createElement(this.tag)));
      return this.$el = this.el;
    };

    BaseInterface.prototype.buildToolbar = function() {
      var klass;
      if (!(klass = this.config('interface:toolbar'))) {
        return;
      }
      this.append(this.toolbar = new Mercury[klass]());
      if (!this.config('interface:enabled')) {
        return this.toolbar.hide();
      }
    };

    BaseInterface.prototype.buildStatusbar = function() {
      var klass;
      if (!(klass = this.config('interface:statusbar'))) {
        return;
      }
      this.append(this.statusbar = new Mercury[klass]());
      if (!this.config('interface:enabled')) {
        return this.statusbar.hide();
      }
    };

    BaseInterface.prototype.bindDefaultEvents = function() {
      var _this = this;
      Mercury.on('mode', function(mode) {
        return _this.setMode(mode);
      });
      Mercury.on('action', function() {
        return _this.focusActiveRegion();
      });
      return $('body').on('mousedown', function() {
        return Mercury.trigger('dialogs:hide');
      });
    };

    BaseInterface.prototype.focusDefaultRegion = function() {
      return this.delay(100, this.focusActiveRegion);
    };

    BaseInterface.prototype.addAllRegions = function() {
      var el, _i, _len, _ref;
      _ref = this.regionElements();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        el = _ref[_i];
        this.addRegion(el);
      }
      this.region || (this.region = this.regions[0]);
      if (!this.config('interface:enabled')) {
        return Mercury.trigger('mode', 'preview');
      }
    };

    BaseInterface.prototype.regionElements = function() {
      return $("[" + (this.config('regions:attribute')) + "]", this.document);
    };

    BaseInterface.prototype.addRegion = function(el) {
      var region;
      if ($(el).data('region')) {
        return;
      }
      region = Mercury.Region.create(el);
      return this.regions.push(region);
    };

    BaseInterface.prototype.focusActiveRegion = function(e) {
      var _ref;
      if (e != null) {
        if (typeof e.preventDefault === "function") {
          e.preventDefault();
        }
      }
      return (_ref = this.region) != null ? _ref.focus() : void 0;
    };

    BaseInterface.prototype.setMode = function(mode) {
      this["" + mode + "Mode"] = !this["" + mode + "Mode"];
      return this.focusActiveRegion();
    };

    BaseInterface.prototype.toggleInterface = function() {
      var _ref;
      if ((_ref = this.interfaceHidden) == null) {
        this.interfaceHidden = this.config('interface:enabled');
      }
      this.interfaceHidden = !this.interfaceHidden;
      if (this.interfaceHidden) {
        Mercury.trigger('interface:show');
        if (this.previewMode) {
          return Mercury.trigger('mode', 'preview');
        }
      } else {
        Mercury.trigger('interface:hide');
        if (!this.previewMode) {
          return Mercury.trigger('mode', 'preview');
        }
      }
    };

    BaseInterface.prototype.onRegionFocus = function(region) {
      return this.region = region;
    };

    BaseInterface.prototype.onRegionRelease = function(region) {
      var index;
      if (region === this.region) {
        this.region = this.regions[0];
      }
      index = this.regions.indexOf(region);
      if (index > -1) {
        return this.regions.splice(index, 1);
      }
    };

    BaseInterface.prototype.onUnload = function() {
      if (this.config('interface:silent') || !this.hasChanges()) {
        return null;
      }
      return this.t('You have unsaved changes.  Are you sure you want to leave without saving them first?');
    };

    BaseInterface.prototype.hasChanges = function() {
      var region, _i, _len, _ref;
      _ref = this.regions;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        region = _ref[_i];
        if (region.hasChanges()) {
          return true;
        }
      }
      return false;
    };

    BaseInterface.prototype.release = function() {
      this.toolbar.release();
      this.statusbar.release();
      while (this.regions.length) {
        this.regions.shift().release();
      }
      return BaseInterface.__super__.release.apply(this, arguments);
    };

    BaseInterface.prototype.save = function() {
      var data, region, _i, _len, _ref;
      data = {};
      _ref = this.regions;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        region = _ref[_i];
        data[region.name] = region.toJSON(true);
      }
      return data;
    };

    return BaseInterface;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.FrameInterface = (function(_super) {

    __extends(FrameInterface, _super);

    function FrameInterface() {
      return FrameInterface.__super__.constructor.apply(this, arguments);
    }

    FrameInterface.prototype.logPrefix = 'Mercury.FrameInterface:';

    FrameInterface.prototype.className = 'mercury-frame-interface';

    FrameInterface.prototype.initialize = function() {
      this.frame = $(this.frame).addClass('mercury-frame-interface-frame');
      if (!this.frame.length) {
        this.initialized = true;
        return FrameInterface.__super__.initialize.apply(this, arguments);
      }
    };

    FrameInterface.prototype.reinitialize = function() {
      if (this.frame.length) {
        this.initialized = false;
        return this.initializeFrame();
      } else {
        return FrameInterface.__super__.reinitialize.apply(this, arguments);
      }
    };

    FrameInterface.prototype.bindDefaultEvents = function() {
      var _this = this;
      this.frame.on('load', function() {
        return _this.initializeFrame();
      });
      Mercury.on('initialize', function() {
        return _this.initializeFrame();
      });
      return FrameInterface.__super__.bindDefaultEvents.apply(this, arguments);
    };

    FrameInterface.prototype.bindDocumentEvents = function() {
      return $('body', this.document).on('mousedown', function() {
        return Mercury.trigger('dialogs:hide');
      });
    };

    FrameInterface.prototype.initializeFrame = function() {
      if (this.initialized) {
        return;
      }
      this.initialized = true;
      this.setupDocument();
      this.bindDocumentEvents();
      this.addAllRegions();
      return Mercury.trigger('initialized');
    };

    FrameInterface.prototype.setupDocument = function() {
      var contentWindow;
      contentWindow = this.frame.get(0).contentWindow;
      contentWindow.Mercury = Mercury;
      return this.document = $(contentWindow.document);
    };

    return FrameInterface;

  })(Mercury.BaseInterface);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Statusbar = (function(_super) {

    __extends(Statusbar, _super);

    function Statusbar() {
      return Statusbar.__super__.constructor.apply(this, arguments);
    }

    Statusbar.prototype.logPrefix = 'Mercury.Statusbar:';

    Statusbar.prototype.className = 'mercury-statusbar';

    Statusbar.prototype.template = 'statusbar';

    Statusbar.prototype.events = {
      'region:update': 'onRegionUpdate',
      'interface:hide': 'hide',
      'interface:show': 'show'
    };

    Statusbar.prototype.elements = {
      path: '.mercury-statusbar-path'
    };

    Statusbar.prototype.build = function() {
      return this.setPath();
    };

    Statusbar.prototype.setPath = function(path) {
      var el, _i, _len, _results;
      if (path == null) {
        path = [];
      }
      this.path.html("<b>" + (this.t('Path:')) + " </b>");
      _results = [];
      for (_i = 0, _len = path.length; _i < _len; _i++) {
        el = path[_i];
        this.path.append(el);
        if (el !== path[path.length - 1]) {
          _results.push(this.path.append(' &raquo; '));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Statusbar.prototype.onRegionUpdate = function(region) {
      var path;
      if (path = typeof region.path === "function" ? region.path() : void 0) {
        return this.setPath(path);
      }
    };

    Statusbar.prototype.hide = function() {
      var _this = this;
      clearTimeout(this.visibilityTimeout);
      this.visible = false;
      this.el.css({
        bottom: -this.el.height()
      });
      return this.visibilityTimeout = this.delay(250, function() {
        return _this.el.hide();
      });
    };

    Statusbar.prototype.show = function() {
      var _this = this;
      clearTimeout(this.visibilityTimeout);
      this.visible = true;
      this.el.show();
      return this.visibilityTimeout = this.delay(1, function() {
        return _this.el.css({
          bottom: 0
        });
      });
    };

    return Statusbar;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Toolbar = (function(_super) {

    __extends(Toolbar, _super);

    function Toolbar() {
      return Toolbar.__super__.constructor.apply(this, arguments);
    }

    Toolbar.prototype.logPrefix = 'Mercury.Toolbar:';

    Toolbar.prototype.className = 'mercury-toolbar';

    Toolbar.prototype.events = {
      'mousedown': 'dialogs:hide',
      'interface:hide': 'hide',
      'interface:show': 'show',
      'region:focus': 'onRegionFocus'
    };

    Toolbar.prototype.elements = {
      toolbar: '.mercury-toolbar-secondary-container'
    };

    Toolbar.prototype.build = function() {
      this.append(new Mercury.ToolbarItem('primary', 'container', this.config("toolbars:primary")));
      return this.append(new Mercury.ToolbarItem('secondary', 'container', {}));
    };

    Toolbar.prototype.hide = function() {
      var _this = this;
      clearTimeout(this.visibilityTimeout);
      this.visible = false;
      this.el.css({
        top: -this.el.height()
      });
      return this.visibilityTimeout = this.delay(250, function() {
        return _this.el.hide();
      });
    };

    Toolbar.prototype.show = function() {
      var _this = this;
      clearTimeout(this.visibilityTimeout);
      this.visible = true;
      this.el.show();
      return this.visibilityTimeout = this.delay(1, function() {
        return _this.el.css({
          top: 0
        });
      });
    };

    Toolbar.prototype.onRegionFocus = function(region) {
      var name, _i, _len, _ref;
      if (this.region === region) {
        return;
      }
      this.region = region;
      this.$('.mercury-toolbar-collection').remove();
      _ref = region.toolbars || [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        name = _ref[_i];
        this.buildToolbar(name);
      }
      return Mercury.trigger('region:update', region);
    };

    Toolbar.prototype.buildToolbar = function(name) {
      var toolbar;
      toolbar = new Mercury.ToolbarItem(name, 'collection', this.config("toolbars:" + name));
      toolbar.appendTo(this.toolbar);
      return toolbar;
    };

    Toolbar.icons = {
      save: '!',
      preview: '"',
      undo: '#',
      redo: '$',
      link: '%',
      file: '&',
      table: "'",
      character: '(',
      snippets: ')',
      history: '*',
      notes: '+',
      upload: ',',
      search: '-',
      bold: 'C',
      italic: 'D',
      strike: 'E',
      underline: 'F',
      subscript: 'G',
      superscript: 'H',
      justifyLeft: 'I',
      justifyCenter: 'J',
      justifyRight: 'K',
      justifyFull: 'L',
      unorderedList: 'M',
      orderedList: 'N',
      indent: 'P',
      outdent: 'O',
      rule: 'Q',
      clean: 'R',
      edit: 'S',
      rowBefore: 'T',
      rowAfter: 'U',
      rowDelete: 'V',
      colBefore: 'W',
      colAfter: 'X',
      colDelete: 'Y',
      colIncrease: 'Z',
      colDecrease: 'a',
      rowIncrease: 'b',
      rowDecrease: 'c',
      h1: 'q',
      h2: 'r',
      h3: 's',
      h4: 't',
      h5: 'u',
      h6: 'v',
      removeHeading: 'w',
      blockquote: 'm',
      pre: 'S',
      crop: 'e',
      resize: 'f',
      alignLeft: 'g',
      alignRight: 'h',
      alignTop: 'i',
      alignMiddle: 'j',
      alignBottom: 'k',
      alignNone: 'l',
      prev: 'n',
      next: 'o',
      remove: 'R',
      togglePlay: 'p'
    };

    return Toolbar;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  Mercury.ToolbarItem = (function(_super) {

    __extends(ToolbarItem, _super);

    ToolbarItem.prototype.logPrefix = 'Mercury.ToolbarItem:';

    function ToolbarItem(name, type, value) {
      this.name = name;
      this.type = type;
      this.value = value;
      this.items = [];
      ToolbarItem.__super__.constructor.call(this);
    }

    ToolbarItem.prototype.build = function() {
      var item, name, value, _ref;
      this.addClasses();
      if (typeof this.value !== 'object') {
        return;
      }
      _ref = this.value;
      for (name in _ref) {
        value = _ref[name];
        item = (function() {
          switch (($.isArray(value) ? 'array' : typeof value)) {
            case 'object':
              return new Mercury.ToolbarItem(name, 'group', value);
            case 'string':
              return new Mercury.ToolbarItem(name, 'separator', value);
            case 'array':
              return (function(func, args, ctor) {
                ctor.prototype = func.prototype;
                var child = new ctor, result = func.apply(child, args);
                return Object(result) === result ? result : child;
              })(Mercury.ToolbarButton.create, [name].concat(__slice.call(value)), function(){});
          }
        })();
        this.items.push(item);
        if (item) {
          this.append(item);
        }
      }
      if (this.type === 'group') {
        return this.append(new Mercury.ToolbarItem('sep_final', 'separator', '-'));
      }
    };

    ToolbarItem.prototype.addClasses = function() {
      var extraClass;
      extraClass = "mercury-toolbar-" + (this.type.toDash());
      if (this.value === '-') {
        extraClass = "mercury-toolbar-line-" + (this.type.toDash());
      }
      return this.addClass(["mercury-toolbar-" + (this.name.toDash()) + "-" + (this.type.toDash()), extraClass].join(' '));
    };

    return ToolbarItem;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  Mercury.ToolbarButton = (function(_super) {

    __extends(ToolbarButton, _super);

    ToolbarButton.prototype.logPrefix = 'Mercury.ToolbarButton:';

    ToolbarButton.prototype.className = 'mercury-toolbar-button';

    ToolbarButton.prototype.events = {
      'mousedown': function(e) {
        if (this.subView && this.subView.visible) {
          e.stopPropagation();
        }
        return this.addClass('mercury-button-pressed');
      },
      'mouseup': function() {
        return this.el.removeClass('mercury-button-pressed');
      },
      'mouseout': function() {
        return this.el.removeClass('mercury-button-pressed');
      },
      'click': 'triggerAction',
      'region:focus': 'onRegionFocus',
      'region:action': 'onRegionUpdate',
      'region:update': 'onRegionUpdate'
    };

    ToolbarButton.prototype.standardOptions = ['title', 'icon', 'action', 'global', 'button'];

    ToolbarButton.create = function(name, label, options) {
      var Klass;
      if (options == null) {
        options = {};
      }
      if (options.button && (Klass = Mercury[("toolbar_" + options.button).toCamelCase(true)])) {
        return new Klass(name, label, options);
      }
      return new Mercury.ToolbarButton(name, label, options);
    };

    function ToolbarButton(name, label, options) {
      this.name = name;
      this.label = label;
      this.options = options != null ? options : {};
      this.action = this.determineAction();
      this.actionName = this.determineActionName();
      this.type = this.determineType();
      ToolbarButton.__super__.constructor.call(this, this.options);
    }

    ToolbarButton.prototype.build = function() {
      var _ref;
      this.attr('data-type', this.type);
      this.attr('data-icon', Mercury.Toolbar.icons[this.icon || this.name] || this.icon);
      this.addClass("mercury-toolbar-" + (this.name.toDash()) + "-button");
      this.html("<em>" + this.label + "</em>");
      return (_ref = this.buildSubView()) != null ? _ref.appendTo(this) : void 0;
    };

    ToolbarButton.prototype.buildSubView = function() {
      var Klass, options;
      if (Klass = Mercury[("toolbar_" + this.type).toCamelCase(true)]) {
        options = this.options[this.type];
        if (typeof options === 'string') {
          options = {
            template: options
          };
        }
        return this.subView = new Klass(options);
      }
    };

    ToolbarButton.prototype.determineAction = function() {
      var action;
      action = this.options.action || this.name;
      if (typeof action === 'string') {
        return [action];
      }
      return action;
    };

    ToolbarButton.prototype.determineActionName = function() {
      var _ref;
      return (_ref = this.determineAction()) != null ? _ref[0] : void 0;
    };

    ToolbarButton.prototype.determineType = function() {
      var option, type, types, value, _i, _len, _ref;
      if (this.type) {
        return this.type;
      }
      if (this.options.type) {
        return this.type = this.options.type;
      }
      types = $.extend({}, this.options);
      _ref = this.standardOptions;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        option = _ref[_i];
        delete types[option];
      }
      for (type in types) {
        value = types[type];
        return this.type = type;
      }
    };

    ToolbarButton.prototype.triggerAction = function() {
      if (this.subView) {
        return this.subView.toggle();
      }
      if (this.event) {
        Mercury.trigger(this.event);
      }
      if (this.mode) {
        Mercury.trigger('mode', this.mode);
      }
      return Mercury.trigger.apply(Mercury, ['action'].concat(__slice.call(this.action)));
    };

    ToolbarButton.prototype.onRegionFocus = function(region) {
      var _this = this;
      return this.delay(100, function() {
        return _this.onRegionUpdate(region);
      });
    };

    ToolbarButton.prototype.onRegionUpdate = function(region) {
      this.el.removeClass('mercury-button-active');
      if (region.hasAction(this.actionName) || this.global) {
        this.el.removeClass('mercury-button-disabled');
        if (region.hasContext(this.name)) {
          return this.el.addClass('mercury-button-active');
        }
      } else {
        return this.el.addClass('mercury-button-disabled');
      }
    };

    return ToolbarButton;

  })(Mercury.View);

}).call(this);
(function() {

  Mercury.View.Modules.ToolbarDialog = {
    included: function() {
      return this.on('build', this.buildToolbarDialog);
    },
    buildToolbarDialog: function() {
      return this.delegateEvents({
        'dialogs:hide': function() {
          return typeof this.hide === "function" ? this.hide() : void 0;
        }
      });
    }
  };

}).call(this);
(function() {

  Mercury.View.Modules.VisibilityToggleable = {
    included: function() {
      return this.on('build', this.buildVisibilityToggleable);
    },
    buildVisibilityToggleable: function() {
      this.visible || (this.visible = false);
      if (!this.visible) {
        this.hide();
      }
      return this.delegateEvents({
        'interface:hide': 'hide'
      });
    },
    toggle: function() {
      if (this.visible) {
        return this.hide();
      } else {
        return this.show();
      }
    },
    hide: function() {
      var _this = this;
      clearTimeout(this.visibilityTimeout);
      this.visible = false;
      this.el.css({
        opacity: 0
      });
      return this.visibilityTimeout = this.delay(100, function() {
        return _this.el.hide();
      });
    },
    show: function() {
      var _this = this;
      clearTimeout(this.visibilityTimeout);
      this.visible = true;
      this.el.show();
      return this.visibilityTimeout = this.delay(1, function() {
        return _this.el.css({
          opacity: 1
        });
      });
    }
  };

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.ToolbarPalette = (function(_super) {

    __extends(ToolbarPalette, _super);

    function ToolbarPalette() {
      return ToolbarPalette.__super__.constructor.apply(this, arguments);
    }

    ToolbarPalette.include(Mercury.View.Modules.ToolbarDialog);

    ToolbarPalette.include(Mercury.View.Modules.VisibilityToggleable);

    ToolbarPalette.prototype.logPrefix = 'Mercury.ToolbarPalette:';

    ToolbarPalette.prototype.className = 'mercury-toolbar-palette';

    return ToolbarPalette;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.ToolbarSelect = (function(_super) {

    __extends(ToolbarSelect, _super);

    function ToolbarSelect() {
      return ToolbarSelect.__super__.constructor.apply(this, arguments);
    }

    ToolbarSelect.include(Mercury.View.Modules.ToolbarDialog);

    ToolbarSelect.include(Mercury.View.Modules.VisibilityToggleable);

    ToolbarSelect.prototype.logPrefix = 'Mercury.ToolbarSelect:';

    ToolbarSelect.prototype.className = 'mercury-toolbar-select';

    return ToolbarSelect;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Model.File = (function(_super) {

    __extends(File, _super);

    File.define('Mercury.Model.File');

    File.url = function() {
      return this.config('uploading:saveUrl');
    };

    function File(file, options) {
      this.file = file;
      this.options = options != null ? options : {};
      File.__super__.constructor.call(this, {
        name: this.file.name,
        type: this.file.type,
        size: this.file.size,
        url: this.file.url || null
      });
    }

    File.prototype.validate = function() {
      var mimeTypes, _ref;
      if (this.get('size') >= this.config('uploading:maxSize')) {
        this.addError('size', this.t('Too large'));
        return;
      }
      mimeTypes = (_ref = this.options['mimeTypes']) != null ? _ref : this.config('uploading:mimeTypes');
      if (mimeTypes && mimeTypes.indexOf(this.get('type')) <= -1) {
        return this.addError('type', this.t('Unsupported format (%s)', this.get('type')));
      }
    };

    File.prototype.readAsDataURL = function(callback) {
      var reader;
      if (!window.FileReader) {
        return;
      }
      reader = new FileReader();
      reader.onload = function() {
        if (callback) {
          return callback(reader.result);
        }
      };
      return reader.readAsDataURL(this.file);
    };

    File.prototype.readableSize = function() {
      return this.get('size').toBytes();
    };

    File.prototype.isImage = function() {
      return ['image/jpeg', 'image/gif', 'image/png'].indexOf(this.get('type')) > -1;
    };

    File.prototype.save = function(options) {
      var defaultOptions;
      if (options == null) {
        options = {};
      }
      defaultOptions = {
        data: this.toFormData(),
        processData: false,
        contentType: false,
        xhr: function() {
          var event, handler, xhr, _fn, _ref;
          xhr = $.ajaxSettings.xhr();
          _ref = options.uploadEvents || {};
          _fn = function(event, handler) {
            return xhr.upload["on" + event] = handler;
          };
          for (event in _ref) {
            handler = _ref[event];
            _fn(event, handler);
          }
          return xhr;
        }
      };
      return File.__super__.save.call(this, $.extend(defaultOptions, options));
    };

    File.prototype.toFormData = function() {
      var formData;
      if (!window.FormData) {
        return;
      }
      formData = new FormData();
      formData.append(this.config('uploading:saveName'), this.file, this.get('name'));
      return formData;
    };

    File.prototype.saveSuccess = function() {
      if (!this.get('url')) {
        return this.notify(this.t('Malformed response from server (%s)', 'no url'));
      }
    };

    return File;

  })(Mercury.Model);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Uploader = (function(_super) {

    __extends(Uploader, _super);

    Uploader.supported = !!(window.FormData && new XMLHttpRequest().upload);

    Uploader.prototype.logPrefix = 'Mercury.Uploader:';

    Uploader.prototype.className = 'mercury-uploader';

    Uploader.prototype.template = 'uploader';

    Uploader.prototype.attributes = {
      style: 'opacity:0'
    };

    Uploader.prototype.elements = {
      status: '.mercury-uploader-progress span',
      details: '.mercury-uploader-details',
      preview: '.mercury-uploader-preview b',
      indicator: '.mercury-uploader-indicator div',
      percent: '.mercury-uploader-indicator b'
    };

    function Uploader(files, options) {
      this.options = options != null ? options : {};
      if (!this.constructor.supported) {
        return this.notify(this.t('is unsupported in this browser'));
      }
      Uploader.__super__.constructor.call(this, this.options);
      this.loaded = 0;
      this.total = 0;
      this.files = [];
      if (!this.calculate(files || []).length) {
        return;
      }
      this.show();
      this.delay(500, this.upload);
    }

    Uploader.prototype.calculate = function(files) {
      var file, _i, _len;
      for (_i = 0, _len = files.length; _i < _len; _i++) {
        file = files[_i];
        file = new Mercury.Model.File(file, {
          mimeTypes: this.mimeTypes
        });
        if (!file.isValid()) {
          alert(this.t('Error uploading %s: %s', file.get('name'), file.errorMessages()));
          continue;
        }
        this.files.push(file);
        this.total += file.get('size');
      }
      return this.files;
    };

    Uploader.prototype.build = function() {
      return this.appendTo(Mercury["interface"]);
    };

    Uploader.prototype.show = function() {
      var _this = this;
      this.update(this.t('Processing...'));
      return this.delay(1, function() {
        return _this.el.css({
          opacity: 1
        });
      });
    };

    Uploader.prototype.release = function(ms) {
      if (ms == null) {
        ms = 0;
      }
      return this.delay(ms, function() {
        this.el.css({
          opacity: 0
        });
        return this.delay(250, function() {
          return Uploader.__super__.release.apply(this, arguments);
        });
      });
    };

    Uploader.prototype.upload = function() {
      var xhr,
        _this = this;
      if (!this.files.length) {
        return this.release(500);
      }
      this.file = this.files.shift();
      this.update(this.t('Uploading...'));
      this.loadDetails();
      if (xhr = this.file.save({
        uploadEvents: this.uploadEvents()
      })) {
        xhr.success(function() {
          return _this.success();
        });
        return xhr.error(function() {
          return _this.error();
        });
      }
    };

    Uploader.prototype.update = function(message, loaded) {
      var percent;
      if (loaded == null) {
        loaded = 0;
      }
      if (message) {
        this.status.html(message);
      }
      percent = Math.floor((this.loaded + loaded) * 100 / this.total) + '%';
      this.indicator.css({
        width: percent
      });
      return this.percent.html(percent);
    };

    Uploader.prototype.loadDetails = function() {
      var _this = this;
      this.details.html([this.t('Name: %s', this.file.get('name')), this.t('Type: %s', this.file.get('type')), this.t('Size: %s', this.file.readableSize())].join('<br/>'));
      if (!this.file.isImage()) {
        return;
      }
      return this.file.readAsDataURL(function(result) {
        return _this.preview.html($('<img>', {
          src: result
        }));
      });
    };

    Uploader.prototype.success = function() {
      this.trigger('uploaded', this.file);
      this.loaded += this.file.get('size');
      this.update(this.t('Successfully uploaded...'));
      return this.upload();
    };

    Uploader.prototype.error = function() {
      this.update(this.t('Error: Unable to upload the file'));
      return this.delay(3000, this.upload);
    };

    Uploader.prototype.uploadEvents = function() {
      var _this = this;
      return {
        progress: function(e) {
          _this.update(_this.t('Uploading...'), e.loaded);
          return _this.percent.show();
        }
      };
    };

    return Uploader;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Action.Image = (function(_super) {

    __extends(Image, _super);

    function Image() {
      return Image.__super__.constructor.apply(this, arguments);
    }

    Image.prototype.name = 'image';

    Image.prototype.asHtml = function() {
      return "<img src=\"" + (this.get('url')) + "\">";
    };

    return Image;

  })(Mercury.Action);

}).call(this);
(function() {

  Mercury.Region.Modules.ContentEditable = {
    included: function() {
      this.on('build', this.buildContentEditable);
      this.on('preview', this.toggleContentEditable);
      return this.on('release', this.releaseContentEditable);
    },
    buildContentEditable: function() {
      var _ref;
      if ((_ref = this.editableDropBehavior) == null) {
        this.editableDropBehavior = true;
      }
      this.document || (this.document = this.el.get(0).ownerDocument);
      this.makeContentEditable();
      this.forceContentEditableDisplay();
      return this.setContentEditablePreferences();
    },
    toggleContentEditable: function() {
      if (this.previewing) {
        return this.makeNotContentEditable();
      } else {
        return this.makeContentEditable();
      }
    },
    releaseContentEditable: function() {
      this.makeNotContentEditable();
      if (this.originalDisplay) {
        return this.el.css({
          display: this.originalDisplay
        });
      }
    },
    makeContentEditable: function() {
      return this.el.get(0).contentEditable = true;
    },
    makeNotContentEditable: function() {
      return this.el.get(0).contentEditable = false;
    },
    forceContentEditableDisplay: function() {
      if (this.el.css('display') === 'inline') {
        this.originalDisplay = 'inline';
        return this.el.css({
          display: 'inline-block'
        });
      }
    },
    setContentEditablePreferences: function() {
      try {
        this.document.execCommand('styleWithCSS', false, false);
        this.document.execCommand('insertBROnReturn', false, true);
        this.document.execCommand('enableInlineTableEditing', false, false);
        return this.document.execCommand('enableObjectResizing', false, false);
      } catch (_error) {}
    },
    stackEquality: function(value) {
      if (this.stackPosition === 0 && this.stack[this.stackPosition]) {
        return JSON.stringify(this.stack[this.stackPosition].val) === JSON.stringify(value.val);
      }
      return JSON.stringify(this.stack[this.stackPosition]) === JSON.stringify(value);
    }
  };

}).call(this);
(function() {

  Mercury.Region.Modules.DropIndicator = {
    included: function() {
      this.on('build', this.buildDropIndicator);
      return this.on('release', this.releaseDropIndicator);
    },
    buildDropIndicator: function() {
      this.el.after(this.dropIndicator = $('<div class="mercury-region-drop-indicator"></div>'));
      return this.delegateEvents(this.el, {
        dragenter: 'showDropIndicator',
        dragover: 'showDropIndicator',
        dragleave: 'hideDropIndicator',
        drop: 'hideDropIndicator'
      });
    },
    releaseDropIndicator: function() {
      return this.dropIndicator.remove();
    },
    dropIndicatorPosition: function() {
      var pos;
      pos = this.el.position();
      return {
        top: pos.top + this.el.outerHeight() / 2,
        left: pos.left + this.el.outerWidth() / 2,
        display: 'block'
      };
    },
    showDropIndicator: function() {
      var _this = this;
      if (this.previewing || this.dropIndicatorVisible) {
        return;
      }
      this.dropIndicatorVisible = true;
      clearTimeout(this.dropIndicatorTimer);
      this.dropIndicator.css(this.dropIndicatorPosition());
      return this.delay(1, function() {
        return _this.dropIndicator.css({
          opacity: 1
        });
      });
    },
    hideDropIndicator: function() {
      var _this = this;
      this.dropIndicatorVisible = false;
      this.dropIndicator.css({
        opacity: 0
      });
      return this.dropIndicatorTimer = this.delay(500, function() {
        return _this.dropIndicator.hide();
      });
    }
  };

}).call(this);
(function() {

  Mercury.Region.Modules.DropItem = {
    onDropItem: function(e, data) {
      var action, url, _ref;
      _ref = this.getActionAndUrlFromData(data), action = _ref[0], url = _ref[1];
      if (!url) {
        return;
      }
      e.preventDefault();
      this.focus();
      return this.handleAction(action, {
        url: url
      });
    },
    getActionAndUrlFromData: function(data) {
      var action, url;
      action = 'image';
      if (data.getData('text/html') || (Mercury.support.safari && (data.types || []).indexOf('image/tiff') === -1)) {
        action = 'link';
      }
      if (url = $('<div>').html(data.getData('text/html')).find('img').attr('src')) {
        action = 'image';
      }
      return [action, url || data.getData('text/uri-list')];
    }
  };

}).call(this);
(function() {

  Mercury.Region.Modules.FocusableTextarea = {
    included: function() {
      this.on('build', this.buildFocusable);
      this.on('action', this.resizeFocusable);
      this.on('preview', this.toggleFocusablePreview);
      return this.on('release', this.releaseFocusable);
    },
    buildFocusable: function() {
      var resize, value, _ref, _ref1;
      if ((_ref = this.editableDropBehavior) == null) {
        this.editableDropBehavior = true;
      }
      if ((_ref1 = this.autoSize) == null) {
        this.autoSize = this.config("regions:" + this.constructor.type + ":autoSize");
      }
      value = this.html().replace('&gt;', '>').replace('&lt;', '<').trim();
      resize = this.autoSize ? 'none' : 'vertical';
      this.preview = $("<div class=\"mercury-" + this.constructor.type + "-region-preview\">");
      this.focusable = $("<textarea class=\"mercury-" + this.constructor.type + "-region-textarea\">");
      if (!this.config("regions:" + this.constructor.type + ":wrapping")) {
        this.focusable.attr({
          wrap: 'off'
        });
      }
      this.el.empty();
      this.append(this.preview, this.focusable.css({
        width: '100%',
        height: this.el.height() || this.height || 20,
        resize: resize
      }));
      this.value(value);
      this.resizeFocusable();
      return this.delegateEvents({
        'keydown textarea': 'handleKeyEvent'
      });
    },
    releaseFocusable: function() {
      var _ref;
      return this.html((_ref = typeof this.convertedValue === "function" ? this.convertedValue() : void 0) != null ? _ref : this.value());
    },
    value: function(value) {
      var _ref;
      if (value == null) {
        value = null;
      }
      if (value === null || typeof value === 'undefined') {
        return this.focusable.val();
      }
      this.focusable.val((_ref = value.val) != null ? _ref : value);
      if (value.sel) {
        return this.setSerializedSelection(value.sel);
      }
    },
    resizeFocusable: function() {
      var body, current, focusable;
      if (!this.autoSize) {
        return;
      }
      focusable = this.focusable.get(0);
      body = $('body', this.el.get(0).ownerDocument);
      current = body.scrollTop();
      this.focusable.css({
        height: 1
      }).css({
        height: focusable.scrollHeight
      });
      return body.scrollTop(current);
    },
    toggleFocusablePreview: function() {
      if (this.previewing) {
        this.focusable.hide();
        return this.preview.html((typeof this.convertedValue === "function" ? this.convertedValue() : void 0) || this.value()).show();
      } else {
        this.preview.hide();
        return this.focusable.show();
      }
    },
    handleKeyEvent: function(e) {
      if (e.keyCode >= 37 && e.keyCode <= 40) {
        return;
      }
      this.delay(1, this.resizeFocusable);
      if (e.metaKey && e.keyCode === 90) {
        return;
      }
      if (e.keyCode === 13) {
        if (typeof this.onReturnKey === "function") {
          this.onReturnKey(e);
        }
      }
      if (e.metaKey) {
        switch (e.keyCode) {
          case 66:
            e.preventDefault();
            return this.handleAction('bold');
          case 73:
            e.preventDefault();
            return this.handleAction('italic');
          case 85:
            e.preventDefault();
            return this.handleAction('underline');
        }
      }
      this.resizeFocusable();
      return this.pushHistory(e.keyCode);
    }
  };

}).call(this);
(function() {

  Mercury.Region.Modules.HtmlSelection = {
    getSelection: function() {
      return rangy.getSelection();
    },
    getSerializedSelection: function() {
      return rangy.serializeSelection();
    },
    setSerializedSelection: function(sel) {
      return rangy.deserializeSelection(sel);
    },
    toggleWrapSelectedWordsInClass: function(className, options) {
      var classApplier;
      if (options == null) {
        options = {};
      }
      options = $.extend({}, {
        normalize: true
      }, options, {
        applyToEditableOnly: true
      });
      classApplier = rangy.createCssClassApplier(className, options);
      return classApplier.toggleSelection();
    },
    replaceSelection: function(val) {
      var range, _i, _len, _ref, _results;
      if (typeof val === 'string' || val.is) {
        val = this.elementFromValue(val);
      }
      _ref = this.getSelection().getAllRanges();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        range = _ref[_i];
        range.deleteContents();
        _results.push(range.insertNode(val));
      }
      return _results;
    },
    elementFromValue: function(val) {
      if (val.is) {
        return val.get(0);
      } else {
        return $(val).get(0);
      }
    }
  };

}).call(this);
(function() {

  Mercury.Region.Modules.SelectionValue = {
    toStack: function() {
      return {
        val: this.toJSON(),
        sel: typeof this.getSerializedSelection === "function" ? this.getSerializedSelection() : void 0
      };
    },
    fromStack: function(val) {
      if (!val) {
        return;
      }
      this.fromJSON(val.val);
      if (val.sel) {
        return typeof this.setSerializedSelection === "function" ? this.setSerializedSelection(val.sel) : void 0;
      }
    }
  };

}).call(this);
(function() {
  var __slice = [].slice;

  Mercury.Region.Modules.TextSelection = {
    getSelection: function() {
      var el, end, start, value;
      el = this.focusable.get(0);
      value = el.value;
      start = el.selectionStart;
      end = el.selectionEnd;
      return {
        start: start,
        end: end,
        length: end - start,
        text: value.slice(start, end)
      };
    },
    setSelection: function(sel, preAdjust, sufAdjust, collapse) {
      var el, end, start, value;
      if (preAdjust == null) {
        preAdjust = 0;
      }
      if (sufAdjust == null) {
        sufAdjust = null;
      }
      if (collapse == null) {
        collapse = false;
      }
      start = sel.start + preAdjust;
      end = sel.end + (sufAdjust != null ? sufAdjust : preAdjust);
      if (end < start || typeof end === 'undefined' || collapse) {
        end = start;
      }
      el = this.focusable.get(0);
      value = el.value;
      if (start < 0) {
        start += value.length;
      }
      if (end < 0) {
        end += value.length;
      }
      el.selectionStart = start;
      return el.selectionEnd = end;
    },
    getSerializedSelection: function() {
      return this.getSelection();
    },
    setSerializedSelection: function(sel) {
      return this.setSelection(sel);
    },
    isWithinToken: function(wrapper) {
      var exp, fix, sel, _ref;
      _ref = this.getTokenAndSelection(wrapper), fix = _ref[0], sel = _ref[1];
      exp = this.expandSelectionToTokens(sel, fix);
      if (exp.cleaned) {
        return true;
      }
    },
    isWithinLineToken: function(wrapper) {
      var exp, fix, sel, set, _ref;
      _ref = this.getTokenAndSelection(wrapper), fix = _ref[0], sel = _ref[1];
      exp = this.expandSelectionToLines(sel);
      set = exp.text.match(fix.regexp);
      if (!(set && set.length === 2)) {
        return false;
      }
      return true;
    },
    firstLineMatches: function(matcher) {
      var exp, sel;
      sel = this.getSelection();
      exp = this.expandSelectionToLines(sel);
      if (exp.text.match(matcher)) {
        return true;
      }
    },
    paragraphMatches: function(matcher) {
      var exp, sel;
      sel = this.getSelection();
      exp = this.expandSelectionToParagraphs(sel);
      if (exp.text.match(matcher)) {
        return true;
      }
    },
    replaceSelection: function(text) {
      var caretIndex, el, sel, value;
      if (text == null) {
        text = '';
      }
      el = this.focusable.get(0);
      value = el.value;
      sel = this.getSelection();
      el.value = [value.slice(0, sel.start), text, value.slice(sel.end)].join('');
      caretIndex = sel.start + text.length;
      return this.setSelection({
        start: caretIndex,
        end: caretIndex
      });
    },
    replaceSelectedLine: function(line, text) {
      if (text == null) {
        text = '';
      }
      this.setSelection(line);
      return this.replaceSelection(text);
    },
    setAndReplaceSelection: function(beforeSel, text, afterSel, preAdjust, sufAdjust, collapse) {
      if (text == null) {
        text = '';
      }
      this.setSelection(beforeSel);
      this.replaceSelection(text);
      return this.setSelection(afterSel, preAdjust, sufAdjust, collapse);
    },
    replaceSelectionWithParagraph: function(text) {
      var pre, sel, suf, val;
      if (text == null) {
        text = '';
      }
      val = this.value();
      sel = this.getSelection();
      pre = '\n';
      if (val[sel.start - 1] !== '\n') {
        pre += '\n';
      }
      if (!sel.start) {
        pre = '';
      }
      suf = '\n';
      if (!(val[sel.end] === '\n' || val[sel.end + 1] === '\n')) {
        suf += '\n';
      }
      if (!sel.end) {
        suf = '\n\n';
      }
      return this.replaceSelection([pre, text, suf].join(''));
    },
    wrapSelected: function(wrapper, options) {
      var fix, pre, sel, suf, val, _ref, _ref1, _ref2;
      if (options == null) {
        options = {};
      }
      _ref = this.getTokenAndSelection(wrapper), fix = _ref[0], sel = _ref[1];
      val = [fix.pre, sel.text || options.text || '', fix.suf].join('');
      if (options.select === 'end') {
        _ref1 = [val.length, null], pre = _ref1[0], suf = _ref1[1];
      } else {
        _ref2 = [0, val.length - sel.length], pre = _ref2[0], suf = _ref2[1];
      }
      return this.setAndReplaceSelection(sel, val, sel, pre, suf, options.select === 'end');
    },
    unwrapSelected: function(wrapper) {
      var fix, sel, set, _ref;
      _ref = this.getTokenAndSelection(wrapper), fix = _ref[0], sel = _ref[1];
      set = sel.text.match(fix.regexp);
      if (!(set && set.length === 2)) {
        return false;
      }
      return this.setAndReplaceSelection(sel, sel.text.replace(fix.regexp, ''), sel, 0, -set.join('').length);
    },
    toggleWrapSelected: function(wrapper, options) {
      if (options == null) {
        options = {};
      }
      if (!this.unwrapSelected(wrapper)) {
        return this.wrapSelected(wrapper, options);
      }
    },
    wrapSelectedWords: function(wrapper) {
      var exp, fix, sel, _ref;
      _ref = this.getTokenAndSelection(wrapper), fix = _ref[0], sel = _ref[1];
      exp = this.expandSelectionToWords(sel);
      return this.setAndReplaceSelection(exp, [fix.pre, exp.text, fix.suf].join(''), sel, fix.pre.length);
    },
    unwrapSelectedWords: function(wrapper) {
      var exp, fix, sel, _ref;
      _ref = this.getTokenAndSelection(wrapper), fix = _ref[0], sel = _ref[1];
      exp = this.expandSelectionToTokens(sel, fix);
      if (!exp.cleaned) {
        return false;
      }
      return this.setAndReplaceSelection(exp, exp.token, sel, -exp.match[0].length);
    },
    toggleWrapSelectedWords: function(wrapper) {
      if (!this.unwrapSelectedWords(wrapper)) {
        return this.wrapSelectedWords(wrapper);
      }
    },
    wrapSelectedLines: function(wrapper) {
      var all, empty, exp, fix, line, pos, pre, sel, suf, val, _i, _len, _ref;
      _ref = this.getTokenAndSelection(wrapper), fix = _ref[0], sel = _ref[1];
      exp = this.expandSelectionToLines(sel);
      pre = 0;
      suf = 0;
      val = [];
      pos = exp.start;
      all = exp.text.split('\n');
      for (_i = 0, _len = all.length; _i < _len; _i++) {
        line = all[_i];
        if (line.trim() || all.length === 1) {
          pre || (pre = fix.pre.length);
          suf += fix.pre.length;
          pos += line.length;
          if (pos < sel.end) {
            suf += fix.suf.length;
          }
          val.push([fix.pre, line, fix.suf].join(''));
        } else {
          empty = true;
          pos += line.length;
          val.push(line);
        }
      }
      if (empty) {
        pre = 0;
      }
      return this.setAndReplaceSelection(exp, val.join('\n'), sel, pre, suf);
    },
    unwrapSelectedLines: function(wrapper) {
      var all, exp, fix, line, pos, pre, ret, sel, set, suf, val, _i, _len, _ref;
      _ref = this.getTokenAndSelection(wrapper), fix = _ref[0], sel = _ref[1];
      exp = this.expandSelectionToLines(sel);
      pre = 0;
      suf = 0;
      val = [];
      pos = exp.start;
      all = exp.text.split('\n');
      ret = true;
      for (_i = 0, _len = all.length; _i < _len; _i++) {
        line = all[_i];
        set = line.match(fix.regexp);
        if (set && set.length === 2) {
          if (pos <= sel.start) {
            pre += set[0].length;
          }
          if (pos < sel.end) {
            suf += set[0].length;
          }
          pos += line.length;
          if (pos <= sel.start) {
            pre += set[1].length;
          }
          if (pos < sel.end) {
            suf += set[1].length;
          }
          val.push(line.replace(fix.regexp, ''));
        } else {
          ret = false;
          pos += line.length;
          val.push(line);
        }
      }
      if (!ret) {
        pre = 0;
      }
      this.setAndReplaceSelection(exp, val.join('\n'), sel, -pre, -suf);
      return ret;
    },
    wrapSelectedParagraphs: function(wrapper, options) {
      var all, empty, exp, fix, line, pos, pre, sel, suf, val, _i, _len, _ref;
      if (options == null) {
        options = {};
      }
      _ref = this.getTokenAndSelection(wrapper), fix = _ref[0], sel = _ref[1];
      exp = this.expandSelectionToParagraphs(sel);
      pre = 0;
      suf = 0;
      val = [];
      pos = exp.start;
      if (options.all) {
        pre = suf += fix.pre.length;
        val.push([fix.pre, exp.text, fix.suf].join(''));
      } else {
        all = exp.text.split('\n');
        for (_i = 0, _len = all.length; _i < _len; _i++) {
          line = all[_i];
          if (line.trim() || all.length === 1) {
            if (pos <= sel.start) {
              pre += fix.pre.length;
            }
            if (pos < sel.end) {
              suf += fix.pre.length;
            }
            pos += line.length;
            if (pos <= sel.start) {
              pre += fix.suf.length;
            }
            if (pos < sel.end) {
              suf += fix.suf.length;
            }
            val.push([fix.pre, line, fix.suf].join(''));
          } else {
            empty = true;
            pos += line.length;
            val.push(line);
          }
        }
        if (empty) {
          pre = 0;
        }
      }
      return this.setAndReplaceSelection(exp, val.join('\n'), sel, pre, suf);
    },
    unwrapSelectedParagraphs: function(wrapper, options) {
      var exp, fix, line, pos, pre, ret, sel, set, suf, val, _i, _len, _ref, _ref1;
      if (options == null) {
        options = {};
      }
      _ref = this.getTokenAndSelection(wrapper), fix = _ref[0], sel = _ref[1];
      exp = this.expandSelectionToParagraphs(sel);
      pre = 0;
      suf = 0;
      val = [];
      pos = exp.start;
      ret = true;
      if (options.all) {
        set = exp.text.match(fix.regexp);
        if (set && set.length === 2) {
          pre += set[0].length;
          suf += set[1].length;
          val.push(exp.text.replace(fix.regexp, ''));
        } else {
          val.push(exp.text);
        }
      } else {
        _ref1 = exp.text.split('\n');
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          line = _ref1[_i];
          set = line.match(fix.regexp);
          if (set && set.length === 2) {
            if (pos <= sel.start) {
              pre += set[0].length;
            }
            if (pos < sel.end) {
              suf += set[0].length;
            }
            pos += line.length;
            if (pos <= sel.start) {
              pre += set[1].length;
            }
            if (pos < sel.end) {
              suf += set[1].length;
            }
            val.push(line.replace(fix.regexp, ''));
          } else {
            ret = false;
            pos += line.length;
            val.push(line);
          }
        }
        if (!ret) {
          pre = 0;
        }
      }
      this.setAndReplaceSelection(exp, val.join('\n'), sel, -pre, -suf);
      return ret;
    },
    expandSelectionToWords: function(sel) {
      var end, lineEnd, lineStart, start, val;
      val = this.value();
      if (this.selectionIsEmptyLine(sel, val) || this.selectionIsEndOfLine(sel, val)) {
        return sel;
      }
      lineStart = this.getSelectionStartOfLine(sel, val);
      lineEnd = this.getSelectionEndOfLine(sel, val);
      start = val.lastIndexOf(' ', sel.start - 1);
      if (start < lineStart) {
        start = lineStart;
      }
      if (start > 0 && (val[start] === ' ' || val[start] === '\n')) {
        start += 1;
      }
      end = val.indexOf(' ', sel.end);
      if (end >= lineEnd || end === -1) {
        end = lineEnd;
      }
      return {
        start: start,
        end: end,
        text: val.substring(start, end),
        length: end - start
      };
    },
    expandSelectionToLines: function(sel) {
      var end, start, val;
      val = this.value();
      if (this.selectionIsEmptyLine(sel, val)) {
        return sel;
      }
      start = this.getSelectionStartOfLine(sel, val);
      end = this.getSelectionEndOfLine(sel, val);
      return {
        start: start,
        end: end,
        text: val.substring(start, end),
        length: end - start
      };
    },
    expandSelectionToParagraphs: function(sel) {
      var end, start, val;
      val = this.value();
      if (this.selectionIsEmptyLine(sel, val)) {
        return sel;
      }
      start = val.lastIndexOf('\n\n', sel.start - 1);
      if (start < 0) {
        start = 0;
      }
      if (start > 0) {
        start += 2;
      }
      if (start === 0 && val[0] === '\n') {
        start += 1;
      }
      if (start === 1 && val[1] === '\n') {
        start += 1;
      }
      if (start > sel.start - 1) {
        start = sel.start;
      }
      end = val.indexOf('\n\n', sel.end - 1);
      if (sel.length && val.substr(sel.end - 2, 2) === '\n\n') {
        end = sel.end;
      }
      if (end < 0) {
        end = val.length;
      }
      return {
        start: start,
        end: end,
        text: val.substring(start, end),
        length: end - start
      };
    },
    expandSelectionToTokens: function(sel, fix) {
      var alt, end, lineEnd, lineStart, match, start, token, val, value;
      val = this.value();
      if (this.selectionIsEmptyLine(sel, val)) {
        return sel;
      }
      if (alt = this.selectionIsToken(sel, val, fix)) {
        return alt;
      }
      lineStart = this.getSelectionStartOfLine(sel, val);
      lineEnd = this.getSelectionEndOfLine(sel, val);
      start = val.lastIndexOf(fix.pre, sel.start - 1);
      if (start < lineStart) {
        start = lineStart;
      }
      if (start > 0 && (val[start] === ' ' || val[start] === '\n')) {
        start += 1;
      }
      end = val.indexOf(fix.suf, sel.end - 1);
      if (end > -1) {
        end += fix.suf.length;
      }
      if (end > lineEnd || end === -1) {
        end = lineEnd;
      }
      token = null;
      value = val.substring(start, end);
      match = value.match(fix.regexp);
      if (match && match.length === 2) {
        token = value.replace(fix.regexp, '');
      }
      return {
        start: start,
        end: end,
        text: value,
        length: end - start,
        cleaned: token !== null,
        token: token,
        match: match
      };
    },
    selectionIsToken: function(sel, val, fix) {
      var end, match, start, token, value;
      if (sel.length > 0) {
        return false;
      }
      start = sel.start - fix.pre.length;
      end = sel.end + fix.suf.length;
      token = null;
      value = val.substring(start, end);
      match = value.match(fix.regexp);
      if (match && match.length === 2) {
        token = value.replace(fix.regexp, '');
      }
      if (token === null) {
        return false;
      }
      return {
        start: start,
        end: end,
        text: value,
        length: end - start,
        cleaned: true,
        token: token,
        match: match
      };
    },
    getSelectionStartOfLine: function(sel, val) {
      var start;
      start = sel.start;
      if (val[start] !== '\n') {
        start = val.lastIndexOf('\n', start);
      }
      if (start === sel.start) {
        start = val.lastIndexOf('\n', start - 1);
      }
      if (start < 0) {
        start = 0;
      }
      if (start === 0 && val[0] === '\n' && sel.start === 0) {
        start = 0;
      } else if (val[start] === '\n') {
        start += 1;
      }
      return start;
    },
    getSelectionEndOfLine: function(sel, val) {
      var end;
      end = sel.end;
      if (sel.length === 0 || (val[end] !== '\n' && val[end - 1] !== '\n')) {
        end = val.indexOf('\n', end);
      }
      if (end < 0) {
        end = val.length;
      }
      return end;
    },
    selectionIsEmptyLine: function(sel, val) {
      return (sel.length <= 1 && val.substr(sel.start - 1, 2) === '\n\n') || (sel.start === 0 && val[0] === '\n');
    },
    selectionIsEndOfLine: function(sel, val) {
      return val[sel.start - 1] === ' ' && (val[sel.start] === '\n' || sel.start === val.length);
    },
    processWrapper: function() {
      var args, fix, wrapper, _ref, _ref1;
      wrapper = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      fix = this.tokenFromWrapper(wrapper);
      fix.pre = (_ref = fix.pre).printf.apply(_ref, args[0]);
      fix.suf = (_ref1 = fix.suf).printf.apply(_ref1, args[1] || args[0]);
      return [fix.pre, fix.suf];
    },
    tokenFromWrapper: function(wrapper) {
      var pre, suf;
      if (typeof wrapper === 'string') {
        wrapper = this.wrappers[wrapper];
      }
      pre = wrapper[0], suf = wrapper[1];
      if (suf == null) {
        suf = pre;
      }
      return {
        pre: pre,
        suf: suf,
        regexp: wrapper[2] || new RegExp("^" + (pre.regExpEscape()) + "|" + (suf.regExpEscape()) + "$", 'gi')
      };
    },
    getTokenAndSelection: function(wrapper) {
      return [this.tokenFromWrapper(wrapper), this.getSelection()];
    }
  };

}).call(this);
(function() {

  Mercury.View.Modules.ToolbarFocusable = {
    included: function() {
      return this.on('build', this.buildToolbarFocusable);
    },
    buildToolbarFocusable: function() {
      return this.delegateEvents({
        'mousedown': function(e) {
          return e.stopPropagation();
        },
        'mouseup': function(e) {
          return e.stopPropagation();
        }
      });
    }
  };

}).call(this);
(function() {
  var initialize,
    __slice = [].slice;

  initialize = function() {
    var isIE;
    this.version = '0.0.1alpha';
    this.init = function(options) {
      if (options == null) {
        options = {};
      }
      if (this["interface"]) {
        return;
      }
      this.trigger('configure');
      return this["interface"] = new this[this.config('interface:class')](options);
    };
    this.release = function() {
      if (!this["interface"]) {
        return;
      }
      this.trigger('released');
      this["interface"].release();
      delete this["interface"];
      return this.off();
    };
    this.Module.extend.call(this, this.Config);
    this.configure = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (this.configuration) {
        this.trigger('configure');
        (_ref = this.Config).set.apply(_ref, args);
      }
      return this.one('configure', function() {
        return this.Config.set(args[0], true, args[1]);
      });
    };
    this.Module.extend.call(this, this.Events);
    this.Module.extend.call(this, this.I18n);
    this.Module.extend.call(this, this.Logger);
    this.support = {
      webkit: navigator.userAgent.indexOf('WebKit') > 0,
      safari: navigator.userAgent.indexOf('Safari') > 0 && navigator.userAgent.indexOf('Chrome') === -1,
      chrome: navigator.userAgent.indexOf('Chrome') > 0,
      gecko: navigator.userAgent.indexOf('Firefox') > 0,
      trident: navigator.userAgent.indexOf('MSIE') > 0,
      ie10: (isIE = navigator.userAgent.match(/MSIE\s([\d|\.]+)/)) ? parseFloat(isIE[1], 10) >= 10 : false
    };
    return this.support.wysiwyg = document.designMode && (!this.support.trident || this.support.ie10) && (window.rangy && window.rangy.supported);
  };

  initialize.call(this.MockMercury || this.Mercury);

}).call(this);
(function() {



}).call(this);
