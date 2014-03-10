
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
      Markdown.__super__.constructor.apply(this, arguments);
      this.setupConverter();
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
      var uploader;
      uploader = new Mercury[this.config('interface:uploader')](files, {
        mimeTypes: this.options.mimeTypes
      });
      return uploader.on('uploaded', (function(_this) {
        return function(file) {
          _this.focus();
          return _this.handleAction('file', file);
        };
      })(this));
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
    media: function(media) {
      return this.replaceSelection(media.asMarkdown());
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
/**
 * marked - a markdown parser
 * Copyright (c) 2011-2013, Christopher Jeffrey. (MIT Licensed)
 * https://github.com/chjj/marked
 */


;(function() {

  /**
   * Block-Level Grammar
   */

  var block = {
    newline: /^\n+/,
    code: /^( {4}[^\n]+\n*)+/,
    fences: noop,
    hr: /^( *[-*_]){3,} *(?:\n+|$)/,
    heading: /^ *(#{1,6}) *([^\n]+?) *#* *(?:\n+|$)/,
    nptable: noop,
    lheading: /^([^\n]+)\n *(=|-){2,} *(?:\n+|$)/,
    blockquote: /^( *>[^\n]+(\n[^\n]+)*\n*)+/,
    list: /^( *)(bull) [\s\S]+?(?:hr|\n{2,}(?! )(?!\1bull )\n*|\s*$)/,
    html: /^ *(?:comment|closed|closing) *(?:\n{2,}|\s*$)/,
    def: /^ *\[([^\]]+)\]: *<?([^\s>]+)>?(?: +["(]([^\n]+)[")])? *(?:\n+|$)/,
    table: noop,
    paragraph: /^((?:[^\n]+\n?(?!hr|heading|lheading|blockquote|tag|def))+)\n*/,
    text: /^[^\n]+/
  };

  block.bullet = /(?:[*+-]|\d+\.)/;
  block.item = /^( *)(bull) [^\n]*(?:\n(?!\1bull )[^\n]*)*/;
  block.item = replace(block.item, 'gm')
      (/bull/g, block.bullet)
      ();

  block.list = replace(block.list)
      (/bull/g, block.bullet)
      ('hr', /\n+(?=(?: *[-*_]){3,} *(?:\n+|$))/)
      ();

  block._tag = '(?!(?:'
      + 'a|em|strong|small|s|cite|q|dfn|abbr|data|time|code'
      + '|var|samp|kbd|sub|sup|i|b|u|mark|ruby|rt|rp|bdi|bdo'
      + '|span|br|wbr|ins|del|img)\\b)\\w+(?!:/|@)\\b';

  block.html = replace(block.html)
      ('comment', /<!--[\s\S]*?-->/)
      ('closed', /<(tag)[\s\S]+?<\/\1>/)
      ('closing', /<tag(?:"[^"]*"|'[^']*'|[^'">])*?>/)
      (/tag/g, block._tag)
      ();

  block.paragraph = replace(block.paragraph)
      ('hr', block.hr)
      ('heading', block.heading)
      ('lheading', block.lheading)
      ('blockquote', block.blockquote)
      ('tag', '<' + block._tag)
      ('def', block.def)
      ();

  /**
   * Normal Block Grammar
   */

  block.normal = merge({}, block);

  /**
   * GFM Block Grammar
   */

  block.gfm = merge({}, block.normal, {
    fences: /^ *(`{3,}|~{3,}) *(\S+)? *\n([\s\S]+?)\s*\1 *(?:\n+|$)/,
    paragraph: /^/
  });

  block.gfm.paragraph = replace(block.paragraph)
      ('(?!', '(?!'
          + block.gfm.fences.source.replace('\\1', '\\2') + '|'
          + block.list.source.replace('\\1', '\\3') + '|')
      ();

  /**
   * GFM + Tables Block Grammar
   */

  block.tables = merge({}, block.gfm, {
    nptable: /^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))*)\n*/,
    table: /^ *\|(.+)\n *\|( *[-:]+[-| :]*)\n((?: *\|.*(?:\n|$))*)\n*/
  });

  /**
   * Block Lexer
   */

  function Lexer(options) {
    this.tokens = [];
    this.tokens.links = {};
    this.options = options || marked.defaults;
    this.rules = block.normal;

    if (this.options.gfm) {
      if (this.options.tables) {
        this.rules = block.tables;
      } else {
        this.rules = block.gfm;
      }
    }
  }

  /**
   * Expose Block Rules
   */

  Lexer.rules = block;

  /**
   * Static Lex Method
   */

  Lexer.lex = function(src, options) {
    var lexer = new Lexer(options);
    return lexer.lex(src);
  };

  /**
   * Preprocessing
   */

  Lexer.prototype.lex = function(src) {
    src = src
        .replace(/\r\n|\r/g, '\n')
        .replace(/\t/g, '    ')
        .replace(/\u00a0/g, ' ')
        .replace(/\u2424/g, '\n');

    return this.token(src, true);
  };

  /**
   * Lexing
   */

  Lexer.prototype.token = function(src, top) {
    var src = src.replace(/^ +$/gm, '')
        , next
        , loose
        , cap
        , bull
        , b
        , item
        , space
        , i
        , l;

    while (src) {
      // newline
      if (cap = this.rules.newline.exec(src)) {
        src = src.substring(cap[0].length);
        if (cap[0].length > 1) {
          this.tokens.push({
            type: 'space'
          });
        }
      }

      // code
      if (cap = this.rules.code.exec(src)) {
        src = src.substring(cap[0].length);
        cap = cap[0].replace(/^ {4}/gm, '');
        this.tokens.push({
          type: 'code',
          text: !this.options.pedantic
              ? cap.replace(/\n+$/, '')
              : cap
        });
        continue;
      }

      // fences (gfm)
      if (cap = this.rules.fences.exec(src)) {
        src = src.substring(cap[0].length);
        this.tokens.push({
          type: 'code',
          lang: cap[2],
          text: cap[3]
        });
        continue;
      }

      // heading
      if (cap = this.rules.heading.exec(src)) {
        src = src.substring(cap[0].length);
        this.tokens.push({
          type: 'heading',
          depth: cap[1].length,
          text: cap[2]
        });
        continue;
      }

      // table no leading pipe (gfm)
      if (top && (cap = this.rules.nptable.exec(src))) {
        src = src.substring(cap[0].length);

        item = {
          type: 'table',
          header: cap[1].replace(/^ *| *\| *$/g, '').split(/ *\| */),
          align: cap[2].replace(/^ *|\| *$/g, '').split(/ *\| */),
          cells: cap[3].replace(/\n$/, '').split('\n')
        };

        for (i = 0; i < item.align.length; i++) {
          if (/^ *-+: *$/.test(item.align[i])) {
            item.align[i] = 'right';
          } else if (/^ *:-+: *$/.test(item.align[i])) {
            item.align[i] = 'center';
          } else if (/^ *:-+ *$/.test(item.align[i])) {
            item.align[i] = 'left';
          } else {
            item.align[i] = null;
          }
        }

        for (i = 0; i < item.cells.length; i++) {
          item.cells[i] = item.cells[i].split(/ *\| */);
        }

        this.tokens.push(item);

        continue;
      }

      // lheading
      if (cap = this.rules.lheading.exec(src)) {
        src = src.substring(cap[0].length);
        this.tokens.push({
          type: 'heading',
          depth: cap[2] === '=' ? 1 : 2,
          text: cap[1]
        });
        continue;
      }

      // hr
      if (cap = this.rules.hr.exec(src)) {
        src = src.substring(cap[0].length);
        this.tokens.push({
          type: 'hr'
        });
        continue;
      }

      // blockquote
      if (cap = this.rules.blockquote.exec(src)) {
        src = src.substring(cap[0].length);

        this.tokens.push({
          type: 'blockquote_start'
        });

        cap = cap[0].replace(/^ *> ?/gm, '');

        // Pass `top` to keep the current
        // "toplevel" state. This is exactly
        // how markdown.pl works.
        this.token(cap, top);

        this.tokens.push({
          type: 'blockquote_end'
        });

        continue;
      }

      // list
      if (cap = this.rules.list.exec(src)) {
        src = src.substring(cap[0].length);
        bull = cap[2];

        this.tokens.push({
          type: 'list_start',
          ordered: bull.length > 1
        });

        // Get each top-level item.
        cap = cap[0].match(this.rules.item);

        next = false;
        l = cap.length;
        i = 0;

        for (; i < l; i++) {
          item = cap[i];

          // Remove the list item's bullet
          // so it is seen as the next token.
          space = item.length;
          item = item.replace(/^ *([*+-]|\d+\.) +/, '');

          // Outdent whatever the
          // list item contains. Hacky.
          if (~item.indexOf('\n ')) {
            space -= item.length;
            item = !this.options.pedantic
                ? item.replace(new RegExp('^ {1,' + space + '}', 'gm'), '')
                : item.replace(/^ {1,4}/gm, '');
          }

          // Determine whether the next list item belongs here.
          // Backpedal if it does not belong in this list.
          if (this.options.smartLists && i !== l - 1) {
            b = block.bullet.exec(cap[i + 1])[0];
            if (bull !== b && !(bull.length > 1 && b.length > 1)) {
              src = cap.slice(i + 1).join('\n') + src;
              i = l - 1;
            }
          }

          // Determine whether item is loose or not.
          // Use: /(^|\n)(?! )[^\n]+\n\n(?!\s*$)/
          // for discount behavior.
          loose = next || /\n\n(?!\s*$)/.test(item);
          if (i !== l - 1) {
            next = item.charAt(item.length - 1) === '\n';
            if (!loose) loose = next;
          }

          this.tokens.push({
            type: loose
                ? 'loose_item_start'
                : 'list_item_start'
          });

          // Recurse.
          this.token(item, false);

          this.tokens.push({
            type: 'list_item_end'
          });
        }

        this.tokens.push({
          type: 'list_end'
        });

        continue;
      }

      // html
      if (cap = this.rules.html.exec(src)) {
        src = src.substring(cap[0].length);
        this.tokens.push({
          type: this.options.sanitize
              ? 'paragraph'
              : 'html',
          pre: cap[1] === 'pre' || cap[1] === 'script' || cap[1] === 'style',
          text: cap[0]
        });
        continue;
      }

      // def
      if (top && (cap = this.rules.def.exec(src))) {
        src = src.substring(cap[0].length);
        this.tokens.links[cap[1].toLowerCase()] = {
          href: cap[2],
          title: cap[3]
        };
        continue;
      }

      // table (gfm)
      if (top && (cap = this.rules.table.exec(src))) {
        src = src.substring(cap[0].length);

        item = {
          type: 'table',
          header: cap[1].replace(/^ *| *\| *$/g, '').split(/ *\| */),
          align: cap[2].replace(/^ *|\| *$/g, '').split(/ *\| */),
          cells: cap[3].replace(/(?: *\| *)?\n$/, '').split('\n')
        };

        for (i = 0; i < item.align.length; i++) {
          if (/^ *-+: *$/.test(item.align[i])) {
            item.align[i] = 'right';
          } else if (/^ *:-+: *$/.test(item.align[i])) {
            item.align[i] = 'center';
          } else if (/^ *:-+ *$/.test(item.align[i])) {
            item.align[i] = 'left';
          } else {
            item.align[i] = null;
          }
        }

        for (i = 0; i < item.cells.length; i++) {
          item.cells[i] = item.cells[i]
              .replace(/^ *\| *| *\| *$/g, '')
              .split(/ *\| */);
        }

        this.tokens.push(item);

        continue;
      }

      // top-level paragraph
      if (top && (cap = this.rules.paragraph.exec(src))) {
        src = src.substring(cap[0].length);
        this.tokens.push({
          type: 'paragraph',
          text: cap[1].charAt(cap[1].length - 1) === '\n'
              ? cap[1].slice(0, -1)
              : cap[1]
        });
        continue;
      }

      // text
      if (cap = this.rules.text.exec(src)) {
        // Top-level should never reach here.
        src = src.substring(cap[0].length);
        this.tokens.push({
          type: 'text',
          text: cap[0]
        });
        continue;
      }

      if (src) {
        throw new
            Error('Infinite loop on byte: ' + src.charCodeAt(0));
      }
    }

    return this.tokens;
  };

  /**
   * Inline-Level Grammar
   */

  var inline = {
    escape: /^\\([\\`*{}\[\]()#+\-.!_>])/,
    autolink: /^<([^ >]+(@|:\/)[^ >]+)>/,
    url: noop,
    tag: /^<!--[\s\S]*?-->|^<\/?\w+(?:"[^"]*"|'[^']*'|[^'">])*?>/,
    link: /^!?\[(inside)\]\(href\)/,
    reflink: /^!?\[(inside)\]\s*\[([^\]]*)\]/,
    nolink: /^!?\[((?:\[[^\]]*\]|[^\[\]])*)\]/,
    strong: /^__([\s\S]+?)__(?!_)|^\*\*([\s\S]+?)\*\*(?!\*)/,
    em: /^\b_((?:__|[\s\S])+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*)/,
    code: /^(`+)\s*([\s\S]*?[^`])\s*\1(?!`)/,
    br: /^ {2,}\n(?!\s*$)/,
    del: noop,
    text: /^[\s\S]+?(?=[\\<!\[_*`]| {2,}\n|$)/
  };

  inline._inside = /(?:\[[^\]]*\]|[^\[\]]|\](?=[^\[]*\]))*/;
  inline._href = /\s*<?([\s\S]*?)>?(?:\s+['"]([\s\S]*?)['"])?\s*/;

  inline.link = replace(inline.link)
      ('inside', inline._inside)
      ('href', inline._href)
      ();

  inline.reflink = replace(inline.reflink)
      ('inside', inline._inside)
      ();

  /**
   * Normal Inline Grammar
   */

  inline.normal = merge({}, inline);

  /**
   * Pedantic Inline Grammar
   */

  inline.pedantic = merge({}, inline.normal, {
    strong: /^__(?=\S)([\s\S]*?\S)__(?!_)|^\*\*(?=\S)([\s\S]*?\S)\*\*(?!\*)/,
    em: /^_(?=\S)([\s\S]*?\S)_(?!_)|^\*(?=\S)([\s\S]*?\S)\*(?!\*)/
  });

  /**
   * GFM Inline Grammar
   */

  inline.gfm = merge({}, inline.normal, {
    escape: replace(inline.escape)('])', '~|])')(),
    url: /^(https?:\/\/[^\s<]+[^<.,:;"')\]\s])/,
    del: /^~~(?=\S)([\s\S]*?\S)~~/,
    text: replace(inline.text)
        (']|', '~]|')
        ('|', '|https?://|')
        ()
  });

  /**
   * GFM + Line Breaks Inline Grammar
   */

  inline.breaks = merge({}, inline.gfm, {
    br: replace(inline.br)('{2,}', '*')(),
    text: replace(inline.gfm.text)('{2,}', '*')()
  });

  /**
   * Inline Lexer & Compiler
   */

  function InlineLexer(links, options) {
    this.options = options || marked.defaults;
    this.links = links;
    this.rules = inline.normal;

    if (!this.links) {
      throw new
          Error('Tokens array requires a `links` property.');
    }

    if (this.options.gfm) {
      if (this.options.breaks) {
        this.rules = inline.breaks;
      } else {
        this.rules = inline.gfm;
      }
    } else if (this.options.pedantic) {
      this.rules = inline.pedantic;
    }
  }

  /**
   * Expose Inline Rules
   */

  InlineLexer.rules = inline;

  /**
   * Static Lexing/Compiling Method
   */

  InlineLexer.output = function(src, links, options) {
    var inline = new InlineLexer(links, options);
    return inline.output(src);
  };

  /**
   * Lexing/Compiling
   */

  InlineLexer.prototype.output = function(src) {
    var out = ''
        , link
        , text
        , href
        , cap;

    while (src) {
      // escape
      if (cap = this.rules.escape.exec(src)) {
        src = src.substring(cap[0].length);
        out += cap[1];
        continue;
      }

      // autolink
      if (cap = this.rules.autolink.exec(src)) {
        src = src.substring(cap[0].length);
        if (cap[2] === '@') {
          text = cap[1].charAt(6) === ':'
              ? this.mangle(cap[1].substring(7))
              : this.mangle(cap[1]);
          href = this.mangle('mailto:') + text;
        } else {
          text = escape(cap[1]);
          href = text;
        }
        out += '<a href="'
            + href
            + '">'
            + text
            + '</a>';
        continue;
      }

      // url (gfm)
      if (cap = this.rules.url.exec(src)) {
        src = src.substring(cap[0].length);
        text = escape(cap[1]);
        href = text;
        out += '<a href="'
            + href
            + '">'
            + text
            + '</a>';
        continue;
      }

      // tag
      if (cap = this.rules.tag.exec(src)) {
        src = src.substring(cap[0].length);
        out += this.options.sanitize
            ? escape(cap[0])
            : cap[0];
        continue;
      }

      // link
      if (cap = this.rules.link.exec(src)) {
        src = src.substring(cap[0].length);
        out += this.outputLink(cap, {
          href: cap[2],
          title: cap[3]
        });
        continue;
      }

      // reflink, nolink
      if ((cap = this.rules.reflink.exec(src))
          || (cap = this.rules.nolink.exec(src))) {
        src = src.substring(cap[0].length);
        link = (cap[2] || cap[1]).replace(/\s+/g, ' ');
        link = this.links[link.toLowerCase()];
        if (!link || !link.href) {
          out += cap[0].charAt(0);
          src = cap[0].substring(1) + src;
          continue;
        }
        out += this.outputLink(cap, link);
        continue;
      }

      // strong
      if (cap = this.rules.strong.exec(src)) {
        src = src.substring(cap[0].length);
        out += '<strong>'
            + this.output(cap[2] || cap[1])
            + '</strong>';
        continue;
      }

      // em
      if (cap = this.rules.em.exec(src)) {
        src = src.substring(cap[0].length);
        out += '<em>'
            + this.output(cap[2] || cap[1])
            + '</em>';
        continue;
      }

      // code
      if (cap = this.rules.code.exec(src)) {
        src = src.substring(cap[0].length);
        out += '<code>'
            + escape(cap[2], true)
            + '</code>';
        continue;
      }

      // br
      if (cap = this.rules.br.exec(src)) {
        src = src.substring(cap[0].length);
        out += '<br>';
        continue;
      }

      // del (gfm)
      if (cap = this.rules.del.exec(src)) {
        src = src.substring(cap[0].length);
        out += '<del>'
            + this.output(cap[1])
            + '</del>';
        continue;
      }

      // text
      if (cap = this.rules.text.exec(src)) {
        src = src.substring(cap[0].length);
        out += escape(this.smartypants(cap[0]));
        continue;
      }

      if (src) {
        throw new
            Error('Infinite loop on byte: ' + src.charCodeAt(0));
      }
    }

    return out;
  };

  /**
   * Compile Link
   */

  InlineLexer.prototype.outputLink = function(cap, link) {
    if (cap[0].charAt(0) !== '!') {
      return '<a href="'
          + escape(link.href)
          + '"'
          + (link.title
          ? ' title="'
          + escape(link.title)
          + '"'
          : '')
          + '>'
          + this.output(cap[1])
          + '</a>';
    } else {
      return '<img src="'
          + escape(link.href)
          + '" alt="'
          + escape(cap[1])
          + '"'
          + (link.title
          ? ' title="'
          + escape(link.title)
          + '"'
          : '')
          + '>';
    }
  };

  /**
   * Smartypants Transformations
   */

  InlineLexer.prototype.smartypants = function(text) {
    if (!this.options.smartypants) return text;
    return text
      // em-dashes
        .replace(/--/g, '\u2014')
      // opening singles
        .replace(/(^|[-\u2014/(\[{"\s])'/g, '$1\u2018')
      // closing singles & apostrophes
        .replace(/'/g, '\u2019')
      // opening doubles
        .replace(/(^|[-\u2014/(\[{\u2018\s])"/g, '$1\u201c')
      // closing doubles
        .replace(/"/g, '\u201d')
      // ellipses
        .replace(/\.{3}/g, '\u2026');
  };

  /**
   * Mangle Links
   */

  InlineLexer.prototype.mangle = function(text) {
    var out = ''
        , l = text.length
        , i = 0
        , ch;

    for (; i < l; i++) {
      ch = text.charCodeAt(i);
      if (Math.random() > 0.5) {
        ch = 'x' + ch.toString(16);
      }
      out += '&#' + ch + ';';
    }

    return out;
  };

  /**
   * Parsing & Compiling
   */

  function Parser(options) {
    this.tokens = [];
    this.token = null;
    this.options = options || marked.defaults;
  }

  /**
   * Static Parse Method
   */

  Parser.parse = function(src, options) {
    var parser = new Parser(options);
    return parser.parse(src);
  };

  /**
   * Parse Loop
   */

  Parser.prototype.parse = function(src) {
    this.inline = new InlineLexer(src.links, this.options);
    this.tokens = src.reverse();

    var out = '';
    while (this.next()) {
      out += this.tok();
    }

    return out;
  };

  /**
   * Next Token
   */

  Parser.prototype.next = function() {
    return this.token = this.tokens.pop();
  };

  /**
   * Preview Next Token
   */

  Parser.prototype.peek = function() {
    return this.tokens[this.tokens.length - 1] || 0;
  };

  /**
   * Parse Text Tokens
   */

  Parser.prototype.parseText = function() {
    var body = this.token.text;

    while (this.peek().type === 'text') {
      body += '\n' + this.next().text;
    }

    return this.inline.output(body);
  };

  /**
   * Parse Current Token
   */

  Parser.prototype.tok = function() {
    switch (this.token.type) {
      case 'space': {
        return '';
      }
      case 'hr': {
        return '<hr>\n';
      }
      case 'heading': {
        return '<h'
            + this.token.depth
            + ' id="'
            + this.token.text.toLowerCase().replace(/[^\w]+/g, '-')
            + '">'
            + this.inline.output(this.token.text)
            + '</h'
            + this.token.depth
            + '>\n';
      }
      case 'code': {
        if (this.options.highlight) {
          var code = this.options.highlight(this.token.text, this.token.lang);
          if (code != null && code !== this.token.text) {
            this.token.escaped = true;
            this.token.text = code;
          }
        }

        if (!this.token.escaped) {
          this.token.text = escape(this.token.text, true);
        }

        return '<pre><code'
            + (this.token.lang
            ? ' class="'
            + this.options.langPrefix
            + this.token.lang
            + '"'
            : '')
            + '>'
            + this.token.text
            + '</code></pre>\n';
      }
      case 'table': {
        var body = ''
            , heading
            , i
            , row
            , cell
            , j;

        // header
        body += '<thead>\n<tr>\n';
        for (i = 0; i < this.token.header.length; i++) {
          heading = this.inline.output(this.token.header[i]);
          body += '<th';
          if (this.token.align[i]) {
            body += ' style="text-align:' + this.token.align[i] + '"';
          }
          body += '>' + heading + '</th>\n';
        }
        body += '</tr>\n</thead>\n';

        // body
        body += '<tbody>\n'
        for (i = 0; i < this.token.cells.length; i++) {
          row = this.token.cells[i];
          body += '<tr>\n';
          for (j = 0; j < row.length; j++) {
            cell = this.inline.output(row[j]);
            body += '<td';
            if (this.token.align[j]) {
              body += ' style="text-align:' + this.token.align[j] + '"';
            }
            body += '>' + cell + '</td>\n';
          }
          body += '</tr>\n';
        }
        body += '</tbody>\n';

        return '<table>\n'
            + body
            + '</table>\n';
      }
      case 'blockquote_start': {
        var body = '';

        while (this.next().type !== 'blockquote_end') {
          body += this.tok();
        }

        return '<blockquote>\n'
            + body
            + '</blockquote>\n';
      }
      case 'list_start': {
        var type = this.token.ordered ? 'ol' : 'ul'
            , body = '';

        while (this.next().type !== 'list_end') {
          body += this.tok();
        }

        return '<'
            + type
            + '>\n'
            + body
            + '</'
            + type
            + '>\n';
      }
      case 'list_item_start': {
        var body = '';

        while (this.next().type !== 'list_item_end') {
          body += this.token.type === 'text'
              ? this.parseText()
              : this.tok();
        }

        return '<li>'
            + body
            + '</li>\n';
      }
      case 'loose_item_start': {
        var body = '';

        while (this.next().type !== 'list_item_end') {
          body += this.tok();
        }

        return '<li>'
            + body
            + '</li>\n';
      }
      case 'html': {
        return !this.token.pre && !this.options.pedantic
            ? this.inline.output(this.token.text)
            : this.token.text;
      }
      case 'paragraph': {
        return '<p>'
            + this.inline.output(this.token.text)
            + '</p>\n';
      }
      case 'text': {
        return '<p>'
            + this.parseText()
            + '</p>\n';
      }
    }
  };

  /**
   * Helpers
   */

  function escape(html, encode) {
    return html
        .replace(!encode ? /&(?!#?\w+;)/g : /&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
  }

  function replace(regex, opt) {
    regex = regex.source;
    opt = opt || '';
    return function self(name, val) {
      if (!name) return new RegExp(regex, opt);
      val = val.source || val;
      val = val.replace(/(^|[^\[])\^/g, '$1');
      regex = regex.replace(name, val);
      return self;
    };
  }

  function noop() {}
  noop.exec = noop;

  function merge(obj) {
    var i = 1
        , target
        , key;

    for (; i < arguments.length; i++) {
      target = arguments[i];
      for (key in target) {
        if (Object.prototype.hasOwnProperty.call(target, key)) {
          obj[key] = target[key];
        }
      }
    }

    return obj;
  }

  /**
   * Marked
   */

  function marked(src, opt, callback) {
    if (callback || typeof opt === 'function') {
      if (!callback) {
        callback = opt;
        opt = null;
      }

      opt = merge({}, marked.defaults, opt || {});

      var highlight = opt.highlight
          , tokens
          , pending
          , i = 0;

      try {
        tokens = Lexer.lex(src, opt)
      } catch (e) {
        return callback(e);
      }

      pending = tokens.length;

      var done = function() {
        var out, err;

        try {
          out = Parser.parse(tokens, opt);
        } catch (e) {
          err = e;
        }

        opt.highlight = highlight;

        return err
            ? callback(err)
            : callback(null, out);
      };

      if (!highlight || highlight.length < 3) {
        return done();
      }

      delete opt.highlight;

      if (!pending) return done();

      for (; i < tokens.length; i++) {
        (function(token) {
          if (token.type !== 'code') {
            return --pending || done();
          }
          return highlight(token.text, token.lang, function(err, code) {
            if (code == null || code === token.text) {
              return --pending || done();
            }
            token.text = code;
            token.escaped = true;
            --pending || done();
          });
        })(tokens[i]);
      }

      return;
    }
    try {
      if (opt) opt = merge({}, marked.defaults, opt);
      return Parser.parse(Lexer.lex(src, opt), opt);
    } catch (e) {
      e.message += '\nPlease report this to https://github.com/chjj/marked.';
      if ((opt || marked.defaults).silent) {
        return '<p>An error occured:</p><pre>'
            + escape(e.message + '', true)
            + '</pre>';
      }
      throw e;
    }
  }

  /**
   * Options
   */

  marked.options =
      marked.setOptions = function(opt) {
        merge(marked.defaults, opt);
        return marked;
      };

  marked.defaults = {
    gfm: true,
    tables: true,
    breaks: false,
    pedantic: false,
    sanitize: false,
    smartLists: false,
    silent: false,
    highlight: null,
    langPrefix: 'lang-',
    smartypants: false
  };

  /**
   * Expose
   */

  marked.Parser = Parser;
  marked.parser = Parser.parse;

  marked.Lexer = Lexer;
  marked.lexer = Lexer.lex;

  marked.InlineLexer = InlineLexer;
  marked.inlineLexer = InlineLexer.output;

  marked.parse = marked;

  if (typeof exports === 'object') {
    module.exports = marked;
  } else if (typeof define === 'function' && define.amd) {
    define(function() { return marked; });
  } else {
    this.marked = marked;
  }

}).call(function() {
      return this || (typeof window !== 'undefined' ? window : global);
    }());
