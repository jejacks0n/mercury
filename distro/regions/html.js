/*!
The HTML region is a full HTML5 Content Editable region -- a true WYSIWYG experience. Effort has been made to normalize,
and keep things consistent, but the nature of it is complex and should be treated as such. There's an expectation that
users who are exposed to this region understand HTML.

Dependencies:
  rangy-core - https://code.google.com/p/rangy/
  rangy-serializer
  rangy-cssclassapplier

Configuration:
  regions:html:
    mimeTypes: false                                     # file types - overrides general uploading to allow anything
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

    Html.include(Mercury.Region.Modules.Snippetable);

    Html.supported = Mercury.support.wysiwyg;

    Html.events = {
      'keydown': 'onKeyEvent',
      'paste': 'onPaste'
    };

    function Html() {
      var e;

      try {
        window.rangy.init();
      } catch (_error) {
        e = _error;
        this.notify(this.t('requires Rangy'));
        return false;
      }
      Html.__super__.constructor.apply(this, arguments);
    }

    Html.prototype.blur = function() {
      this.saveSelection();
      return Html.__super__.blur.apply(this, arguments);
    };

    Html.prototype.onDropFile = function(files) {
      var uploader,
        _this = this;

      uploader = new Mercury[this.config('interface:uploader')](files, {
        mimeTypes: this.options.mimeTypes
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

    return Html;

  })(Mercury.Region);

  Mercury.Region.Html.addToolbar({
    defined: {
      style: [
        'Style', {
          plugin: 'styles'
        }
      ],
      sep: ' ',
      block: [
        'Block Format', {
          plugin: 'blocks'
        }
      ]
    },
    color: {
      bgcolor: [
        'Background Color', {
          plugin: 'color'
        }
      ],
      sep: ' ',
      color: [
        'Text Color', {
          plugin: 'color'
        }
      ]
    },
    decoration: {
      bold: ['Bold'],
      italic: ['Italicize'],
      strike: ['Strikethrough'],
      underline: ['Underline']
    },
    script: {
      subscript: ['Subscript'],
      superscript: ['Superscript']
    },
    justify: {
      justifyLeft: ['Align Left'],
      justifyCenter: ['Center'],
      justifyRight: ['Align Right'],
      justifyFull: ['Justify Full']
    },
    list: {
      unorderedList: ['Unordered List'],
      orderedList: ['Numbered List']
    },
    indent: {
      indent: ['Increase Indentation'],
      outdent: ['Decrease Indentation']
    },
    rules: {
      rule: [
        'Horizontal Rule', {
          title: 'Insert a horizontal rule'
        }
      ]
    },
    extra: {
      clean: [
        'Remove Formatting', {
          title: 'Remove formatting for the selection'
        }
      ],
      sep: ' ',
      edit: [
        'Edit HTML', {
          title: 'Edit the HTML content'
        }
      ]
    },
    table: {
      rowBefore: [
        'Insert Table Row', {
          title: 'Insert a table row before the cursor'
        }
      ],
      rowAfter: [
        'Insert Table Row', {
          title: 'Insert a table row after the cursor'
        }
      ],
      rowDelete: [
        'Delete Table Row', {
          title: 'Delete this table row'
        }
      ],
      colBefore: [
        'Insert Table Column', {
          title: 'Insert a table column before the cursor'
        }
      ],
      colAfter: [
        'Insert Table Column', {
          title: 'Insert a table column after the cursor'
        }
      ],
      colDelete: [
        'Delete Table Column', {
          title: 'Delete this table column'
        }
      ],
      sep: ' ',
      colIncrease: [
        'Increase Cell Columns', {
          title: 'Increase the cells colspan'
        }
      ],
      colDecrease: [
        'Decrease Cell Columns', {
          title: 'Decrease the cells colspan and add a new cell'
        }
      ],
      rowIncrease: [
        'Increase Cell Rows', {
          title: 'Increase the cells rowspan'
        }
      ],
      rowDecrease: [
        'Decrease Cell Rows', {
          title: 'Decrease the cells rowspan and add a new cell'
        }
      ]
    }
  });

  Mercury.Region.Html.addAction({
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
    style: function() {},
    link: function(linkAction) {
      return this.replaceSelection(linkAction.asHtml());
    },
    table: function(tableAction) {
      return this.replaceSelection(tableAction.asHtml());
    },
    media: function(mediaAction) {
      return this.replaceSelection(mediaAction.asHtml());
    }
  });

}).call(this);
