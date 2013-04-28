
/*!
Mercury Editor is a Coffeescript and jQuery based WYSIWYG editor released under the MIT License.
Documentation and other useful information can be found at https://github.com/jejacks0n/mercury

Copyright (c) 2013 Jeremy Jackson
*/


(function() {

  this.Mercury || (this.Mercury = {});

  Mercury.configuration = {
    logging: {
      enabled: false,
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
    "interface": {
      enabled: true,
      "class": 'FrameInterface',
      toolbar: 'Toolbar',
      statusbar: 'Statusbar',
      uploader: 'Uploader',
      silent: false,
      shadowed: false,
      maskable: false
    },
    toolbars: {
      floating: false,
      style: 'standard',
      primary: {
        save: [
          'Save', {
            title: 'Save this page',
            event: 'save',
            global: true
          }
        ],
        preview: [
          'Preview', {
            title: 'Preview this page',
            mode: 'preview',
            global: true
          }
        ],
        sep1: ' ',
        undo: [
          'Undo', {
            title: 'Undo your last action'
          }
        ],
        redo: [
          'Redo', {
            title: 'Redo your last action'
          }
        ],
        sep2: '-',
        link: [
          'Link', {
            title: 'Insert Link',
            plugin: 'link'
          }
        ],
        file: [
          'Media', {
            title: 'Insert Media and Files (images, videos, etc.)',
            plugin: 'media'
          }
        ],
        table: [
          'Table', {
            title: 'Insert Table',
            plugin: 'table'
          }
        ],
        character: [
          'Character', {
            title: 'Special Characters',
            plugin: 'character'
          }
        ],
        snippets: [
          'Snippet', {
            title: 'Snippet Panel'
          }
        ],
        sep3: ' ',
        history: [
          'History', {
            title: 'Page Version History',
            global: true,
            plugin: 'history'
          }
        ],
        notes: [
          'Notes', {
            title: 'Page Notes',
            global: true,
            plugin: 'notes'
          }
        ]
      }
    },
    regions: {
      attribute: 'data-mercury',
      options: 'data-region-options',
      identifier: 'id',
      gallery: {
        mimeTypes: ['image/jpeg']
      },
      html: {
        mimeTypes: false
      },
      image: {
        mimeTypes: ['image/jpeg']
      },
      markdown: {
        autoSize: true,
        mimeTypes: false,
        wrapping: true,
        sanitize: false,
        breaks: true
      },
      plain: {
        actions: true
      },
      text: {
        autoSize: true,
        stripTags: true,
        wrapping: false
      }
    }
  };

}).call(this);
(function() {

  this.Mercury || (this.Mercury = {});

}).call(this);
(function() {

  this.JST || (this.JST = {});

  JST['/mercury/templates/interface'] = function() {
    return "<div class=\"mercury-interface-mask\"></div>";
  };

}).call(this);
(function() {

  this.JST || (this.JST = {});

  JST['/mercury/templates/lightview'] = function() {
    return "<div class=\"mercury-lightview-overlay\"></div>\n<div class=\"mercury-lightview-dialog\">\n  <div class=\"mercury-lightview-dialog-positioner\">\n    <div class=\"mercury-lightview-dialog-title\"><em>&times;</em><span></span></div>\n    <div class=\"mercury-lightview-loading-indicator\"></div>\n    <div class=\"mercury-lightview-dialog-content-container\">\n      <div class=\"mercury-lightview-dialog-content\">\n      </div>\n    </div>\n  </div>\n</div>";
  };

}).call(this);
(function() {

  this.JST || (this.JST = {});

  JST['/mercury/templates/modal'] = function() {
    return "<div class=\"mercury-modal-overlay\"></div>\n<div class=\"mercury-modal-dialog\">\n  <div class=\"mercury-modal-dialog-positioner\">\n    <div class=\"mercury-modal-dialog-title\"><em>&times;</em><span></span></div>\n    <div class=\"mercury-modal-loading-indicator\"></div>\n    <div class=\"mercury-modal-dialog-content-container\">\n      <div class=\"mercury-modal-dialog-content\">\n      </div>\n    </div>\n  </div>\n</div>";
  };

}).call(this);
(function() {

  this.JST || (this.JST = {});

  JST['/mercury/templates/panel'] = function() {
    return "<div class=\"mercury-panel-title\"><em>&times;</em><span>Test Panel</span></div>\n<div class=\"mercury-panel-loading-indicator\"></div>\n  <div class=\"mercury-panel-content-container\">\n    <div class=\"mercury-panel-content\">\n      content\n    </div>\n  </div>\n</div>";
  };

}).call(this);
(function() {

  this.JST || (this.JST = {});

  JST['/mercury/templates/statusbar'] = function() {
    return "<div class=\"mercury-statusbar-about\">\n  <a href=\"https://github.com/jejacks0n/mercury\" target=\"_blank\">Mercury Editor v" + Mercury.version + "</a>\n</div>\n<div class=\"mercury-statusbar-path\"></div>";
  };

}).call(this);
(function() {

  this.JST || (this.JST = {});

  JST['/mercury/templates/uploader'] = function() {
    return "<div class=\"mercury-uploader-dialog\">\n  <div class=\"mercury-uploader-preview\"><b><img/></b></div>\n  <div class=\"mercury-uploader-details\"></div>\n  <div class=\"mercury-uploader-progress\">\n    <span></span>\n    <div class=\"mercury-uploader-indicator\"><div><b>0%</b></div></div>\n  </div>\n</div>";
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
  var __hasProp = {}.hasOwnProperty;

  Object.toParams = function(params) {
    var pairs, proc;
    pairs = [];
    (proc = function(object, prefix) {
      var el, i, key, value, _results;
      _results = [];
      for (key in object) {
        if (!__hasProp.call(object, key)) continue;
        value = object[key];
        if (value instanceof Array) {
          _results.push((function() {
            var _i, _len, _results1;
            _results1 = [];
            for (i = _i = 0, _len = value.length; _i < _len; i = ++_i) {
              el = value[i];
              _results1.push(proc(el, prefix != null ? "" + prefix + "[" + key + "][]" : "" + key + "[]"));
            }
            return _results1;
          })());
        } else if (value instanceof Object) {
          _results.push(proc(value, prefix != null ? prefix += "[" + key + "]" : prefix = key));
        } else {
          _results.push(pairs.push(prefix != null ? "" + prefix + "[" + key + "]=" + value : "" + key + "=" + value));
        }
      }
      return _results;
    })(params, null);
    return pairs.join('&');
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

  Mercury.TableEditor = (function() {

    function TableEditor(table, cell, cellContent) {
      this.table = table;
      this.cell = cell != null ? cell : null;
      this.cellContent = cellContent != null ? cellContent : '';
      if (this.table) {
        this.load(this.table, this.cell, this.cellContent);
      }
    }

    TableEditor.prototype.load = function(table, cell, cellContent) {
      this.table = table;
      this.cell = cell != null ? cell : null;
      this.cellContent = cellContent != null ? cellContent : '';
      this.cell || (this.cell = $(this.table.find('th, td')[0]));
      this.row = this.cell.parent('tr');
      this.columnCount = this.getColumnCount();
      return this.rowCount = this.getRowCount();
    };

    TableEditor.prototype.addColumnBefore = function() {
      return this.addColumn('before');
    };

    TableEditor.prototype.addColumnAfter = function() {
      return this.addColumn('after');
    };

    TableEditor.prototype.addColumn = function(position) {
      var i, intersecting, matchOptions, matching, newCell, row, sig, _i, _len, _ref, _results;
      if (position == null) {
        position = 'after';
      }
      sig = this.cellSignatureFor(this.cell);
      _ref = this.table.find('tr');
      _results = [];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        row = _ref[i];
        matchOptions = position === 'after' ? {
          right: sig.right
        } : {
          left: sig.left
        };
        if (matching = this.findCellByOptionsFor(row, matchOptions)) {
          newCell = $("<" + (matching.cell.get(0).tagName) + ">").html(this.cellContent);
          this.setRowspanFor(newCell, matching.height);
          if (position === 'before') {
            matching.cell.before(newCell);
          } else {
            matching.cell.after(newCell);
          }
          _results.push(i += matching.height - 1);
        } else if (intersecting = this.findCellByIntersectionFor(row, sig)) {
          _results.push(this.setColspanFor(intersecting.cell, intersecting.width + 1));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    TableEditor.prototype.removeColumn = function() {
      var adjusting, cell, i, intersecting, matching, removing, row, sig, _i, _j, _k, _len, _len1, _len2, _ref, _results;
      sig = this.cellSignatureFor(this.cell);
      if (sig.width > 1) {
        return;
      }
      removing = [];
      adjusting = [];
      _ref = this.table.find('tr');
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        row = _ref[i];
        if (matching = this.findCellByOptionsFor(row, {
          left: sig.left,
          width: sig.width
        })) {
          removing.push(matching.cell);
          i += matching.height - 1;
        } else if (intersecting = this.findCellByIntersectionFor(row, sig)) {
          adjusting.push(intersecting.cell);
        }
      }
      for (_j = 0, _len1 = removing.length; _j < _len1; _j++) {
        cell = removing[_j];
        $(cell).remove();
      }
      _results = [];
      for (_k = 0, _len2 = adjusting.length; _k < _len2; _k++) {
        cell = adjusting[_k];
        _results.push(this.setColspanFor(cell, this.colspanFor(cell) - 1));
      }
      return _results;
    };

    TableEditor.prototype.addRowBefore = function() {
      return this.addRow('before');
    };

    TableEditor.prototype.addRowAfter = function() {
      return this.addRow('after');
    };

    TableEditor.prototype.addRow = function(position) {
      var cell, cellCount, colspan, newCell, newRow, previousRow, rowCount, rowspan, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
      if (position == null) {
        position = 'after';
      }
      newRow = $('<tr>');
      if ((rowspan = this.rowspanFor(this.cell)) > 1 && position === 'after') {
        this.row = $(this.row.nextAll('tr')[rowspan - 2]);
      }
      cellCount = 0;
      _ref = this.row.find('th, td');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cell = _ref[_i];
        colspan = this.colspanFor(cell);
        newCell = $("<" + cell.tagName + ">").html(this.cellContent);
        this.setColspanFor(newCell, colspan);
        cellCount += colspan;
        if ((rowspan = this.rowspanFor(cell)) > 1 && position === 'after') {
          this.setRowspanFor(cell, rowspan + 1);
          continue;
        }
        newRow.append(newCell);
      }
      if (cellCount < this.columnCount) {
        rowCount = 0;
        _ref1 = this.row.prevAll('tr');
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          previousRow = _ref1[_j];
          rowCount += 1;
          _ref2 = $(previousRow).find('td[rowspan], th[rowspan]');
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            cell = _ref2[_k];
            rowspan = this.rowspanFor(cell);
            if (rowspan - 1 >= rowCount && position === 'before') {
              this.setRowspanFor(cell, rowspan + 1);
            } else if (rowspan - 1 >= rowCount && position === 'after') {
              if (rowspan - 1 === rowCount) {
                newCell = $("<" + cell.tagName + ">").html(this.cellContent);
                this.setColspanFor(newCell, this.colspanFor(cell));
                newRow.append(newCell);
              } else {
                this.setRowspanFor(cell, rowspan + 1);
              }
            }
          }
        }
      }
      if (position === 'before') {
        return this.row.before(newRow);
      } else {
        return this.row.after(newRow);
      }
    };

    TableEditor.prototype.removeRow = function() {
      var aboveRow, cell, i, match, minRowspan, prevRowspan, rowsAbove, rowspan, rowspansMatch, sig, _i, _j, _k, _l, _len, _len1, _len2, _len3, _m, _ref, _ref1, _ref2, _ref3, _ref4;
      rowspansMatch = true;
      prevRowspan = 0;
      minRowspan = 0;
      _ref = this.row.find('td, th');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cell = _ref[_i];
        rowspan = this.rowspanFor(cell);
        if (prevRowspan && rowspan !== prevRowspan) {
          rowspansMatch = false;
        }
        if (rowspan < minRowspan || !minRowspan) {
          minRowspan = rowspan;
        }
        prevRowspan = rowspan;
      }
      if (!rowspansMatch && this.rowspanFor(this.cell) > minRowspan) {
        return;
      }
      if (minRowspan > 1) {
        for (i = _j = 0, _ref1 = minRowspan - 2; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
          $(this.row.nextAll('tr')[i]).remove();
        }
      }
      _ref2 = this.row.find('td[rowspan], th[rowspan]');
      for (_k = 0, _len1 = _ref2.length; _k < _len1; _k++) {
        cell = _ref2[_k];
        sig = this.cellSignatureFor(cell);
        if (sig.height === minRowspan) {
          continue;
        }
        if (match = this.findCellByOptionsFor(this.row.nextAll('tr')[minRowspan - 1], {
          left: sig.left,
          forceAdjacent: true
        })) {
          this.setRowspanFor(cell, this.rowspanFor(cell) - this.rowspanFor(this.cell));
          if (match.direction === 'before') {
            match.cell.before($(cell).clone());
          } else {
            match.cell.after($(cell).clone());
          }
        }
      }
      if (this.columnsFor(this.row.find('td, th')) < this.columnCount) {
        rowsAbove = 0;
        _ref3 = this.row.prevAll('tr');
        for (_l = 0, _len2 = _ref3.length; _l < _len2; _l++) {
          aboveRow = _ref3[_l];
          rowsAbove += 1;
          _ref4 = $(aboveRow).find('td[rowspan], th[rowspan]');
          for (_m = 0, _len3 = _ref4.length; _m < _len3; _m++) {
            cell = _ref4[_m];
            rowspan = this.rowspanFor(cell);
            if (rowspan > rowsAbove) {
              this.setRowspanFor(cell, rowspan - this.rowspanFor(this.cell));
            }
          }
        }
      }
      return this.row.remove();
    };

    TableEditor.prototype.increaseColspan = function() {
      var cell;
      cell = this.cell.next('td, th');
      if (!cell.length) {
        return;
      }
      if (this.rowspanFor(cell) !== this.rowspanFor(this.cell)) {
        return;
      }
      if (this.cellIndexFor(cell) > this.cellIndexFor(this.cell) + this.colspanFor(this.cell)) {
        return;
      }
      this.setColspanFor(this.cell, this.colspanFor(this.cell) + this.colspanFor(cell));
      return cell.remove();
    };

    TableEditor.prototype.decreaseColspan = function() {
      var newCell;
      if (this.colspanFor(this.cell) === 1) {
        return;
      }
      this.setColspanFor(this.cell, this.colspanFor(this.cell) - 1);
      newCell = $("<" + (this.cell.get(0).tagName) + ">").html(this.cellContent);
      this.setRowspanFor(newCell, this.rowspanFor(this.cell));
      return this.cell.after(newCell);
    };

    TableEditor.prototype.increaseRowspan = function() {
      var match, nextRow, sig;
      sig = this.cellSignatureFor(this.cell);
      nextRow = this.row.nextAll('tr')[sig.height - 1];
      if (nextRow && (match = this.findCellByOptionsFor(nextRow, {
        left: sig.left,
        width: sig.width
      }))) {
        this.setRowspanFor(this.cell, sig.height + match.height);
        return match.cell.remove();
      }
    };

    TableEditor.prototype.decreaseRowspan = function() {
      var match, newCell, nextRow, sig;
      sig = this.cellSignatureFor(this.cell);
      if (sig.height === 1) {
        return;
      }
      nextRow = this.row.nextAll('tr')[sig.height - 2];
      if (match = this.findCellByOptionsFor(nextRow, {
        left: sig.left,
        forceAdjacent: true
      })) {
        newCell = $("<" + (this.cell.get(0).tagName) + ">").html(this.cellContent);
        this.setColspanFor(newCell, this.colspanFor(this.cell));
        this.setRowspanFor(this.cell, sig.height - 1);
        if (match.direction === 'before') {
          return match.cell.before(newCell);
        } else {
          return match.cell.after(newCell);
        }
      }
    };

    TableEditor.prototype.getColumnCount = function() {
      return this.columnsFor(this.table.find('thead tr:first-child, tbody tr:first-child, tfoot tr:first-child').first().find('td, th'));
    };

    TableEditor.prototype.getRowCount = function() {
      return this.table.find('tr').length;
    };

    TableEditor.prototype.cellIndexFor = function(cell) {
      var aboveCell, aboveRow, columns, index, row, rowsAbove, _i, _j, _len, _len1, _ref, _ref1;
      cell = $(cell);
      row = cell.parent('tr');
      columns = this.columnsFor(row.find('td, th'));
      index = this.columnsFor(cell.prevAll('td, th'));
      if (columns < this.columnCount) {
        rowsAbove = 0;
        _ref = row.prevAll('tr');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          aboveRow = _ref[_i];
          rowsAbove += 1;
          _ref1 = $(aboveRow).find('td[rowspan], th[rowspan]');
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            aboveCell = _ref1[_j];
            if (this.rowspanFor(aboveCell) > rowsAbove && this.cellIndexFor(aboveCell) <= index) {
              index += this.colspanFor(aboveCell);
            }
          }
        }
      }
      return index;
    };

    TableEditor.prototype.cellSignatureFor = function(cell) {
      var sig;
      sig = {
        cell: $(cell)
      };
      sig.left = this.cellIndexFor(cell);
      sig.width = this.colspanFor(cell);
      sig.height = this.rowspanFor(cell);
      sig.right = sig.left + sig.width;
      return sig;
    };

    TableEditor.prototype.findCellByOptionsFor = function(row, options) {
      var cell, prev, sig, _i, _len, _ref;
      _ref = $(row).find('td, th');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cell = _ref[_i];
        sig = this.cellSignatureFor(cell);
        if (typeof options.right !== 'undefined') {
          if (sig.right === options.right) {
            return sig;
          }
        }
        if (typeof options.left !== 'undefined') {
          if (options.width) {
            if (sig.left === options.left && sig.width === options.width) {
              return sig;
            }
          } else if (!options.forceAdjacent) {
            if (sig.left === options.left) {
              return sig;
            }
          } else if (options.forceAdjacent) {
            if (sig.left > options.left) {
              prev = $(cell).prev('td, th');
              if (prev.length) {
                sig = this.cellSignatureFor(prev);
                sig.direction = 'after';
              } else {
                sig.direction = 'before';
              }
              return sig;
            }
          }
        }
      }
      if (options.forceAdjacent) {
        sig.direction = 'after';
        return sig;
      }
      return null;
    };

    TableEditor.prototype.findCellByIntersectionFor = function(row, signature) {
      var cell, sig, _i, _len, _ref;
      _ref = $(row).find('td, th');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cell = _ref[_i];
        sig = this.cellSignatureFor(cell);
        if (sig.right - signature.left >= 0 && sig.right > signature.left) {
          return sig;
        }
      }
      return null;
    };

    TableEditor.prototype.columnsFor = function(cells) {
      var cell, count, _i, _len;
      count = 0;
      for (_i = 0, _len = cells.length; _i < _len; _i++) {
        cell = cells[_i];
        count += this.colspanFor(cell);
      }
      return count;
    };

    TableEditor.prototype.colspanFor = function(cell) {
      return parseInt($(cell).attr('colspan'), 10) || 1;
    };

    TableEditor.prototype.rowspanFor = function(cell) {
      return parseInt($(cell).attr('rowspan'), 10) || 1;
    };

    TableEditor.prototype.setColspanFor = function(cell, value) {
      return $(cell).attr('colspan', value > 1 ? value : null);
    };

    TableEditor.prototype.setRowspanFor = function(cell, value) {
      return $(cell).attr('rowspan', value > 1 ? value : null);
    };

    return TableEditor;

  })();

}).call(this);
(function() {
  var __slice = [].slice;

  (this.Mercury || (this.Mercury = {})).I18n = {
    __locales__: {},
    define: function(name, mapping) {
      return this.__locales__[name] = mapping;
    },
    locale: function() {
      var sub, top, _ref, _ref1;
      if (this.__determined__) {
        return this.__determined__;
      }
      if (!((_ref = Mercury.configuration.localization) != null ? _ref.enabled : void 0)) {
        return [{}, {}];
      }
      _ref1 = this.detectLocale(), top = _ref1[0], sub = _ref1[1];
      top = this.__locales__[top];
      sub = top && sub ? top["_" + (sub.toUpperCase()) + "_"] : false;
      return this.__determined__ = [top || {}, sub || {}];
    },
    detectLocale: function() {
      var _ref;
      return this.__detected__ || (this.__detected__ = (this.clientLocale() || ((_ref = Mercury.configuration.localization) != null ? _ref.preferred : void 0)).split('-'));
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

  (this.Mercury || (this.Mercury = {})).Logger = {
    logPrefix: 'Mercury:',
    log: function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (!((_ref = Mercury.configuration.logging) != null ? _ref.enabled : void 0)) {
        return;
      }
      if (this.logPrefix || this.constructor.logPrefix) {
        args.unshift(this.logPrefix || this.constructor.logPrefix);
      }
      return typeof console !== "undefined" && console !== null ? typeof console.debug === "function" ? console.debug.apply(console, args) : void 0 : void 0;
    },
    notify: function(msg) {
      var _ref, _ref1;
      if (this.logPrefix || this.constructor.logPrefix) {
        msg = "" + (this.constructor.logPrefix || this.logPrefix) + " " + msg;
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
      this.__handlers__ = $.extend({}, this.__handlers__);
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
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  Mercury.Action = (function(_super) {

    __extends(Action, _super);

    Action.include(Mercury.I18n);

    Action.include(Mercury.Logger);

    Action.logPrefix = 'Mercury.Action:';

    Action.create = function(name, attrsOrOther) {
      var klass;
      if (attrsOrOther == null) {
        attrsOrOther = {};
      }
      if ($.isPlainObject(attrsOrOther)) {
        klass = name.toCamelCase(true);
        if (Mercury.Action[klass]) {
          return new Mercury.Action[klass](attrsOrOther);
        }
        return new Mercury.Action(name, attrsOrOther);
      } else {
        return attrsOrOther;
      }
    };

    function Action() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.name || (this.name = args.shift());
      this.attributes = args.pop() || {};
      Action.__super__.constructor.apply(this, arguments);
    }

    Action.prototype.get = function(key) {
      return this.attributes[key];
    };

    return Action;

  })(Mercury.Module);

}).call(this);
(function() {
  var __slice = [].slice;

  (this.Mercury || (this.Mercury = {})).Config = {
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
      var args, config, merge, part, parts, path, value;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      path = args.shift();
      value = args.pop();
      merge = args.pop();
      if (typeof path === 'object') {
        return Mercury.configuration = path;
      }
      config = Mercury.configuration || (Mercury.configuration = {});
      parts = path.split(':');
      part = parts.shift();
      while (part) {
        if (parts.length === 0) {
          if (merge && typeof config[part] === 'object') {
            config[part] = $.extend(true, config[part], value);
          } else {
            config[part] = value;
          }
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

  (this.Mercury || (this.Mercury = {})).Events = {
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
      var callback;
      callback = function() {
        this.off(events, callback);
        return handler.apply(this, arguments);
      };
      return this.on(events, callback);
    },
    off: function(events, handler) {
      var h, i, list, name, _i, _j, _len, _len1, _ref, _ref1;
      if (!events) {
        this.__handlers__ = {};
        return this;
      }
      _ref = events.split(' ');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        name = _ref[_i];
        if (!(list = (_ref1 = this.__handlers__) != null ? _ref1[name] : void 0)) {
          continue;
        }
        if (!handler) {
          delete this.__handlers__[name];
          continue;
        }
        for (i = _j = 0, _len1 = list.length; _j < _len1; i = ++_j) {
          h = list[i];
          if (!(h === handler)) {
            continue;
          }
          list = list.slice();
          list.splice(i, 1);
          this.__handlers__[name] = list;
          break;
        }
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

  (this.Mercury || (this.Mercury = {})).Stack = {
    included: function() {
      this.stackPosition = 0;
      this.maxStackLength = 200;
      return this.stack = [];
    },
    pushStack: function(value) {
      if (value === null || this.stackEquality(value)) {
        return;
      }
      this.stack = this.stack.slice(0, this.stackPosition + 1);
      this.stack.push(value);
      if (this.stack.length > this.maxStackLength) {
        this.stack.shift();
      }
      return this.stackPosition = this.stack.length - 1;
    },
    stackEquality: function(value) {
      return JSON.stringify(this.stack[this.stackPosition]) === JSON.stringify(value);
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
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Model = (function(_super) {

    __extends(Model, _super);

    Model.extend(Mercury.Config);

    Model.extend(Mercury.Events);

    Model.include(Mercury.Config);

    Model.include(Mercury.Events);

    Model.include(Mercury.I18n);

    Model.include(Mercury.Logger);

    Model.include(Mercury.Stack);

    Model.logPrefix = 'Mercury.Model:';

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
      this.pushStack(this.toJSON());
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
  var registered,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  registered = {};

  Mercury.Plugin = (function(_super) {

    __extends(Plugin, _super);

    Plugin.extend(Mercury.Logger);

    Plugin.extend(Mercury.I18n);

    Plugin.include(Mercury.Config);

    Plugin.include(Mercury.Events);

    Plugin.include(Mercury.I18n);

    Plugin.include(Mercury.Logger);

    Plugin.logPrefix = 'Mercury.Plugin:';

    Plugin.events = {
      'mercury:region:focus': 'onRegionFocus',
      'button:click': 'onButtonClick'
    };

    Plugin.register = function(name, options) {
      options.name = name;
      return new Mercury.Plugin.Definition(options);
    };

    Plugin.get = function(name, instance) {
      var definition;
      if (instance == null) {
        instance = false;
      }
      definition = registered[name];
      if (!definition) {
        throw new Error("unable to locate the " + name + " plugin");
      }
      if (instance) {
        return new Mercury.Plugin(definition.signature());
      } else {
        return definition;
      }
    };

    Plugin.all = function() {
      return registered;
    };

    Plugin.unregister = function(name) {
      var definition;
      definition = registered[name];
      if (!definition) {
        throw new Error("unable to locate the " + name + " plugin");
      }
      return delete registered[name];
    };

    function Plugin(options) {
      var key, value, _ref;
      this.options = options != null ? options : {};
      this.configuration = this.options.config || {};
      _ref = this.options;
      for (key in _ref) {
        value = _ref[key];
        if (key !== 'config') {
          this[key] = value;
        }
      }
      if (!this.name) {
        throw new Error('must provide a name for plugins');
      }
      this.actionsArray = [];
      this.actions || (this.actions = {});
      this.events = $.extend({}, this.constructor.events, this.events);
      this.delegateEvents(this.events);
      this.appendActions(this.actions);
      Plugin.__super__.constructor.apply(this, arguments);
    }

    Plugin.prototype.buttonRegistered = function(button) {
      this.button = button;
      this.configuration = $.extend({}, this.configuration, this.button.get('settings'));
      if (this.prependButtonAction) {
        this.context = this.button.get('actionName');
        this.prependAction(this.context, this.prependButtonAction);
      }
      return typeof this.registerButton === "function" ? this.registerButton() : void 0;
    };

    Plugin.prototype.regionSupported = function(region) {
      var action, _i, _len, _ref;
      this.region = region;
      _ref = this.actionsArray;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        action = _ref[_i];
        if (this.region.hasAction(action[0])) {
          if (typeof this.regionContext === "function") {
            this.regionContext();
          }
          return true;
        }
      }
      return false;
    };

    Plugin.prototype.triggerAction = function() {
      var action, args, _i, _len, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (!this.region) {
        return false;
      }
      _ref = this.actionsArray;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        action = _ref[_i];
        if (this.region.hasAction(action[0])) {
          args.unshift(action[0]);
          Mercury.trigger('focus');
          action[1].apply(this, args);
          return true;
        }
      }
      return false;
    };

    Plugin.prototype.config = function(path) {
      var config, part, _i, _len, _ref;
      config = this.configuration || (this.configuration = {});
      try {
        _ref = path.split(':');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          part = _ref[_i];
          config = config[part];
        }
      } catch (e) {
        return Mercury.Config.get(path);
      }
      if (typeof config === 'undefined') {
        return Mercury.Config.get(path);
      }
      return config;
    };

    Plugin.prototype.configure = function() {
      var args, config, merge, part, parts, path, value;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      path = args.shift();
      value = args.pop();
      merge = args.pop();
      if (typeof path === 'object') {
        return this.configuration = path;
      }
      config = this.configuration || (this.configuration = {});
      parts = path.split(':');
      part = parts.shift();
      while (part) {
        if (parts.length === 0) {
          if (merge && typeof config[part] === 'object') {
            config[part] = $.extend(true, config[part], value);
          } else {
            config[part] = value;
          }
          return config[part];
        }
        config = config[part] ? config[part] : config[part] = {};
        part = parts.shift();
      }
    };

    Plugin.prototype.release = function() {
      var method, name, _ref;
      _ref = this.__global_handlers__ || {};
      for (name in _ref) {
        method = _ref[name];
        Mercury.off(name, method);
      }
      return this.off();
    };

    Plugin.prototype.onRegionFocus = function(region) {
      this.region = region;
    };

    Plugin.prototype.onButtonClick = function() {};

    Plugin.prototype.appendActions = function(actions) {
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
        _results.push(this.actionsArray.push([key, method]));
      }
      return _results;
    };

    Plugin.prototype.prependAction = function(key, method) {
      if (typeof method !== 'function') {
        if (!this[method]) {
          throw new Error("" + method + " doesn't exist");
        }
        method = this[method];
      }
      return this.actionsArray.unshift([key, method]);
    };

    Plugin.prototype.delegateEvents = function(events) {
      var key, method, _results,
        _this = this;
      this.__global_handlers__ || (this.__global_handlers__ = {});
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
        if (key.indexOf('mercury:') === 0) {
          key = key.replace(/^mercury:/, '');
          this.__global_handlers__[key] = method;
          Mercury.on(key, method);
          continue;
        }
        _results.push(this.on(key, method));
      }
      return _results;
    };

    return Plugin;

  })(Mercury.Module);

  Mercury.Plugin.Module = {
    registerPlugin: Mercury.Plugin.register,
    getPlugin: Mercury.Plugin.get
  };

  Mercury.Plugin.Definition = (function() {

    function Definition(options) {
      this.options = options != null ? options : {};
      this.configuration = this.options.config;
      this.name = this.options.name;
      registered[this.name] = this;
    }

    Definition.prototype.signature = function(functions) {
      var name, sig, value;
      if (functions == null) {
        functions = true;
      }
      sig = $.extend({}, this.options, {
        config: this.configuration
      });
      if (!functions) {
        for (name in sig) {
          value = sig[name];
          if (typeof value === 'function') {
            delete sig[name];
          }
        }
      }
      return sig;
    };

    Definition.prototype.config = function(path) {
      var config, part, _i, _len, _ref;
      config = this.configuration || (this.configuration = {});
      try {
        _ref = path.split(':');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          part = _ref[_i];
          config = config[part];
        }
      } catch (e) {
        return Mercury.Config.get(path);
      }
      if (typeof config === 'undefined') {
        return Mercury.Config.get(path);
      }
      return config;
    };

    Definition.prototype.configure = function() {
      var args, config, merge, part, parts, path, value;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      path = args.shift();
      value = args.pop();
      merge = args.pop();
      if (typeof path === 'object') {
        return this.configuration = path;
      }
      config = this.configuration || (this.configuration = {});
      parts = path.split(':');
      part = parts.shift();
      while (part) {
        if (parts.length === 0) {
          if (merge && typeof config[part] === 'object') {
            config[part] = $.extend(true, config[part], value);
          } else {
            config[part] = value;
          }
          return config[part];
        }
        config = config[part] ? config[part] : config[part] = {};
        part = parts.shift();
      }
    };

    return Definition;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  Mercury.View = (function(_super) {

    __extends(View, _super);

    View.include(Mercury.Config);

    View.include(Mercury.Events);

    View.include(Mercury.I18n);

    View.include(Mercury.Logger);

    View.Modules = {};

    View.logPrefix = 'Mercury.View:';

    View.tag = 'div';

    View.prototype.eventSplitter = /^(\S+)\s*(.*)$/;

    function View(options) {
      var key, value, _ref;
      this.options = options != null ? options : {};
      _ref = this.options;
      for (key in _ref) {
        value = _ref[key];
        this[key] = value;
      }
      this.buildElement();
      this.elements = $.extend({}, this.constructor.elements, this.elements);
      this.events = $.extend({}, this.constructor.events, this.events);
      this.attributes = $.extend({}, this.constructor.attributes, this.attributes);
      this.refreshElements();
      if (typeof this.build === "function") {
        this.build();
      }
      this.trigger('build');
      this.delegateEvents(this.events);
      this.refreshElements();
      View.__super__.constructor.apply(this, arguments);
      this.trigger('init');
    }

    View.prototype.buildElement = function() {
      if (this.$el) {
        this.el = this.$el.get(0);
      } else {
        if (!this.el) {
          this.el = document.createElement(this.tag || this.constructor.tag);
        }
        this.$el = $(this.el);
      }
      this.attr(this.attributes);
      this.addClass(this.constructor.className);
      this.addClass(this.className);
      if (this.template || this.constructor.template) {
        return this.html(this.renderTemplate(this.template || this.constructor.template));
      }
    };

    View.prototype.$ = function(selector) {
      return $(selector, this.$el);
    };

    View.prototype.addClass = function(className) {
      return this.$el.addClass(className);
    };

    View.prototype.removeClass = function(className) {
      return this.$el.removeClass(className);
    };

    View.prototype.attr = function(key, value) {
      if (key && arguments.length === 1) {
        return this.$el.attr(key);
      }
      return this.$el.attr(key, value);
    };

    View.prototype.css = function(key, value) {
      if (key && arguments.length === 1) {
        return this.$el.css(key);
      }
      return this.$el.css(key, value);
    };

    View.prototype.html = function(element) {
      if (!arguments.length) {
        return this.$el.html();
      }
      this.$el.html((element != null ? element.$el : void 0) || (element != null ? element.el : void 0) || element);
      this.refreshElements();
      return this.$el;
    };

    View.prototype.append = function() {
      var e, elements, _ref;
      elements = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      elements = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = elements.length; _i < _len; _i++) {
          e = elements[_i];
          _results.push(e.$el || e.el || e);
        }
        return _results;
      })();
      (_ref = this.$el).append.apply(_ref, elements);
      this.refreshElements();
      return this.$el;
    };

    View.prototype.appendTo = function(element) {
      this.$el.appendTo(element.$el || element.el || element);
      return this.$el;
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
        _results.push(this["$" + key] = this.$(value));
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
        return template.call(options || this);
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

    View.prototype.focusFirstFocusable = function() {
      var _ref;
      return (_ref = this.$(':input:visible[tabindex != "-1"]')[0]) != null ? _ref.focus() : void 0;
    };

    View.prototype.prevent = function(e, stop) {
      if (stop == null) {
        stop = false;
      }
      if (!(e && e.preventDefault)) {
        return;
      }
      e.preventDefault();
      if (stop) {
        return e.stopPropagation();
      }
    };

    View.prototype.release = function() {
      var method, name, _ref;
      this.trigger('release');
      this.$el.remove();
      _ref = this.__global_handlers__ || {};
      for (name in _ref) {
        method = _ref[name];
        Mercury.off(name, method);
      }
      return this.off();
    };

    View.prototype.delegateEvents = function(el, events) {
      var event, key, match, method, selector, _ref, _results,
        _this = this;
      if (arguments.length === 1) {
        events = el;
        el = this.$el;
      }
      this.__global_handlers__ || (this.__global_handlers__ = {});
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
          if (method.indexOf('mercury:') === 0) {
            method = method.replace(/^mercury:/, '');
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
        if (key.indexOf('mercury:') === 0) {
          key = key.replace(/^mercury:/, '');
          this.__global_handlers__[key] = method;
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

    Region.define = function(klass, type, actions) {
      this.klass = klass;
      this.type = type;
      if (actions == null) {
        actions = {};
      }
      this.logPrefix = this.prototype.logPrefix = "" + this.klass + ":";
      this.prototype.actions = $.extend(this.prototype.actions, actions);
      this.prototype.toolbars = [this.type];
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
      type = ("" + type).toLowerCase().toCamelCase(true);
      if (!Mercury.Region[type]) {
        this.notify(this.t('unknown "%s" region type, falling back to base region', type));
      }
      return new (Mercury.Region[type] || Mercury.Region)(el);
    };

    Region.addAction = function(action, handler) {
      var actions;
      if (typeof action === 'object') {
        actions = action;
      } else {
        actions = {};
        actions[action] = handler;
      }
      return this.actions = $.extend(this.actions || {}, actions);
    };

    Region.addContext = function(context, handler) {
      var contexts;
      if (typeof context === 'object') {
        contexts = context;
      } else {
        contexts = {};
        contexts[context] = handler;
      }
      return this.context = $.extend(this.context || {}, contexts);
    };

    Region.addData = function(attr, handler) {
      var dataAttrs;
      if (typeof attr === 'object') {
        dataAttrs = attr;
      } else {
        dataAttrs = {};
        dataAttrs[attr] = handler;
      }
      return this.dataAttrs = $.extend(this.dataAttrs || {}, dataAttrs);
    };

    Region.addToolbar = function(name, obj) {
      var path;
      if (obj == null) {
        obj = {};
      }
      if (typeof name === 'object') {
        obj = name;
        name = this.type;
      }
      path = name === this.type ? "toolbars:" + name : "toolbars:" + this.type + ":" + name;
      return Mercury.configure(path, obj);
    };

    function Region(el, options) {
      var attr;
      this.el = el;
      this.options = options != null ? options : {};
      if (this.el && $(this.el).data('region')) {
        return false;
      }
      if (!this.constructor.supported) {
        this.notify(this.t('is unsupported in this browser'));
        return false;
      }
      this.actions || (this.actions = {});
      this.context = $.extend({}, this.constructor.context, this.context);
      this.dataAttrs = $.extend({}, this.constructor.dataAttrs, this.dataAttrs);
      if (this.el && (attr = this.config('regions:options'))) {
        this.options = $.extend(JSON.parse($(this.el).attr(attr) || '{}'), this.options);
      }
      if (typeof this.beforeBuild === "function") {
        this.beforeBuild();
      }
      Region.__super__.constructor.call(this, this.options);
      if (!this.$focusable) {
        this.attr({
          tabindex: 0
        });
      }
      this.name || (this.name = this.$el.attr(this.config('regions:identifier')));
      this.previewing || (this.previewing = false);
      this.focused || (this.focused = false);
      this.$focusable || (this.$focusable = this.$el);
      this.skipHistoryOn || (this.skipHistoryOn = ['redo']);
      this.changed || (this.changed = false);
      this.setInitialData();
      if (typeof this.afterBuild === "function") {
        this.afterBuild();
      }
      this.$el.data({
        region: this
      });
      if (!this.name) {
        this.notify(this.t('no name provided for the "%s" region, falling back to random', this.constructor.type));
        this.name = "" + this.constructor.type + (Math.floor(Math.random() * 10000));
      }
      this.addRegionClassname();
      if (!this.skipHistoryOnInitialize) {
        this.pushHistory();
      }
      this.bindDefaultEvents();
      this.initialValue = JSON.stringify(this.toJSON());
    }

    Region.prototype.setInitialData = function() {
      var attr, handler, obj, _ref, _results;
      _ref = this.dataAttrs;
      _results = [];
      for (attr in _ref) {
        handler = _ref[attr];
        obj = {};
        obj[attr] = this.$el.data(attr) || null;
        _results.push(this.data(obj));
      }
      return _results;
    };

    Region.prototype.addRegionClassname = function() {
      return this.addClass("mercury-" + this.constructor.type + "-region");
    };

    Region.prototype.trigger = function(event) {
      Region.__super__.trigger.apply(this, arguments);
      return Mercury.trigger("region:" + event, this);
    };

    Region.prototype.hasAction = function(action) {
      return !!this.actions[action];
    };

    Region.prototype.hasContext = function(context, result) {
      if (result == null) {
        result = false;
      }
      if (!this.context[context]) {
        return false;
      }
      context = this.context[context].call(this, context);
      if (result) {
        return context;
      } else {
        return !!context;
      }
    };

    Region.prototype.handleAction = function(name, options) {
      var action, _ref;
      if (options == null) {
        options = {};
      }
      if (!this.focused || this.previewing) {
        return;
      }
      if (!(this.skipHistoryOn.indexOf(name) > -1)) {
        this.pushHistory();
      }
      action = Mercury.Action.create(name, options);
      if ((_ref = this.actions[name]) != null) {
        _ref.call(this, action);
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
        this.$focusable.removeAttr('tabindex');
      } else {
        this.$focusable.attr({
          tabindex: 0
        });
      }
      return typeof this.onTogglePreview === "function" ? this.onTogglePreview() : void 0;
    };

    Region.prototype.pushHistory = function(keyCode) {
      var knownKeyCode, pushNow,
        _this = this;
      if (keyCode == null) {
        keyCode = null;
      }
      if (keyCode) {
        knownKeyCode = [13, 46, 8].indexOf(keyCode);
      }
      if (keyCode === null || (knownKeyCode >= 0 && knownKeyCode !== this.lastKeyCode)) {
        pushNow = true;
      }
      this.lastKeyCode = knownKeyCode;
      clearTimeout(this.historyTimeout);
      if (pushNow) {
        return this.pushStack(this.toStack());
      } else {
        return this.historyTimeout = this.delay(2500, function() {
          return _this.pushStack(_this.toStack());
        });
      }
    };

    Region.prototype.focus = function() {
      this.focused = true;
      this.$focusable.focus();
      return typeof this.onFocus === "function" ? this.onFocus() : void 0;
    };

    Region.prototype.blur = function() {
      this.focused = false;
      this.$focusable.blur();
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
      var data, obj;
      if (typeof key === 'string' && arguments.length === 1 || arguments.length === 0) {
        data = this.$el.data(key);
        if (arguments.length === 0) {
          data = $.extend({}, data);
          delete data.region;
          delete data.mercury;
        }
        return data != null ? data : null;
      }
      obj = key;
      if (typeof key === 'string') {
        obj = {};
        obj[key] = value;
      }
      this.setData(obj);
      return this.$el;
    };

    Region.prototype.setData = function(obj) {
      var attr, value, _ref, _results;
      this.$el.data(obj);
      _results = [];
      for (attr in obj) {
        value = obj[attr];
        _results.push((_ref = this.dataAttrs[attr]) != null ? typeof _ref.call === "function" ? _ref.call(this, value) : void 0 : void 0);
      }
      return _results;
    };

    Region.prototype.snippets = function() {
      return {};
    };

    Region.prototype.hasChanges = function() {
      return this.changed || this.initialValue !== JSON.stringify(this.toJSON());
    };

    Region.prototype.onSave = function() {
      this.initialValue = JSON.stringify(this.toJSON());
      return this.changed = false;
    };

    Region.prototype.onUndo = function() {
      return this.fromStack(this.undoStack());
    };

    Region.prototype.onRedo = function() {
      return this.fromStack(this.redoStack());
    };

    Region.prototype.toStack = function() {
      return this.toJSON();
    };

    Region.prototype.fromStack = function(val) {
      if (val) {
        return this.fromJSON(val);
      }
    };

    Region.prototype.toJSON = function(forSave) {
      if (forSave == null) {
        forSave = false;
      }
      return {
        name: this.name,
        type: this.constructor.type,
        value: this.value(),
        data: this.data(),
        snippets: this.snippets()
      };
    };

    Region.prototype.fromJSON = function(json) {
      if (typeof json === 'string') {
        json = JSON.parse(json);
      }
      if (json.value) {
        this.value(json.value);
      }
      if (json.data) {
        return this.data(json.data);
      }
    };

    Region.prototype.release = function() {
      this.$el.data({
        region: null
      });
      this.removeClass("mercury-" + this.constructor.type + "-region");
      this.$focusable.removeAttr('tabindex');
      this.trigger('release');
      this.$el.off();
      this.$focusable.off();
      this.off();
      return this.blur();
    };

    Region.prototype.bindDefaultEvents = function() {
      this.delegateActions($.extend(true, this.constructor.actions, this.constructor.defaultActions, this.actions || (this.actions = {})));
      this.delegateEvents({
        'mercury:action': function() {
          return this.handleAction.apply(this, arguments);
        },
        'mercury:mode': function() {
          return this.handleMode.apply(this, arguments);
        },
        'mercury:save': function() {
          return this.onSave();
        }
      });
      this.bindFocusEvents();
      this.bindKeyEvents();
      this.bindMouseEvents();
      if (this.onDropFile || this.onDropItem) {
        return this.bindDropEvents();
      }
    };

    Region.prototype.bindFocusEvents = function() {
      var _this = this;
      return this.delegateEvents(this.$focusable, {
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
      return this.delegateEvents(this.$focusable, {
        keyup: function() {
          return _this.trigger('update');
        },
        keydown: function(e) {
          if (!(e.metaKey && e.keyCode === 90)) {
            return;
          }
          _this.prevent(e);
          if (e.shiftKey) {
            return _this.handleAction('redo');
          } else {
            return _this.handleAction('undo');
          }
        }
      });
    };

    Region.prototype.bindMouseEvents = function() {
      var _this = this;
      return this.delegateEvents(this.$focusable, {
        mouseup: function() {
          return _this.trigger('update');
        }
      });
    };

    Region.prototype.bindDropEvents = function() {
      var _this = this;
      return this.delegateEvents(this.$el, {
        dragenter: function(e) {
          return _this.prevent(e);
        },
        dragover: function(e) {
          if (!(_this.editableDropBehavior && Mercury.support.webkit)) {
            return _this.prevent(e);
          }
        },
        drop: function(e) {
          var data;
          if (_this.previewing) {
            return;
          }
          data = e.originalEvent.dataTransfer;
          if (data.files.length && _this.onDropFile) {
            _this.prevent(e);
            return _this.onDropFile(data.files);
          } else if (_this.onDropItem) {
            return _this.onDropItem(e, data);
          }
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

  Mercury.View.Modules.FormHandler = {
    included: function() {
      return this.on('build', this.buildFormHandler);
    },
    buildFormHandler: function() {
      return this.delegateEvents({
        'submit': 'onFormSubmit'
      });
    },
    validate: function() {
      return this.clearInputErrors();
    },
    addInputError: function(input, message) {
      input.after("<span class=\"help-inline error-message\">" + message + "</span>").closest('.control-group').addClass('error');
      return this.valid = false;
    },
    clearInputErrors: function() {
      this.$('.control-group.error').removeClass('error').find('.error-message').remove();
      return this.valid = true;
    },
    onFormSubmit: function(e) {
      this.prevent(e);
      this.validate();
      if (this.valid) {
        return typeof this.onSubmit === "function" ? this.onSubmit() : void 0;
      }
    }
  };

}).call(this);
(function() {

  Mercury.View.Modules.InterfaceFocusable = {
    included: function() {
      return this.on('build', this.buildInterfaceFocusable);
    },
    buildInterfaceFocusable: function() {
      if (!this.revertFocusOn) {
        return;
      }
      this.delegateEvents({
        'mousedown': 'handleFocusableEvent',
        'mouseup': 'handleFocusableEvent',
        'click': 'handleFocusableEvent'
      });
      return this.delegateRevertedFocus(this.revertFocusOn);
    },
    delegateRevertedFocus: function(matcher) {
      var reverted;
      reverted = {};
      reverted["mousedown " + matcher] = function() {
        return this.delay(1, function() {
          return Mercury.trigger('focus');
        });
      };
      reverted["click " + matcher] = function() {
        return this.delay(1, function() {
          return Mercury.trigger('focus');
        });
      };
      return this.delegateEvents(reverted);
    },
    handleFocusableEvent: function(e) {
      e.stopPropagation();
      if (!$(e.target).is(this.focusableSelector || ':input, [tabindex]')) {
        return this.prevent(e);
      }
    }
  };

}).call(this);
(function() {

  Mercury.View.Modules.ScrollPropagation = {
    preventScrollPropagation: function(el) {
      return el.on('mousewheel DOMMouseScroll', function(e) {
        var delta, scrollTop, _ref;
        _ref = [e.originalEvent.wheelDelta || -e.originalEvent.detail, el.scrollTop()], delta = _ref[0], scrollTop = _ref[1];
        if (delta > 0 && scrollTop <= 0) {
          return false;
        }
        if (delta < 0 && scrollTop >= el.get(0).scrollHeight - el.height()) {
          return false;
        }
        return true;
      });
    }
  };

}).call(this);
(function() {

  Mercury.View.Modules.ToolbarDialog = {
    included: function() {
      return this.on('build', this.buildToolbarDialog);
    },
    buildToolbarDialog: function() {
      return this.delegateEvents({
        'mercury:dialogs:hide': function() {
          return typeof this.hide === "function" ? this.hide() : void 0;
        },
        'mercury:interface:resize': 'positionAndResize'
      });
    },
    positionAndResize: function(dimensions) {
      this.position(dimensions);
      return this.resize(false, dimensions);
    },
    position: function(dimensions) {
      var e, left, o, p, top, v;
      this.css({
        left: 0,
        top: 0
      });
      v = {
        width: $(window).width(),
        height: $(window).height()
      };
      e = {
        width: this.$el.outerWidth(),
        height: this.$el.outerHeight()
      };
      p = {
        width: this.$el.parent().outerWidth(),
        height: this.$el.parent().outerHeight()
      };
      o = this.$el.parent().position();
      left = 0;
      if (e.width + o.left > v.width) {
        left = -e.width + p.width;
      }
      if (o.left + left < 0) {
        left -= o.left + left;
      }
      top = 0;
      if (e.height + o.top + p.height > v.height) {
        top = -e.height;
      }
      if (o.top + top + p.height < 0) {
        top -= o.top + top + p.height;
      }
      return this.css({
        top: top,
        left: left
      });
    },
    resize: function(animate, dimensions) {
      if (animate == null) {
        animate = true;
      }
    }
  };

}).call(this);
(function() {

  Mercury.View.Modules.VisibilityToggleable = {
    included: function() {
      return this.on('build', this.buildVisibilityToggleable);
    },
    buildVisibilityToggleable: function() {
      this.delegateEvents({
        'mercury:interface:hide': function() {
          return this.hide();
        }
      });
      if (this.hidden) {
        this.visible = true;
        return this.hide();
      } else {
        return this.show();
      }
    },
    toggle: function() {
      if (this.visible) {
        return this.hide();
      } else {
        return this.show();
      }
    },
    show: function(update) {
      if (update == null) {
        update = true;
      }
      if (this.visible) {
        return false;
      }
      this.trigger('show');
      clearTimeout(this.visibilityTimout);
      this.visible = true;
      this.$el.show();
      this.visibilityTimout = this.delay(50, function() {
        this.css({
          opacity: 1
        });
        if (update) {
          return typeof this.update === "function" ? this.update() : void 0;
        }
      });
      return true;
    },
    hide: function(release) {
      if (release == null) {
        release = false;
      }
      if (!this.visible) {
        return false;
      }
      this.trigger('hide');
      clearTimeout(this.visibilityTimout);
      this.visible = false;
      this.css({
        opacity: 0
      });
      this.visibilityTimout = this.delay(250, function() {
        this.$el.hide();
        if (release) {
          return this.release();
        }
      });
      return true;
    }
  };

}).call(this);
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.BaseInterface = (function(_super) {

    __extends(BaseInterface, _super);

    BaseInterface.logPrefix = 'Mercury.BaseInterface:';

    BaseInterface.template = 'interface';

    BaseInterface.tag = 'mercury';

    BaseInterface.elements = {
      mask: '.mercury-interface-mask'
    };

    BaseInterface.events = {
      'mercury:focus': 'focusActiveRegion',
      'mercury:action': 'focusActiveRegion',
      'mercury:blur': 'blurActiveRegion',
      'mercury:region:focus': 'onRegionFocus',
      'mercury:region:release': 'onRegionRelease',
      'mercury:reinitialize': 'reinitialize',
      'mercury:interface:mask': 'mask',
      'mercury:interface:unmask': 'unmask',
      'mousedown .mercury-interface-mask': function(e) {
        return this.prevent(e);
      },
      'mouseup .mercury-interface-mask': function(e) {
        return this.prevent(e);
      },
      'click .mercury-interface-mask': function(e) {
        this.prevent(e, true);
        return Mercury.trigger('dialogs:hide');
      }
    };

    function BaseInterface() {
      this.onUnload = __bind(this.onUnload, this);

      this.onResize = __bind(this.onResize, this);
      if (parent !== window && parent.Mercury) {
        this.log(this.t('is already defined in parent frame'));
        return;
      }
      Mercury["interface"] = this;
      BaseInterface.__super__.constructor.apply(this, arguments);
      this.regions || (this.regions = []);
      $(window).on('beforeunload', this.onUnload);
      $(window).on('resize', this.onResize);
      this.initialize();
      this.buildInterface();
      this.bindDefaultEvents();
      this.removeClass('loading');
      Mercury.trigger('initialized');
    }

    BaseInterface.prototype.build = function() {
      if (!this.el) {
        this.$el = this.el = $(this.tag);
      }
      this.attr(this.attributes);
      return this.addClass(this.className);
    };

    BaseInterface.prototype.init = function() {
      this.addLocaleClass();
      $('body').before(this.$el);
      this.makeShadowed();
      if (this.template) {
        this.html(this.renderTemplate(this.template));
      }
      return this.addClass('loading');
    };

    BaseInterface.prototype.initialize = function() {
      this.addAllRegions();
      return this.bindDocumentEvents();
    };

    BaseInterface.prototype.reinitialize = function() {
      this.initialize();
      return this.focusActiveRegion();
    };

    BaseInterface.prototype.buildInterface = function() {
      this.buildToolbar();
      this.buildStatusbar();
      return this.focusDefaultRegion();
    };

    BaseInterface.prototype.addLocaleClass = function() {
      return this.addClass("locale-" + (Mercury.I18n.detectLocale().join('-').toLowerCase()));
    };

    BaseInterface.prototype.makeShadowed = function() {
      if (!(this.config('interface:shadowed') && this.el.webkitCreateShadowRoot)) {
        return;
      }
      this.shadow = $(this.el.webkitCreateShadowRoot());
      this.shadow.get(0).applyAuthorStyles = true;
      return this.shadow.append(this.$el = this.el = $(document.createElement(this.tag)));
    };

    BaseInterface.prototype.buildToolbar = function() {
      var klass;
      if (!(klass = this.config('interface:toolbar'))) {
        return;
      }
      this.append(this.toolbar = new Mercury[klass]());
      if (!this.config('interface:enabled')) {
        return this.toolbar.hide();
      }
    };

    BaseInterface.prototype.buildStatusbar = function() {
      var klass;
      if (!(klass = this.config('interface:statusbar'))) {
        return;
      }
      this.append(this.statusbar = new Mercury[klass]());
      if (!this.config('interface:enabled')) {
        return this.statusbar.hide();
      }
    };

    BaseInterface.prototype.bindDefaultEvents = function() {
      return this.delegateEvents({
        'mercury:mode': function(mode) {
          return this.setMode(mode);
        },
        'mercury:action': function() {
          return this.focusActiveRegion();
        }
      });
    };

    BaseInterface.prototype.bindDocumentEvents = function() {
      if (!this.config('interface:mask')) {
        return $('body', this.document).on('mousedown', function() {
          return Mercury.trigger('dialogs:hide');
        });
      }
    };

    BaseInterface.prototype.focusDefaultRegion = function() {
      return this.delay(100, this.focusActiveRegion);
    };

    BaseInterface.prototype.addAllRegions = function() {
      var el, _i, _len, _ref;
      _ref = this.regionElements();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        el = _ref[_i];
        this.addRegion(el);
      }
      this.region || (this.region = this.regions[0]);
      if (!this.config('interface:enabled')) {
        return Mercury.trigger('mode', 'preview');
      }
    };

    BaseInterface.prototype.regionElements = function() {
      return $("[" + (this.config('regions:attribute')) + "]", this.document);
    };

    BaseInterface.prototype.addRegion = function(el) {
      var region;
      if ($(el).data('region')) {
        return;
      }
      region = Mercury.Region.create(el);
      return this.regions.push(region);
    };

    BaseInterface.prototype.focusActiveRegion = function(e) {
      var _ref;
      this.prevent(e);
      return (_ref = this.region) != null ? _ref.focus() : void 0;
    };

    BaseInterface.prototype.blurActiveRegion = function() {
      var _ref;
      return (_ref = this.region) != null ? _ref.blur() : void 0;
    };

    BaseInterface.prototype.setMode = function(mode) {
      this["" + mode + "Mode"] = !this["" + mode + "Mode"];
      return this.focusActiveRegion();
    };

    BaseInterface.prototype.toggleInterface = function() {
      var _ref;
      if ((_ref = this.interfaceHidden) == null) {
        this.interfaceHidden = this.config('interface:enabled');
      }
      this.interfaceHidden = !this.interfaceHidden;
      if (this.interfaceHidden) {
        Mercury.trigger('interface:show');
        if (this.previewMode) {
          return Mercury.trigger('mode', 'preview');
        }
      } else {
        Mercury.trigger('interface:hide');
        if (!this.previewMode) {
          return Mercury.trigger('mode', 'preview');
        }
      }
    };

    BaseInterface.prototype.mask = function() {
      if (!this.config('interface:mask')) {
        return;
      }
      return this.$mask.show();
    };

    BaseInterface.prototype.unmask = function() {
      return this.$mask.hide();
    };

    BaseInterface.prototype.dimensions = function() {
      var statusbarHeight, toolbarHeight;
      toolbarHeight = this.toolbar.height();
      statusbarHeight = this.statusbar.height();
      return {
        top: toolbarHeight,
        left: 0,
        right: 0,
        bottom: statusbarHeight,
        width: $(window).width(),
        height: $(window).height() - toolbarHeight - statusbarHeight
      };
    };

    BaseInterface.prototype.onRegionFocus = function(region) {
      return this.region = region;
    };

    BaseInterface.prototype.onRegionRelease = function(region) {
      var index;
      if (region === this.region) {
        this.region = this.regions[0];
      }
      index = this.regions.indexOf(region);
      if (index > -1) {
        return this.regions.splice(index, 1);
      }
    };

    BaseInterface.prototype.onResize = function() {
      return Mercury.trigger('interface:resize', this.dimensions());
    };

    BaseInterface.prototype.onUnload = function() {
      if (this.config('interface:silent') || !this.hasChanges()) {
        return null;
      }
      return this.t('You have unsaved changes.  Are you sure you want to leave without saving them first?');
    };

    BaseInterface.prototype.hasChanges = function() {
      var region, _i, _len, _ref;
      _ref = this.regions;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        region = _ref[_i];
        if (region.hasChanges()) {
          return true;
        }
      }
      return false;
    };

    BaseInterface.prototype.release = function() {
      this.toolbar.release();
      this.statusbar.release();
      $(window).off('resize', this.resize);
      while (this.regions.length) {
        this.regions.shift().release();
      }
      return BaseInterface.__super__.release.apply(this, arguments);
    };

    BaseInterface.prototype.save = function() {
      var data, region, _i, _len, _ref;
      data = {};
      _ref = this.regions;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        region = _ref[_i];
        data[region.name] = region.toJSON(true);
      }
      return data;
    };

    return BaseInterface;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.FrameInterface = (function(_super) {

    __extends(FrameInterface, _super);

    function FrameInterface() {
      return FrameInterface.__super__.constructor.apply(this, arguments);
    }

    FrameInterface.logPrefix = 'Mercury.FrameInterface:';

    FrameInterface.className = 'mercury-frame-interface';

    FrameInterface.prototype.initialize = function() {
      this.$frame = $(this.frame).addClass('mercury-frame-interface-frame');
      if (!this.$frame.length) {
        this.initialized = true;
        return FrameInterface.__super__.initialize.apply(this, arguments);
      }
    };

    FrameInterface.prototype.reinitialize = function() {
      if (this.$frame.length) {
        this.initialized = false;
        return this.initializeFrame();
      } else {
        return FrameInterface.__super__.reinitialize.apply(this, arguments);
      }
    };

    FrameInterface.prototype.bindDefaultEvents = function() {
      var _this = this;
      this.$frame.on('load', function() {
        return _this.initializeFrame();
      });
      this.delegateEvents({
        'mercury:initialize': function() {
          return this.initializeFrame();
        }
      });
      return FrameInterface.__super__.bindDefaultEvents.apply(this, arguments);
    };

    FrameInterface.prototype.initializeFrame = function() {
      if (this.initialized) {
        return;
      }
      this.initialized = true;
      this.setupDocument();
      this.bindDocumentEvents();
      this.addAllRegions();
      Mercury.trigger('initialized');
      return this.delay(100, this.focusDefaultRegion);
    };

    FrameInterface.prototype.setupDocument = function() {
      var contentWindow;
      contentWindow = this.$frame.get(0).contentWindow;
      contentWindow.Mercury = Mercury;
      return this.document = $(contentWindow.document);
    };

    return FrameInterface;

  })(Mercury.BaseInterface);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Modal = (function(_super) {

    __extends(Modal, _super);

    Modal.include(Mercury.View.Modules.FormHandler);

    Modal.include(Mercury.View.Modules.InterfaceFocusable);

    Modal.include(Mercury.View.Modules.ScrollPropagation);

    Modal.include(Mercury.View.Modules.VisibilityToggleable);

    Modal.logPrefix = 'Mercury.Modal:';

    Modal.className = 'mercury-dialog mercury-modal';

    Modal.elements = {
      overlay: '.mercury-modal-overlay',
      dialog: '.mercury-modal-dialog-positioner',
      content: '.mercury-modal-dialog-content',
      contentContainer: '.mercury-modal-dialog-content-container',
      titleContainer: '.mercury-modal-dialog-title',
      title: '.mercury-modal-dialog-title span'
    };

    Modal.events = {
      'mercury:interface:hide': function() {
        return this.hide();
      },
      'mercury:interface:resize': function(dimensions) {
        return this.resize(false, dimensions);
      },
      'mercury:modals:hide': function() {
        return this.hide();
      },
      'click .mercury-modal-dialog-title em': function() {
        return this.hide();
      }
    };

    Modal.prototype.primaryTemplate = 'modal';

    function Modal(options) {
      var _base;
      this.options = options != null ? options : {};
      (_base = this.options).template || (_base.template = this.template);
      Modal.__super__.constructor.call(this, this.options);
      if (this.hidden) {
        this.visible = false;
      } else {
        this.show();
      }
    }

    Modal.prototype.buildElement = function() {
      this.subTemplate = this.options.template;
      this.template = this.primaryTemplate;
      return Modal.__super__.buildElement.apply(this, arguments);
    };

    Modal.prototype.build = function() {
      this.addClass('loading');
      this.appendTo(Mercury["interface"]);
      return this.preventScrollPropagation(this.$contentContainer);
    };

    Modal.prototype.update = function(options) {
      var content, key, value, _ref;
      if (!this.visible) {
        return;
      }
      this.options = $.extend({}, this.options, options || {});
      _ref = this.options;
      for (key in _ref) {
        value = _ref[key];
        this[key] = value;
      }
      this.subTemplate = this.options.template;
      this.template = this.primaryTemplate;
      this.$title.html(this.title);
      this.$dialog.css({
        width: this.width
      });
      content = this.contentFromOptions();
      if (content === this.lastContent) {
        return;
      }
      this.addClass('loading');
      this.$content.css({
        visibility: 'hidden',
        opacity: 0,
        width: this.width
      }).html(content);
      this.lastContent = content;
      this.resize();
      this.show(false);
      this.refreshElements();
      return this.delay(300, this.focusFirstFocusable);
    };

    Modal.prototype.resize = function(animate, dimensions) {
      var height, titleHeight, width;
      if (animate == null) {
        animate = true;
      }
      clearTimeout(this.showContentTimeout);
      if (!animate) {
        this.addClass('mercury-no-animation');
      }
      this.$contentContainer.css({
        height: 'auto'
      });
      titleHeight = this.$titleContainer.outerHeight();
      if (!this.width) {
        this.$content.css({
          position: 'absolute'
        });
        width = this.$content.outerWidth();
        height = Math.min(this.$content.outerHeight() + titleHeight, $(window).height() - 10);
        this.$content.css({
          position: 'static'
        });
      } else {
        height = Math.min(this.$content.outerHeight() + titleHeight, $(window).height() - 10);
      }
      this.$dialog.css({
        height: height,
        width: width || this.width
      });
      this.$contentContainer.css({
        height: height - titleHeight
      });
      if (animate) {
        this.showContentTimeout = this.delay(300, this.showContent);
      } else {
        this.showContent(false);
      }
      return this.delay(250, function() {
        return this.removeClass('mercury-no-animation');
      });
    };

    Modal.prototype.contentFromOptions = function() {
      if (this.subTemplate) {
        return this.renderTemplate(this.subTemplate);
      }
      return this.content;
    };

    Modal.prototype.showContent = function(animate) {
      if (animate == null) {
        animate = true;
      }
      clearTimeout(this.contentOpacityTimeout);
      this.removeClass('loading');
      this.$content.css({
        visibility: 'visible',
        width: 'auto'
      });
      if (animate) {
        return this.contentOpacityTimeout = this.delay(50, function() {
          return this.$content.css({
            opacity: 1
          });
        });
      } else {
        return this.$content.css({
          opacity: 1
        });
      }
    };

    Modal.prototype.show = function(update) {
      if (update == null) {
        update = true;
      }
      if (this.visible) {
        return;
      }
      Mercury.trigger('blur');
      Mercury.trigger('modals:hide');
      this.trigger('show');
      clearTimeout(this.visibilityTimout);
      this.visible = true;
      this.$el.show();
      return this.visibilityTimout = this.delay(50, function() {
        this.css({
          opacity: 1
        });
        if (update) {
          return this.update();
        }
      });
    };

    Modal.prototype.hide = function(release) {
      if (release == null) {
        release = false;
      }
      if (!this.visible && !release) {
        return;
      }
      Mercury.trigger('focus');
      this.trigger('hide');
      clearTimeout(this.visibilityTimout);
      this.visible = false;
      this.css({
        opacity: 0
      });
      return this.visibilityTimout = this.delay(250, function() {
        this.$el.hide();
        if (release) {
          return this.release();
        }
      });
    };

    Modal.prototype.appendTo = function() {
      this.log(this.t('appending to mercury interface instead'));
      return Modal.__super__.appendTo.call(this, Mercury["interface"]);
    };

    Modal.prototype.release = function() {
      if (this.visible) {
        return this.hide(true);
      }
      return Modal.__super__.release.apply(this, arguments);
    };

    return Modal;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Lightview = (function(_super) {

    __extends(Lightview, _super);

    function Lightview() {
      return Lightview.__super__.constructor.apply(this, arguments);
    }

    Lightview.logPrefix = 'Mercury.Lightview:';

    Lightview.className = 'mercury-dialog mercury-lightview';

    Lightview.elements = {
      overlay: '.mercury-lightview-overlay',
      dialog: '.mercury-lightview-dialog-positioner',
      content: '.mercury-lightview-dialog-content',
      contentContainer: '.mercury-lightview-dialog-content-container',
      titleContainer: '.mercury-lightview-dialog-title',
      title: '.mercury-lightview-dialog-title span'
    };

    Lightview.events = {
      'mercury:interface:hide': function() {
        return this.hide();
      },
      'mercury:interface:resize': function(dimensions) {
        return this.resize(false, dimensions);
      },
      'mercury:modals:hide': function() {
        return this.hide();
      },
      'click .mercury-lightview-dialog-title em': function() {
        return this.hide();
      }
    };

    Lightview.prototype.primaryTemplate = 'lightview';

    Lightview.prototype.build = function() {
      Lightview.__super__.build.apply(this, arguments);
      return this.$dialog.css({
        marginTop: ($(window).height() - 75) / 2
      });
    };

    Lightview.prototype.resize = function(animate, dimensions) {
      var height, titleHeight;
      if (animate == null) {
        animate = true;
      }
      clearTimeout(this.showContentTimeout);
      if (!animate) {
        this.addClass('mercury-no-animation');
      }
      this.$contentContainer.css({
        height: 'auto'
      });
      this.$content.css({
        width: Math.min(this.$content.outerWidth(), $(window).width())
      });
      titleHeight = this.$titleContainer.outerHeight();
      height = Math.min(this.$content.outerHeight() + titleHeight, $(window).height());
      this.$dialog.css({
        marginTop: ($(window).height() - height) / 2,
        height: height
      });
      this.$content.css({
        width: 'auto'
      });
      this.$contentContainer.css({
        height: height - titleHeight
      });
      if (animate) {
        this.showContentTimeout = this.delay(300, this.showContent);
      } else {
        this.showContent(false);
      }
      return this.removeClass('mercury-no-animation');
    };

    return Lightview;

  })(Mercury.Modal);

}).call(this);
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Panel = (function(_super) {

    __extends(Panel, _super);

    Panel.include(Mercury.View.Modules.FormHandler);

    Panel.include(Mercury.View.Modules.InterfaceFocusable);

    Panel.include(Mercury.View.Modules.ScrollPropagation);

    Panel.include(Mercury.View.Modules.VisibilityToggleable);

    Panel.logPrefix = 'Mercury.Panel:';

    Panel.className = 'mercury-dialog mercury-panel';

    Panel.elements = {
      content: '.mercury-panel-content',
      contentContainer: '.mercury-panel-content-container',
      titleContainer: '.mercury-panel-title',
      title: '.mercury-panel-title span'
    };

    Panel.events = {
      'mercury:interface:hide': function() {
        return this.hide();
      },
      'mercury:interface:resize': function(e) {
        return this.resize(false, e);
      },
      'mercury:panels:hide': function() {
        return this.hide();
      },
      'mousedown .mercury-panel-title em': function(e) {
        return this.prevent(e);
      },
      'click .mercury-panel-title em': function() {
        return this.hide();
      }
    };

    Panel.prototype.primaryTemplate = 'panel';

    function Panel(options) {
      var _base;
      this.options = options != null ? options : {};
      this.resize = __bind(this.resize, this);

      (_base = this.options).template || (_base.template = this.template);
      Panel.__super__.constructor.call(this, this.options);
      if (this.hidden) {
        this.visible = false;
      } else {
        this.show();
      }
    }

    Panel.prototype.buildElement = function() {
      this.subTemplate = this.options.template;
      this.template = this.primaryTemplate;
      return Panel.__super__.buildElement.apply(this, arguments);
    };

    Panel.prototype.build = function() {
      this.addClass('loading');
      this.appendTo(Mercury["interface"]);
      return this.preventScrollPropagation(this.$contentContainer);
    };

    Panel.prototype.update = function(options) {
      var content, key, value, _ref;
      if (!this.visible) {
        return;
      }
      this.options = $.extend({}, this.options, options || {});
      _ref = this.options;
      for (key in _ref) {
        value = _ref[key];
        this[key] = value;
      }
      this.subTemplate = this.options.template;
      this.template = this.primaryTemplate;
      this.$title.html(this.title);
      this.css({
        width: this.width
      });
      content = this.contentFromOptions();
      if (content === this.lastContent) {
        return;
      }
      this.addClass('loading');
      this.$content.css({
        visibility: 'hidden',
        opacity: 0,
        width: this.width
      }).html(content);
      this.lastContent = content;
      this.resize(true, Mercury["interface"].dimensions());
      this.show(false);
      return this.refreshElements();
    };

    Panel.prototype.resize = function(animate, dimensions) {
      var height, titleHeight;
      if (animate == null) {
        animate = true;
      }
      clearTimeout(this.showContentTimeout);
      if (dimensions) {
        this.css({
          top: dimensions.top + 10,
          bottom: dimensions.bottom + 10
        });
      }
      if (!animate) {
        this.addClass('mercury-no-animation');
      }
      titleHeight = this.$titleContainer.outerHeight();
      height = this.$el.height();
      this.$contentContainer.css({
        height: height - titleHeight
      });
      if (animate) {
        this.showContentTimeout = this.delay(300, this.showContent);
      } else {
        this.showContent(false);
      }
      return this.removeClass('mercury-no-animation');
    };

    Panel.prototype.contentFromOptions = function() {
      if (this.subTemplate) {
        return this.renderTemplate(this.subTemplate);
      }
      return this.content;
    };

    Panel.prototype.showContent = function(animate) {
      clearTimeout(this.contentOpacityTimeout);
      this.removeClass('loading');
      this.$content.css({
        visibility: 'visible',
        width: 'auto'
      });
      if (animate) {
        return this.contentOpacityTimeout = this.delay(50, function() {
          return this.$content.css({
            opacity: 1
          });
        });
      } else {
        return this.$content.css({
          opacity: 1
        });
      }
    };

    Panel.prototype.show = function(update) {
      if (update == null) {
        update = true;
      }
      if (this.visible) {
        return;
      }
      Mercury.trigger('panels:hide');
      this.trigger('show');
      clearTimeout(this.visibilityTimout);
      this.visible = true;
      this.$el.show();
      return this.visibilityTimout = this.delay(50, function() {
        this.css({
          opacity: 1
        });
        if (update) {
          return this.update();
        }
      });
    };

    Panel.prototype.hide = function(release) {
      if (release == null) {
        release = false;
      }
      if (!this.visible) {
        return;
      }
      Mercury.trigger('focus');
      this.trigger('hide');
      clearTimeout(this.visibilityTimout);
      this.visible = false;
      this.css({
        opacity: 0
      });
      return this.visibilityTimout = this.delay(250, function() {
        this.$el.hide();
        if (release) {
          return this.release();
        }
      });
    };

    Panel.prototype.appendTo = function() {
      this.log(this.t('appending to mercury interface instead'));
      return Panel.__super__.appendTo.call(this, Mercury["interface"]);
    };

    Panel.prototype.release = function() {
      if (this.visible) {
        return this.hide(true);
      }
      return Panel.__super__.release.apply(this, arguments);
    };

    return Panel;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Statusbar = (function(_super) {

    __extends(Statusbar, _super);

    function Statusbar() {
      return Statusbar.__super__.constructor.apply(this, arguments);
    }

    Statusbar.logPrefix = 'Mercury.Statusbar:';

    Statusbar.className = 'mercury-statusbar';

    Statusbar.template = 'statusbar';

    Statusbar.elements = {
      path: '.mercury-statusbar-path'
    };

    Statusbar.events = {
      'mercury:interface:hide': 'hide',
      'mercury:interface:show': 'show',
      'mercury:region:update': 'onRegionUpdate',
      'mousedown': 'onMousedown'
    };

    Statusbar.prototype.build = function() {
      return this.setPath();
    };

    Statusbar.prototype.setPath = function(path) {
      var el, _i, _len, _results;
      if (path == null) {
        path = [];
      }
      this.$path.html("<b>" + (this.t('Path:')) + " </b>");
      _results = [];
      for (_i = 0, _len = path.length; _i < _len; _i++) {
        el = path[_i];
        this.$path.append(el);
        if (el !== path[path.length - 1]) {
          _results.push(this.$path.append(' &raquo; '));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Statusbar.prototype.show = function() {
      var _this = this;
      clearTimeout(this.visibilityTimeout);
      this.visible = true;
      this.$el.show();
      return this.visibilityTimeout = this.delay(50, function() {
        return _this.css({
          bottom: 0
        });
      });
    };

    Statusbar.prototype.hide = function() {
      var _this = this;
      clearTimeout(this.visibilityTimeout);
      this.visible = false;
      this.css({
        bottom: -this.$el.height()
      });
      return this.visibilityTimeout = this.delay(250, function() {
        return _this.$el.hide();
      });
    };

    Statusbar.prototype.height = function() {
      return this.$el.outerHeight();
    };

    Statusbar.prototype.onMousedown = function(e) {
      this.prevent(e);
      Mercury.trigger('dialogs:hide');
      return Mercury.trigger('focus');
    };

    Statusbar.prototype.onRegionUpdate = function(region) {
      var path;
      if (path = typeof region.path === "function" ? region.path() : void 0) {
        return this.setPath(path);
      }
    };

    return Statusbar;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __slice = [].slice;

  Mercury.ToolbarButton = (function(_super) {

    __extends(ToolbarButton, _super);

    ToolbarButton.logPrefix = 'Mercury.ToolbarButton:';

    ToolbarButton.className = 'mercury-toolbar-button';

    ToolbarButton.events = {
      'mousedown': 'indicate',
      'mouseup': 'deindicate',
      'mouseout': 'deindicate',
      'click': 'triggerAction',
      'mercury:region:focus': 'onRegionFocus',
      'mercury:region:action': 'onRegionUpdate',
      'mercury:region:update': 'onRegionUpdate'
    };

    ToolbarButton.prototype.standardOptions = ['title', 'icon', 'action', 'global', 'button', 'settings'];

    ToolbarButton.create = function(name, label, options) {
      var Klass;
      if (options == null) {
        options = {};
      }
      if (options.button && (Klass = Mercury[("toolbar_" + options.button).toCamelCase(true)])) {
        return new Klass(name, label, options);
      }
      if (options.plugin && (Klass = Mercury.getPlugin(options.plugin).Button)) {
        return new Klass(name, label, options);
      }
      return new Mercury.ToolbarButton(name, label, options);
    };

    function ToolbarButton(name, label, options) {
      this.name = name;
      this.label = label;
      this.options = options != null ? options : {};
      this.determineAction();
      this.determineTypes();
      ToolbarButton.__super__.constructor.call(this, this.options);
    }

    ToolbarButton.prototype.determineAction = function() {
      this.action = this.options.action || this.name;
      if (typeof this.action === 'string') {
        this.action = [this.action];
      }
      return this.actionName = this.action[0];
    };

    ToolbarButton.prototype.determineTypes = function() {
      var type, value, _ref;
      this.types = [];
      if (this.options.type) {
        return this.types = [this.options.type];
      }
      _ref = this.options;
      for (type in _ref) {
        value = _ref[type];
        if (__indexOf.call(this.standardOptions, type) < 0) {
          this.types.push(type);
        }
      }
      return this.type = this.types[0];
    };

    ToolbarButton.prototype.build = function() {
      var _ref;
      this.registerPlugin();
      this.attr('data-type', this.type);
      this.attr('data-icon', Mercury.Toolbar.icons[this.icon || this.name] || this.icon);
      this.addClass("mercury-toolbar-" + (this.name.toDash()) + "-button");
      this.html("<em>" + this.label + "</em>");
      return (_ref = this.buildSubview()) != null ? _ref.appendTo(this) : void 0;
    };

    ToolbarButton.prototype.registerPlugin = function() {
      if (!this.plugin) {
        return;
      }
      this.plugin = Mercury.getPlugin(this.plugin, true);
      return this.plugin.buttonRegistered(this);
    };

    ToolbarButton.prototype.buildSubview = function() {
      var Klass, options,
        _this = this;
      if (this.subview) {
        this.subview.on('show', function() {
          if (_this.toggle) {
            _this.toggled();
          }
          return _this.activate();
        });
        this.subview.on('hide', function() {
          _this.untoggled();
          return _this.deactivate();
        });
        return this.subview;
      }
      if (Klass = Mercury[("toolbar_" + this.type).toCamelCase(true)]) {
        options = this.options[this.type];
        if (typeof options === 'string') {
          options = {
            template: options
          };
        }
        return this.subview = new Klass($.extend({
          parent: this.$el
        }, options));
      }
    };

    ToolbarButton.prototype.triggerAction = function() {
      if (this.isDisabled()) {
        return;
      }
      if (this.toggle || this.mode) {
        if (!this.isToggled) {
          this.toggled();
        } else {
          this.untoggled();
        }
      }
      if (this.subview) {
        if (this.subview.visible) {
          this.deactivate();
        } else {
          this.activate();
        }
        this.subview.toggle();
      }
      if (this.plugin) {
        return this.plugin.trigger('button:click');
      }
      if (this.subview) {
        return;
      }
      if (this.event) {
        Mercury.trigger(this.event);
      }
      if (this.mode) {
        Mercury.trigger('mode', this.mode);
      }
      return Mercury.trigger.apply(Mercury, ['action'].concat(__slice.call(this.action)));
    };

    ToolbarButton.prototype.regionSupported = function(region) {
      if (this.plugin) {
        return this.plugin.regionSupported(region);
      }
      return region.hasAction(this.actionName);
    };

    ToolbarButton.prototype.onRegionFocus = function(region) {
      var _this = this;
      return this.delay(100, function() {
        return _this.onRegionUpdate(region);
      });
    };

    ToolbarButton.prototype.onRegionUpdate = function(region) {
      var _ref;
      if (!((_ref = this.subview) != null ? _ref.visible : void 0)) {
        this.deactivate();
      }
      if (this.global || this.regionSupported(region)) {
        this.enable();
        if (region.hasContext(this.name)) {
          return this.activate();
        }
      } else {
        return this.disable();
      }
    };

    ToolbarButton.prototype.get = function(key) {
      return this[key];
    };

    ToolbarButton.prototype.set = function(key, value) {
      var attrs, _results;
      attrs = {};
      if (typeof key === 'object') {
        attrs = key;
      } else {
        attrs[key] = value;
      }
      _results = [];
      for (key in attrs) {
        value = attrs[key];
        _results.push(this[key] = value);
      }
      return _results;
    };

    ToolbarButton.prototype.toggled = function() {
      this.isToggled = true;
      return this.addClass('mercury-button-toggled');
    };

    ToolbarButton.prototype.untoggled = function() {
      this.isToggled = false;
      return this.removeClass('mercury-button-toggled');
    };

    ToolbarButton.prototype.activate = function() {
      this.isActive = true;
      return this.addClass('mercury-button-active');
    };

    ToolbarButton.prototype.deactivate = function() {
      this.isActive = false;
      return this.removeClass('mercury-button-active');
    };

    ToolbarButton.prototype.enable = function() {
      this.isEnabled = true;
      return this.removeClass('mercury-button-disabled');
    };

    ToolbarButton.prototype.disable = function() {
      this.isEnabled = false;
      return this.addClass('mercury-button-disabled');
    };

    ToolbarButton.prototype.isDisabled = function() {
      return this.isEnabled === false || this.$el.closest('.mercury-button-disabled').length;
    };

    ToolbarButton.prototype.indicate = function(e) {
      var _ref;
      this.isIndicated = false;
      if (this.isDisabled()) {
        return;
      }
      if (e && ((_ref = this.subview) != null ? _ref.visible : void 0)) {
        this.deactivate();
        this.prevent(e, true);
      }
      return this.addClass('mercury-button-pressed');
    };

    ToolbarButton.prototype.deindicate = function() {
      this.isIndicated = true;
      return this.removeClass('mercury-button-pressed');
    };

    return ToolbarButton;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  Mercury.ToolbarItem = (function(_super) {

    __extends(ToolbarItem, _super);

    ToolbarItem.logPrefix = 'Mercury.ToolbarItem:';

    function ToolbarItem(name, type, value) {
      this.name = name != null ? name : 'unknown';
      this.type = type != null ? type : 'unknown';
      this.value = value != null ? value : null;
      ToolbarItem.__super__.constructor.call(this);
    }

    ToolbarItem.prototype.build = function() {
      var name, value, _ref;
      this.addClasses();
      if (typeof this.value !== 'object') {
        return;
      }
      _ref = this.value;
      for (name in _ref) {
        value = _ref[name];
        this.buildSubview(name, value);
      }
      if (this.type === 'group') {
        return this.buildSubview('sep-final', '-');
      }
    };

    ToolbarItem.prototype.buildSubview = function(name, value) {
      var item;
      item = (function() {
        var _ref;
        switch (($.isArray(value) ? 'array' : typeof value)) {
          case 'object':
            return new Mercury.ToolbarItem(name, 'group', value);
          case 'string':
            return new Mercury.ToolbarItem(name, 'separator', value);
          case 'array':
            return (_ref = Mercury.ToolbarButton).create.apply(_ref, [name].concat(__slice.call(value)));
        }
      })();
      if (item) {
        return this.append(item);
      }
    };

    ToolbarItem.prototype.addClasses = function() {
      var extraClass;
      extraClass = "mercury-toolbar-" + (this.type.toDash());
      if (this.value === '-') {
        extraClass = "mercury-toolbar-line-" + (this.type.toDash());
      }
      return this.addClass(["mercury-toolbar-" + (this.name.toDash()) + "-" + (this.type.toDash()), extraClass].join(' '));
    };

    return ToolbarItem;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Toolbar = (function(_super) {

    __extends(Toolbar, _super);

    function Toolbar() {
      return Toolbar.__super__.constructor.apply(this, arguments);
    }

    Toolbar.logPrefix = 'Mercury.Toolbar:';

    Toolbar.className = 'mercury-toolbar';

    Toolbar.elements = {
      toolbar: '.mercury-toolbar-secondary-container'
    };

    Toolbar.events = {
      'mercury:interface:hide': 'hide',
      'mercury:interface:show': 'show',
      'mercury:region:focus': 'onRegionFocus',
      'mousedown': 'onMousedown',
      'mouseup': function(e) {
        return this.prevent(e, true);
      },
      'click': function(e) {
        return this.prevent(e, true);
      }
    };

    Toolbar.prototype.build = function() {
      this.append(new Mercury.ToolbarItem('primary', 'container', this.config("toolbars:primary")));
      return this.append(new Mercury.ToolbarItem('secondary', 'container', {}));
    };

    Toolbar.prototype.buildToolbar = function(name) {
      return new Mercury.ToolbarItem(name, 'collection', this.config("toolbars:" + name)).appendTo(this.$toolbar);
    };

    Toolbar.prototype.show = function() {
      var _this = this;
      clearTimeout(this.visibilityTimeout);
      this.visible = true;
      this.$el.show();
      return this.visibilityTimeout = this.delay(50, function() {
        return _this.css({
          top: 0
        });
      });
    };

    Toolbar.prototype.hide = function() {
      var _this = this;
      clearTimeout(this.visibilityTimeout);
      this.visible = false;
      this.css({
        top: -this.$el.height()
      });
      return this.visibilityTimeout = this.delay(250, function() {
        return _this.$el.hide();
      });
    };

    Toolbar.prototype.height = function() {
      return this.$el.outerHeight();
    };

    Toolbar.prototype.onMousedown = function(e) {
      this.prevent(e);
      Mercury.trigger('dialogs:hide');
      return Mercury.trigger('focus');
    };

    Toolbar.prototype.onRegionFocus = function(region) {
      var name, _i, _len, _ref;
      if (this.region === region) {
        return;
      }
      this.region = region;
      this.$('.mercury-toolbar-collection').remove();
      _ref = region.toolbars || [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        name = _ref[_i];
        this.buildToolbar(name);
      }
      return Mercury.trigger('region:update', region);
    };

    Toolbar.icons = {
      save: 'A',
      preview: 'B',
      undo: 'C',
      redo: 'D',
      link: 'J',
      file: 'K',
      table: 'L',
      character: 'M',
      snippets: 'N',
      history: 'O',
      notes: 'P',
      upload: 'X',
      search: 'Y',
      bold: 'b',
      italic: 'c',
      strike: 'd',
      underline: 'e',
      subscript: 'f',
      superscript: 'g',
      justifyLeft: 'h',
      justifyCenter: 'i',
      justifyRight: 'j',
      justifyFull: 'k',
      unorderedList: 'l',
      orderedList: 'm',
      outdent: 'n',
      indent: 'o',
      rule: 'p',
      h1: 'q',
      h2: 'r',
      h3: 's',
      h4: 't',
      h5: 'u',
      h6: 'v',
      removeHeading: 'w',
      blockquote: 'x',
      clean: 'y',
      edit: 'z',
      pre: 'z',
      rowBefore: '0',
      rowAfter: '1',
      rowDelete: '2',
      colBefore: '3',
      colAfter: '4',
      colDelete: '5',
      colIncrease: '6',
      colDecrease: '7',
      rowIncrease: '8',
      rowDecrease: '9',
      alignLeft: '"',
      alignRight: "'",
      alignTop: '?',
      alignMiddle: '!',
      alignBottom: '@',
      alignNone: '_',
      crop: '*',
      resize: '#',
      prev: '$',
      next: '%',
      remove: 'y',
      togglePlay: '&',
      fav: '^',
      softWrap: '`',
      direction: '{',
      calculate: '|',
      user: '}',
      brightness: '~'
    };

    return Toolbar;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.ToolbarPalette = (function(_super) {

    __extends(ToolbarPalette, _super);

    function ToolbarPalette() {
      return ToolbarPalette.__super__.constructor.apply(this, arguments);
    }

    ToolbarPalette.include(Mercury.View.Modules.InterfaceFocusable);

    ToolbarPalette.include(Mercury.View.Modules.ToolbarDialog);

    ToolbarPalette.include(Mercury.View.Modules.VisibilityToggleable);

    ToolbarPalette.logPrefix = 'Mercury.ToolbarPalette:';

    ToolbarPalette.className = 'mercury-dialog mercury-toolbar-palette';

    ToolbarPalette.prototype.hidden = true;

    ToolbarPalette.prototype.init = function() {
      this.on('show', function() {
        if (!this.visible) {
          return Mercury.trigger('interface:mask');
        }
      });
      return this.on('hide', function() {
        if (this.visible) {
          return Mercury.trigger('interface:unmask');
        }
      });
    };

    return ToolbarPalette;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.ToolbarSelect = (function(_super) {

    __extends(ToolbarSelect, _super);

    function ToolbarSelect() {
      return ToolbarSelect.__super__.constructor.apply(this, arguments);
    }

    ToolbarSelect.include(Mercury.View.Modules.InterfaceFocusable);

    ToolbarSelect.include(Mercury.View.Modules.ToolbarDialog);

    ToolbarSelect.include(Mercury.View.Modules.VisibilityToggleable);

    ToolbarSelect.logPrefix = 'Mercury.ToolbarSelect:';

    ToolbarSelect.className = 'mercury-dialog mercury-toolbar-select';

    ToolbarSelect.prototype.hidden = true;

    ToolbarSelect.prototype.init = function() {
      this.on('show', function() {
        if (!this.visible) {
          return Mercury.trigger('interface:mask');
        }
      });
      return this.on('hide', function() {
        if (this.visible) {
          return Mercury.trigger('interface:unmask');
        }
      });
    };

    return ToolbarSelect;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Model.File = (function(_super) {

    __extends(File, _super);

    File.define('Mercury.Model.File');

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
        url: this.file.url || null
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
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Uploader = (function(_super) {

    __extends(Uploader, _super);

    Uploader.supported = !!(window.FormData && new XMLHttpRequest().upload);

    Uploader.logPrefix = 'Mercury.Uploader:';

    Uploader.className = 'mercury-uploader';

    Uploader.template = 'uploader';

    Uploader.attributes = {
      style: 'opacity:0'
    };

    Uploader.elements = {
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
        file = new Mercury.Model.File(file, {
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
      return this.appendTo(Mercury["interface"]);
    };

    Uploader.prototype.show = function() {
      var _this = this;
      this.update(this.t('Processing...'));
      return this.delay(50, function() {
        return _this.css({
          opacity: 1
        });
      });
    };

    Uploader.prototype.release = function(ms) {
      if (ms == null) {
        ms = 0;
      }
      return this.delay(ms, function() {
        this.css({
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
      percent = Math.floor((this.loaded + loaded) * 100 / this.total) + '%';
      if (message) {
        this.$status.html(message);
      }
      this.$indicator.css({
        width: percent
      });
      return this.$percent.html(percent);
    };

    Uploader.prototype.loadDetails = function() {
      var _this = this;
      this.$details.html([this.t('Name: %s', this.file.get('name')), this.t('Type: %s', this.file.get('type')), this.t('Size: %s', this.file.readableSize())].join('<br/>'));
      if (!this.file.isImage()) {
        return;
      }
      return this.file.readAsDataURL(function(result) {
        return _this.$preview.html($('<img>', {
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
          return _this.$percent.show();
        }
      };
    };

    return Uploader;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Action.Image = (function(_super) {

    __extends(Image, _super);

    function Image() {
      return Image.__super__.constructor.apply(this, arguments);
    }

    Image.prototype.name = 'image';

    Image.prototype.asHtml = function() {
      return "<img src=\"" + (this.get('url')) + "\">";
    };

    return Image;

  })(Mercury.Action);

}).call(this);
(function() {

  Mercury.Region.Modules.ContentEditable = {
    included: function() {
      this.on('build', this.buildContentEditable);
      this.on('preview', this.toggleContentEditable);
      return this.on('release', this.releaseContentEditable);
    },
    buildContentEditable: function() {
      var _ref;
      if ((_ref = this.editableDropBehavior) == null) {
        this.editableDropBehavior = true;
      }
      this.document || (this.document = this.$el.get(0).ownerDocument);
      this.makeContentEditable();
      this.forceContentEditableDisplay();
      return this.setContentEditablePreferences();
    },
    toggleContentEditable: function() {
      if (this.previewing) {
        return this.makeNotContentEditable();
      } else {
        return this.makeContentEditable();
      }
    },
    releaseContentEditable: function() {
      this.makeNotContentEditable();
      if (this.originalDisplay) {
        return this.css({
          display: this.originalDisplay
        });
      }
    },
    makeContentEditable: function() {
      return this.$el.get(0).contentEditable = true;
    },
    makeNotContentEditable: function() {
      return this.$el.get(0).contentEditable = false;
    },
    forceContentEditableDisplay: function() {
      if (this.css('display') === 'inline') {
        this.originalDisplay = 'inline';
        return this.css({
          display: 'inline-block'
        });
      }
    },
    setContentEditablePreferences: function() {
      try {
        this.document.execCommand('styleWithCSS', false, false);
        this.document.execCommand('insertBROnReturn', false, true);
        this.document.execCommand('enableInlineTableEditing', false, false);
        return this.document.execCommand('enableObjectResizing', false, false);
      } catch (_error) {}
    },
    stackEquality: function(value) {
      if (this.stackPosition === 0 && this.stack[this.stackPosition]) {
        return JSON.stringify(this.stack[this.stackPosition].val) === JSON.stringify(value.val);
      }
      return JSON.stringify(this.stack[this.stackPosition]) === JSON.stringify(value);
    }
  };

}).call(this);
(function() {

  Mercury.Region.Modules.DropIndicator = {
    included: function() {
      this.on('build', this.buildDropIndicator);
      return this.on('release', this.releaseDropIndicator);
    },
    buildDropIndicator: function() {
      this.$el.after(this.$dropIndicator = $('<div class="mercury-region-drop-indicator"></div>'));
      return this.delegateEvents({
        dragenter: 'showDropIndicator',
        dragover: 'showDropIndicator',
        dragleave: 'hideDropIndicator',
        drop: 'hideDropIndicator'
      });
    },
    releaseDropIndicator: function() {
      return this.$dropIndicator.remove();
    },
    dropIndicatorPosition: function() {
      var pos;
      pos = this.$el.position();
      return {
        top: pos.top + this.$el.outerHeight() / 2,
        left: pos.left + this.$el.outerWidth() / 2,
        display: 'block'
      };
    },
    showDropIndicator: function() {
      var _this = this;
      if (this.previewing || this.dropIndicatorVisible) {
        return;
      }
      this.dropIndicatorVisible = true;
      clearTimeout(this.dropIndicatorTimer);
      this.$dropIndicator.css(this.dropIndicatorPosition());
      return this.delay(50, function() {
        return _this.$dropIndicator.css({
          opacity: 1
        });
      });
    },
    hideDropIndicator: function() {
      var _this = this;
      this.dropIndicatorVisible = false;
      this.$dropIndicator.css({
        opacity: 0
      });
      return this.dropIndicatorTimer = this.delay(500, function() {
        return _this.$dropIndicator.hide();
      });
    }
  };

}).call(this);
(function() {

  Mercury.Region.Modules.DropItem = {
    onDropItem: function(e, data) {
      var action, url, _ref;
      _ref = this.getActionAndUrlFromData(data), action = _ref[0], url = _ref[1];
      if (!url) {
        return;
      }
      this.prevent(e);
      this.focus();
      return this.handleAction(action, {
        url: url
      });
    },
    getActionAndUrlFromData: function(data) {
      var action, url;
      action = 'image';
      if (data.getData('text/html') || (Mercury.support.safari && (data.types || []).indexOf('image/tiff') === -1)) {
        action = 'link';
      }
      if (url = $('<div>').html(data.getData('text/html')).find('img').attr('src')) {
        action = 'image';
      }
      return [action, url || data.getData('text/uri-list')];
    }
  };

}).call(this);
(function() {

  Mercury.Region.Modules.FocusableTextarea = {
    included: function() {
      this.on('build', this.buildFocusable);
      this.on('action', this.resizeFocusable);
      this.on('preview', this.toggleFocusablePreview);
      return this.on('release', this.releaseFocusable);
    },
    buildFocusable: function() {
      var resize, value, _ref, _ref1;
      if ((_ref = this.editableDropBehavior) == null) {
        this.editableDropBehavior = true;
      }
      if ((_ref1 = this.autoSize) == null) {
        this.autoSize = this.config("regions:" + this.constructor.type + ":autoSize");
      }
      value = this.html().replace('&gt;', '>').replace('&lt;', '<').trim();
      resize = this.autoSize ? 'none' : 'vertical';
      this.$preview = $("<div class=\"mercury-" + this.constructor.type + "-region-preview\">");
      this.$focusable = $("<textarea class=\"mercury-" + this.constructor.type + "-region-textarea\">");
      if (!this.config("regions:" + this.constructor.type + ":wrapping")) {
        this.$focusable.attr({
          wrap: 'off'
        });
      }
      this.$el.empty();
      this.append(this.$preview, this.$focusable.css({
        width: '100%',
        height: this.$el.height() || this.height || 20,
        resize: resize
      }));
      this.value(value);
      this.resizeFocusable();
      return this.delegateEvents({
        'keydown textarea': 'handleKeyEvent'
      });
    },
    releaseFocusable: function() {
      var _ref;
      return this.html((_ref = typeof this.convertedValue === "function" ? this.convertedValue() : void 0) != null ? _ref : this.value());
    },
    value: function(value) {
      var _ref;
      if (value == null) {
        value = null;
      }
      if (value === null || typeof value === 'undefined') {
        return this.$focusable.val();
      }
      this.$focusable.val((_ref = value.val) != null ? _ref : value);
      if (value.sel) {
        return this.setSerializedSelection(value.sel);
      }
    },
    resizeFocusable: function() {
      var body, current, focusable;
      if (!this.autoSize) {
        return;
      }
      focusable = this.$focusable.get(0);
      body = $('body', this.el.ownerDocument);
      current = body.scrollTop();
      this.$focusable.css({
        height: 1
      }).css({
        height: focusable.scrollHeight
      });
      return body.scrollTop(current);
    },
    toggleFocusablePreview: function() {
      if (this.previewing) {
        this.$focusable.hide();
        return this.$preview.html((typeof this.convertedValue === "function" ? this.convertedValue() : void 0) || this.value()).show();
      } else {
        this.$preview.hide();
        return this.$focusable.show();
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
      this.resizeFocusable();
      return this.pushHistory(e.keyCode);
    }
  };

}).call(this);
(function() {

  Mercury.Region.Modules.HtmlSelection = {
    getSelection: function() {
      return rangy.getSelection();
    },
    getSerializedSelection: function() {
      return rangy.serializeSelection();
    },
    setSerializedSelection: function(sel) {
      return rangy.deserializeSelection(sel);
    },
    toggleWrapSelectedWordsInClass: function(className, options) {
      var classApplier;
      if (options == null) {
        options = {};
      }
      options = $.extend({}, {
        normalize: true
      }, options, {
        applyToEditableOnly: true
      });
      classApplier = rangy.createCssClassApplier(className, options);
      return classApplier.toggleSelection();
    },
    replaceSelection: function(val) {
      var range, _i, _len, _ref, _results;
      if (typeof val === 'string' || val.is) {
        val = this.elementFromValue(val);
      }
      _ref = this.getSelection().getAllRanges();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        range = _ref[_i];
        range.deleteContents();
        _results.push(range.insertNode(val));
      }
      return _results;
    },
    elementFromValue: function(val) {
      if (val.is) {
        return val.get(0);
      } else {
        return $(val).get(0);
      }
    }
  };

}).call(this);
(function() {

  Mercury.Region.Modules.SelectionValue = {
    toStack: function() {
      return {
        val: this.toJSON(),
        sel: typeof this.getSerializedSelection === "function" ? this.getSerializedSelection() : void 0
      };
    },
    fromStack: function(val) {
      if (!val) {
        return;
      }
      this.fromJSON(val.val);
      if (val.sel) {
        return typeof this.setSerializedSelection === "function" ? this.setSerializedSelection(val.sel) : void 0;
      }
    }
  };

}).call(this);
(function() {
  var __slice = [].slice;

  Mercury.Region.Modules.TextSelection = {
    getSelection: function() {
      var el, end, start, value;
      el = this.$focusable.get(0);
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
    setSelection: function(sel, preAdjust, sufAdjust, collapse) {
      var el, end, start, value;
      if (preAdjust == null) {
        preAdjust = 0;
      }
      if (sufAdjust == null) {
        sufAdjust = null;
      }
      if (collapse == null) {
        collapse = false;
      }
      start = sel.start + preAdjust;
      end = sel.end + (sufAdjust != null ? sufAdjust : preAdjust);
      if (end < start || typeof end === 'undefined' || collapse) {
        end = start;
      }
      el = this.$focusable.get(0);
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
    getSerializedSelection: function() {
      return this.getSelection();
    },
    setSerializedSelection: function(sel) {
      return this.setSelection(sel);
    },
    isWithinToken: function(wrapper) {
      var exp, fix, sel, _ref;
      _ref = this.getTokenAndSelection(wrapper), fix = _ref[0], sel = _ref[1];
      exp = this.expandSelectionToTokens(sel, fix);
      if (exp.cleaned) {
        return true;
      }
    },
    isWithinLineToken: function(wrapper) {
      var exp, fix, sel, set, _ref;
      _ref = this.getTokenAndSelection(wrapper), fix = _ref[0], sel = _ref[1];
      exp = this.expandSelectionToLines(sel);
      set = exp.text.match(fix.regexp);
      if (!(set && set.length === 2)) {
        return false;
      }
      return true;
    },
    firstLineMatches: function(matcher) {
      var exp, sel;
      sel = this.getSelection();
      exp = this.expandSelectionToLines(sel);
      if (exp.text.match(matcher)) {
        return true;
      }
    },
    paragraphMatches: function(matcher) {
      var exp, sel;
      sel = this.getSelection();
      exp = this.expandSelectionToParagraphs(sel);
      if (exp.text.match(matcher)) {
        return true;
      }
    },
    replaceSelection: function(text) {
      var caretIndex, el, sel, value;
      if (text == null) {
        text = '';
      }
      el = this.$focusable.get(0);
      value = el.value;
      sel = this.getSelection();
      el.value = [value.slice(0, sel.start), text, value.slice(sel.end)].join('');
      caretIndex = sel.start + text.length;
      return this.setSelection({
        start: caretIndex,
        end: caretIndex
      });
    },
    replaceSelectedLine: function(line, text) {
      if (text == null) {
        text = '';
      }
      this.setSelection(line);
      return this.replaceSelection(text);
    },
    setAndReplaceSelection: function(beforeSel, text, afterSel, preAdjust, sufAdjust, collapse) {
      if (text == null) {
        text = '';
      }
      this.setSelection(beforeSel);
      this.replaceSelection(text);
      return this.setSelection(afterSel, preAdjust, sufAdjust, collapse);
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
      var fix, pre, sel, suf, val, _ref, _ref1, _ref2;
      if (options == null) {
        options = {};
      }
      _ref = this.getTokenAndSelection(wrapper), fix = _ref[0], sel = _ref[1];
      val = [fix.pre, sel.text || options.text || '', fix.suf].join('');
      if (options.select === 'end') {
        _ref1 = [val.length, null], pre = _ref1[0], suf = _ref1[1];
      } else {
        _ref2 = [0, val.length - sel.length], pre = _ref2[0], suf = _ref2[1];
      }
      return this.setAndReplaceSelection(sel, val, sel, pre, suf, options.select === 'end');
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
  var initialize,
    __slice = [].slice;

  initialize = function() {
    var isIE;
    this.version = '2.0.1 pre alpha';
    this.init = function(options) {
      if (options == null) {
        options = {};
      }
      if (this["interface"]) {
        return;
      }
      this.trigger('configure');
      return this["interface"] = new this[this.config('interface:class')](options);
    };
    this.release = function() {
      if (!this["interface"]) {
        return;
      }
      this.trigger('released');
      this["interface"].release();
      delete this["interface"];
      return this.off();
    };
    this.Module.extend.call(this, this.Config);
    this.configure = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (this.configuration) {
        this.trigger('configure');
        (_ref = this.Config).set.apply(_ref, args);
      }
      return this.one('configure', function() {
        return this.Config.set(args[0], true, args[1]);
      });
    };
    this.focus = function() {
      return this.trigger('focus');
    };
    this.blur = function() {
      return this.trigger('blur');
    };
    this.Module.extend.call(this, this.Events);
    this.Module.extend.call(this, this.I18n);
    this.Module.extend.call(this, this.Logger);
    this.Module.extend.call(this, this.Plugin);
    this.support = {
      webkit: navigator.userAgent.indexOf('WebKit') > 0,
      safari: navigator.userAgent.indexOf('Safari') > 0 && navigator.userAgent.indexOf('Chrome') === -1,
      chrome: navigator.userAgent.indexOf('Chrome') > 0,
      gecko: navigator.userAgent.indexOf('Firefox') > 0,
      trident: navigator.userAgent.indexOf('MSIE') > 0,
      ie10: (isIE = navigator.userAgent.match(/MSIE\s([\d|\.]+)/)) ? parseFloat(isIE[1], 10) >= 10 : false
    };
    return this.support.wysiwyg = document.designMode && (!this.support.trident || this.support.ie10) && (window.rangy && window.rangy.supported);
  };

  initialize.call(this.MockMercury || this.Mercury);

}).call(this);
(function() {
  var Plugin,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('blocks', {
    description: 'Provides interface for selecting common block elements.',
    version: '1.0.0',
    prependButtonAction: 'insert',
    actions: {
      block: 'insert'
    },
    config: {
      blocks: {
        h1: 'Heading 1',
        h2: 'Heading 2',
        h3: 'Heading 3',
        h4: 'Heading 4',
        h5: 'Heading 5',
        h6: 'Heading 6',
        p: 'Paragraph',
        blockquote: 'Blockquote',
        pre: 'Preformatted'
      }
    },
    registerButton: function() {
      return this.button.set({
        type: 'select',
        subview: this.bindTo(new Plugin.Select())
      });
    },
    bindTo: function(view) {
      var _this = this;
      return view.on('block:picked', function(value) {
        return _this.triggerAction(value);
      });
    },
    insert: function(name, value) {
      return Mercury.trigger('action', name, value);
    }
  });

  Plugin.Select = (function(_super) {

    __extends(Select, _super);

    function Select() {
      return Select.__super__.constructor.apply(this, arguments);
    }

    Select.prototype.template = 'blocks';

    Select.prototype.className = 'mercury-blocks-select';

    Select.prototype.events = {
      'click [data-value]': function(e) {
        return this.trigger('block:picked', $(e.target).closest('li').data('value'));
      }
    };

    return Select;

  })(Mercury.ToolbarSelect);

  this.JST || (this.JST = {});

  JST['/mercury/templates/blocks'] = function() {
    var block, text;
    return "<ul>" + (((function() {
      var _ref, _results;
      _ref = Plugin.config('blocks');
      _results = [];
      for (block in _ref) {
        text = _ref[block];
        _results.push("<li data-value='" + block + "'><" + block + ">" + text + "</" + block + "></li>");
      }
      return _results;
    })()).join('')) + "</ul>";
  };

}).call(this);
(function() {
  var Plugin,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('character', {
    description: 'Provides interface for selecting and inserting special characters.',
    version: '1.0.0',
    actions: {
      html: 'insertHtml',
      text: 'insertText'
    },
    config: {
      modal: true,
      characters: '162 8364 163 165 169 174 8482 8240 181 183 8226 8230 8242 8243 167 182 223 8249 8250 171 187 8216 ' + '8217 8220 8221 8218 8222 8804 8805 8211 8212 175 8254 164 166 168 161 191 710 732 176 8722 177 247 ' + '8260 215 185 178 179 188 189 190 402 8747 8721 8734 8730 8764 8773 8776 8800 8801 8712 8713 8715 ' + '8719 8743 8744 172 8745 8746 8706 8704 8707 8709 8711 8727 8733 8736 180 184 170 186 8224 8225 192 ' + '193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 216 338 352 ' + '217 218 219 220 221 376 222 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 ' + '242 243 244 245 246 248 339 353 249 250 251 252 253 254 255 913 914 915 916 917 918 919 920 921 922 ' + '923 924 925 926 927 928 929 931 932 933 934 935 936 937 945 946 947 948 949 950 951 952 953 954 955 ' + '956 957 958 959 960 961 962 963 964 965 966 967 968 969 8501 982 8476 977 978 8472 8465 8592 8593 ' + '8594 8595 8596 8629 8656 8657 8658 8659 8660 8756 8834 8835 8836 8838 8839 8853 8855 8869 8901 8968 ' + '8969 8970 8971 9001 9002 9674 9824 9827 9829 9830 x263F'
    },
    registerButton: function() {
      return this.button.set({
        type: 'character',
        subview: this.bindTo(this.view())
      });
    },
    view: function() {
      if (this.config('modal')) {
        return new Plugin.Modal();
      } else {
        return new Plugin.Palette();
      }
    },
    bindTo: function(view) {
      var _this = this;
      return view.on('character:picked', function(char) {
        return _this.triggerAction(char);
      });
    },
    insertHtml: function(name, value) {
      return Mercury.trigger('action', 'html', "&#" + value + ";");
    },
    insertText: function(name, value) {
      return Mercury.trigger('action', 'text', $("<em>&#" + value + ";</em>").html());
    }
  });

  Plugin.Modal = (function(_super) {

    __extends(Modal, _super);

    function Modal() {
      return Modal.__super__.constructor.apply(this, arguments);
    }

    Modal.prototype.template = 'character';

    Modal.prototype.className = 'mercury-character-modal';

    Modal.prototype.title = 'Character Picker';

    Modal.prototype.hidden = true;

    Modal.prototype.events = {
      'click li': function(e) {
        return this.trigger('character:picked', $(e.target).data('value')) && this.hide();
      }
    };

    return Modal;

  })(Mercury.Modal);

  Plugin.Palette = (function(_super) {

    __extends(Palette, _super);

    function Palette() {
      return Palette.__super__.constructor.apply(this, arguments);
    }

    Palette.prototype.template = 'character';

    Palette.prototype.className = 'mercury-character-palette';

    Palette.prototype.hidden = true;

    Palette.prototype.events = {
      'click li': function(e) {
        return this.trigger('character:picked', $(e.target).data('value'));
      }
    };

    return Palette;

  })(Mercury.ToolbarPalette);

  this.JST || (this.JST = {});

  JST['/mercury/templates/character'] = function() {
    var char;
    return "<ul>" + (((function() {
      var _i, _len, _ref, _results;
      _ref = Plugin.config('characters').split(' ');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        char = _ref[_i];
        _results.push("<li data-value='" + char + "'>&#" + char + ";</li>");
      }
      return _results;
    })()).join('')) + "</ul>";
  };

}).call(this);
(function() {
  var Plugin,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('color', {
    description: 'Provides interface for selecting colors.',
    version: '1.0.0',
    prependButtonAction: 'insert',
    actions: {
      color: 'insert',
      html: 'insert',
      text: 'insert'
    },
    config: {
      colors: 'FFFFFF FFCCCC FFCC99 FFFF99 FFFFCC 99FF99 99FFFF CCFFFF CCCCFF FFCCFF CCCCCC FF6666 FF9966 FFFF66 FFFF33 ' + '66FF99 33FFFF 66FFFF 9999FF FF99FF C0C0C0 FF0000 FF9900 FFCC66 FFFF00 33FF33 66CCCC 33CCFF 6666CC CC66CC ' + '999999 CC0000 FF6600 FFCC33 FFCC00 33CC00 00CCCC 3366FF 6633FF CC33CC 666666 990000 CC6600 CC9933 999900 ' + '009900 339999 3333FF 6600CC 993399 333333 660000 993300 996633 666600 006600 336666 000099 333399 663366 ' + '000000 330000 663300 663333 333300 003300 003333 000066 330099 330033'
    },
    registerButton: function() {
      return this.button.set({
        type: 'color',
        subview: this.bindTo(new Plugin.Palette())
      });
    },
    bindTo: function(view) {
      var _this = this;
      return view.on('color:picked', function(value) {
        _this.triggerAction(value);
        return _this.button.css({
          color: "#" + value
        });
      });
    },
    regionContext: function() {
      var color;
      if (color = this.region.hasContext(this.context, true) || this.region.hasContext('color', true)) {
        return this.button.css({
          color: color
        });
      }
    },
    insert: function(name, value) {
      return Mercury.trigger('action', name, "#" + value);
    }
  });

  Plugin.Palette = (function(_super) {

    __extends(Palette, _super);

    function Palette() {
      return Palette.__super__.constructor.apply(this, arguments);
    }

    Palette.prototype.template = 'color';

    Palette.prototype.className = 'mercury-color-palette';

    Palette.prototype.events = {
      'click li': function(e) {
        var value;
        value = $(e.target).data('value');
        this.$('.last-picked').data({
          value: value
        }).css({
          background: "#" + value
        });
        return this.trigger('color:picked', value);
      }
    };

    return Palette;

  })(Mercury.ToolbarPalette);

  this.JST || (this.JST = {});

  JST['/mercury/templates/color'] = function() {
    var color;
    return "<ul>\n  " + (((function() {
      var _i, _len, _ref, _results;
      _ref = Plugin.config('colors').split(' ');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        color = _ref[_i];
        _results.push("<li data-value='" + color + "' style='background:#" + color + "'></li>");
      }
      return _results;
    })()).join('')) + "\n  <li class=\"last-picked\">Last Color Picked</li>\n</ul>";
  };

}).call(this);
(function() {
  var Plugin,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('history', {
    description: 'Provides interface for selecting saved versions -- requires server implementation.',
    version: '1.0.0',
    registerButton: function() {
      return this.button.set({
        type: 'history',
        toggle: true,
        subview: new Plugin.Panel()
      });
    }
  });

  Plugin.Panel = (function(_super) {

    __extends(Panel, _super);

    function Panel() {
      return Panel.__super__.constructor.apply(this, arguments);
    }

    Panel.prototype.template = 'history';

    Panel.prototype.className = 'mercury-history-dialog';

    Panel.prototype.title = 'Page Version History';

    Panel.prototype.width = 250;

    Panel.prototype.hidden = true;

    return Panel;

  })(Mercury.Panel);

  this.JST || (this.JST = {});

  JST['/mercury/templates/history'] || (JST['/mercury/templates/history'] = function() {
    return "<input type=\"text\" class=\"search-input\"/>\n<p>The History Plugin expects a server implementation.</p>\n<p>Since this is a demo, it wasn't included, but you can check the <a href=\"https://github.com/jejacks0n/mercury-rails\">mercury-rails project</a> on github for examples of how to integrate it with your server technology.</p>";
  });

}).call(this);
(function() {
  var Plugin,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('link', {
    description: 'Provides interface for inserting and editing links.',
    version: '1.0.0',
    actions: {
      link: 'insert'
    },
    events: {
      'mercury:edit:link': 'showDialog',
      'button:click': 'showDialog'
    },
    registerButton: function() {
      return this.button.set({
        type: 'link'
      });
    },
    showDialog: function() {
      return this.bindTo(new Plugin.Modal());
    },
    bindTo: function(view) {
      return view.on('form:submitted', function(value) {
        return console.debug(value);
      });
    },
    insert: function() {}
  });

  Plugin.Modal = (function(_super) {

    __extends(Modal, _super);

    function Modal() {
      return Modal.__super__.constructor.apply(this, arguments);
    }

    Modal.prototype.template = 'link';

    Modal.prototype.className = 'mercury-link-dialog';

    Modal.prototype.title = 'Link Manager';

    Modal.prototype.width = 600;

    Modal.prototype.elements = {
      text: '#link_text',
      target: '#link_target'
    };

    Modal.prototype.events = {
      'change .control-label input': 'onLabelChecked',
      'focus .controls [name]': 'onInputFocused',
      'change #link_target': 'onChangeTarget'
    };

    Modal.prototype.onLabelChecked = function(e) {
      var $el, inputId;
      $el = $(e.target);
      inputId = $el.closest('.control-label').attr('for');
      return $el.closest('.control-group').find("#" + inputId).focus();
    };

    Modal.prototype.onInputFocused = function(e) {
      var $el;
      $el = $(e.target);
      return $el.closest('.control-group').find('input[type=radio]').prop('checked', true);
    };

    Modal.prototype.onChangeTarget = function(e) {
      var $el;
      $el = $(e.target);
      this.$('.link-target-options').hide();
      this.$("#" + ($el.val()) + "_options").show();
      return this.resize(false);
    };

    Modal.prototype.validate = function() {
      var $el;
      Modal.__super__.validate.apply(this, arguments);
      $el = this.$("#link_" + (this.$('input[name=link_type]:checked').val()));
      if (!$el.val()) {
        this.addInputError($el, this.t("can't be blank"));
      }
      if (this.$text.is(':visible') && !this.$text.val().trim()) {
        this.addInputError(this.$text, this.t("can't be blank"));
      }
      return this.resize(false);
    };

    Modal.prototype.onSubmit = function() {
      var args, attrs, content, target, type;
      this.validate();
      content = this.$text.val();
      target = this.$target.val();
      type = this.$('input[name=link_type]:checked').val();
      switch (type) {
        case 'existing_bookmark':
          attrs = {
            href: "#" + (this.$('#link_existing_bookmark').val())
          };
          break;
        case 'new_bookmark':
          attrs = {
            name: "" + (this.$('#link_new_bookmark').val())
          };
          break;
        default:
          attrs = {
            href: this.$("#link_" + type).val()
          };
      }
      switch (target) {
        case 'popup':
          args = {
            width: parseInt(this.$('#link_popup_width').val(), 10) || 500,
            height: parseInt(this.$('#link_popup_height').val(), 10) || 500,
            menubar: 'no',
            toolbar: 'no'
          };
          attrs['href'] = "javascript:void(window.open('" + attrs['href'] + "','popup_window','" + (Object.toParams(args).replace(/&/g, ',')) + "'))";
          break;
        default:
          if (target) {
            attrs['target'] = target;
          }
      }
      attrs['content'] = this.content || content;
      this.trigger('form:submitted', attrs);
      return this.hide();
    };

    return Modal;

  })(Mercury.Modal);

  this.JST || (this.JST = {});

  JST['/mercury/templates/link'] || (JST['/mercury/templates/link'] = function() {
    return "<form class=\"form-horizontal\">\n\n  <fieldset class=\"link_text_container\">\n    <div class=\"control-group string required\">\n      <label class=\"string required control-label\" for=\"link_text\">Link Content</label>\n      <div class=\"controls\">\n        <input class=\"string required\" id=\"link_text\" name=\"link[text]\" size=\"50\" type=\"text\" tabindex=\"1\">\n      </div>\n    </div>\n  </fieldset>\n\n  <fieldset>\n    <legend>Standard Links</legend>\n    <div class=\"control-group url optional\">\n      <label class=\"url optional control-label\" for=\"link_external_url\">\n        <input name=\"link_type\" type=\"radio\" value=\"external_url\" checked=\"checked\" tabindex=\"-1\"/>URL\n      </label>\n      <div class=\"controls\">\n        <input class=\"string url optional\" id=\"link_external_url\" name=\"link[external_url]\" size=\"50\" type=\"text\" tabindex=\"1\">\n      </div>\n    </div>\n  </fieldset>\n\n  <fieldset>\n    <legend>Index / Bookmark Links</legend>\n    <div class=\"control-group select optional\">\n      <label class=\"select optional control-label\" for=\"link_existing_bookmark\">\n        <input name=\"link_type\" type=\"radio\" value=\"existing_bookmark\" tabindex=\"-1\"/>Existing Links\n      </label>\n      <div class=\"controls\">\n        <select class=\"select optional\" id=\"link_existing_bookmark\" name=\"link[existing_bookmark]\" tabindex=\"1\"></select>\n      </div>\n    </div>\n    <div class=\"control-group string optional\">\n      <label class=\"string optional control-label\" for=\"link_new_bookmark\">\n        <input name=\"link_type\" type=\"radio\" value=\"new_bookmark\" tabindex=\"-1\"/>Bookmark\n      </label>\n      <div class=\"controls\">\n        <input class=\"string optional\" id=\"link_new_bookmark\" name=\"link[new_bookmark]\" type=\"text\" tabindex=\"1\">\n      </div>\n    </div>\n  </fieldset>\n\n  <fieldset>\n    <legend>Options</legend>\n    <div class=\"control-group select optional\">\n      <label class=\"select optional control-label\" for=\"link_target\">Link Target</label>\n      <div class=\"controls\">\n        <select class=\"select optional\" id=\"link_target\" name=\"link[target]\" tabindex=\"1\">\n          <option value=\"\">Self (the same window or tab)</option>\n          <option value=\"_blank\">Blank (a new window or tab)</option>\n          <option value=\"_top\">Top (removes any frames)</option>\n          <option value=\"popup\">Popup Window (javascript new window popup)</option>\n        </select>\n      </div>\n    </div>\n    <div id=\"popup_options\" class=\"link-target-options\" style=\"display:none\">\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"link_popup_width\">Popup Width</label>\n        <div class=\"controls\">\n          <input class=\"span2 number optional\" id=\"link_popup_width\" name=\"link[popup_width]\" type=\"number\" value=\"960\" tabindex=\"1\">\n        </div>\n      </div>\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"link_popup_height\">Popup Height</label>\n        <div class=\"controls\">\n          <input class=\"span2 number optional\" id=\"link_popup_height\" name=\"link[popup_height]\" type=\"number\" value=\"800\" tabindex=\"1\">\n        </div>\n      </div>\n    </div>\n  </fieldset>\n\n  <div class=\"form-actions\">\n    <input class=\"btn btn-primary\" name=\"commit\" type=\"submit\" value=\"Insert Link\" tabindex=\"2\">\n  </div>\n</form>";
  });

}).call(this);
(function() {
  var Plugin,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('media', {
    description: 'Provides interface for inserting and editing media.',
    version: '1.0.0',
    actions: {
      image: 'insertImage',
      html: 'insertHtml'
    },
    events: {
      'mercury:edit:media': 'showDialog',
      'button:click': 'showDialog'
    },
    registerButton: function() {
      return this.button.set({
        type: 'media'
      });
    },
    showDialog: function() {
      return this.bindTo(new Plugin.Modal());
    },
    bindTo: function(view) {
      var _this = this;
      return view.on('form:submitted', function(value) {
        return _this.triggerAction(value);
      });
    },
    insertImage: function(name, value) {
      if (value.type !== 'image') {
        return this.insertHtml(name, value);
      }
      return Mercury.trigger('action', name, value);
    },
    insertHtml: function(name, value) {
      if (value.type === 'image') {
        value = "<img src=\"" + value.src + "\"/>";
      } else {
        value = "<iframe src=\"" + value.src + "\" width=\"" + value.width + "\" height=\"" + value.height + "\" frameborder=\"0\" allowFullScreen></iframe>";
      }
      return Mercury.trigger('action', 'html', value);
    }
  });

  Plugin.Modal = (function(_super) {

    __extends(Modal, _super);

    function Modal() {
      return Modal.__super__.constructor.apply(this, arguments);
    }

    Modal.prototype.template = 'media';

    Modal.prototype.className = 'mercury-media-dialog';

    Modal.prototype.title = 'Media Manager';

    Modal.prototype.width = 600;

    Modal.prototype.events = {
      'change .control-label input': 'onLabelChecked',
      'focus .controls [name]': 'onInputFocused'
    };

    Modal.prototype.onLabelChecked = function(e) {
      var $el, inputId;
      $el = $(e.target);
      inputId = $el.closest('.control-label').attr('for');
      return $el.closest('.control-group').find("#" + inputId).focus();
    };

    Modal.prototype.onInputFocused = function(e) {
      var $el;
      $el = $(e.target);
      $el.closest('.control-group').find('input[type=radio]').prop('checked', true);
      if ($el.closest('.media-options').length) {
        return;
      }
      this.$('.media-options').hide();
      this.$("#" + ($el.attr('id').replace('media_', '')) + "_options").show();
      return this.resize(true);
    };

    Modal.prototype.validate = function() {
      var $el, type;
      Modal.__super__.validate.apply(this, arguments);
      type = this.$('input[name=media_type]:checked').val();
      $el = this.$("#media_" + type);
      if ($el.val()) {
        switch (type) {
          case 'youtube_url':
            if (!/^https?:\/\/youtu.be\//.test($el.val())) {
              this.addInputError($el, "is invalid");
            }
            break;
          case 'vimeo_url':
            if (!/^https?:\/\/youtu.be\//.test($el.val())) {
              this.addInputError($el, "is invalid");
            }
        }
      } else {
        this.addInputError($el, "can't be blank");
      }
      return this.resize(false);
    };

    Modal.prototype.onSubmit = function() {
      var $el, attrs, type, url;
      this.validate();
      type = this.$('input[name=media_type]:checked').val();
      $el = this.$("#media_" + type);
      url = $el.val();
      switch (type) {
        case 'youtube_url':
          attrs = {
            type: 'youtube',
            protocol: /^https:/.test(url) ? 'https' : 'http',
            width: parseInt(this.$('#media_youtube_width').val(), 10) || 560,
            height: parseInt(this.$('#media_youtube_height').val(), 10) || 349,
            share: url,
            code: url.replace(/^https?:\/\/youtu.be\//, '')
          };
          attrs.src = "" + attrs.protocol + "://www.youtube-nocookie.com/embed/" + attrs.code + "?rel=0&wmode=transparent";
          break;
        case 'vimeo_url':
          attrs = {
            type: 'vimeo',
            protocol: /^https:/.test(url) ? 'https' : 'http',
            width: parseInt(this.$('#media_vimeo_width').val(), 10) || 400,
            height: parseInt(this.$('#media_vimeo_height').val(), 10) || 225,
            share: url,
            code: url.replace(/^https?:\/\/vimeo.com\//, '')
          };
          attrs.src = "" + attrs.protocol + "://player.vimeo.com/video/" + attrs.code + "?title=1&byline=1&portrait=0&color=ffffff";
          break;
        default:
          attrs = {
            type: 'image',
            protocol: /^https:/.test(url) ? 'https' : 'http',
            src: url,
            url: url,
            align: this.$('#media_image_alignment').val(),
            float: this.$('#media_image_float').val()
          };
      }
      this.trigger('form:submitted', attrs);
      return this.hide();
    };

    return Modal;

  })(Mercury.Modal);

  this.JST || (this.JST = {});

  JST['/mercury/templates/media'] || (JST['/mercury/templates/media'] = function() {
    return "<form class=\"form-horizontal\">\n\n  <fieldset>\n    <legend>Images</legend>\n    <div class=\"control-group url optional\">\n      <label class=\"url optional control-label\" for=\"media_image_url\">\n        <input name=\"media_type\" type=\"radio\" value=\"image_url\" checked=\"checked\" tabindex=\"-1\"/>URL\n      </label>\n      <div class=\"controls\">\n        <input class=\"span6 string url optional\" id=\"media_image_url\" name=\"media[image_url]\" size=\"50\" type=\"text\" tabindex=\"1\">\n      </div>\n    </div>\n  </fieldset>\n\n  <fieldset>\n    <legend>Videos</legend>\n    <div class=\"control-group url optional\">\n      <label class=\"url optional control-label\" for=\"media_youtube_url\">\n        <input name=\"media_type\" type=\"radio\" value=\"youtube_url\" tabindex=\"-1\"/>YouTube URL\n      </label>\n      <div class=\"controls\">\n        <input class=\"span6 string url optional\" id=\"media_youtube_url\" name=\"media[youtube_url]\" size=\"50\" type=\"text\" placeholder=\"http://youtu.be/28tZ-S1LFok\" tabindex=\"1\">\n      </div>\n    </div>\n    <div class=\"control-group url optional\">\n      <label class=\"url optional control-label\" for=\"media_vimeo_url\">\n        <input name=\"media_type\" type=\"radio\" value=\"vimeo_url\" tabindex=\"-1\"/>Vimeo URL\n      </label>\n      <div class=\"controls\">\n        <input class=\"span6 string url optional\" id=\"media_vimeo_url\" name=\"media[vimeo_url]\" size=\"50\" type=\"text\" placeholder=\"http://vimeo.com/36684976\" tabindex=\"1\">\n      </div>\n    </div>\n  </fieldset>\n\n  <fieldset>\n    <legend>Options</legend>\n\n    <div class=\"media-options\" id=\"image_url_options\">\n      <div class=\"control-group select optional\">\n        <label class=\"select optional control-label\" for=\"media_image_alignment\">Alignment</label>\n        <div class=\"controls\">\n          <select class=\"select optional\" id=\"media_image_alignment\" name=\"media[image_alignment]\" tabindex=\"1\">\n            <option value=\"\">None</option>\n            <option value=\"left\">Left</option>\n            <option value=\"right\">Right</option>\n            <option value=\"top\">Top</option>\n            <option value=\"middle\">Middle</option>\n            <option value=\"bottom\">Bottom</option>\n            <option value=\"absmiddle\">Absolute Middle</option>\n            <option value=\"absbottom\">Absolute Bottom</option>\n          </select>\n        </div>\n      </div>\n      <div class=\"control-group select optional\">\n        <label class=\"select optional control-label\" for=\"media_image_float\">Float</label>\n        <div class=\"controls\">\n          <select class=\"select optional\" id=\"media_image_float\" name=\"media[image_float]\" tabindex=\"1\">\n            <option value=\"\">None</option>\n            <option value=\"left\">Left</option>\n            <option value=\"right\">Right</option>\n            <option value=\"none\">None</option>\n            <option value=\"inherit\">Inherit</option>\n          </select>\n        </div>\n      </div>\n    </div>\n\n    <div class=\"media-options\" id=\"youtube_url_options\" style=\"display:none\">\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"media_youtube_width\">Width</label>\n        <div class=\"controls\">\n          <input class=\"span2 number optional\" id=\"media_youtube_width\" name=\"media[youtube_width]\" size=\"50\" type=\"number\" value=\"560\" tabindex=\"1\">\n        </div>\n      </div>\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"media_youtube_height\">Height</label>\n        <div class=\"controls\">\n          <input class=\"span2 number optional\" id=\"media_youtube_height\" name=\"media[youtube_height]\" size=\"50\" type=\"number\" value=\"349\" tabindex=\"1\">\n        </div>\n      </div>\n    </div>\n\n    <div class=\"media-options\" id=\"vimeo_url_options\" style=\"display:none\">\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"media_vimeo_width\">Width</label>\n        <div class=\"controls\">\n          <input class=\"span2 number optional\" id=\"media_vimeo_width\" name=\"media[vimeo_width]\" size=\"50\" type=\"number\" value=\"400\" tabindex=\"1\">\n        </div>\n      </div>\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"media_vimeo_height\">Height</label>\n        <div class=\"controls\">\n          <input class=\"span2 number optional\" id=\"media_vimeo_height\" name=\"media[vimeo_height]\" size=\"50\" type=\"number\" value=\"225\" tabindex=\"1\">\n        </div>\n      </div>\n    </div>\n  </fieldset>\n\n  <div class=\"form-actions\">\n    <input class=\"btn btn-primary\" name=\"commit\" type=\"submit\" value=\"Insert Media\" tabindex=\"2\"/>\n  </div>\n</form>";
  });

}).call(this);
(function() {
  var Plugin,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('notes', {
    description: 'Provides interface for reading and adding notes for the page -- requires server implementation.',
    version: '1.0.0',
    registerButton: function() {
      return this.button.set({
        type: 'toggle',
        toggle: true,
        subview: new Plugin.Panel()
      });
    }
  });

  Plugin.Panel = (function(_super) {

    __extends(Panel, _super);

    function Panel() {
      return Panel.__super__.constructor.apply(this, arguments);
    }

    Panel.prototype.template = 'notes';

    Panel.prototype.className = 'mercury-notes-dialog';

    Panel.prototype.title = 'Page Notes';

    Panel.prototype.width = 250;

    Panel.prototype.hidden = true;

    return Panel;

  })(Mercury.Panel);

  this.JST || (this.JST = {});

  JST['/mercury/templates/notes'] = function() {
    return "<p>The Notes Plugin expects a server implementation.</p>\n<p>Since this is a demo, it wasn't included, but you can check the <a href=\"https://github.com/jejacks0n/mercury-rails\">mercury-rails project</a> on github for examples of how to integrate it with your server technology.</p>";
  };

}).call(this);
(function() {
  var Plugin,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('styles', {
    description: 'Provides interface for selecting predefined styles / classes.',
    version: '1.0.0',
    prependButtonAction: 'insert',
    actions: {
      style: 'insert',
      text: 'insert'
    },
    config: {
      styles: {
        red: 'Red Text',
        blue: 'Blue Text',
        highlight: 'Highlighted'
      }
    },
    registerButton: function() {
      return this.button.set({
        type: 'select',
        subview: this.bindTo(new Plugin.Select())
      });
    },
    bindTo: function(view) {
      var _this = this;
      return view.on('style:picked', function(value) {
        return _this.triggerAction(value);
      });
    },
    insert: function(name, value) {
      return Mercury.trigger('action', name, "" + value);
    }
  });

  Plugin.Select = (function(_super) {

    __extends(Select, _super);

    function Select() {
      return Select.__super__.constructor.apply(this, arguments);
    }

    Select.prototype.template = 'styles';

    Select.prototype.className = 'mercury-styles-dialog';

    Select.prototype.events = {
      'click li': function(e) {
        return this.trigger('style:picked', $(e.target).data('value'));
      }
    };

    return Select;

  })(Mercury.ToolbarSelect);

  this.JST || (this.JST = {});

  JST['/mercury/templates/styles'] = function() {
    var style, text;
    return "<ul>" + (((function() {
      var _ref, _results;
      _ref = Plugin.config('styles');
      _results = [];
      for (style in _ref) {
        text = _ref[style];
        _results.push("<li data-value='" + style + "' class='" + style + "'>" + text + "</li>");
      }
      return _results;
    })()).join('')) + "</ul>";
  };

}).call(this);
(function() {
  var Plugin,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('table', {
    description: 'Provides interface for inserting and editing tables.',
    version: '1.0.0',
    actions: {
      link: 'insert'
    },
    events: {
      'mercury:edit:table': 'showDialog',
      'button:click': 'showDialog'
    },
    registerButton: function() {
      return this.button.set({
        type: 'table'
      });
    },
    showDialog: function() {
      return this.bindTo(new Plugin.Modal());
    },
    bindTo: function(view) {
      return view.on('form:submitted', function(value) {
        return console.debug(value);
      });
    },
    insert: function() {}
  });

  Plugin.Modal = (function(_super) {

    __extends(Modal, _super);

    function Modal() {
      return Modal.__super__.constructor.apply(this, arguments);
    }

    Modal.prototype.template = 'table';

    Modal.prototype.className = 'mercury-table-dialog';

    Modal.prototype.title = 'Table Manager';

    Modal.prototype.width = 600;

    return Modal;

  })(Mercury.Modal);

  this.JST || (this.JST = {});

  JST['/mercury/templates/table'] || (JST['/mercury/templates/table'] = function() {
    return "<form class=\"form-horizontal\">\n  <div class=\"form-inputs\">\n\n    <fieldset id=\"table_display\">\n      <div class=\"control-group optional\">\n        <div class=\"controls\">\n          <table border=\"1\" cellspacing=\"0\">\n            <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>\n            <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>\n            <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>\n          </table>\n        </div>\n      </div>\n    </fieldset>\n\n    <fieldset>\n      <div class=\"control-group buttons optional\">\n        <label class=\"buttons optional control-label\">Rows</label>\n        <div class=\"controls btn-group\">\n          <button class=\"btn\" data-action=\"addRowBefore\">Add Before</button>\n          <button class=\"btn\" data-action=\"addRowAfter\">Add After</button>\n          <button class=\"btn\" data-action=\"removeRow\">Remove</button>\n        </div>\n      </div>\n      <div class=\"control-group buttons optional\">\n        <label class=\"buttons optional control-label\">Columns</label>\n        <div class=\"controls btn-group\">\n          <button class=\"btn\" data-action=\"addColumnBefore\">Add Before</button>\n          <button class=\"btn\" data-action=\"addColumnAfter\">Add After</button>\n          <button class=\"btn\" data-action=\"removeColumn\">Remove</button>\n        </div>\n      </div>\n\n      <hr/>\n\n      <div class=\"control-group buttons optional\">\n        <label class=\"buttons optional control-label\">Row Span</label>\n        <div class=\"controls btn-group\">\n          <button class=\"btn\" data-action=\"increaseRowspan\">+</button>\n          <button class=\"btn\" data-action=\"decreaseRowspan\">-</button>\n        </div>\n      </div>\n      <div class=\"control-group buttons optional\">\n        <label class=\"buttons optional control-label\">Column Span</label>\n        <div class=\"controls btn-group\">\n          <button class=\"btn\" data-action=\"increaseColspan\">+</button>\n          <button class=\"btn\" data-action=\"decreaseColspan\">-</button>\n        </div>\n      </div>\n    </fieldset>\n\n    <fieldset>\n      <legend>Options</legend>\n      <div class=\"control-group select optional\">\n        <label class=\"select optional control-label\" for=\"table_alignment\">Alignment</label>\n        <div class=\"controls\">\n          <select class=\"select optional\" id=\"table_alignment\" name=\"table[alignment]\">\n            <option value=\"\">None</option>\n            <option value=\"right\">Right</option>\n            <option value=\"left\">Left</option>\n          </select>\n        </div>\n      </div>\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"table_border\">Border</label>\n        <div class=\"controls\">\n          <input class=\"span1 number optional\" id=\"table_border\" name=\"table[border]\" size=\"50\" type=\"number\" value=\"1\">\n        </div>\n      </div>\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"table_spacing\">Spacing</label>\n        <div class=\"controls\">\n          <input class=\"span1 number optional\" id=\"table_spacing\" name=\"table[spacing]\" size=\"50\" type=\"number\" value=\"0\">\n        </div>\n      </div>\n    </fieldset>\n\n  </div>\n  <div class=\"form-actions\">\n    <input class=\"btn btn-primary\" name=\"commit\" type=\"submit\" value=\"Insert Table\"/>\n  </div>\n</form>";
  });

}).call(this);
