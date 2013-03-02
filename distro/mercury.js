
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
      notifier: 'error'
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
      config = this.configuration || (this.configuration = Mercury.configuration || (Mercury.configuration = {}));
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
        return this.configuration = value;
      }
      config = this.configuration || (this.configuration = Mercury.configuration || (Mercury.configuration = {}));
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
      var _ref;
      if (this.logPrefix) {
        msg = "" + this.logPrefix + " " + msg;
      }
      try {
        console.error(msg);
        return typeof console.trace === "function" ? console.trace() : void 0;
      } catch (e) {
        switch ((_ref = Mercury.configuration.logging) != null ? _ref.notifier : void 0) {
          case 'alert':
            return alert(msg);
          case 'error':
            throw new Error(msg);
        }
      }
    }
  };

}).call(this);
(function() {

  this.Mercury || (this.Mercury = {});

  Mercury.Stack = {
    pushStack: function(value) {
      if (value === null) {
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
    },
    included: function() {
      var self;
      self = this.prototype || this;
      self.stackPosition = 0;
      self.maxStackLength = 200;
      return self.stack = [];
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
      return (_ref = module.included) != null ? _ref.apply(this) : void 0;
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
      if (!this.events) {
        this.events = this.constructor.events;
      }
      if (!this.elements) {
        this.elements = this.constructor.elements;
      }
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

    View.prototype.delegateEvents = function(events) {
      var event, key, match, method, selector, _ref, _results,
        _this = this;
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
        _results.push(this.el.on(event, selector || null, method));
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

    Region.supported = true;

    Region.type = 'unknown';

    Region.prototype.logPrefix = 'Mercury.Region:';

    Region.define = function(className, type, actions) {
      this.className = className;
      this.type = type;
      this.actions = actions;
      this.logPrefix = this.prototype.logPrefix = "" + this.className + ":";
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
      Region.__super__.constructor.call(this, this.options);
      this.attr({
        tabindex: this.tabIndex || 0
      });
      this.name || (this.name = this.el.attr(this.config('regions:identifier')));
      if (!this.name) {
        this.notify(this.t('no name provided for the "%s" region, falling back to random', this.constructor.type));
        this.name = "" + this.constructor.type + (Math.floor(Math.random() * 10000));
      }
      this.previewing || (this.previewing = false);
      this.bindDefaultEvents();
    }

    Region.prototype.bindDefaultEvents = function() {
      var _this = this;
      this.delegateEvents({
        focus: function() {
          return typeof _this.onFocus === "function" ? _this.onFocus() : void 0;
        },
        blur: function() {
          return typeof _this.onBlur === "function" ? _this.onBlur() : void 0;
        }
      });
      Mercury.on('action', function() {
        return _this.handleAction.apply(_this, arguments);
      });
      this.delegateActions($.extend(true, this.constructor.actions, this.actions || (this.actions = {})));
      if (typeof this.dropFile === 'function') {
        return this.delegateDropFile();
      }
    };

    Region.prototype.handleAction = function() {
      var args, _base, _name;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return typeof (_base = this.actions)[_name = args.shift()] === "function" ? _base[_name].apply(_base, args) : void 0;
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

    Region.prototype.toJSON = function() {
      return {
        name: this.name,
        type: this.constructor.type,
        value: this.html(),
        data: this.data(),
        snippets: this.snippets()
      };
    };

    Region.prototype.release = function() {
      this.trigger('release');
      return this.off();
    };

    Region.prototype.delegateDropFile = function() {
      var _this = this;
      this.el.on('dragenter', function(e) {
        return e.preventDefault();
      });
      this.el.on('dragover', function(e) {
        return e.preventDefault();
      });
      return this.el.on('drop', function(e) {
        if (!e.originalEvent.dataTransfer.files.length) {
          return;
        }
        e.preventDefault();
        return _this.dropFile(e.originalEvent.dataTransfer.files);
      });
    };

    Region.prototype.delegateActions = function(actions) {
      var key, method, _results,
        _this = this;
      _results = [];
      for (key in actions) {
        method = actions[key];
        if (typeof method === 'function') {
          method = (function(method) {
            return function() {
              method.apply(_this, arguments);
              return true;
            };
          })(method);
        } else {
          if (!this[method]) {
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

  Mercury.GalleryRegion = (function(_super) {

    __extends(GalleryRegion, _super);

    function GalleryRegion() {
      return GalleryRegion.__super__.constructor.apply(this, arguments);
    }

    GalleryRegion.supported = true;

    GalleryRegion.define('Mercury.GalleryRegion', 'gallery', {
      undo: 'undo',
      redo: 'redo'
    });

    GalleryRegion.prototype.className = 'mercury-gallery-region';

    GalleryRegion.prototype.elements = {
      controls: '.mercury-gallery-region-controls',
      slides: '.slides',
      paginator: '.paginator'
    };

    GalleryRegion.prototype.events = {
      'click .mercury-gallery-region-controls em': 'removeSlide',
      'click .mercury-gallery-region-controls img': 'gotoSlide'
    };

    GalleryRegion.prototype.build = function() {
      var _this = this;
      this.speed || (this.speed = 3000);
      this.append('<ul class="mercury-gallery-region-controls"></ul>');
      this.index = 1;
      this.refresh(true);
      this.delay(this.speed, function() {
        return _this.nextSlide();
      });
      return this.pushStack(this.el.html());
    };

    GalleryRegion.prototype.onBlur = function() {
      return this.controls.hide();
    };

    GalleryRegion.prototype.onFocus = function() {
      return this.controls.show();
    };

    GalleryRegion.prototype.undo = function() {
      var html;
      if (html = this.undoStack()) {
        this.html(html);
      }
      return this.refresh(true);
    };

    GalleryRegion.prototype.redo = function() {
      var html;
      if (html = this.redoStack()) {
        this.html(html);
      }
      return this.refresh(true);
    };

    GalleryRegion.prototype.refresh = function(controls) {
      if (controls == null) {
        controls = false;
      }
      this.images = this.$('.slide').hide();
      if (this.index > this.images.length) {
        this.index = 1;
      }
      this.$(".slide:nth-child(" + this.index + ")").show();
      this.paginator.html(Array(this.images.length + 1).join('<span>&bull;</span>'));
      this.paginator.find("span:nth-child(" + this.index + ")").addClass('active');
      if (controls) {
        return this.refreshControls();
      }
    };

    GalleryRegion.prototype.refreshControls = function() {
      var slide, _i, _len, _ref, _results;
      this.controls.html('');
      _ref = this.images;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        slide = _ref[_i];
        _results.push(this.addLink($(slide)));
      }
      return _results;
    };

    GalleryRegion.prototype.nextSlide = function() {
      var _this = this;
      this.index += 1;
      this.refresh();
      return this.timeout = this.delay(this.speed, function() {
        return _this.nextSlide();
      });
    };

    GalleryRegion.prototype.gotoSlide = function(e) {
      var _this = this;
      clearTimeout(this.timeout);
      this.index = $(e.target).closest('li').prevAll('li').length + 1;
      this.refresh();
      return this.timeout = this.delay(this.speed, function() {
        return _this.nextSlide();
      });
    };

    GalleryRegion.prototype.addLink = function(slide) {
      var src;
      src = slide.find('img').attr('src');
      return this.controls.append($("<li><img src=\"" + src + "\"/><em>&times;</em></li>").data({
        slide: slide
      }));
    };

    GalleryRegion.prototype.dropFile = function(files) {
      var uploader,
        _this = this;
      uploader = new Mercury.Uploader(files, {
        mimeTypes: this.config('regions:gallery:mimeTypes')
      });
      return uploader.on('uploaded', function() {
        return _this.appendSlide.apply(_this, arguments);
      });
    };

    GalleryRegion.prototype.appendSlide = function(file) {
      var slide;
      if (!file.isImage()) {
        return;
      }
      slide = $("<div class=\"slide\"><img src=\"" + (file.get('url')) + "\"/></div>");
      this.slides.append(slide);
      this.addLink(slide);
      this.refresh();
      return this.pushStack(this.el.html());
    };

    GalleryRegion.prototype.removeSlide = function(e) {
      var el, index, slide,
        _this = this;
      el = $(e.target).closest('li');
      slide = el.data('slide');
      index = slide.prevAll('.slide').length + 1;
      slide.remove();
      el.remove();
      if (index < this.index) {
        this.index -= 1;
      } else if (index === this.index) {
        clearTimeout(this.timeout);
        this.timeout = this.delay(this.speed, function() {
          return _this.nextSlide();
        });
      }
      this.refresh();
      return this.pushStack(this.el.html());
    };

    return GalleryRegion;

  })(Mercury.Region);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Editor = (function(_super) {

    __extends(Editor, _super);

    Editor.prototype.logPrefix = 'Mercury.Editor:';

    Editor.prototype.attributes = {
      id: 'mercury'
    };

    function Editor(options) {
      var region;
      this.options = options != null ? options : {};
      Editor.__super__.constructor.apply(this, arguments);
      this.regions = (function() {
        var _i, _len, _ref, _results;
        _ref = this.regionElements();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          region = _ref[_i];
          _results.push(Mercury.Region.create(region));
        }
        return _results;
      }).call(this);
    }

    Editor.prototype.regionElements = function() {
      return $("[" + (this.config('regions:attribute')) + "]");
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
      var mimeTypes;
      if (this.get('size') >= this.config('uploading:maxSize')) {
        this.addError('size', this.t('Too large'));
        return;
      }
      mimeTypes = this.options['mimeTypes'] || this.config('uploading:mimeTypes');
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
  var globalize;

  globalize = function() {
    this.version = '1.0.0';
    this.Module.extend.call(this, this.Config);
    this.configure = this.Config.set;
    this.Module.extend.call(this, this.Events);
    this.Module.extend.call(this, this.I18n);
    return this.Module.extend.call(this, this.Logger);
  };

  globalize.call(Mercury);

}).call(this);
