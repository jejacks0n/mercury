/*!
Markdown provides an easy way to provide some markup abilities without the exposing the ability to edit complex HTML.
Use the markdown sent to the server on save to render the content when not editing, and render the markdown when
editing. Some options are for the converter - more here: https://github.com/chjj/marked

When saved this region will serialize the unprocessed markdown content as well as the processed/converted html content.
This can be used by your server to render html, or to serve the markdown when editing -- it's up to you how you
accomplish this.

The default converter uses Github Flavored Markdown, so your server should implement the same thing.

Dependencies:
  marked - https://github.com/chjj/marked

Configuration:
  regions:markdown:
    autoSize : true                                      # the region will auto-resize to the content within it
    mimeTypes: false                                     # file types - overrides general uploading to allow anything
    wrapping : true                                      # enables/disables soft line wrapping
    sanitize : false                                     # sanitize the output - ignore any html that has been input
    breaks   : true                                      # enable line breaks - new lines will become line breaks
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Region.Markdown = (function(_super) {
    __extends(Markdown, _super);

    Markdown.define('Mercury.Region.Markdown', 'markdown');

    Markdown.include(Mercury.Region.Modules.DropIndicator);

    Markdown.include(Mercury.Region.Modules.DropItem);

    Markdown.include(Mercury.Region.Modules.SelectionValue);

    Markdown.include(Mercury.Region.Modules.FocusableTextarea);

    Markdown.include(Mercury.Region.Modules.TextSelection);

    Markdown.supported = true;

    Markdown.prototype.wrappers = {
      h1: ['# ', ' #'],
      h2: ['## ', ' ##'],
      h3: ['### ', ' ###'],
      h4: ['#### ', ' ####'],
      h5: ['##### ', ' #####'],
      h6: ['###### ', ' ######'],
      pre: ['```\n', '\n```'],
      indentPre: ['    ', ''],
      blockquote: ['> ', ''],
      paragraph: ['\n', '\n'],
      bold: ['**'],
      italic: ['_'],
      underline: ['<u>', '</u>'],
      strike: ['<del>', '</del>'],
      superscript: ['<sup>', '</sup>'],
      subscript: ['<sub>', '</sub>'],
      unorderedList: ['- ', ''],
      orderedList: ['1. ', '', /^\d+. |$/gi],
      link: ['[', '](%s)', /^\[|\]\([^)]\)/gi],
      image: ['![', '](%s)', /^!\[|\]\([^)]\)/gi],
      style: ['<span style="%s">', '</span>', /^(<span style="[^"]*">)|(<\/span>)$/gi],
      "class": ['<span class="%s">', '</span>', /^(<span class="[^"]*">)|(<\/span>)$/gi]
    };

    Markdown.prototype.blocks = ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', 'unorderedList', 'orderedList'];

    function Markdown(el, options) {
      var _ref;

      this.el = el;
      this.options = options != null ? options : {};
      this.converter = (_ref = this.options.converter) != null ? _ref : window.marked;
      if (!this.converter) {
        this.notify(this.t('requires a markdown converter'));
        return false;
      }
      this.setupConverter();
      Markdown.__super__.constructor.apply(this, arguments);
    }

    Markdown.prototype.setupConverter = function() {
      return this.converter.setOptions(this.options);
    };

    Markdown.prototype.convertedValue = function() {
      return this.converter(this.value());
    };

    Markdown.prototype.toJSON = function(forSave) {
      var obj;

      if (forSave == null) {
        forSave = false;
      }
      obj = Markdown.__super__.toJSON.apply(this, arguments);
      if (!forSave) {
        return obj;
      }
      obj.converted = this.convertedValue();
      return obj;
    };

    Markdown.prototype.onDropFile = function(files) {
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

    Markdown.prototype.onReturnKey = function(e) {
      var exp, match, next, val;

      exp = this.expandSelectionToLines(this.getSelection());
      val = exp.text;
      if (val.match(/^- /)) {
        this.prevent(e);
        if (val.match(/^- ./)) {
          return this.replaceSelection('\n- ');
        } else {
          return this.replaceSelectedLine(exp, '\n');
        }
      } else if (match = val.match(/^(\d+)\. /)) {
        this.prevent(e);
        next = parseInt(match[1], 10) + 1;
        if (val.match(/^\d+\. ./)) {
          return this.replaceSelection("\n" + next + ". ");
        } else {
          return this.replaceSelectedLine(exp, '\n');
        }
      } else if (match = val.match(/^(> )+/g)) {
        this.prevent(e);
        if (val.match(/^(> )+./g)) {
          return this.replaceSelection("\n" + match[0]);
        } else {
          return this.replaceSelectedLine(exp, '\n');
        }
      } else if (match = val.match(/^\s{4}/g)) {
        this.prevent(e);
        if (val.match(/^\s{4}./)) {
          return this.replaceSelection("\n    ");
        } else {
          return this.replaceSelectedLine(exp, '\n');
        }
      }
    };

    return Markdown;

  })(Mercury.Region);

  Mercury.Region.Markdown.addToolbar({
    defined: {
      style: [
        'Style', {
          plugin: 'styles'
        }
      ]
    },
    headings: {
      h1: [
        'Heading 1', {
          action: ['block', 'h1']
        }
      ],
      h2: [
        'Heading 2', {
          action: ['block', 'h2']
        }
      ],
      h3: [
        'Heading 3', {
          action: ['block', 'h3']
        }
      ],
      h4: [
        'Heading 4', {
          action: ['block', 'h4']
        }
      ],
      h5: [
        'Heading 5', {
          action: ['block', 'h5']
        }
      ],
      h6: [
        'Heading 6', {
          action: ['block', 'h6']
        }
      ],
      removeHeading: [
        'No Heading', {
          action: ['block', null]
        }
      ]
    },
    blocks: {
      unorderedList: ['Unordered List'],
      orderedList: ['Numbered List'],
      blockquote: [
        'Blockquote', {
          action: ['block', 'blockquote']
        }
      ],
      sep: ' ',
      pre: [
        'Formatted', {
          action: ['block', 'pre']
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
    }
  });

  Mercury.Region.Markdown.addAction({
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
      return this.toggleWrapSelectedWords('subscript');
    },
    superscript: function() {
      return this.toggleWrapSelectedWords('superscript');
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
    style: function(value) {
      var wrapper;

      wrapper = (value || '').indexOf(':') > -1 ? 'style' : 'class';
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
    character: function(html) {
      return this.handleAction('html', html);
    },
    table: function(table) {
      return this.handleAction('html', table.asHtml());
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
      return this.replaceSelection(link.asMarkdown());
    },
    image: function(image) {
      var text;

      text = image.get('text');
      return this.wrapSelected(this.processWrapper('image', [image.get('url'), text]), {
        text: text,
        select: 'end'
      });
    }
  });

  Mercury.Region.Markdown.addContext({
    h1: function() {
      return this.isWithinLineToken('h1');
    },
    h2: function() {
      return this.isWithinLineToken('h2');
    },
    h3: function() {
      return this.isWithinLineToken('h3');
    },
    h4: function() {
      return this.isWithinLineToken('h4');
    },
    h5: function() {
      return this.isWithinLineToken('h5');
    },
    h6: function() {
      return this.isWithinLineToken('h6');
    },
    blockquote: function() {
      return this.firstLineMatches(/^> /);
    },
    pre: function() {
      return this.paragraphMatches(/^```|```$/) || this.firstLineMatches(/^(> )*\s{4}/);
    },
    bold: function() {
      return this.isWithinToken('bold');
    },
    italic: function() {
      return this.isWithinToken('italic');
    },
    underline: function() {
      return this.isWithinToken('underline');
    },
    strike: function() {
      return this.isWithinToken('strike');
    },
    subscript: function() {
      return this.isWithinToken('subscript');
    },
    superscript: function() {
      return this.isWithinToken('superscript');
    },
    unorderedList: function() {
      return this.firstLineMatches(/^(> )*- /);
    },
    orderedList: function() {
      return this.firstLineMatches(/^(> )*\d+\./);
    }
  });

}).call(this);
