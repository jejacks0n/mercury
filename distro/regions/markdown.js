
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

  Mercury.MarkdownRegion = (function(_super) {

    __extends(MarkdownRegion, _super);

    MarkdownRegion.define('Mercury.MarkdownRegion', 'markdown');

    MarkdownRegion.include(Mercury.Region.Modules.DropIndicator);

    MarkdownRegion.include(Mercury.Region.Modules.SelectionValue);

    MarkdownRegion.include(Mercury.Region.Modules.FocusableTextarea);

    MarkdownRegion.include(Mercury.Region.Modules.TextSelection);

    MarkdownRegion.supported = true;

    MarkdownRegion.prototype.wrappers = {
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
      sup: ['<sup>', '</sup>'],
      sub: ['<sub>', '</sub>'],
      unorderedList: ['- ', ''],
      orderedList: ['1. ', '', /^\d+. |$/gi],
      link: ['[', '](%s)\n', /^\[|\]\([^)]\)/gi],
      image: ['![', '](%s)\n', /^!\[|\]\([^)]\)/gi],
      style: ['<span style="%s">', '</span>', /^(<span style="[^"]*">)|(<\/span>)$/gi],
      "class": ['<span class="%s">', '</span>', /^(<span class="[^"]*">)|(<\/span>)$/gi]
    };

    MarkdownRegion.prototype.blocks = ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', 'unorderedList', 'orderedList'];

    function MarkdownRegion(el, options) {
      this.el = el;
      this.options = options != null ? options : {};
      try {
        this.converter = this.options.converter || new Showdown.converter().makeHtml;
      } catch (e) {
        this.notify(this.t('requires Showdown'));
        return false;
      }
      MarkdownRegion.__super__.constructor.apply(this, arguments);
    }

    MarkdownRegion.prototype.convertedValue = function() {
      return this.converter(this.value());
    };

    MarkdownRegion.prototype.onDropFile = function(files) {
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

    MarkdownRegion.prototype.onDropItem = function(e, data) {
      var url;
      if (url = $('<div>').html(data.getData('text/html')).find('img').attr('src')) {
        e.preventDefault();
        this.focus();
        return this.handleAction('image', url);
      }
    };

    MarkdownRegion.prototype.onReturnKey = function(e) {
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

    MarkdownRegion.prototype.actions = {
      bold: function() {
        return this.toggleWrapSelectedWords('bold');
      },
      italic: function() {
        return this.toggleWrapSelectedWords('italic');
      },
      underline: function() {
        return this.toggleWrapSelectedWords('underline');
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
        if (wrapper === 'style') {
          this.unwrapSelectedWords('class');
        } else {
          this.unwrapSelectedWords('style');
        }
        return this.toggleWrapSelectedWords(this.processWrapper(wrapper, [value]));
      },
      html: function(html) {
        return this.replaceSelection(html = (html.get && html.get(0) || html).outerHTML || html);
      },
      block: function(format) {
        var wrapper, _i, _len, _ref;
        if (format === 'blockquote') {
          this.unwrapSelectedParagraphs('orderedList');
          this.unwrapSelectedParagraphs('unorderedList');
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
        _ref = this.blocks;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          wrapper = _ref[_i];
          this.unwrapSelectedLines(wrapper);
        }
        if (this.wrappers[format]) {
          return this.wrapSelectedLines(format);
        }
      },
      orderedList: function() {
        this.unwrapSelectedParagraphs('blockquote');
        this.unwrapSelectedParagraphs('unorderedList');
        if (!this.unwrapSelectedParagraphs('orderedList')) {
          return this.wrapSelectedParagraphs('orderedList');
        }
      },
      unorderedList: function() {
        this.unwrapSelectedParagraphs('blockquote');
        this.unwrapSelectedParagraphs('orderedList');
        if (!this.unwrapSelectedParagraphs('unorderedList')) {
          return this.wrapSelectedParagraphs('unorderedList');
        }
      },
      snippet: function(snippet) {
        return console.error('not implemented');
      },
      file: function(file) {
        var action;
        action = file.isImage() ? 'image' : 'link';
        return this.handleAction(action, file.get('url'), file.get('name'));
      },
      link: function(url, text) {
        return this.wrapSelected(this.processWrapper('link', [url, text]), {
          text: text,
          select: 'end'
        });
      },
      image: function(url, text) {
        return this.wrapSelected(this.processWrapper('image', [url, text]), {
          text: text,
          select: 'end'
        });
      }
    };

    return MarkdownRegion;

  })(Mercury.Region);

}).call(this);
