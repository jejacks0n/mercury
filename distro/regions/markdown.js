
/*!
The Markdown region utilizes the Markdown syntax (http://en.wikipedia.org/wiki/Markdown) to generate an html preview.
When saved this region will return the markdown content (unprocessed). This content can be used by your server to render
html content to a user, or to serve the markdown when editing.

Dependencies:
  showdown-1.0 - https://github.com/coreyti/showdown

This is still experimental and could be changed later to provide a way to fetch the markdown content for a given region
via Ajax.
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Region.Markdown = (function(_super) {

    __extends(Markdown, _super);

    Markdown.define('Mercury.Region.Markdown', 'markdown');

    Markdown.include(Mercury.Region.Modules.DropIndicator);

    Markdown.include(Mercury.Region.Modules.SelectionValue);

    Markdown.include(Mercury.Region.Modules.FocusableTextarea);

    Markdown.include(Mercury.Region.Modules.TextSelection);

    Markdown.supported = true;

    Markdown.prototype.toolbars = ['markup'];

    Markdown.prototype.wrappers = {
      h1: ['# ', ' #'],
      h2: ['## ', ' ##'],
      h3: ['### ', ' ###'],
      h4: ['#### ', ' ####'],
      h5: ['##### ', ' #####'],
      h6: ['###### ', ' ######'],
      pre: ['```\n', '\n```'],
      paragraph: ['\n', '\n'],
      blockquote: ['> ', ''],
      bold: ['**'],
      italic: ['_'],
      underline: ['<u>', '</u>'],
      strike: ['<del>', '</del>'],
      sup: ['<sup>', '</sup>'],
      sub: ['<sub>', '</sub>'],
      unorderedList: ['- ', ''],
      orderedList: ['1. ', '', /^\d+. |$/gi],
      link: ['[', '](%s)', /^\[|\]\([^)]\)/gi],
      image: ['![', '](%s)', /^!\[|\]\([^)]\)/gi],
      style: ['<span style="%s">', '</span>', /^(<span style="[^"]*">)|(<\/span>)$/gi],
      "class": ['<span class="%s">', '</span>', /^(<span class="[^"]*">)|(<\/span>)$/gi]
    };

    Markdown.prototype.blocks = ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', 'unorderedList', 'orderedList'];

    function Markdown(el, options) {
      this.el = el;
      this.options = options != null ? options : {};
      try {
        this.converter = this.options.converter || new Showdown.converter().makeHtml;
      } catch (e) {
        this.notify(this.t('requires Showdown'));
        return false;
      }
      Markdown.__super__.constructor.apply(this, arguments);
    }

    Markdown.prototype.convertedValue = function() {
      return this.converter(this.value());
    };

    Markdown.prototype.onDropFile = function(files) {
      var uploader,
        _this = this;
      uploader = new Mercury.Uploader(files, {
        mimeTypes: this.config('regions:markdown:mimeTypes')
      });
      return uploader.on('uploaded', function(file) {
        _this.focus();
        return _this.handleAction('file', file);
      });
    };

    Markdown.prototype.onDropItem = function(e, data) {
      var url;
      if (url = $('<div>').html(data.getData('text/html')).find('img').attr('src')) {
        e.preventDefault();
        this.focus();
        return this.handleAction('image', {
          url: url
        });
      }
    };

    Markdown.prototype.onReturnKey = function(e) {
      var exp, match, next, val;
      exp = this.expandSelectionToLines(this.getSelection());
      val = exp.text;
      if (val.match(/^- /)) {
        e.preventDefault();
        if (val.match(/^- ./)) {
          return this.replaceSelection('\n- ');
        } else {
          return this.replaceSelectedLine(exp, '\n');
        }
      } else if (match = val.match(/^(\d+)\. /)) {
        e.preventDefault();
        next = parseInt(match[1], 10) + 1;
        if (val.match(/^\d+\. ./)) {
          return this.replaceSelection("\n" + next + ". ");
        } else {
          return this.replaceSelectedLine(exp, '\n');
        }
      } else if (match = val.match(/^(> )+/g)) {
        e.preventDefault();
        if (val.match(/^(> )+./g)) {
          return this.replaceSelection("\n" + match[0]);
        } else {
          return this.replaceSelectedLine(exp, '\n');
        }
      }
    };

    Markdown.prototype.actions = {
      bold: function() {
        return this.toggleWrapSelectedWords('bold');
      },
      italic: function() {
        return this.toggleWrapSelectedWords('italic');
      },
      underline: function() {
        return this.toggleWrapSelectedWords('underline');
      },
      strike: function() {
        return this.toggleWrapSelectedWords('strike');
      },
      subscript: function() {
        return this.toggleWrapSelectedWords('sub');
      },
      superscript: function() {
        return this.toggleWrapSelectedWords('sup');
      },
      rule: function() {
        return this.replaceSelectionWithParagraph('- - -');
      },
      indent: function() {
        return this.wrapSelectedParagraphs('blockquote');
      },
      outdent: function() {
        return this.unwrapSelectedParagraphs('blockquote');
      },
      style: function(value) {
        var wrapper;
        wrapper = value.indexOf(':') > -1 ? 'style' : 'class';
        this.unwrapSelectedWords(wrapper === 'style' ? 'class' : 'style');
        return this.toggleWrapSelectedWords(this.processWrapper(wrapper, [value]));
      },
      html: function(html) {
        return this.replaceSelection(html = (html.get && html.get(0) || html).outerHTML || html);
      },
      block: function(format) {
        var wrapper, _i, _j, _len, _len1, _ref, _ref1;
        if (format === 'blockquote') {
          _ref = ['orderedList', 'unorderedList'];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            wrapper = _ref[_i];
            this.unwrapSelectedParagraphs(wrapper);
          }
          if (!this.unwrapSelectedParagraphs('blockquote')) {
            this.handleAction('indent');
          }
          return;
        }
        if (format === 'pre' || format === 'paragraph') {
          this.unwrapSelectedParagraphs('pre', {
            all: true
          });
          if (this.wrappers[format]) {
            return this.wrapSelectedParagraphs(format, {
              all: true
            });
          }
        }
        _ref1 = this.blocks;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          wrapper = _ref1[_j];
          this.unwrapSelectedLines(wrapper);
        }
        if (this.wrappers[format]) {
          return this.wrapSelectedLines(format);
        }
      },
      orderedList: function() {
        var wrapper, _i, _len, _ref;
        _ref = ['blockquote', 'unorderedList'];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          wrapper = _ref[_i];
          this.unwrapSelectedParagraphs(wrapper);
        }
        if (!this.unwrapSelectedParagraphs('orderedList')) {
          return this.wrapSelectedParagraphs('orderedList');
        }
      },
      unorderedList: function() {
        var wrapper, _i, _len, _ref;
        _ref = ['blockquote', 'orderedList'];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          wrapper = _ref[_i];
          this.unwrapSelectedParagraphs(wrapper);
        }
        if (!this.unwrapSelectedParagraphs('unorderedList')) {
          return this.wrapSelectedParagraphs('unorderedList');
        }
      },
      file: function(file) {
        var action;
        action = file.isImage() ? 'image' : 'link';
        return this.handleAction(action, {
          url: file.get('url'),
          text: file.get('name')
        });
      },
      link: function(link) {
        var text;
        text = link.get('text');
        return this.wrapSelected(this.processWrapper('link', [link.get('url'), text]), {
          text: text,
          select: 'end'
        });
      },
      image: function(image) {
        var text;
        text = image.get('text');
        return this.wrapSelected(this.processWrapper('image', [image.get('url'), text]), {
          text: text,
          select: 'end'
        });
      }
    };

    return Markdown;

  })(Mercury.Region);

}).call(this);
