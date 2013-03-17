
/*!
The HTML region utilizes the full HTML5 ContentEditable featureset and adds some layers on top of that to normalize it
between browsers and to make it nicer to use.

Dependencies:
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.HtmlRegion = (function(_super) {

    __extends(HtmlRegion, _super);

    HtmlRegion.define('Mercury.HtmlRegion', 'html');

    HtmlRegion.include(Mercury.Region.Modules.DropIndicator);

    HtmlRegion.include(Mercury.Region.Modules.HtmlSelection);

    HtmlRegion.include(Mercury.Region.Modules.SelectionValue);

    HtmlRegion.supported = document.designMode && (!Mercury.support.msie || Mercury.support.msie >= 10) && (window.rangy && window.rangy.supported);

    HtmlRegion.prototype.skipHistoryOnInitialize = true;

    HtmlRegion.prototype.events = {
      'keydown': 'handleKeyEvent'
    };

    function HtmlRegion() {
      try {
        window.rangy.init();
      } catch (e) {
        this.notify(this.t('requires Rangy'));
        return false;
      }
      HtmlRegion.__super__.constructor.apply(this, arguments);
    }

    HtmlRegion.prototype.build = function() {
      this.document = this.el.get(0).ownerDocument;
      this.makeEditable();
      return this.setEditPreferences();
    };

    HtmlRegion.prototype.makeEditable = function() {
      return this.el.get(0).contentEditable = true;
    };

    HtmlRegion.prototype.setEditPreferences = function() {
      try {
        this.document.execCommand('styleWithCSS', false, false);
        this.document.execCommand('insertBROnReturn', false, true);
        this.document.execCommand('enableInlineTableEditing', false, false);
        return this.document.execCommand('enableObjectResizing', false, false);
      } catch (_error) {}
    };

    HtmlRegion.prototype.handleKeyEvent = function(e) {
      if (e.keyCode >= 37 && e.keyCode <= 40) {
        return;
      }
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
      return this.pushHistory(e.keyCode);
    };

    HtmlRegion.prototype.actions = {
      bold: function() {
        return this.toggleWrapSelectedWordsInClass('red');
      },
      italic: function() {
        return this.toggleWrapSelectedWordsInClass('highlight');
      },
      underline: function() {
        return this.toggleWrapSelectedWordsInClass('blue');
      }
    };

    return HtmlRegion;

  })(Mercury.Region);

}).call(this);
