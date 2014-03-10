
/*!
The Plain region is a simplified single line HTML5 Content Editable region. It restricts drag/drop, can restrict paste
and line feeds and only provides the ability to do some common actions like bold, italics, and underline. This is a
useful region for headings and other single line areas.

Dependencies:
  rangy-core - https://code.google.com/p/rangy/
  rangy-serializer
  rangy-cssclassapplier

Configuration:
  regions:plain:
    actions  : true                                      # allow the common actions (bold/italic/underline)
    pasting  : true                                      # allow pasting -- always sanitized to text
    newlines : false                                     # allow line feeds (on enter and paste)
 */

(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Region.Plain = (function(_super) {
    __extends(Plain, _super);

    Plain.define('Mercury.Region.Plain', 'plain');

    Plain.include(Mercury.Region.Modules.HtmlSelection);

    Plain.include(Mercury.Region.Modules.SelectionValue);

    Plain.include(Mercury.Region.Modules.ContentEditable);

    Plain.supported = Mercury.support.wysiwyg;

    Plain.events = {
      'keydown': 'onKeyEvent',
      'paste': 'onPaste'
    };

    function Plain() {
      var e;
      try {
        window.rangy.init();
      } catch (_error) {
        e = _error;
        this.notify(this.t('requires Rangy'));
        return false;
      }
      Plain.__super__.constructor.apply(this, arguments);
      if (this.options.allowActs === false) {
        this.actions = false;
      }
    }

    Plain.prototype.onDropItem = function(e) {
      return this.prevent(e);
    };

    Plain.prototype.onPaste = function(e) {
      this.prevent(e);
      return this.insertContent(e.originalEvent.clipboardData.getData('text/plain'));
    };

    Plain.prototype.insertContent = function(content) {
      content = this.options.newlines ? content.replace('\n', '<br>') : content.replace('\n', ' ');
      return document.execCommand('insertHTML', null, content || ' ');
    };

    Plain.prototype.onKeyEvent = function(e) {
      if (e.keyCode >= 37 && e.keyCode <= 40) {
        return;
      }
      if (e.metaKey && e.keyCode === 90) {
        return;
      }
      if (e.keyCode === 13 && !this.options.newlines) {
        return this.prevent(e);
      }
      if (e.metaKey) {
        switch (e.keyCode) {
          case 66:
            this.prevent(e);
            return this.handleAction('bold');
          case 73:
            this.prevent(e);
            return this.handleAction('italic');
          case 85:
            this.prevent(e);
            return this.handleAction('underline');
        }
      }
      return this.pushHistory(e.keyCode);
    };

    return Plain;

  })(Mercury.Region);

  Mercury.Region.Plain.addToolbar({
    decoration: {
      bold: ['Bold'],
      italic: ['Italicize'],
      underline: ['Underline']
    }
  });

  Mercury.Region.Plain.addAction({
    bold: function() {
      return this.toggleWrapSelectedWordsInClass('red');
    },
    italic: function() {
      return this.toggleWrapSelectedWordsInClass('highlight');
    },
    underline: function() {
      return this.toggleWrapSelectedWordsInClass('blue');
    }
  });

}).call(this);
