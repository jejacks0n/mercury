
/*!
The HTML region utilizes the full HTML5 ContentEditable featureset and adds some layers on top of that to normalize it
between browsers and to make it nicer to use.

Dependencies:
  rangy-core - https://code.google.com/p/rangy/
  rangy-serializer
  rangy-cssclassapplier
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Region.Html = (function(_super) {

    __extends(Html, _super);

    Html.define('Mercury.Region.Html', 'html');

    Html.include(Mercury.Region.Modules.DropIndicator);

    Html.include(Mercury.Region.Modules.HtmlSelection);

    Html.include(Mercury.Region.Modules.SelectionValue);

    Html.include(Mercury.Region.Modules.ContentEditable);

    Html.supported = document.designMode && (!Mercury.support.msie || Mercury.support.msie >= 10) && (window.rangy && window.rangy.supported);

    Html.prototype.events = {
      'keydown': 'onKeyEvent',
      'paste': 'onPaste'
    };

    function Html() {
      try {
        window.rangy.init();
      } catch (e) {
        this.notify(this.t('requires Rangy'));
        return false;
      }
      Html.__super__.constructor.apply(this, arguments);
    }

    Html.prototype.onDropFile = function(files, options) {
      var uploader,
        _this = this;
      uploader = new Mercury.Uploader(files, {
        mimeTypes: this.config('regions:html:mimeTypes')
      });
      return uploader.on('uploaded', function(file) {
        _this.focus();
        return _this.handleAction('file', file);
      });
    };

    Html.prototype.onDropItem = function() {
      return this.pushHistory();
    };

    Html.prototype.onPaste = function(e) {
      return console.debug('pasted', e);
    };

    Html.prototype.onKeyEvent = function(e) {
      if (e.keyCode >= 37 && e.keyCode <= 40) {
        return;
      }
      if (e.metaKey && e.keyCode === 90) {
        return;
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

    Html.prototype.actions = {
      bold: function() {
        return this.toggleWrapSelectedWordsInClass('red');
      },
      italic: function() {
        return this.toggleWrapSelectedWordsInClass('highlight');
      },
      underline: function() {
        return this.toggleWrapSelectedWordsInClass('blue');
      },
      rule: function() {
        return this.replaceSelection('<hr/>');
      },
      file: function(file) {
        var action;
        action = file.isImage() ? 'image' : 'link';
        return this.handleAction(action, {
          url: file.get('url'),
          text: file.get('name')
        });
      }
    };

    return Html;

  })(Mercury.Region);

}).call(this);
