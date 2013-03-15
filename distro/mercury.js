
/*!
Mercury Editor is a Coffeescript and jQuery based WYSIWYG editor released under the MIT License.
Documentation and other useful information can be found at https://github.com/jejacks0n/mercury

Copyright (c) 2013 Jeremy Jackson
*/


(function() {

  this.Mercury || (this.Mercury = {});

  Mercury.configuration = {
    logging: {
      enabled: true,
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
    regions: {
      attribute: 'data-mercury',
      identifier: 'id',
      image: {
        mimeTypes: ['image/jpeg']
      },
      gallery: {
        mimeTypes: ['image/jpeg']
      },
      markdown: {
        autoSize: true,
        mimeTypes: false
      }
    }
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
      var args, config, part, parts, path, value;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      value = args.pop();
      path = args.shift();
      if (!path) {
        return Mercury.configuration = value;
      }
      config = Mercury.configuration || (Mercury.configuration = {});
      parts = path.split(':');
      part = parts.shift();
      while (part) {
        if (parts.length === 0) {
          config[part] = value;
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

  Mercury.Stack = {
    included: function() {
      this.stackPosition = 0;
      this.maxStackLength = 200;
      return this.stack = [];
    },
    pushStack: function(value) {
      if (value === null || JSON.stringify(this.stack[this.stackPosition]) === JSON.stringify(value)) {
        return;
      }
      this.stack = this.stack.slice(0, this.stackPosition + 1);
      this.stack.push(value);
      if (this.stack.length > this.maxStackLength) {
        this.stack.shift();
      }
      return this.stackPosition = this.stack.length - 1;
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
      this.pushStack($.extend(true, {}, this.attributes));
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
      if (!this.el) {
        this.el = document.createElement(this.tag);
      }
      this.el = $(this.el);
      this.$el = this.el;
      this.attr(this.attributes);
      this.addClass(this.className);
      if (this.template) {
        this.html(this.renderTemplate(this.template));
      }
      this.elements || (this.elements = this.constructor.elements);
      this.events || (this.events = this.constructor.events);
      if (typeof this.build === "function") {
        this.build();
      }
      if (this.events) {
        this.delegateEvents(this.events);
      }
      if (this.elements) {
        this.refreshElements();
      }
      View.__super__.constructor.apply(this, arguments);
    }

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
          Mercury.on(key, method);
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
      type = ("" + type + "_region").toLowerCase().toCamelCase(true);
      if (!Mercury[type]) {
        this.notify(this.t('unknown "%s" region type, falling back to base region', type));
      }
      return new (Mercury[type] || Mercury.Region)(el);
    };

    function Region(el, options) {
      this.el = el;
      this.options = options != null ? options : {};
      if (!this.constructor.supported) {
        return this.notify(this.t('is unsupported in this browser'));
      }
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
      if (!this.name) {
        this.notify(this.t('no name provided for the "%s" region, falling back to random', this.constructor.type));
        this.name = "" + this.constructor.type + (Math.floor(Math.random() * 10000));
      }
      this.previewing || (this.previewing = false);
      this.focused || (this.focused = false);
      this.focusable || (this.focusable = this.el);
      this.skipHistoryOn || (this.skipHistoryOn = ['redo']);
      this.addClass("mercury-" + this.constructor.type + "-region");
      this.trigger('build');
      if (typeof this.afterBuild === "function") {
        this.afterBuild();
      }
      this.pushHistory();
      this.bindDefaultEvents();
    }

    Region.prototype.handleAction = function() {
      var action, args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (!this.focused || this.previewing) {
        return;
      }
      action = args.shift();
      if (!(this.skipHistoryOn.indexOf(action) > -1)) {
        this.pushHistory();
      }
      if (this.actions[action]) {
        this.actions[action].apply(this, args);
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

    Region.prototype.pushHistory = function() {
      var _ref;
      return this.pushStack((_ref = typeof this.valueForStack === "function" ? this.valueForStack() : void 0) != null ? _ref : this.value());
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
      if (value) {
        return this.el.data(key, value);
      } else {
        return this.el.data(key);
      }
    };

    Region.prototype.snippets = function() {
      return {};
    };

    Region.prototype.onUndo = function() {
      return this.value(this.undoStack());
    };

    Region.prototype.onRedo = function() {
      return this.value(this.redoStack());
    };

    Region.prototype.toJSON = function() {
      return {
        name: this.name,
        type: this.constructor.type,
        value: this.value(),
        data: this.data(),
        snippets: this.snippets()
      };
    };

    Region.prototype.release = function() {
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
      this.delegateActions($.extend(true, this.constructor.actions, this.constructor.defaultActions, this.actions || (this.actions = {})));
      this.bindFocusEvents();
      this.bindKeyEvents();
      if (typeof this.onDropFile === 'function') {
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

    Region.prototype.bindDropEvents = function() {
      var preventDefault,
        _this = this;
      preventDefault = function(e) {
        return e.preventDefault();
      };
      return this.delegateEvents(this.focusable, {
        dragenter: preventDefault,
        dragover: this.editableDragOver && Mercury.support.webkit ? (function() {}) : preventDefault,
        drop: function(e) {
          if (!e.originalEvent.dataTransfer.files.length) {
            return;
          }
          e.preventDefault();
          return _this.onDropFile(e.originalEvent.dataTransfer.files);
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

  this.JST || (this.JST = {});

  JST['/mercury/templates/editor'] = function(scope) {
    return "<ul id=\"mercury_controls\">\n  <li data-action=\"preview\">Toggle Preview</li>\n  <li data-action=\"undo\">Undo</li>\n  <li data-action=\"redo\">Redo</li>\n  <hr/>\n  <li data-action=\"direction\">custom action (toggle rtl/ltr)</li>\n  <hr/>\n  <li data-action=\"block\" data-value=\"none\">none</li>\n  <li data-action=\"block\" data-value=\"h1\">h1</li>\n  <li data-action=\"block\" data-value=\"h2\">h2</li>\n  <li data-action=\"block\" data-value=\"h3\">h3</li>\n  <li data-action=\"block\" data-value=\"h4\">h4</li>\n  <li data-action=\"block\" data-value=\"h5\">h5</li>\n  <li data-action=\"block\" data-value=\"h6\">h6</li>\n  <li data-action=\"block\" data-value=\"pre\">pre</li>\n  <li data-action=\"block\" data-value=\"paragraph\">paragraph</li>\n  <li data-action=\"block\" data-value=\"blockquote\">blockquote</li>\n  <hr/>\n  <li data-action=\"bold\">bold</li>\n  <li data-action=\"italic\">italic</li>\n  <li data-action=\"underline\">underline</li>\n  <li data-action=\"subscript\">subscript</li>\n  <li data-action=\"superscript\">superscript</li>\n  <hr/>\n  <li data-action=\"orderedList\">orderedList</li>\n  <li data-action=\"unorderedList\">unorderedList</li>\n  <hr/>\n  <li data-action=\"indent\">indent</li>\n  <li data-action=\"outdent\">outdent</li>\n  <hr/>\n  <li data-action=\"style\" data-value=\"border:1px solid red\">style</li>\n  <li data-action=\"style\" data-value=\"foo\">class</li>\n  <hr/>\n  <li data-action=\"html\" data-value=\"html\">html (with html)</li>\n  <li data-action=\"html\" data-value=\"el\">html (with element)</li>\n  <li data-action=\"html\" data-value=\"jquery\">html (with jQuery)</li>\n  <hr/>\n  <li data-action=\"link\" data-value=\"https://github.com/jejacks0n/mercury\">link</li>\n  <li data-action=\"image\" data-value=\"http://goo.gl/UWYSd\">image</li>\n  <hr/>\n  <li data-action=\"rule\">rule</li>\n  <hr/>\n  <li><input type=\"text\"/></li>\n</ul>";
  };

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Editor = (function(_super) {

    __extends(Editor, _super);

    Editor.prototype.logPrefix = 'Mercury.Editor:';

    Editor.prototype.template = 'editor';

    Editor.prototype.attributes = {
      id: 'mercury'
    };

    Editor.prototype.events = {
      'mousedown': 'keepRegionFocused',
      'click [data-action]': 'processAction'
    };

    function Editor(options) {
      var el, _i, _len, _ref, _ref1;
      this.options = options != null ? options : {};
      Editor.__super__.constructor.apply(this, arguments);
      this.regions || (this.regions = []);
      _ref = this.regionElements();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        el = _ref[_i];
        this.addRegion(el);
      }
      if ((_ref1 = this.regions[0]) != null) {
        _ref1.focus();
      }
    }

    Editor.prototype.regionElements = function() {
      return $("[" + (this.config('regions:attribute')) + "]");
    };

    Editor.prototype.addRegion = function(el) {
      var region,
        _this = this;
      region = Mercury.Region.create(el);
      region.on('focus', function() {
        return _this.region = region;
      });
      return this.regions.push(region);
    };

    Editor.prototype.keepRegionFocused = function(e) {
      e.preventDefault();
      return this.region.focus();
    };

    Editor.prototype.save = function() {
      var data, region, _i, _len, _ref;
      data = {};
      _ref = this.regions;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        region = _ref[_i];
        data[region.name] = region.toJSON();
      }
      return data;
    };

    Editor.prototype.processAction = function(e) {
      var action, target, value;
      target = $(e.target);
      action = target.data('action');
      value = target.data('value');
      switch (action) {
        case 'preview':
          return Mercury.trigger('mode', 'preview');
        case 'html':
          value = (function() {
            switch (value) {
              case 'html':
                return '<table>\n  <tr>\n    <td>1</td>\n    <td>2</td>\n  </tr>\n</table>';
              case 'el':
                return $('<section class="foo"><h1>testing</h1></section>').get(0);
              case 'jquery':
                return $('<section class="foo"><h1>testing</h1></section>');
            }
          })();
          return Mercury.trigger('action', action, value);
        default:
          return Mercury.trigger('action', action, value);
      }
    };

    return Editor;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.File = (function(_super) {

    __extends(File, _super);

    File.define('Mercury.File');

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
        url: null
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

  this.JST || (this.JST = {});

  JST['/mercury/templates/uploader'] = function(scope) {
    return "<div class=\"mercury-uploader-dialog\">\n  <div class=\"mercury-uploader-preview\"><b><img/></b></div>\n  <div class=\"mercury-uploader-details\"></div>\n  <div class=\"mercury-uploader-progress\">\n    <span></span>\n    <div class=\"mercury-uploader-indicator\"><div><b>0%</b></div></div>\n  </div>\n</div>";
  };

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Uploader = (function(_super) {

    __extends(Uploader, _super);

    Uploader.supported = !!(window.FormData && new XMLHttpRequest().upload);

    Uploader.prototype.logPrefix = 'Mercury.Uploader:';

    Uploader.prototype.template = 'uploader';

    Uploader.prototype.className = 'mercury-uploader';

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
        file = new Mercury.File(file, {
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
      return this.appendTo($('#mercury'));
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

  Mercury.Region.Modules.DropIndicator = {
    included: function() {
      this.dropIndicator = $('<div class="mercury-region-drop-indicator"></div>');
      this.on('build', this.buildDropIndicator);
      return this.on('release', this.releaseDropIndicator);
    },
    buildDropIndicator: function() {
      this.el.after(this.dropIndicator);
      return this.delegateEvents(this.focusable, {
        dragenter: 'showDropIndicator',
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
    setSelection: function(sel, preAdjust, sufAdjust) {
      var el, end, start, value;
      if (preAdjust == null) {
        preAdjust = 0;
      }
      if (sufAdjust == null) {
        sufAdjust = null;
      }
      start = sel.start + preAdjust;
      end = sel.end + (sufAdjust != null ? sufAdjust : preAdjust);
      if (end < start || typeof end === 'undefined') {
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
    replaceSelectedLine: function(line, val) {
      if (val == null) {
        val = '';
      }
      this.setSelection(line);
      return this.replaceSelection('');
    },
    setAndReplaceSelection: function(beforeSel, text, afterSel, preAdjust, sufAdjust) {
      if (text == null) {
        text = '';
      }
      this.setSelection(beforeSel);
      this.replaceSelection(text);
      return this.setSelection(afterSel, preAdjust, sufAdjust);
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
      var fix, sel, val, _ref;
      if (options == null) {
        options = {};
      }
      _ref = this.getTokenAndSelection(wrapper), fix = _ref[0], sel = _ref[1];
      val = [fix.pre, sel.text || options.text || '', fix.suf].join('');
      return this.setAndReplaceSelection(sel, val, sel, 0, val.length - sel.length);
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

  Mercury.Region.Modules.FocusableTextarea = {
    included: function() {
      this.autoSize = false;
      this.preview = $("<div class=\"mercury-" + this.constructor.type + "-region-preview\">");
      this.focusable = $("<textarea class=\"mercury-" + this.constructor.type + "-region-textarea\">");
      this.on('build', this.buildFocusable);
      this.on('action', this.resizeFocusable);
      this.on('preview', this.toggleFocusablePreview);
      return this.on('release', this.releaseFocusable);
    },
    buildFocusable: function() {
      var resize, value;
      this.autoSize = this.config("regions:" + this.constructor.type + ":autoSize");
      value = this.html().replace('&gt;', '>').replace('&lt;', '<');
      resize = this.autoSize ? 'none' : 'vertical';
      this.el.empty();
      this.append(this.preview, this.focusable.val(value).css({
        width: '100%',
        height: this.el.height(),
        resize: resize
      }));
      this.resizeFocusable();
      return this.delegateEvents({
        'keydown textarea': 'handleKeyEvent'
      });
    },
    releaseFocusable: function() {
      var _ref;
      return this.html((_ref = typeof this.convertedValue === "function" ? this.convertedValue() : void 0) != null ? _ref : this.value());
    },
    resizeFocusable: function() {
      var body, current, focusable;
      if (!this.autoSize) {
        return;
      }
      focusable = this.focusable.get(0);
      body = $('body');
      current = body.scrollTop();
      this.focusable.css({
        height: 1
      }).css({
        height: focusable.scrollHeight
      });
      return $('body').scrollTop(current);
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
  var globalize;

  globalize = function() {
    this.version = '1.0.0';
    this.Module.extend.call(this, this.Config);
    this.configure = this.Config.set;
    this.Module.extend.call(this, this.Events);
    this.Module.extend.call(this, this.I18n);
    this.Module.extend.call(this, this.Logger);
    return this.support = {
      webkit: navigator.userAgent.indexOf('WebKit') > 0,
      firefox: navigator.userAgent.indexOf('Firefox') > 0
    };
  };

  globalize.call(Mercury);

}).call(this);
