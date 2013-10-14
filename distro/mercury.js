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
      enabled: false,
      preferred: 'swedish_chef-BORK'
    },
    uploading: {
      enabled: true,
      saveUrl: '/mercury/uploads',
      saveName: 'file',
      mimeTypes: ['image/jpeg', 'image/gif', 'image/png'],
      maxSize: 5242880
    },
    saving: {
      enabled: true,
      url: '/mercury/save',
      method: 'POST',
      contentType: 'application/json'
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
      maskable: false,
      style: false,
      floating: false,
      floatWidth: false,
      floatDrag: true,
      nohijack: ['mercury-ignored']
    },
    toolbars: {
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
          'Snippets', {
            title: 'Snippet Panel',
            plugin: 'snippets'
          }
        ],
        sep3: ' ',
        history: [
          'History', {
            title: 'Page Version History',
            plugin: 'history'
          }
        ],
        notes: [
          'Notes', {
            title: 'Page Notes',
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
        allowActs: true,
        pasting: true,
        newlines: false
      },
      text: {
        autoSize: true,
        wrapping: true
      }
    }
  };

}).call(this);
(function() {
  this.JST || (this.JST = {});

  this.Mercury || (this.Mercury = {});

}).call(this);
(function() {
  JST['/mercury/templates/lightview'] = function() {
    return "<div class=\"mercury-lightview-overlay\"></div>\n<div class=\"mercury-lightview-dialog\">\n  <div class=\"mercury-lightview-dialog-positioner\">\n    <div class=\"mercury-lightview-dialog-title\"><em>&times;</em><span></span></div>\n    <div class=\"mercury-lightview-loading-indicator\"></div>\n    <div class=\"mercury-lightview-dialog-content-container\">\n      <div class=\"mercury-lightview-dialog-content\">\n      </div>\n    </div>\n  </div>\n</div>";
  };

}).call(this);
(function() {
  JST['/mercury/templates/modal'] = function() {
    return "<div class=\"mercury-modal-overlay\"></div>\n<div class=\"mercury-modal-dialog\">\n  <div class=\"mercury-modal-dialog-positioner\">\n    <div class=\"mercury-modal-dialog-title\"><em>&times;</em><span></span></div>\n    <div class=\"mercury-modal-loading-indicator\"></div>\n    <div class=\"mercury-modal-dialog-content-container\">\n      <div class=\"mercury-modal-dialog-content\">\n      </div>\n    </div>\n  </div>\n</div>";
  };

}).call(this);
(function() {
  JST['/mercury/templates/panel'] = function() {
    return "<div class=\"mercury-panel-title\"><em>&times;</em><span>Test Panel</span></div>\n<div class=\"mercury-panel-loading-indicator\"></div>\n  <div class=\"mercury-panel-content-container\">\n    <div class=\"mercury-panel-content\">\n      content\n    </div>\n  </div>\n</div>";
  };

}).call(this);
(function() {
  JST['/mercury/templates/statusbar'] = function() {
    return "<div class=\"mercury-statusbar-about\">\n  <a href=\"https://github.com/jejacks0n/mercury\" target=\"_blank\">Mercury Editor v" + Mercury.version + "</a>\n</div>\n<div class=\"mercury-statusbar-path\"></div>";
  };

}).call(this);
(function() {
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

  Object.serialize = function(obj, arr, prefix) {
    var key, thisPrefix, type, v, val, _i, _len;
    if (arr == null) {
      arr = [];
    }
    if (Object.prototype.toString.call(obj) !== '[object Object]') {
      arr.push({
        name: prefix,
        value: obj
      });
      return arr;
    }
    for (key in obj) {
      if (!__hasProp.call(obj, key)) continue;
      val = obj[key];
      thisPrefix = prefix ? "" + prefix + "[" + key + "]" : key;
      type = Object.prototype.toString.call(val);
      if (type === '[object Object]') {
        Object.serialize(val, arr, thisPrefix);
      } else if (type === '[object Array]') {
        for (_i = 0, _len = val.length; _i < _len; _i++) {
          v = val[_i];
          Object.serialize(v, arr, "" + thisPrefix + "[]");
        }
      } else {
        arr.push({
          name: thisPrefix,
          value: val
        });
      }
    }
    return arr;
  };

  Object.deserialize = function(arr, obj) {
    var cap, i, item, lookup, named, _i, _len;
    if (obj == null) {
      obj = {};
    }
    lookup = obj;
    for (_i = 0, _len = arr.length; _i < _len; _i++) {
      item = arr[_i];
      named = item.name.replace(/\[([^\]]+)?\]/g, ",$1").split(",");
      cap = named.length - 1;
      i = 0;
      while (i < cap) {
        if (lookup.push) {
          if (!lookup[lookup.length - 1] || lookup[lookup.length - 1].constructor !== Object || lookup[lookup.length - 1][named[i + 1]] !== void 0) {
            lookup.push({});
          }
          lookup = lookup[lookup.length - 1];
        } else {
          lookup = lookup[named[i]] = lookup[named[i]] || (named[i + 1] === "" ? [] : {});
        }
        i++;
      }
      if (lookup.push) {
        lookup.push(item.value);
      } else {
        lookup[named[cap]] = item.value;
      }
      lookup = obj;
    }
    return obj;
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

  String.prototype.htmlReduce = function() {
    return this.replace(/\n|\s\s+/g, '');
  };

}).call(this);
(function() {
  Mercury.TableEditor = (function() {
    function TableEditor(table, cellContent) {
      this.table = table;
      this.cellContent = cellContent != null ? cellContent : '';
      if (this.table) {
        this.load(this.table);
      }
    }

    TableEditor.prototype.load = function(table, cellContent) {
      this.table = table;
      if (cellContent) {
        this.cellContent = cellContent;
      }
      this.setCell();
      this.row = this.cell.parent('tr');
      this.columnCount = this.getColumnCount();
      return this.rowCount = this.getRowCount();
    };

    TableEditor.prototype.setCell = function(cell) {
      this.cell = cell != null ? cell : null;
      this.table.find('.selected').removeAttr('class');
      if (this.cell) {
        this.cell = this.cell.closest('td, th');
      }
      this.cell || (this.cell = this.table.find('th, td').first());
      return this.cell.addClass('selected');
    };

    TableEditor.prototype.asHtml = function(cellContent) {
      var table;
      if (cellContent == null) {
        cellContent = '';
      }
      table = this.table.clone();
      table.find('.selected').removeAttr('class');
      table.find('td, th').html(cellContent);
      return $('<div>').html(table).html().replace(/^\s+|\n/gm, '').replace(/(<\/.*?>|<table.*?>|<tbody>|<tr>)/g, '$1\n');
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
      var possible, _ref, _ref1;
      if (this.__detected__) {
        return this.__detected__;
      }
      possible = (this.clientLocale() || ((_ref = Mercury.configuration.localization) != null ? _ref.preferred : void 0)).split('-');
      if (!this.__locales__[possible[0]]) {
        possible = (((_ref1 = Mercury.configuration.localization) != null ? _ref1.preferred : void 0) || 'en-US').split('-');
      }
      return this.__detected__ = possible;
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
        } catch (_error) {}
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

    Module.extend = function(object, apply) {
      var method, module, name, _ref;
      if (apply == null) {
        apply = 'extended';
      }
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
      return (_ref = module[apply]) != null ? _ref.apply(this) : void 0;
    };

    Module.include = function(object, apply) {
      var method, module, name, _ref;
      if (apply == null) {
        apply = 'included';
      }
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
      return (_ref = module[apply]) != null ? _ref.apply(this.prototype) : void 0;
    };

    Module.mixin = function(object) {
      if (object.klass) {
        this.extend(object.klass);
        delete object.klass;
      }
      return this.include(object);
    };

    Module.proxy = function(callback) {
      var _this = this;
      return function() {
        return callback.apply(_this, arguments);
      };
    };

    function Module() {
      var mixin, _i, _len, _ref;
      this.__handlers__ = $.extend(true, {}, this.__handlers__);
      _ref = (this.mixins || []).concat(this.constructor.mixins || []);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        mixin = _ref[_i];
        Mercury.Module.extend.call(this, mixin, 'included');
      }
      if (typeof this.init === "function") {
        this.init.apply(this, arguments);
      }
      if (typeof this.trigger === "function") {
        this.trigger('init');
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

    Action.prototype.set = function(key, value) {
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
        _results.push(this.attributes[key] = value);
      }
      return _results;
    };

    return Action;

  })(Mercury.Module);

}).call(this);
(function() {
  var __slice = [].slice;

  (this.Mercury || (this.Mercury = {})).Config = {
    get: function(path) {
      var config, e, part, _i, _len, _ref;
      config = Mercury.configuration || (Mercury.configuration = {});
      try {
        if (path) {
          _ref = path.split(':');
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            part = _ref[_i];
            config = config[part];
          }
        }
      } catch (_error) {
        e = _error;
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
    },
    clearStack: function() {
      this.stackPosition = 0;
      return this.stack = [];
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
      var e;
      try {
        return this.find(id);
      } catch (_error) {
        e = _error;
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
      var _base;
      if (attrs == null) {
        attrs = {};
      }
      this.attributes = {};
      this.errors = {};
      this.set(attrs);
      this.cid || (this.cid = this.constructor.uid('c'));
      (_base = this.constructor).records || (_base.records = {});
      this.constructor.records[this.cid] = this;
      Model.__super__.constructor.apply(this, arguments);
    }

    Model.prototype.url = function() {
      return this.constructor.url(this);
    };

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
        url: this.url(),
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        cache: false,
        data: this.toJSON(),
        success: function(json) {
          if (typeof json === 'object') {
            _this.id = json.id;
            if (_this.id) {
              _this.constructor.records[_this.id] = _this;
            }
            _this.set(json);
            _this.trigger('save', json);
          }
          return typeof _this.saveSuccess === "function" ? _this.saveSuccess(json) : void 0;
        },
        error: function(xhr) {
          _this.trigger('error', xhr, options);
          _this.notify(_this.t('Unable to process response: %s', xhr.status));
          return typeof _this.saveError === "function" ? _this.saveError.apply(_this, arguments) : void 0;
        }
      };
      options = $.extend(defaultOptions, options);
      if (options.dataType && typeof options.data !== 'string') {
        options.data = JSON.stringify(options.data);
      }
      return $.ajax(options);
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

    Plugin.include(Mercury.Config);

    Plugin.include(Mercury.Events);

    Plugin.include(Mercury.I18n);

    Plugin.include(Mercury.Logger);

    Plugin.logPrefix = 'Mercury.Plugin:';

    Plugin.events = {
      'mercury:region:focus': 'onRegionFocus'
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
      var _this = this;
      this.button = button;
      this.configuration = $.extend({}, this.configuration, this.button.get('settings'));
      this.button.on('click', function() {
        return _this.onButtonClick();
      });
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
      var config, e, part, _i, _len, _ref;
      config = this.configuration || (this.configuration = {});
      try {
        _ref = path.split(':');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          part = _ref[_i];
          config = config[part];
        }
      } catch (_error) {
        e = _error;
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
      this.name = this.options.name;
      if (!this.name) {
        throw new Error('must provide a name for plugins');
      }
      this.configuration = this.options.config;
      this.description = this.options.description;
      this.version = this.options.version;
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
      var config, e, part, _i, _len, _ref;
      config = this.configuration || (this.configuration = {});
      try {
        _ref = path.split(':');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          part = _ref[_i];
          config = config[part];
        }
      } catch (_error) {
        e = _error;
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
      this.subviews || (this.subviews = []);
      this.refreshElements();
      if (typeof this.build === "function") {
        this.build();
      }
      this.trigger('build');
      this.delegateEvents(this.events);
      this.refreshElements();
      View.__super__.constructor.apply(this, arguments);
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
      this.localize(this.$el);
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

    View.prototype.appendView = function(elOrView, view) {
      if (view == null) {
        view = null;
      }
      if (arguments.length === 1) {
        view = elOrView;
        elOrView = this.$el;
      }
      if (typeof elOrView === 'string') {
        elOrView = this.$(elOrView);
      }
      if (view.appendTo) {
        if (typeof view.appendTo === "function") {
          view.appendTo(elOrView);
        }
      } else {
        elOrView.append(view.$el || view.el);
      }
      this.subviews.push(view);
      return view;
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
      if (typeof path === 'function') {
        template = path;
      } else {
        template = JST["/mercury/templates/" + path];
        if (this.config('templates:enabled') && !template) {
          template = this.fetchTemplate(path);
        }
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

    View.prototype.localize = function($el) {
      var attrs, el, t, type, _i, _len, _ref, _results;
      _ref = $el.find('*').contents();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        el = _ref[_i];
        attrs = el.attributes;
        if (typeof el.data === 'string' && (t = this.translationForContent(el.data))) {
          el.data = t;
        }
        switch (el.nodeName) {
          case 'IMG':
            if (t = this.translationForAttr(attrs['src'])) {
              _results.push($(el).attr('src', t));
            } else {
              _results.push(void 0);
            }
            break;
          case 'A':
            if (t = this.translationForAttr(attrs['href'])) {
              _results.push($(el).attr('href', t));
            } else {
              _results.push(void 0);
            }
            break;
          case 'INPUT':
            type = attrs['type'].nodeValue.toLowerCase();
            if (attrs['value'] && (type === 'button' || type === 'reset' || type === 'submit')) {
              if (t = this.translationForAttr(attrs['value'])) {
                _results.push($(el).attr('value', t));
              } else {
                _results.push(void 0);
              }
            } else {
              _results.push(void 0);
            }
            break;
        }
      }
      return _results;
    };

    View.prototype.translationForAttr = function(attr) {
      if (!(attr && attr.nodeValue)) {
        return false;
      }
      return this.translationForContent(attr.nodeValue);
    };

    View.prototype.translationForContent = function(content) {
      var original, translated;
      original = $.trim(content);
      if (!original) {
        return false;
      }
      translated = this.t(original);
      if (translated === original) {
        return false;
      } else {
        return translated;
      }
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

    View.prototype.preventStop = function(e) {
      return this.prevent(e, true);
    };

    View.prototype.release = function() {
      var method, name, _ref;
      this.trigger('release');
      this.releaseSubviews();
      this.$el.remove();
      _ref = this.__global_handlers__ || {};
      for (name in _ref) {
        method = _ref[name];
        Mercury.off(name, method);
      }
      return this.off();
    };

    View.prototype.releaseSubviews = function() {
      var view, _i, _len, _ref;
      _ref = this.subviews || [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        view = _ref[_i];
        view.release();
      }
      return this.subviews = [];
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
  Mercury.View.Modules.FormHandler = {
    included: function() {
      return this.on('build', this.buildFormHandler);
    },
    buildFormHandler: function() {
      this.delegateEvents({
        'submit': this.onFormSubmit
      });
      if (this.model) {
        return this.on('update', this.applySerializedModel);
      }
    },
    validate: function() {
      return this.clearInputErrors();
    },
    displayInputErrors: function() {
      var attr, message, _ref, _results;
      _ref = this.model.errors;
      _results = [];
      for (attr in _ref) {
        message = _ref[attr];
        _results.push(this.addInputError(this.$("[name=" + attr + "]"), message.join(', ')));
      }
      return _results;
    },
    addInputError: function(input, message) {
      input.after("<span class=\"help-inline error-message\">" + message + "</span>").closest('.control-group').addClass('error');
      return this.valid = false;
    },
    clearInputErrors: function() {
      this.$('.control-group.error').removeClass('error').find('.error-message').remove();
      return this.valid = true;
    },
    applySerializedModel: function() {
      var $el, $form, check, item, _i, _len, _ref, _results;
      $form = this.$('form').find('input,select,textarea');
      check = function(el, checked) {
        return el.prop('checked', checked);
      };
      check($form.filter(':checked'), false);
      _ref = Object.serialize(this.model.toJSON());
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        $el = $form.filter("[name='" + item.name + "']");
        if ($el.filter(':checkbox').length) {
          if ($el.val() == item.value) {
            _results.push(check($el.filter(':checkbox'), true));
          } else {
            _results.push(void 0);
          }
        } else if ($el.filter(':radio').length) {
          _results.push(check($el.filter("[value='" + item.value + "']"), true));
        } else {
          _results.push($el.val(item.value));
        }
      }
      return _results;
    },
    serializeModel: function() {
      this.clearInputErrors();
      this.model.set(this.serializeForm());
      if (this.model.isValid()) {
        this.trigger('form:success');
        if (this.hideOnValidSubmit) {
          return this.hide();
        }
      } else {
        return this.displayInputErrors();
      }
    },
    serializeForm: function() {
      return Object.deserialize(this.$('form').serializeArray());
    },
    onFormSubmit: function(e) {
      this.prevent(e);
      this.validate();
      if (this.model) {
        this.serializeModel();
      }
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
        mousedown: 'handleFocusableEvent',
        mouseup: 'handleFocusableEvent',
        click: 'handleFocusableEvent'
      });
      return this.delegateRevertedFocus(this.revertFocusOn);
    },
    delegateRevertedFocus: function(matcher) {
      var reverted;
      reverted = {};
      reverted["mousedown " + matcher] = 'revertInterfaceFocus';
      reverted["click " + matcher] = 'revertInterfaceFocus';
      return this.delegateEvents(reverted);
    },
    handleFocusableEvent: function(e) {
      e.stopPropagation();
      if (!$(e.target).is(this.focusableSelector || ':input, [tabindex]')) {
        return this.prevent(e);
      }
    },
    revertInterfaceFocus: function() {
      return this.delay(1, function() {
        return Mercury.trigger('focus');
      });
    },
    preventFocusout: function($constrain) {
      var $focus,
        _this = this;
      $focus = $(this.createFocusableKeeper().appendTo(this.$el)[0]);
      this.on('release', function() {
        return _this.clearFocusout($focus, $constrain);
      });
      this.on('hide', function() {
        return _this.clearFocusout($focus, $constrain);
      });
      $focus.on('blur', function() {
        return _this.keepFocusConstrained($focus, $constrain);
      });
      $constrain.off('focusout').on('focusout', function() {
        return _this.keepFocusConstrained($focus, $constrain);
      });
      return $constrain.on('keydown', function(e) {
        var first, focusables, last;
        if (e.keyCode !== 9) {
          return;
        }
        focusables = $constrain.find(':input[tabindex != "-1"]');
        if (!focusables.length) {
          return;
        }
        first = focusables[0];
        last = focusables[focusables.length - 1];
        if ((e.shiftKey && e.target === first) || (!e.shiftKey && e.target === last)) {
          return _this.prevent(e, true);
        }
      });
    },
    createFocusableKeeper: function() {
      return $('<input style="position:fixed;left:100%;top:20px" tabindex="-1"/><input style="position:fixed;left:100%;top:20px"/>');
    },
    keepFocusConstrained: function($focus, $constrain) {
      var _this = this;
      return this.preventFocusoutTimeout = this.delay(1, function() {
        if ($.contains($constrain[0], document.activeElement)) {
          return;
        }
        return $focus.focus();
      });
    },
    clearFocusout: function($focus, $constrain) {
      clearTimeout(this.preventFocusoutTimeout);
      $focus.off();
      return $constrain.off('keydown').off('focusout');
    }
  };

}).call(this);
(function() {
  Mercury.View.Modules.ScrollPropagation = {
    preventScrollPropagation: function($el) {
      return $el.on('mousewheel DOMMouseScroll', function(e) {
        var delta, scrollTop, _ref;
        _ref = [e.originalEvent.wheelDelta || -e.originalEvent.detail, $el.scrollTop()], delta = _ref[0], scrollTop = _ref[1];
        if (delta > 0 && scrollTop <= 0) {
          return false;
        }
        if (delta < 0 && scrollTop >= $el.get(0).scrollHeight - $el.height()) {
          return false;
        }
        return true;
      });
    }
  };

}).call(this);
(function() {
  Mercury.View.Modules.VisibilityToggleable = {
    included: function() {
      return this.on('build', this.buildVisibilityToggleable);
    },
    buildVisibilityToggleable: function() {
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
        return;
      }
      this.trigger('show');
      clearTimeout(this.visibilityTimout);
      if (typeof this.onShow === "function") {
        this.onShow();
      }
      this.visible = true;
      this.$el.show();
      if (typeof this.position === "function") {
        this.position();
      }
      return this.visibilityTimout = this.delay(50, function() {
        this.css({
          opacity: 1
        });
        if (update && typeof update === 'boolean') {
          return typeof this.update === "function" ? this.update() : void 0;
        }
      });
    },
    hide: function(release) {
      if (!this.visible) {
        return;
      }
      if (typeof release !== 'boolean') {
        release = null;
      }
      if (release == null) {
        release = this.releaseOnHide;
      }
      this.trigger('hide');
      clearTimeout(this.visibilityTimout);
      if (typeof this.onHide === "function") {
        this.onHide();
      }
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
    }
  };

}).call(this);
(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Modal = (function(_super) {
    __extends(Modal, _super);

    function Modal() {
      _ref = Modal.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Modal.include(Mercury.View.Modules.FormHandler);

    Modal.include(Mercury.View.Modules.InterfaceFocusable);

    Modal.include(Mercury.View.Modules.ScrollPropagation);

    Modal.include(Mercury.View.Modules.VisibilityToggleable);

    Modal.logPrefix = 'Mercury.Modal:';

    Modal.className = 'mercury-dialog mercury-modal';

    Modal.elements = {
      dialog: '.mercury-modal-dialog-positioner',
      content: '.mercury-modal-dialog-content',
      contentContainer: '.mercury-modal-dialog-content-container',
      titleContainer: '.mercury-modal-dialog-title',
      title: '.mercury-modal-dialog-title span'
    };

    Modal.events = {
      'mercury:interface:resize': 'resize',
      'mercury:modals:hide': 'hide',
      'click .mercury-modal-dialog-title em': 'hide'
    };

    Modal.prototype.primaryTemplate = 'modal';

    Modal.prototype.releaseOnHide = true;

    Modal.prototype.buildElement = function() {
      if (this.hidden) {
        this.releaseOnHide = false;
      }
      this.negotiateTemplate();
      return Modal.__super__.buildElement.apply(this, arguments);
    };

    Modal.prototype.build = function() {
      this.appendTo();
      this.preventScrollPropagation(this.$contentContainer);
      return this.preventFocusout(this.$contentContainer, this.focusFirstFocusable);
    };

    Modal.prototype.negotiateTemplate = function() {
      var _base;
      (_base = this.options).template || (_base.template = this.template);
      this.subTemplate = this.options.template;
      return this.template = this.primaryTemplate;
    };

    Modal.prototype.update = function(options) {
      if (!(this.visible && this.updateForOptions(options))) {
        return;
      }
      this.resize();
      this.show(false);
      this.refreshElements();
      this.trigger('update');
      return this.delay(300, this.focusFirstFocusable);
    };

    Modal.prototype.updateForOptions = function(options) {
      var content, key, value, _ref1;
      this.options = $.extend({}, this.options, options || {});
      _ref1 = this.options;
      for (key in _ref1) {
        value = _ref1[key];
        this[key] = value;
      }
      this.negotiateTemplate();
      this.$title.html(this.t(this.title));
      this.setWidth(this.width);
      content = this.contentFromOptions();
      if (content === this.lastContent && this.width === this.lastWidth) {
        return false;
      }
      this.addClass('loading');
      this.lastContent = content;
      this.lastWidth = this.width;
      this.$content.css({
        visibility: 'hidden',
        opacity: 0,
        width: this.width
      }).html(content);
      this.localize(this.$content);
      return true;
    };

    Modal.prototype.setWidth = function(width) {
      return this.$dialog.css({
        width: width
      });
    };

    Modal.prototype.resize = function(animate, dimensions) {
      var height, titleHeight, width;
      if (animate == null) {
        animate = true;
      }
      if (dimensions == null) {
        dimensions = null;
      }
      if (!this.visible) {
        return;
      }
      clearTimeout(this.showContentTimeout);
      if (typeof animate === 'object') {
        dimensions = animate;
        animate = false;
      }
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
        width: 'auto',
        display: 'block'
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

    Modal.prototype.appendTo = function() {
      return Modal.__super__.appendTo.call(this, Mercury["interface"]);
    };

    Modal.prototype.release = function() {
      if (this.visible) {
        return this.hide(true);
      }
      return Modal.__super__.release.apply(this, arguments);
    };

    Modal.prototype.onShow = function() {
      Mercury.trigger('blur');
      return Mercury.trigger('modals:hide');
    };

    Modal.prototype.onHide = function() {
      Mercury.trigger('focus');
      return this.delay(250, function() {
        this.lastWidth = null;
        this.$dialog.css({
          height: '',
          width: ''
        });
        this.$contentContainer.css({
          height: ''
        });
        return this.$content.hide();
      });
    };

    return Modal;

  })(Mercury.View);

}).call(this);
(function() {
  var registered, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  registered = {};

  Mercury.Snippet = (function(_super) {
    __extends(Snippet, _super);

    Snippet.logPrefix = 'Mercury.Snippet:';

    Snippet.register = function(name, options) {
      options.name = name;
      return new Mercury.Snippet.Definition(options);
    };

    Snippet.get = function(name, instance) {
      var definition;
      if (instance == null) {
        instance = false;
      }
      definition = registered[name];
      if (!definition) {
        throw new Error("unable to locate the " + name + " snippet");
      }
      if (instance) {
        return new Mercury.Snippet(definition.signature());
      } else {
        return definition;
      }
    };

    Snippet.fromSerializedJSON = function(json) {
      var instance;
      instance = this.get(json.name, true);
      instance.cid = json.cid;
      instance.set(json.attributes);
      return instance;
    };

    Snippet.all = function() {
      return registered;
    };

    Snippet.unregister = function(name) {
      var definition;
      definition = registered[name];
      if (!definition) {
        throw new Error("unable to locate the " + name + " snippet");
      }
      return delete registered[name];
    };

    function Snippet(options) {
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
        throw new Error('must provide a name for snippets');
      }
      this.supportedRegions || (this.supportedRegions = 'all');
      Snippet.__super__.constructor.call(this, this.defaults || {});
    }

    Snippet.prototype.toSerializedJSON = function() {
      return {
        cid: this.cid,
        name: this.name,
        attributes: this.toJSON()
      };
    };

    Snippet.prototype.initialize = function(region) {
      this.region = region;
      if (this.supportedRegions !== 'all' && this.supportedRegions.indexOf(this.region.type()) === -1) {
        return alert(this.t("Unable to use the " + this.name + " snippet in that region. Supported regions: " + (this.supportedRegions.join(', '))));
      }
      if (this.form) {
        return this.displayForm();
      }
      return this.render();
    };

    Snippet.prototype.delay = function(ms, callback) {
      var _this = this;
      return setTimeout((function() {
        return callback.call(_this);
      }), ms);
    };

    Snippet.prototype.displayForm = function(form) {
      var view,
        _this = this;
      view = new (this.Modal || Mercury.Modal)({
        title: this.get('title'),
        template: this.templateClosure(form || this.form),
        width: 600,
        model: this,
        hideOnValidSubmit: true
      });
      return view.on('form:success', function() {
        return _this.render();
      });
    };

    Snippet.prototype.render = function(options) {
      if (options == null) {
        options = {};
      }
      options = $.extend({}, this.renderOptions, options);
      if (this.url() && !this.renderedView) {
        return this.save(options);
      }
      return this.renderView(options.template);
    };

    Snippet.prototype.renderView = function(template) {
      this.renderedView = this.view(this.templateClosure(template || this.template));
      this.trigger('rendered', this.renderedView);
      return this.delay(1, this.afterRender);
    };

    Snippet.prototype.afterRender = function() {};

    Snippet.prototype.view = function(template) {
      return new Mercury.Snippet.View({
        template: template,
        snippet: this
      });
    };

    Snippet.prototype.saveSuccess = function(content) {
      var _this = this;
      return this.renderView(function() {
        return _this.get('preview') || content;
      });
    };

    Snippet.prototype.templateClosure = function(template) {
      var closure,
        _this = this;
      if (typeof template === 'function') {
        closure = (function() {
          return template.apply(null, arguments);
        });
      }
      return closure || template;
    };

    Snippet.prototype.getRenderedView = function(region) {
      return this.renderedView;
    };

    Snippet.prototype.replaceWithView = function($el) {
      $el.replaceWith(this.renderedView.$el);
      return this.afterRender();
    };

    Snippet.prototype.renderAndReplaceWithView = function($el, callback) {
      if (callback == null) {
        callback = null;
      }
      this.one('rendered', function(view) {
        $el.replaceWith(view.$el);
        return typeof callback === "function" ? callback($el, view) : void 0;
      });
      return this.render();
    };

    return Snippet;

  })(Mercury.Model);

  Mercury.Snippet.Module = {
    registerSnippet: Mercury.Snippet.register,
    getSnippet: Mercury.Snippet.get
  };

  Mercury.Snippet.Definition = (function() {
    function Definition(options) {
      this.options = options != null ? options : {};
      this.name = this.options.name;
      if (!this.name) {
        throw new Error('must provide a name for snippets');
      }
      this.configuration = this.options.config;
      this.title = this.options.title;
      this.description = this.options.description;
      this.version = this.options.version;
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

    return Definition;

  })();

  Mercury.Snippet.View = (function(_super) {
    __extends(View, _super);

    function View() {
      _ref = View.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    View.prototype.build = function() {
      this.addClass("mercury-" + this.snippet.name + "-snippet");
      this.attr({
        'data-mercury-snippet': this.snippet.cid
      });
      this.attr('contenteditable', false);
      return this.$el.data({
        'snippet': this.snippet
      });
    };

    return View;

  })(Mercury.View);

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
        this.notify(this.t('Region type not provided'));
      }
      type = ("" + type).toLowerCase().toCamelCase(true);
      if (!Mercury.Region[type]) {
        this.notify(this.t('Unknown %s region type, falling back to base region', type));
      }
      return new (Mercury.Region[type] || Mercury.Region)(el);
    };

    Region.addBehavior = function(name, options) {
      var toolbar;
      if (options == null) {
        options = {};
      }
      if (options.action) {
        this.addAction(name, options.action);
      }
      if (options.context) {
        this.addContext(name, options.context);
      }
      if (options.data) {
        this.addData(name, options.data);
      }
      if (options.toolbar) {
        toolbar = {};
        toolbar[name] = options.toolbar;
        return this.addToolbar(name, toolbar);
      }
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
        this.notify(this.t('Is unsupported in this browser'));
        return false;
      }
      this.actions || (this.actions = {});
      this.context = $.extend({}, this.constructor.context, this.context);
      this.dataAttrs = $.extend({}, this.constructor.dataAttrs, this.dataAttrs);
      this.options = $.extend({}, this.options, this.config("regions:" + (this.type())));
      if (this.el && (attr = this.config('regions:options'))) {
        this.options = $.extend(this.options, JSON.parse($(this.el).attr(attr) || '{}'));
      }
      this.placeholder || (this.placeholder = this.options.placeholder || '');
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
      this.$focusable.attr({
        'data-placeholder': this.placeholder
      });
      if (!this.name) {
        this.notify(this.t('No name provided for the %s region, falling back to random', this.type()));
        this.name = "" + (this.type()) + (Math.floor(Math.random() * 10000));
        this.$el.attr(this.config('regions:identifier'), this.name);
      }
      this.addRegionAttrs();
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

    Region.prototype.addRegionAttrs = function() {
      this.addClass("mercury-" + (this.type()) + "-region");
      return this.$focusable.attr('data-mercury-region', true);
    };

    Region.prototype.type = function() {
      return this.constructor.type;
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
      this.trigger('update');
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
        this.$focusable.removeAttr('tabindex').removeAttr('data-mercury-region');
      } else {
        this.$focusable.attr({
          tabindex: 0
        }).attr('data-mercury-region', true);
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

    Region.prototype.focus = function(scroll, force) {
      var x, y;
      if (scroll == null) {
        scroll = false;
      }
      if (force == null) {
        force = false;
      }
      this.focused = true;
      x = window.scrollX;
      y = window.scrollY;
      if (force || !this.$focusable.is(':focus')) {
        this.$focusable.focus();
      }
      if (!scroll) {
        window.scrollTo(x, y);
      }
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
          this.cleanData(data);
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

    Region.prototype.cleanData = function(data) {
      delete data.region;
      delete data.mercury;
      delete data.mercuryRegion;
      delete data.placeholder;
      return delete data.regionOptions;
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

    Region.prototype.onItemDropped = function(e) {
      var data, snippet, snippetName;
      if (this.previewing) {
        return;
      }
      data = e.originalEvent.dataTransfer;
      this.focus();
      if (data.files.length && this.onDropFile) {
        this.prevent(e);
        return this.onDropFile(data.files);
      } else if (this.onDropSnippet && (snippetName = data.getData('snippet'))) {
        this.onDropSnippet(snippet = Mercury.Snippet.get(snippetName, true));
        return snippet.initialize(this);
      } else {
        return typeof this.onDropItem === "function" ? this.onDropItem(e, data) : void 0;
      }
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
        type: this.type(),
        value: this.value(),
        data: this.data(),
        snippets: this.snippets()
      };
    };

    Region.prototype.fromJSON = function(json) {
      if (typeof json === 'string') {
        json = JSON.parse(json);
      }
      if (!(json.value === null || typeof json.value === 'undefined')) {
        this.value(json.value);
      }
      if (json.data) {
        return this.data(json.data);
      }
    };

    Region.prototype.load = function(json) {
      this.fromJSON(json);
      return typeof this.loadSnippets === "function" ? this.loadSnippets(json.snippets || {}) : void 0;
    };

    Region.prototype.release = function() {
      this.$el.data({
        region: null
      });
      this.removeClass("mercury-" + (this.type()) + "-region");
      this.$focusable.removeAttr('tabindex').removeAttr('data-mercury-region');
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
      return this.bindDropEvents();
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
      if (!(this.onDropFile || this.onDropItem || this.onDropSnippet)) {
        return;
      }
      return this.delegateEvents(this.$el, {
        dragenter: function(e) {
          if (!_this.previewing) {
            return _this.prevent(e);
          }
        },
        dragover: function(e) {
          if (!(_this.previewing || (_this.editableDropBehavior && Mercury.support.webkit && !Mercury.dragHack))) {
            return _this.prevent(e);
          }
        },
        drop: 'onItemDropped'
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
  Mercury.View.Modules.Draggable = {
    startDrag: function(e) {
      var position;
      if (e.button > 1) {
        return;
      }
      this.prevent(e);
      this.viewportSize = {
        width: $(window).width(),
        height: $(window).height()
      };
      position = this.$el.position();
      this.dragPosition = {
        x: position.left * -1,
        y: position.top * -1
      };
      return this.potentialDragStart(e.pageX, e.pageY);
    },
    potentialDragStart: function(x, y) {
      this.startPosition = {
        x: this.dragPosition.x,
        y: this.dragPosition.y
      };
      this.initialPosition = {
        x: x,
        y: y
      };
      this.potentiallyDragging = true;
      this.bindDocumentDragEvents(document);
      if (Mercury["interface"].document && Mercury["interface"].document !== document) {
        return this.bindDocumentDragEvents(Mercury["interface"].document);
      }
    },
    onStartDragging: function(x, y) {
      this.addClass('mercury-no-animation');
      this.dragging = true;
      this.initialPosition = {
        x: x,
        y: y
      };
      return typeof this.onDragStart === "function" ? this.onDragStart() : void 0;
    },
    onDrag: function(e) {
      var currentX, currentY, x, y;
      this.prevent(e);
      x = e.pageX;
      y = e.pageY;
      if (!this.dragging && (Math.abs(this.initialPosition.x - x) > 5 || Math.abs(this.initialPosition.y - y) > 5)) {
        return this.onStartDragging(x, y);
      }
      this.lastPosition = this.dragPosition;
      currentX = (this.startPosition.x - x + this.initialPosition.x) * -1;
      currentY = (this.startPosition.y - y + this.initialPosition.y) * -1;
      this.dragPosition = {
        x: currentX,
        y: currentY
      };
      return this.setPositionOnDrag(currentX, currentY);
    },
    onEndDragging: function(e) {
      if (this.dragging === true) {
        if (typeof this.onDragEnd === "function") {
          this.onDragEnd(e);
        }
      }
      this.dragging = false;
      this.potentiallyDragging = false;
      this.unbindDocumentDragEvents(document);
      if (Mercury["interface"].document && Mercury["interface"].document !== document) {
        this.unbindDocumentDragEvents(Mercury["interface"].document);
      }
      return this.delay(250, function() {
        return this.removeClass('mercury-no-animation');
      });
    },
    bindDocumentDragEvents: function(el) {
      var _this = this;
      return $(el).on('mousemove', this.onDragHandler = function(e) {
        return _this.onDrag(e);
      }).on('mouseup', this.onEndDraggingHandler = function(e) {
        return _this.onEndDragging(e);
      });
    },
    unbindDocumentDragEvents: function(el) {
      return $(el).off('mousemove', this.onDragHandler).off('mouseup', this.onEndDraggingHandler);
    },
    setPositionOnDrag: function(x, y) {
      return this.css({
        top: y,
        left: x
      });
    }
  };

}).call(this);
(function() {
  Mercury.View.Modules.FilterableList = {
    included: function() {
      return this.on('show', this.buildFilterable);
    },
    buildFilterable: function() {
      if (!LiquidMetal) {
        return this.$('input.mercury-filter').hide();
      }
      return this.delegateEvents({
        'keyup input.mercury-filter': this.onFilter,
        'search input.mercury-filter': this.onFilter
      });
    },
    onFilter: function(e) {
      var item, value, _i, _len, _ref, _results;
      value = $(e.target).val();
      _ref = this.$('li[data-filter]');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if (LiquidMetal.score((item = $(item)).data('filter'), value) <= 0.5) {
          _results.push(item.hide());
        } else {
          _results.push(item.show());
        }
      }
      return _results;
    }
  };

}).call(this);
(function() {
  Mercury.View.Modules.InterfaceMaskable = {
    included: function() {
      return this.on('build', this.buildInterfaceMaskable);
    },
    extended: function() {
      return this.on('build', this.buildInterfaceMaskable);
    },
    buildInterfaceMaskable: function() {
      this.$mask = $('<div class="mercury-interface-mask">');
      this.append(this.$mask);
      return this.delegateEvents({
        'mercury:interface:mask': this.mask,
        'mercury:interface:unmask': this.unmask,
        'mousedown .mercury-interface-mask': this.prevent,
        'mouseup .mercury-interface-mask': this.prevent,
        'click .mercury-interface-mask': this.onMaskClick
      });
    },
    mask: function() {
      return this.$mask.show();
    },
    unmask: function() {
      return this.$mask.hide();
    },
    onMaskClick: function(e) {
      this.prevent(e, true);
      return Mercury.trigger('dialogs:hide');
    }
  };

}).call(this);
(function() {
  Mercury.View.Modules.InterfaceShadowed = {
    included: function() {
      return this.on('init', this.buildInterfaceShadowed);
    },
    extended: function() {
      return this.on('init', this.buildInterfaceShadowed);
    },
    buildInterfaceShadowed: function() {
      if (!this.el.webkitCreateShadowRoot) {
        return;
      }
      this.shadow = $(this.el.webkitCreateShadowRoot());
      this.el = document.createElement(this.tag || this.constructor.tag);
      this.$el = $(this.el);
      this.shadow.get(0).applyAuthorStyles = true;
      return this.shadow.append(this.el);
    }
  };

}).call(this);
(function() {
  Mercury.View.Modules.ToolbarDialog = {
    included: function() {
      return this.on('build', this.buildToolbarDialog);
    },
    buildToolbarDialog: function() {
      this.delegateEvents({
        'mercury:dialogs:hide': function() {
          return typeof this.hide === "function" ? this.hide() : void 0;
        },
        'mercury:interface:resize': 'positionAndResize'
      });
      this.on('show', function() {
        if (!this.visible) {
          Mercury.trigger('interface:mask');
        }
        return true;
      });
      return this.on('hide', function() {
        if (this.visible) {
          Mercury.trigger('interface:unmask');
        }
        return true;
      });
    },
    positionAndResize: function(dimensions) {
      this.position(dimensions);
      return this.resize(false, dimensions);
    },
    position: function(dimensions) {
      var e, left, o, p, par, top, v, win;
      this.css({
        top: 0,
        left: 0
      });
      par = this.$el.parent();
      win = $(window);
      v = {
        width: win.width(),
        height: win.height()
      };
      e = {
        width: this.$el.outerWidth(),
        height: this.$el.outerHeight()
      };
      p = {
        width: par.outerWidth(),
        height: par.outerHeight()
      };
      o = par.offset();
      o.left -= window.scrollX;
      o.top -= window.scrollY;
      left = 0;
      if (e.width + o.left > v.width) {
        left = -e.width + p.width;
      }
      if (o.left + left < 0) {
        left -= o.left + left;
      }
      top = p.height;
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
    resize: function() {}
  };

}).call(this);
(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Model.Page = (function(_super) {
    __extends(Page, _super);

    function Page() {
      _ref = Page.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Page.define('Mercury.Model.Page');

    Page.prototype.save = function(options) {
      if (options == null) {
        options = {};
      }
      return Page.__super__.save.call(this, $.extend(this.config('saving'), options));
    };

    return Page;

  })(Mercury.Model);

}).call(this);
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.BaseInterface = (function(_super) {
    __extends(BaseInterface, _super);

    BaseInterface.include(Mercury.Module);

    BaseInterface.include(Mercury.View.Modules.Draggable);

    BaseInterface.logPrefix = 'Mercury.BaseInterface:';

    BaseInterface.tag = 'mercury';

    BaseInterface.events = {
      'mercury:save': 'save',
      'mercury:focus': 'focusActiveRegion',
      'mercury:blur': 'blurActiveRegion',
      'mercury:resize': 'onResize',
      'mercury:action': 'focusActiveRegion',
      'mercury:region:focus': 'onRegionFocus',
      'mercury:region:release': 'onRegionRelease',
      'mercury:reinitialize': 'reinitialize',
      'mercury:interface:toggle': 'toggle',
      'mousedown .mercury-drag-handle': 'startDrag'
    };

    function BaseInterface() {
      this.onUnload = __bind(this.onUnload, this);
      this.onResize = __bind(this.onResize, this);
      this.hideDialogs = __bind(this.hideDialogs, this);
      if (parent !== window && parent.Mercury) {
        this.log(this.t('Has already been defined in parent frame'));
        return;
      }
      if (this.config('interface:maskable')) {
        this.extend(Mercury.View.Modules.InterfaceMaskable);
      }
      if (this.config('interface:shadowed')) {
        this.extend(Mercury.View.Modules.InterfaceShadowed);
      }
      Mercury["interface"] || (Mercury["interface"] = this);
      this.floating || (this.floating = this.config('interface:floating'));
      this.visible = true;
      BaseInterface.__super__.constructor.apply(this, arguments);
      this.page = new Mercury.Model.Page();
      this.regions || (this.regions = []);
      $(window).on('beforeunload', this.onUnload);
      $(window).on('resize', this.onResize);
      this.initialize();
      this.buildInterface();
      this.bindDefaultEvents();
      Mercury.trigger('initialized');
    }

    BaseInterface.prototype.build = function() {
      if (!this.el) {
        this.el = document.createElement(this.tag || this.constructor.tag);
      }
      this.$el = $(this.el);
      this.attr(this.attributes);
      if (this.config('interface:floatDrag')) {
        return this.append('<div class="mercury-drag-handle"/>');
      }
    };

    BaseInterface.prototype.init = function() {
      return $('body').before(this.$el);
    };

    BaseInterface.prototype.initialize = function() {
      this.addAllRegions();
      return this.bindDocumentEvents();
    };

    BaseInterface.prototype.load = function(json) {
      var data, name, _ref, _ref1, _results;
      _ref = json.contents || json;
      _results = [];
      for (name in _ref) {
        data = _ref[name];
        _results.push((_ref1 = this.findRegionByName(name)) != null ? _ref1.load(data) : void 0);
      }
      return _results;
    };

    BaseInterface.prototype.findRegionByName = function(name) {
      var region, _i, _len, _ref;
      _ref = this.regions || [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        region = _ref[_i];
        if (region.name === name) {
          return region;
        }
      }
      return null;
    };

    BaseInterface.prototype.addAllRegions = function() {
      var el, _i, _len, _ref;
      _ref = this.regionElements();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        el = _ref[_i];
        this.addRegion(el);
      }
      return this.region || (this.region = this.regions[0]);
    };

    BaseInterface.prototype.bindDocumentEvents = function() {
      if (!this.config('interface:mask')) {
        return $('body', this.document).on('mousedown', this.hideDialogs);
      }
    };

    BaseInterface.prototype.buildInterface = function() {
      var klass, subview, _i, _len, _ref;
      this.addClasses();
      _ref = ['toolbar', 'statusbar'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        subview = _ref[_i];
        if (!(klass = this.config("interface:" + subview))) {
          continue;
        }
        this[subview] = this.appendView(new Mercury[klass]());
      }
      if (!this.config('interface:enabled')) {
        this.previewMode = true;
        this.hide();
        Mercury.trigger('mode', 'preview');
      }
      this.focusDefaultRegion();
      this.onResize();
      return this.delay(500, function() {
        return this.removeClass('loading');
      });
    };

    BaseInterface.prototype.addClasses = function() {
      this.addClass(this.className);
      this.addClass('loading');
      this.addClass(this.config('interface:style') || 'standard');
      if (this.floating) {
        this.addClass('mercury-floating');
      }
      return this.addClass("locale-" + (Mercury.I18n.detectLocale().join('-').toLowerCase()));
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

    BaseInterface.prototype.reinitialize = function() {
      this.addAllRegions();
      return this.focusDefaultRegion();
    };

    BaseInterface.prototype.setInterface = function(type) {
      if (type === 'float') {
        type = 'mercury-floating';
        this.floating = true;
        if ($('body').hasClass('mercury-transitions')) {
          $('body').removeClass('mercury-transitions').addClass('mercury-no-transitions');
        }
      }
      this.addClass(type);
      this.position();
      return this.onResize();
    };

    BaseInterface.prototype.removeInterface = function(type) {
      if (type === 'float') {
        type = 'mercury-floating';
        this.floating = false;
        this.placed = false;
        this.css({
          position: ''
        });
      }
      if ($('body').hasClass('mercury-no-transitions')) {
        $('body').removeClass('mercury-no-transitions').addClass('mercury-transitions');
      }
      this.removeClass(type);
      this.position();
      return this.onResize();
    };

    BaseInterface.prototype.focusDefaultRegion = function() {
      return this.delay(100, this.focusActiveRegion);
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

    BaseInterface.prototype.focusActiveRegion = function() {
      var _ref;
      return (_ref = this.region) != null ? _ref.focus(false, true) : void 0;
    };

    BaseInterface.prototype.blurActiveRegion = function() {
      var _ref;
      return (_ref = this.region) != null ? _ref.blur() : void 0;
    };

    BaseInterface.prototype.setMode = function(mode) {
      this["" + mode + "Mode"] = !this["" + mode + "Mode"];
      this.focusActiveRegion();
      if (mode === 'preview') {
        return this.delay(50, function() {
          return this.position();
        });
      }
    };

    BaseInterface.prototype.toggle = function() {
      if (this.visible) {
        return this.hide();
      } else {
        return this.show();
      }
    };

    BaseInterface.prototype.show = function() {
      if (this.visible) {
        return;
      }
      Mercury.trigger('interface:show');
      if (this.previewMode) {
        Mercury.trigger('mode', 'preview');
      }
      this.$el.show();
      this.visible = true;
      this.onResize();
      this.$el.stop().animate({
        opacity: 1
      }, {
        duration: 250
      });
      return this.position();
    };

    BaseInterface.prototype.hide = function() {
      var _this = this;
      if (!this.visible) {
        return;
      }
      this.hiding = true;
      Mercury.trigger('interface:hide');
      if (!this.previewMode) {
        Mercury.trigger('mode', 'preview');
      }
      $('body').css({
        position: 'relative',
        top: 0
      });
      this.visible = false;
      this.position();
      return this.$el.stop().animate({
        opacity: 0
      }, {
        duration: 250,
        complete: function() {
          _this.$el.hide();
          return _this.hiding = false;
        }
      });
    };

    BaseInterface.prototype.dimensions = function() {
      var statusbarHeight, toolbarHeight, _ref, _ref1;
      if (this.floating) {
        toolbarHeight = 0;
        statusbarHeight = 0;
      } else {
        toolbarHeight = (_ref = this.toolbar) != null ? _ref.height() : void 0;
        statusbarHeight = (_ref1 = this.statusbar) != null ? _ref1.height() : void 0;
      }
      return {
        top: toolbarHeight,
        left: 0,
        right: 0,
        bottom: statusbarHeight,
        width: $(window).width(),
        height: $(window).height() - toolbarHeight - statusbarHeight
      };
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

    BaseInterface.prototype.hideDialogs = function() {
      return Mercury.trigger('dialogs:hide');
    };

    BaseInterface.prototype.release = function() {
      $(window).off('resize', this.resize);
      $('body').css({
        position: '',
        top: ''
      });
      $('body', this.document).off('mousedown', this.hideDialogs);
      while (this.regions.length) {
        this.regions.shift().release();
      }
      return BaseInterface.__super__.release.apply(this, arguments);
    };

    BaseInterface.prototype.serialize = function() {
      var data, region, _i, _len, _ref;
      data = {};
      _ref = this.regions;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        region = _ref[_i];
        data[region.name] = region.toJSON(true);
      }
      return data;
    };

    BaseInterface.prototype.save = function() {
      var _this = this;
      this.page.set({
        content: this.serialize(),
        location: location.pathname
      });
      this.page.on('error', function(xhr, options) {
        return alert(_this.t('Unable to save to the url: %s', options.url));
      });
      return this.page.save().always = function() {
        return _this.delay(250, function() {
          return Mercury.trigger('save:complete');
        });
      };
    };

    BaseInterface.prototype.heightForWidth = function(width) {
      var height, oldWidth;
      oldWidth = this.$el.outerWidth();
      this.css({
        width: width,
        visibility: 'hidden',
        height: 'auto'
      });
      height = this.$el.outerHeight();
      this.css({
        width: oldWidth,
        visibility: 'visible'
      });
      return height;
    };

    BaseInterface.prototype.position = function(animate) {
      var callback, height, left, pos, viewport, width;
      if (animate == null) {
        animate = false;
      }
      if (!this.floating) {
        return;
      }
      if (!this.region) {
        return;
      }
      if (this.placed) {
        return;
      }
      if (this.hiding) {
        return;
      }
      this.addClass('mercury-no-animation');
      pos = this.positionForRegion();
      this.width = width = Math.max(this.config('interface:floatWidth') || this.region.$el.width(), 300);
      height = this.heightForWidth(width);
      left = pos.left;
      viewport = $(window).width();
      if (left + width > viewport) {
        left -= left + width - viewport;
      }
      callback = function() {
        if (animate) {
          this.removeClass('mercury-no-animation');
        }
        return this.css({
          top: pos.top - height,
          left: left,
          width: width
        });
      };
      if (animate) {
        this.delay(20, callback);
        return this.delay(300, function() {
          return Mercury.trigger('interface:resize', this.dimensions());
        });
      } else {
        return callback.call(this);
      }
    };

    BaseInterface.prototype.positionForRegion = function() {
      return this.region.$el.offset();
    };

    BaseInterface.prototype.onDragStart = function() {
      return Mercury.trigger('dialogs:hide');
    };

    BaseInterface.prototype.setPositionOnDrag = function(x, y) {
      if (!this.placed) {
        this.placed = true;
        this.startPosition.x += window.scrollX;
        this.startPosition.y += window.scrollY;
        x -= window.scrollX;
        y -= window.scrollY;
        this.lastPosition = {
          x: x,
          y: y
        };
        this.css({
          position: 'fixed',
          top: y,
          left: x
        });
      }
      if (x < 0) {
        x = 0;
      }
      if (y < 0) {
        y = 0;
      }
      if (x > this.viewportSize.width - 50) {
        x = this.viewportSize.width - 50;
      }
      if (y > this.viewportSize.height - 50) {
        y = this.viewportSize.height - 50;
      }
      this.css({
        top: y,
        left: x
      });
      if (!this.width) {
        return this.onResize();
      }
    };

    BaseInterface.prototype.onRegionFocus = function(region) {
      this.region = region;
      return this.delay(50, function() {
        if (this.floating) {
          return this.position(true);
        } else {
          return this.onResize();
        }
      });
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
      var dimensions;
      dimensions = this.dimensions();
      $('body').css({
        position: 'relative',
        top: dimensions.top
      });
      if (!this.visible) {
        return;
      }
      Mercury.trigger('interface:resize', dimensions);
      this.position();
      return dimensions;
    };

    BaseInterface.prototype.onUnload = function() {
      if (this.config('interface:silent') || !this.hasChanges()) {
        return;
      }
      return this.t('You have unsaved changes.  Are you sure you want to leave without saving them first?');
    };

    return BaseInterface;

  })(Mercury.View);

}).call(this);
(function() {
  var _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.FrameInterface = (function(_super) {
    __extends(FrameInterface, _super);

    function FrameInterface() {
      this.onResize = __bind(this.onResize, this);
      this.onScroll = __bind(this.onScroll, this);
      _ref = FrameInterface.__super__.constructor.apply(this, arguments);
      return _ref;
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

    FrameInterface.prototype.load = function(json) {
      this.loadedJSON = json;
      if (!this.initialized) {
        return;
      }
      return FrameInterface.__super__.load.apply(this, arguments);
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
        _this.initializeFrame();
        _this.load(_this.loadedJSON);
        return _this.$frame.off('load').on('load', function() {
          return _this.reinitializeFrame();
        });
      });
      this.delegateEvents({
        'mercury:initialize': function() {
          return this.initializeFrame();
        }
      });
      return FrameInterface.__super__.bindDefaultEvents.apply(this, arguments);
    };

    FrameInterface.prototype.bindDocumentEvents = function() {
      $(this.window).on('scroll', this.onScroll);
      return FrameInterface.__super__.bindDocumentEvents.apply(this, arguments);
    };

    FrameInterface.prototype.initializeFrame = function() {
      if (this.initialized) {
        return;
      }
      this.initialized = true;
      this.regions || (this.regions = []);
      this.setupDocument();
      this.bindDocumentEvents();
      this.addAllRegions();
      this.hijackLinksAndForms();
      this.trigger('initialized');
      Mercury.trigger('initialized');
      return this.delay(100, this.focusDefaultRegion);
    };

    FrameInterface.prototype.reinitializeFrame = function() {
      if (this.frameLocation()) {
        this.initialized = false;
        this.regions = [];
        this.initializeFrame();
        return this.load(this.loadedJSON);
      } else {
        alert(this.t("You've left editing the page you were on, please refresh the page."));
        return this.release();
      }
    };

    FrameInterface.prototype.frameLocation = function() {
      var _ref1, _ref2;
      return (_ref1 = this.$frame.get(0)) != null ? (_ref2 = _ref1.contentWindow) != null ? _ref2.location.href : void 0 : void 0;
    };

    FrameInterface.prototype.setupDocument = function() {
      var _base;
      this.window = this.$frame.get(0).contentWindow;
      (_base = this.window).Mercury || (_base.Mercury = Mercury);
      this.window.Mercury["interface"] = this;
      return this.document = $(this.window.document);
    };

    FrameInterface.prototype.hide = function() {
      this.$frame.css({
        top: 0,
        height: '100%'
      });
      return FrameInterface.__super__.hide.apply(this, arguments);
    };

    FrameInterface.prototype.positionForRegion = function() {
      var frameOffset, offset;
      offset = FrameInterface.__super__.positionForRegion.apply(this, arguments);
      if (this.$frame.length) {
        frameOffset = this.$frame.offset();
        offset.top -= $('body', this.document).scrollTop();
        offset.left += frameOffset.left;
      }
      return offset;
    };

    FrameInterface.prototype.hijackLinksAndForms = function() {
      var $el, classname, el, ignored, nonHijackableClasses, regionSelector, _i, _j, _len, _len1, _ref1, _results;
      nonHijackableClasses = this.config('interface:nohijack') || [];
      regionSelector = "[" + (this.config('regions:attribute')) + "]";
      _ref1 = $('a, form', this.document);
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        el = _ref1[_i];
        $el = $(el);
        ignored = false;
        for (_j = 0, _len1 = nonHijackableClasses.length; _j < _len1; _j++) {
          classname = nonHijackableClasses[_j];
          if ($el.hasClass(classname)) {
            ignored = true;
            continue;
          }
        }
        if (!ignored && (el.target === '' || el.target === '_self') && !$el.closest(regionSelector).length) {
          _results.push($el.attr('target', '_parent'));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    FrameInterface.prototype.release = function() {
      var frameLocation;
      this.$frame.css({
        top: 0
      });
      $(this.window).off('scroll', this.onScroll);
      FrameInterface.__super__.release.apply(this, arguments);
      try {
        if (frameLocation = this.frameLocation()) {
          return Mercury.redirect(frameLocation);
        }
      } catch (_error) {}
    };

    FrameInterface.prototype.onScroll = function() {
      return this.position();
    };

    FrameInterface.prototype.onResize = function() {
      var position;
      position = FrameInterface.__super__.onResize.apply(this, arguments);
      if (position) {
        return this.$frame.css({
          top: position.top,
          height: position.height
        });
      }
    };

    return FrameInterface;

  })(Mercury.BaseInterface);

}).call(this);
(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Lightview = (function(_super) {
    __extends(Lightview, _super);

    function Lightview() {
      _ref = Lightview.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Lightview.logPrefix = 'Mercury.Lightview:';

    Lightview.className = 'mercury-dialog mercury-lightview';

    Lightview.elements = {
      dialog: '.mercury-lightview-dialog-positioner',
      content: '.mercury-lightview-dialog-content',
      contentContainer: '.mercury-lightview-dialog-content-container',
      titleContainer: '.mercury-lightview-dialog-title',
      title: '.mercury-lightview-dialog-title span'
    };

    Lightview.events = {
      'mercury:interface:resize': 'resize',
      'mercury:modals:hide': 'hide',
      'click .mercury-lightview-dialog-title em': 'hide'
    };

    Lightview.prototype.primaryTemplate = 'lightview';

    Lightview.prototype.releaseOnHide = true;

    Lightview.prototype.build = function() {
      Lightview.__super__.build.apply(this, arguments);
      return this.defaultPosition();
    };

    Lightview.prototype.defaultPosition = function() {
      return this.$dialog.css({
        marginTop: ($(window).height() - 75) / 2
      });
    };

    Lightview.prototype.resize = function(animate, dimensions) {
      var height, titleHeight;
      if (animate == null) {
        animate = true;
      }
      if (dimensions == null) {
        dimensions = null;
      }
      if (!this.visible) {
        return;
      }
      clearTimeout(this.showContentTimeout);
      if (typeof animate === 'object') {
        dimensions = animate;
        animate = false;
      }
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

    Lightview.prototype.onHide = function() {
      Lightview.__super__.onHide.apply(this, arguments);
      return this.delay(250, this.defaultPosition);
    };

    return Lightview;

  })(Mercury.Modal);

}).call(this);
(function() {
  var _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Panel = (function(_super) {
    __extends(Panel, _super);

    function Panel() {
      this.resize = __bind(this.resize, this);
      _ref = Panel.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Panel.include(Mercury.View.Modules.Draggable);

    Panel.logPrefix = 'Mercury.Panel:';

    Panel.className = 'mercury-dialog mercury-panel';

    Panel.elements = {
      content: '.mercury-panel-content',
      contentContainer: '.mercury-panel-content-container',
      titleContainer: '.mercury-panel-title',
      title: '.mercury-panel-title span'
    };

    Panel.events = {
      'mercury:interface:resize': 'resize',
      'mercury:panels:hide': 'hide',
      'mousedown .mercury-panel-title em': 'prevent',
      'mousedown .mercury-panel-title': 'startDrag',
      'click .mercury-panel-title em': 'hide'
    };

    Panel.prototype.primaryTemplate = 'panel';

    Panel.prototype.releaseOnHide = false;

    Panel.prototype.setWidth = function(width) {
      return this.css({
        width: width
      });
    };

    Panel.prototype.resize = function(animate, dimensions) {
      var height, titleHeight, _ref1;
      if (animate == null) {
        animate = true;
      }
      if (dimensions == null) {
        dimensions = null;
      }
      if (!this.visible) {
        return;
      }
      clearTimeout(this.showContentTimeout);
      if (typeof animate === 'object') {
        dimensions = animate;
        animate = false;
      }
      if (!animate) {
        this.addClass('mercury-no-animation');
      }
      if (dimensions || (dimensions = (_ref1 = Mercury["interface"]) != null ? typeof _ref1.dimensions === "function" ? _ref1.dimensions() : void 0 : void 0)) {
        this.css({
          top: dimensions.top + 10,
          bottom: dimensions.bottom + 10
        });
        if (this.$el.outerWidth() + this.$el.offset().left >= dimensions.width - 10) {
          this.css({
            left: ''
          });
        }
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

    Panel.prototype.onShow = function() {
      this.delay(1, this.resize);
      return Mercury.trigger('panels:hide');
    };

    Panel.prototype.onHide = function() {
      return Mercury.trigger('focus');
    };

    Panel.prototype.focusFirstFocusable = function() {};

    Panel.prototype.keepFocusConstrained = function() {};

    Panel.prototype.setPositionOnDrag = function(x) {
      if (x < 10) {
        x = 10;
      }
      if (x >= this.viewportSize.width - this.$el.outerWidth() - 10) {
        return this.css({
          left: ''
        });
      }
      return this.css({
        left: x
      });
    };

    return Panel;

  })(Mercury.Modal);

}).call(this);
(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Statusbar = (function(_super) {
    __extends(Statusbar, _super);

    function Statusbar() {
      _ref = Statusbar.__super__.constructor.apply(this, arguments);
      return _ref;
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
      if (Mercury["interface"].floating && this.visible) {
        return;
      }
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
      if (Mercury["interface"].floating) {
        return;
      }
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
      this.icon || (this.icon = (this.name || '').toDash());
      ToolbarButton.__super__.constructor.call(this, this.options);
      this.handleSpecial();
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
        if (this.standardOptions.indexOf(type) === -1) {
          this.types.push(type);
        }
      }
      return this.type = this.types[0];
    };

    ToolbarButton.prototype.build = function() {
      var _ref;
      this.registerPlugin();
      this.attr('data-type', this.type);
      if (this.options.title) {
        this.attr('title', this.t(this.options.title));
      }
      this.addClass("mercury-icon-" + this.icon);
      this.html("<em>" + (this.t(this.label)) + "</em>");
      return (_ref = this.buildSubview()) != null ? _ref.appendTo(this) : void 0;
    };

    ToolbarButton.prototype.handleSpecial = function() {
      if (this.event === 'save') {
        this.makeSaveButton();
      }
      if (this.mode) {
        return this.makeModeButton();
      }
    };

    ToolbarButton.prototype.makeSaveButton = function() {
      return this.delegateEvents({
        'mercury:save': function() {
          return this.addClass('mercury-loading-indicator');
        },
        'mercury:save:complete': function() {
          return this.removeClass('mercury-loading-indicator');
        }
      });
    };

    ToolbarButton.prototype.makeModeButton = function() {
      return this.delegateEvents({
        'mercury:mode': function(mode) {
          if (mode !== this.mode) {
            return;
          }
          if (this.isToggled) {
            return this.untoggled();
          } else {
            return this.toggled();
          }
        }
      });
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
        return this.subview = new Klass(options);
      }
    };

    ToolbarButton.prototype.triggerAction = function() {
      if (this.isDisabled()) {
        return;
      }
      if (this.toggle) {
        if (this.isToggled) {
          this.untoggled();
        } else {
          this.toggled();
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
      this.trigger('click');
      if (this.plugin || this.subview) {
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

    ToolbarButton.prototype.release = function() {
      var _ref;
      if ((_ref = this.subview) != null) {
        _ref.release();
      }
      return ToolbarButton.__super__.release.apply(this, arguments);
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
      var _ref, _ref1;
      if (region !== ((_ref = Mercury["interface"]) != null ? _ref.region : void 0)) {
        return;
      }
      if (!((_ref1 = this.subview) != null ? _ref1.visible : void 0)) {
        this.deactivate();
      }
      if (this.global || this.regionSupported(region)) {
        this.enable();
        if (region.hasContext(this.name, true) === true) {
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

    ToolbarButton.prototype.indicate = function(e) {
      var _ref;
      this.isIndicated = true;
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
      this.isIndicated = false;
      return this.removeClass('mercury-button-pressed');
    };

    ToolbarButton.prototype.isDisabled = function() {
      return !!(this.isEnabled === false || this.$el.closest('.mercury-button-disabled').length);
    };

    return ToolbarButton;

  })(Mercury.View);

}).call(this);
(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.ToolbarSelect = (function(_super) {
    __extends(ToolbarSelect, _super);

    function ToolbarSelect() {
      _ref = ToolbarSelect.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    ToolbarSelect.include(Mercury.View.Modules.InterfaceFocusable);

    ToolbarSelect.include(Mercury.View.Modules.ToolbarDialog);

    ToolbarSelect.include(Mercury.View.Modules.VisibilityToggleable);

    ToolbarSelect.logPrefix = 'Mercury.ToolbarSelect:';

    ToolbarSelect.className = 'mercury-dialog mercury-toolbar-select';

    ToolbarSelect.prototype.hidden = true;

    return ToolbarSelect;

  })(Mercury.View);

}).call(this);
(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.ToolbarExpander = (function(_super) {
    __extends(ToolbarExpander, _super);

    function ToolbarExpander() {
      _ref = ToolbarExpander.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    ToolbarExpander.logPrefix = 'Mercury.ToolbarExpander:';

    ToolbarExpander.className = 'mercury-toolbar-expander';

    ToolbarExpander.events = {
      'mercury:interface:resize': 'onResize',
      'mousedown': 'preventStop',
      'click': 'toggleExpander',
      'click li': 'onClickForButton'
    };

    ToolbarExpander.prototype.build = function() {
      return this.select = this.appendView(new Mercury.ToolbarSelect());
    };

    ToolbarExpander.prototype.show = function() {
      if (this.visible) {
        return;
      }
      this.visible = true;
      return this.$el.show();
    };

    ToolbarExpander.prototype.hide = function() {
      if (!this.visible) {
        return;
      }
      this.visible = false;
      return this.$el.hide();
    };

    ToolbarExpander.prototype.toggleExpander = function(e) {
      if (!this.visible) {
        return;
      }
      this.prevent(e, true);
      this.updateSelect();
      if (!this.select.visible) {
        Mercury.trigger('dialogs:hide');
      }
      return this.select.toggle();
    };

    ToolbarExpander.prototype.updateSelect = function() {
      var button, ul, _i, _len, _ref1, _results;
      this.select.html('<ul>');
      ul = this.select.$('ul');
      _ref1 = this.parent.hiddenButtons();
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        button = _ref1[_i];
        _results.push(ul.append($("<li class='" + button["class"] + "'>" + button.title + "</li>").data({
          button: button.el
        })));
      }
      return _results;
    };

    ToolbarExpander.prototype.onClickForButton = function(e) {
      this.prevent(e);
      return $($(e.target).closest('li').data('button')).click();
    };

    ToolbarExpander.prototype.onResize = function() {
      if (this.parent.el.scrollHeight > this.parent.$el.height() + 10) {
        this.show();
      } else {
        this.hide();
      }
      if (this.select.visible) {
        return this.updateSelect();
      }
    };

    return ToolbarExpander;

  })(Mercury.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  Mercury.ToolbarItem = (function(_super) {
    __extends(ToolbarItem, _super);

    ToolbarItem.logPrefix = 'Mercury.ToolbarItem:';

    function ToolbarItem(name, type, value, expander) {
      this.name = name != null ? name : 'unknown';
      this.type = type != null ? type : 'unknown';
      this.value = value != null ? value : null;
      this.expander = expander != null ? expander : false;
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
        this.buildSubview('sep-final', '-');
      }
      if (this.type === 'container' && this.expander) {
        return this.buildExpander();
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
        return this.appendView(item);
      }
    };

    ToolbarItem.prototype.buildExpander = function() {
      return this.appendView(new Mercury.ToolbarExpander({
        parent: this
      }));
    };

    ToolbarItem.prototype.addClasses = function() {
      var extraClass;
      extraClass = "mercury-toolbar-" + (this.type.toDash());
      if (this.value === '-') {
        extraClass = "mercury-toolbar-line-" + (this.type.toDash());
      }
      return this.addClass(["mercury-toolbar-" + (this.name.toDash()) + "-" + (this.type.toDash()), extraClass].join(' '));
    };

    ToolbarItem.prototype.hiddenButtons = function() {
      var button, buttons, el, height, top, _i, _len, _ref, _ref1;
      height = this.$el.height();
      buttons = [];
      _ref = this.$('.mercury-toolbar-button');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        button = _ref[_i];
        el = $(button);
        top = el.position().top;
        if (top >= height) {
          buttons.push({
            title: el.find('em').html(),
            "class": (_ref1 = el.attr('class')) != null ? _ref1.replace(/\s?mercury-toolbar-button\s?/, '') : void 0,
            el: el
          });
        }
      }
      return buttons;
    };

    return ToolbarItem;

  })(Mercury.View);

}).call(this);
(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Toolbar = (function(_super) {
    __extends(Toolbar, _super);

    function Toolbar() {
      _ref = Toolbar.__super__.constructor.apply(this, arguments);
      return _ref;
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
      'click': 'preventStop'
    };

    Toolbar.prototype.build = function() {
      this.append(new Mercury.ToolbarItem('primary', 'container', this.config('toolbars:primary'), true));
      return this.append(new Mercury.ToolbarItem('secondary', 'container', {}));
    };

    Toolbar.prototype.buildToolbar = function(name) {
      if (this.config("toolbars:" + name)) {
        return this.appendView(this.$toolbar.show(), new Mercury.ToolbarItem(name, 'collection', this.config("toolbars:" + name)));
      } else {
        return this.$toolbar.hide();
      }
    };

    Toolbar.prototype.show = function() {
      var _this = this;
      if (Mercury["interface"].floating && this.visible) {
        return;
      }
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
      if (Mercury["interface"].floating) {
        return;
      }
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
      if (Mercury["interface"].visible) {
        return this.$el.outerHeight();
      } else {
        return 0;
      }
    };

    Toolbar.prototype.onMousedown = function(e) {
      this.prevent(e);
      Mercury.trigger('dialogs:hide');
      return Mercury.trigger('focus');
    };

    Toolbar.prototype.onRegionFocus = function(region) {
      var name, _i, _len, _ref1;
      if (this.region === region) {
        return;
      }
      this.region = region;
      this.$('.mercury-toolbar-collection').remove();
      this.releaseSubviews();
      _ref1 = region.toolbars || [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        name = _ref1[_i];
        this.buildToolbar(name);
      }
      return Mercury.trigger('region:update', region);
    };

    return Toolbar;

  })(Mercury.View);

}).call(this);
(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.ToolbarPalette = (function(_super) {
    __extends(ToolbarPalette, _super);

    function ToolbarPalette() {
      _ref = ToolbarPalette.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    ToolbarPalette.include(Mercury.View.Modules.InterfaceFocusable);

    ToolbarPalette.include(Mercury.View.Modules.ToolbarDialog);

    ToolbarPalette.include(Mercury.View.Modules.VisibilityToggleable);

    ToolbarPalette.logPrefix = 'Mercury.ToolbarPalette:';

    ToolbarPalette.className = 'mercury-dialog mercury-toolbar-palette';

    ToolbarPalette.prototype.hidden = true;

    return ToolbarPalette;

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
        this.addError('size', this.t('Too large (max %s)', this.config('uploading:maxSize').toBytes()));
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
        dataType: false,
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
        return this.notify(this.t('Unable to process response: %s', 'no url'));
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
        return this.notify(this.t('Is unsupported in this browser'));
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
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Action.Link = (function(_super) {
    __extends(Link, _super);

    function Link() {
      _ref = Link.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Link.prototype.name = 'link';

    Link.prototype.asMarkdown = function() {
      return "[" + (this.get('text')) + "](" + (this.get('url')) + ")";
    };

    Link.prototype.asHtml = function() {
      var target;
      target = this.get('target') ? " target=\"" + (this.get('target')) + "\"" : '';
      return "<a href=\"" + (this.get('url')) + "\"" + target + ">" + (this.get('text')) + "</a>";
    };

    return Link;

  })(Mercury.Action);

}).call(this);
(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Action.Media = (function(_super) {
    __extends(Media, _super);

    function Media() {
      _ref = Media.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Media.prototype.name = 'media';

    Media.prototype.asMarkdown = function() {
      if (!!this.get('width') || !!this.get('height') || this.get('type') !== 'image') {
        return this.asHtml();
      } else {
        return "![](" + (this.get('src')) + ")";
      }
    };

    Media.prototype.asHtml = function() {
      if (this.get('type') === 'image') {
        return "<img src=\"" + (this.get('src')) + "\" align=\"" + (this.get('align')) + "\" width=\"" + (this.get('width')) + "\" height=\"" + (this.get('height')) + "\"/>";
      } else {
        return "<iframe src=\"" + (this.get('src')) + "\" width=\"" + (this.get('width')) + "\" height=\"" + (this.get('height')) + "\" frameborder=\"0\" allowFullScreen></iframe>";
      }
    };

    return Media;

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
      if (this.editableDropBehavior == null) {
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
      if (this.previewing) {
        return;
      }
      if (Mercury.dragHack && !this.onDropSnippet) {
        return;
      }
      if (!Mercury.dragHack && !this.onDropItem && !this.onDropFile) {
        return;
      }
      this.$dropIndicator.css(this.dropIndicatorPosition());
      this.$dropIndicator.removeClass('mercury-region-snippet-drop-indicator');
      if (Mercury.dragHack) {
        this.$dropIndicator.addClass('mercury-region-snippet-drop-indicator');
      }
      return this.$dropIndicator.addClass('mercury-shown');
    },
    hideDropIndicator: function() {
      return this.$dropIndicator.removeClass('mercury-shown');
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
      var resize, value;
      if (this.editableDropBehavior == null) {
        this.editableDropBehavior = true;
      }
      value = this.originalContent();
      resize = this.options.autoSize ? 'none' : 'vertical';
      this.$preview = $("<div class=\"mercury-" + this.constructor.type + "-region-preview\">");
      this.$focusable = $("<textarea class=\"mercury-" + this.constructor.type + "-region-textarea\" placeholder=\"" + this.placeholder + "\">");
      if (!this.options.wrapping) {
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
      this.delay(1, this.resizeFocusable);
      return this.delegateEvents({
        'keydown textarea': 'handleKeyEvent'
      });
    },
    originalContent: function() {
      return this.html().replace('&gt;', '>').replace('&lt;', '<').trim();
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
      if (!this.options.autoSize) {
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
    elementFromValue: function(val) {
      if (val.is) {
        return val.get(0);
      } else {
        return $(val).get(0);
      }
    },
    getSelection: function() {
      return rangy.getSelection(this.document);
    },
    getSerializedSelection: function() {
      return rangy.serializeSelection(this.getSelection(), false);
    },
    getSelectedNode: function() {
      var parent, range, sel;
      sel = this.getSelection();
      if (!(sel.rangeCount > 0)) {
        return this.document.body;
      }
      range = sel.getRangeAt(0);
      parent = range.commonAncestorContainer;
      if (parent.nodeType === 3) {
        return parent.parentNode;
      } else {
        return parent;
      }
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
      var range, select, _i, _len, _ref, _results;
      select = this.selection ? this.restoreSelection() : this.getSelection();
      if (typeof val === 'string' || val.is) {
        val = this.elementFromValue(val);
      }
      _ref = selection.getAllRanges();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        range = _ref[_i];
        range.deleteContents();
        _results.push(range.insertNode(val));
      }
      return _results;
    },
    restoreSelection: function() {
      this.setSerializedSelection(this.selection);
      return this.selection = null;
    },
    setSerializedSelection: function(sel) {
      if (rangy.canDeserializeSelection(sel)) {
        return rangy.deserializeSelection(sel, null, Mercury["interface"].window);
      }
    },
    saveSelection: function() {
      return this.selection = this.getSerializedSelection();
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
  Mercury.Region.Modules.Snippetable = {
    included: function() {
      return this.on('action', this.restoreSnippets);
    },
    restoreSnippets: function() {
      var $el, el, _i, _len, _ref;
      _ref = this.$("[data-mercury-snippet]");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        el = _ref[_i];
        $el = $(el);
        if (!$el.data('snippet')) {
          Mercury.Snippet.find($el.data('mercury-snippet')).replaceWithView($el);
        }
      }
      return typeof this.onLoadSnippet === "function" ? this.onLoadSnippet() : void 0;
    },
    snippets: function() {
      var el, snippet, snippets, _i, _len, _ref;
      snippets = {};
      _ref = this.$('[data-mercury-snippet]');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        el = _ref[_i];
        snippet = Mercury.Snippet.find($(el).data('mercury-snippet'));
        snippets[snippet.cid] = snippet.toJSON();
      }
      return snippets;
    },
    loadSnippets: function(json) {
      var cid, data, _results;
      if (json == null) {
        json = {};
      }
      this.clearStack();
      _results = [];
      for (cid in json) {
        data = json[cid];
        _results.push(this.loadSnippet(cid, data));
      }
      return _results;
    },
    loadSnippet: function(cid, data) {
      var _this = this;
      return Mercury.Snippet.fromSerializedJSON(data).renderAndReplaceWithView(this.$("[data-mercury-snippet=" + cid + "]"), function() {
        try {
          _this.initialValue = JSON.stringify(_this.toJSON());
          _this.pushHistory();
          return typeof _this.onLoadSnippet === "function" ? _this.onLoadSnippet() : void 0;
        } catch (_error) {}
      });
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
    var e, map, _fn, _i, _len,
      _this = this;
    this.version = '2.0.1 pre alpha';
    this.JST = window.JST || {};
    this.init = function(options) {
      if (options == null) {
        options = {};
      }
      if (this["interface"]) {
        return;
      }
      this.trigger('configure');
      this["interface"] = new this[this.config('interface:class')](options);
      this.load(this.loadedJSON || {});
      return this["interface"];
    };
    this.load = function(json) {
      if (json == null) {
        json = {};
      }
      this.loadedJSON = json;
      if (!this["interface"]) {
        return;
      }
      this["interface"].load(this.loadedJSON);
      return delete this.loadedJSON;
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
    this.redirect = function(url) {
      return window.location.assign(url);
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
    map = ['focus', 'blur', 'save', 'initialize', 'reinitialize', 'interface:toggle', 'interface:show', 'interface:hide'];
    _fn = function(e) {
      return _this[e.replace('interface:', '')] = function() {
        return this.trigger(e);
      };
    };
    for (_i = 0, _len = map.length; _i < _len; _i++) {
      e = map[_i];
      _fn(e);
    }
    this.Module.extend.call(this, this.Events);
    this.Module.extend.call(this, this.I18n);
    this.Module.extend.call(this, this.Logger);
    this.Module.extend.call(this, this.Plugin);
    this.Module.extend.call(this, this.Snippet);
    this.support = {
      webkit: navigator.userAgent.indexOf('WebKit') > 0,
      safari: navigator.userAgent.indexOf('Safari') > 0 && navigator.userAgent.indexOf('Chrome') === -1,
      chrome: navigator.userAgent.indexOf('Chrome') > 0,
      gecko: navigator.userAgent.indexOf('Firefox') > 0,
      trident: navigator.userAgent.indexOf('MSIE') > 0,
      ie10: navigator.userAgent.match(/MSIE\s([\d|\.]+)/) && parseFloat(isIE[1], 10) >= 10
    };
    this.support.wysiwyg = document.designMode && (!this.support.trident || this.support.ie10);
    if (this.support.gecko && parseFloat(navigator.userAgent.match(/Firefox\/([\d|\.]+)/)[1], 10) < 22) {
      return this.support.wysiwyg = false;
    }
  };

  initialize.call(this.MockMercury || this.Mercury);

}).call(this);
(function() {
  var Plugin, _ref,
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
        pre: 'Formatted'
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
      _ref = Select.__super__.constructor.apply(this, arguments);
      return _ref;
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

  JST['/mercury/templates/blocks'] = function() {
    var block, text;
    return "<ul>" + (((function() {
      var _ref1, _results;
      _ref1 = Plugin.config('blocks');
      _results = [];
      for (block in _ref1) {
        text = _ref1[block];
        _results.push("<li data-value='" + block + "'><" + block + ">" + text + "</" + block + "></li>");
      }
      return _results;
    })()).join('')) + "</ul>";
  };

}).call(this);
(function() {
  var Plugin, _ref, _ref1,
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
      _ref = Modal.__super__.constructor.apply(this, arguments);
      return _ref;
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
      _ref1 = Palette.__super__.constructor.apply(this, arguments);
      return _ref1;
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

  JST['/mercury/templates/character'] = function() {
    var char;
    return "<ul>" + (((function() {
      var _i, _len, _ref2, _results;
      _ref2 = Plugin.config('characters').split(' ');
      _results = [];
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        char = _ref2[_i];
        _results.push("<li data-value='" + char + "'>&#" + char + ";</li>");
      }
      return _results;
    })()).join('')) + "</ul>";
  };

}).call(this);
(function() {
  var Plugin, _ref,
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
      _ref = Palette.__super__.constructor.apply(this, arguments);
      return _ref;
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

  JST['/mercury/templates/color'] = function() {
    var color;
    return "<ul>\n  " + (((function() {
      var _i, _len, _ref1, _results;
      _ref1 = Plugin.config('colors').split(' ');
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        color = _ref1[_i];
        _results.push("<li data-value='" + color + "' style='background:#" + color + "'></li>");
      }
      return _results;
    })()).join('')) + "\n  <li class=\"last-picked\">Last Color Picked</li>\n</ul>";
  };

}).call(this);
(function() {
  var Plugin, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('history', {
    description: 'Provides interface for selecting saved versions -- requires server implementation.',
    version: '1.0.0',
    registerButton: function() {
      return this.button.set({
        type: 'history',
        global: true,
        toggle: true,
        subview: new Plugin.Panel()
      });
    }
  });

  Plugin.Panel = (function(_super) {
    __extends(Panel, _super);

    function Panel() {
      _ref = Panel.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Panel.prototype.mixins = [Mercury.View.Modules.FilterableList];

    Panel.prototype.template = 'history';

    Panel.prototype.className = 'mercury-history-panel';

    Panel.prototype.title = 'Page Version History';

    Panel.prototype.width = 300;

    Panel.prototype.hidden = true;

    return Panel;

  })(Mercury.Panel);

}).call(this);
(function() {
  var Plugin, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('link', {
    description: 'Provides interface for inserting and editing links.',
    version: '1.0.0',
    actions: {
      link: 'insert'
    },
    events: {
      'mercury:edit:link': 'onButtonClick'
    },
    registerButton: function() {
      return this.button.set({
        type: 'link'
      });
    },
    onButtonClick: function() {
      return this.bindTo(new Plugin.Modal());
    },
    bindTo: function(view) {
      var _this = this;
      return view.on('form:submitted', function(value) {
        return _this.triggerAction(value);
      });
    },
    insert: function(name, value) {
      return Mercury.trigger('action', name, value);
    }
  });

  Plugin.Modal = (function(_super) {
    __extends(Modal, _super);

    function Modal() {
      _ref = Modal.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Modal.prototype.template = 'link';

    Modal.prototype.className = 'mercury-link-modal';

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
            url: "#" + (this.$('#link_existing_bookmark').val())
          };
          break;
        case 'new_bookmark':
          attrs = {
            name: "" + (this.$('#link_new_bookmark').val())
          };
          break;
        default:
          attrs = {
            url: this.$("#link_" + type).val()
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
          attrs['url'] = "javascript:void(window.open('" + attrs['url'] + "','popup_window','" + (Object.toParams(args).replace(/&/g, ',')) + "'))";
          break;
        default:
          attrs['target'] = target || "self";
      }
      attrs['text'] = this.content || content;
      this.trigger('form:submitted', attrs);
      return this.hide();
    };

    return Modal;

  })(Mercury.Modal);

  JST['/mercury/templates/link'] || (JST['/mercury/templates/link'] = function() {
    return "<form class=\"form-horizontal\">\n\n  <fieldset class=\"link_text_container\">\n    <div class=\"control-group string required\">\n      <label class=\"string required control-label\" for=\"link_text\">Link Content</label>\n      <div class=\"controls\">\n        <input class=\"string required\" id=\"link_text\" name=\"link[text]\" size=\"50\" type=\"text\" tabindex=\"1\">\n      </div>\n    </div>\n  </fieldset>\n\n  <fieldset>\n    <legend>Standard Links</legend>\n    <div class=\"control-group url optional\">\n      <label class=\"url optional control-label\" for=\"link_external_url\">\n        <input name=\"link_type\" type=\"radio\" value=\"external_url\" checked=\"checked\" tabindex=\"-1\"/>URL\n      </label>\n      <div class=\"controls\">\n        <input class=\"string url optional\" id=\"link_external_url\" name=\"link[external_url]\" size=\"50\" type=\"text\" tabindex=\"1\">\n      </div>\n    </div>\n  </fieldset>\n\n  <fieldset>\n    <legend>Index / Bookmark Links</legend>\n    <div class=\"control-group select optional\">\n      <label class=\"select optional control-label\" for=\"link_existing_bookmark\">\n        <input name=\"link_type\" type=\"radio\" value=\"existing_bookmark\" tabindex=\"-1\"/>Existing Links\n      </label>\n      <div class=\"controls\">\n        <select class=\"select optional\" id=\"link_existing_bookmark\" name=\"link[existing_bookmark]\" tabindex=\"1\"></select>\n      </div>\n    </div>\n    <div class=\"control-group string optional\">\n      <label class=\"string optional control-label\" for=\"link_new_bookmark\">\n        <input name=\"link_type\" type=\"radio\" value=\"new_bookmark\" tabindex=\"-1\"/>Bookmark\n      </label>\n      <div class=\"controls\">\n        <input class=\"string optional\" id=\"link_new_bookmark\" name=\"link[new_bookmark]\" type=\"text\" tabindex=\"1\">\n      </div>\n    </div>\n  </fieldset>\n\n  <fieldset>\n    <legend>Options</legend>\n    <div class=\"control-group select optional\">\n      <label class=\"select optional control-label\" for=\"link_target\">Link Target</label>\n      <div class=\"controls\">\n        <select class=\"select optional\" id=\"link_target\" name=\"link[target]\" tabindex=\"1\">\n          <option value=\"\">Self (the same window or tab)</option>\n          <option value=\"_blank\">Blank (a new window or tab)</option>\n          <option value=\"_top\">Top (removes any frames)</option>\n          <option value=\"popup\">Popup Window (javascript new window popup)</option>\n        </select>\n      </div>\n    </div>\n    <div id=\"popup_options\" class=\"link-target-options\" style=\"display:none\">\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"link_popup_width\">Popup Width</label>\n        <div class=\"controls\">\n          <input class=\"number optional\" id=\"link_popup_width\" name=\"link[popup_width]\" type=\"number\" value=\"960\" tabindex=\"1\">\n        </div>\n      </div>\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"link_popup_height\">Popup Height</label>\n        <div class=\"controls\">\n          <input class=\"number optional\" id=\"link_popup_height\" name=\"link[popup_height]\" type=\"number\" value=\"800\" tabindex=\"1\">\n        </div>\n      </div>\n    </div>\n  </fieldset>\n\n  <div class=\"form-actions\">\n    <input class=\"btn btn-primary\" name=\"commit\" type=\"submit\" value=\"Insert Link\" tabindex=\"2\">\n  </div>\n</form>";
  });

}).call(this);
(function() {
  var Plugin, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('media', {
    description: 'Provides interface for inserting and editing media.',
    version: '1.0.0',
    actions: {
      media: 'insert'
    },
    events: {
      'mercury:edit:media': 'onButtonClick'
    },
    registerButton: function() {
      return this.button.set({
        type: 'media'
      });
    },
    onButtonClick: function() {
      return this.bindTo(new Plugin.Modal());
    },
    bindTo: function(view) {
      var _this = this;
      return view.on('form:submitted', function(value) {
        return _this.triggerAction(value);
      });
    },
    insert: function(name, value) {
      return Mercury.trigger('action', name, value);
    }
  });

  Plugin.Modal = (function(_super) {
    __extends(Modal, _super);

    function Modal() {
      _ref = Modal.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Modal.prototype.template = 'media';

    Modal.prototype.className = 'mercury-media-modal';

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
              this.addInputError($el, this.t('Is invalid'));
            }
            break;
          case 'vimeo_url':
            if (!/^https?:\/\/youtu.be\//.test($el.val())) {
              this.addInputError($el, this.t('Is invalid'));
            }
        }
      } else {
        this.addInputError($el, this.t("Can't be blank"));
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
            width: parseInt(this.$('#media_image_width').val(), 10) || "",
            height: parseInt(this.$('#media_image_height').val(), 10) || "",
            align: this.$('#media_image_alignment').val(),
            float: this.$('#media_image_float').val()
          };
      }
      this.trigger('form:submitted', attrs);
      return this.hide();
    };

    return Modal;

  })(Mercury.Modal);

  JST['/mercury/templates/media'] || (JST['/mercury/templates/media'] = function() {
    return "<form class=\"form-horizontal\">\n\n  <fieldset>\n    <legend>Images</legend>\n    <div class=\"control-group url optional\">\n      <label class=\"url optional control-label\" for=\"media_image_url\">\n        <input name=\"media_type\" type=\"radio\" value=\"image_url\" checked=\"checked\" tabindex=\"-1\"/>URL\n      </label>\n      <div class=\"controls\">\n        <input class=\"string url optional\" id=\"media_image_url\" name=\"media[image_url]\" size=\"50\" type=\"text\" tabindex=\"1\">\n      </div>\n    </div>\n  </fieldset>\n\n  <fieldset>\n    <legend>Videos</legend>\n    <div class=\"control-group url optional\">\n      <label class=\"url optional control-label\" for=\"media_youtube_url\">\n        <input name=\"media_type\" type=\"radio\" value=\"youtube_url\" tabindex=\"-1\"/>YouTube URL\n      </label>\n      <div class=\"controls\">\n        <input class=\"string url optional\" id=\"media_youtube_url\" name=\"media[youtube_url]\" size=\"50\" type=\"text\" placeholder=\"http://youtu.be/28tZ-S1LFok\" tabindex=\"1\">\n      </div>\n    </div>\n    <div class=\"control-group url optional\">\n      <label class=\"url optional control-label\" for=\"media_vimeo_url\">\n        <input name=\"media_type\" type=\"radio\" value=\"vimeo_url\" tabindex=\"-1\"/>Vimeo URL\n      </label>\n      <div class=\"controls\">\n        <input class=\"string url optional\" id=\"media_vimeo_url\" name=\"media[vimeo_url]\" size=\"50\" type=\"text\" placeholder=\"http://vimeo.com/36684976\" tabindex=\"1\">\n      </div>\n    </div>\n  </fieldset>\n\n  <fieldset>\n    <legend>Options</legend>\n\n    <div class=\"media-options\" id=\"image_url_options\">\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"media_image_width\">Width</label>\n        <div class=\"controls\">\n          <input class=\"number optional\" id=\"media_image_width\" name=\"media[image_width]\" size=\"50\" type=\"number\" value=\"\" tabindex=\"1\">\n        </div>\n      </div>\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"media_image_height\">Height</label>\n        <div class=\"controls\">\n          <input class=\"number optional\" id=\"media_image_height\" name=\"media[image_height]\" size=\"50\" type=\"number\" value=\"\" tabindex=\"1\">\n        </div>\n      </div>\n      <div class=\"control-group select optional\">\n        <label class=\"select optional control-label\" for=\"media_image_alignment\">Alignment</label>\n        <div class=\"controls\">\n          <select class=\"select optional\" id=\"media_image_alignment\" name=\"media[image_alignment]\" tabindex=\"1\">\n            <option value=\"\">None</option>\n            <option value=\"left\">Left</option>\n            <option value=\"right\">Right</option>\n            <option value=\"top\">Top</option>\n            <option value=\"middle\">Middle</option>\n            <option value=\"bottom\">Bottom</option>\n            <option value=\"absmiddle\">Absolute Middle</option>\n            <option value=\"absbottom\">Absolute Bottom</option>\n          </select>\n        </div>\n      </div>\n      <div class=\"control-group select optional\">\n        <label class=\"select optional control-label\" for=\"media_image_float\">Float</label>\n        <div class=\"controls\">\n          <select class=\"select optional\" id=\"media_image_float\" name=\"media[image_float]\" tabindex=\"1\">\n            <option value=\"\">None</option>\n            <option value=\"left\">Left</option>\n            <option value=\"right\">Right</option>\n            <option value=\"inherit\">Inherit</option>\n          </select>\n        </div>\n      </div>\n    </div>\n\n    <div class=\"media-options\" id=\"youtube_url_options\" style=\"display:none\">\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"media_youtube_width\">Width</label>\n        <div class=\"controls\">\n          <input class=\"number optional\" id=\"media_youtube_width\" name=\"media[youtube_width]\" size=\"50\" type=\"number\" value=\"560\" tabindex=\"1\">\n        </div>\n      </div>\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"media_youtube_height\">Height</label>\n        <div class=\"controls\">\n          <input class=\"number optional\" id=\"media_youtube_height\" name=\"media[youtube_height]\" size=\"50\" type=\"number\" value=\"349\" tabindex=\"1\">\n        </div>\n      </div>\n    </div>\n\n    <div class=\"media-options\" id=\"vimeo_url_options\" style=\"display:none\">\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"media_vimeo_width\">Width</label>\n        <div class=\"controls\">\n          <input class=\"number optional\" id=\"media_vimeo_width\" name=\"media[vimeo_width]\" size=\"50\" type=\"number\" value=\"400\" tabindex=\"1\">\n        </div>\n      </div>\n      <div class=\"control-group number optional\">\n        <label class=\"number optional control-label\" for=\"media_vimeo_height\">Height</label>\n        <div class=\"controls\">\n          <input class=\"number optional\" id=\"media_vimeo_height\" name=\"media[vimeo_height]\" size=\"50\" type=\"number\" value=\"225\" tabindex=\"1\">\n        </div>\n      </div>\n    </div>\n  </fieldset>\n\n  <div class=\"form-actions\">\n    <input class=\"btn btn-primary\" name=\"commit\" type=\"submit\" value=\"Insert Media\" tabindex=\"2\"/>\n  </div>\n</form>";
  });

}).call(this);
(function() {
  var Plugin, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('notes', {
    description: 'Provides interface for reading and adding notes for the page -- requires server implementation.',
    version: '1.0.0',
    registerButton: function() {
      return this.button.set({
        type: 'notes',
        global: true,
        toggle: true,
        subview: new Plugin.Panel()
      });
    }
  });

  Plugin.Panel = (function(_super) {
    __extends(Panel, _super);

    function Panel() {
      _ref = Panel.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Panel.prototype.template = 'notes';

    Panel.prototype.className = 'mercury-notes-panel';

    Panel.prototype.title = 'Page Notes';

    Panel.prototype.width = 250;

    Panel.prototype.hidden = true;

    return Panel;

  })(Mercury.Panel);

  JST['/mercury/templates/notes'] = function() {
    return "<p>The Notes Plugin expects a server implementation.</p>\n<p>Since this is a demo, it wasn't included, but you can check the <a href=\"https://github.com/jejacks0n/mercury-rails\">mercury-rails project</a> on github for examples of how to integrate it with your server technology.</p>";
  };

}).call(this);
(function() {
  var Plugin, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('snippets', {
    description: 'Provides interface for adding snippets to various regions -- may require server implementation.',
    version: '1.0.0',
    config: {
      toggleOnSnippetRegion: false
    },
    actions: {
      snippet: 'insert'
    },
    registerButton: function() {
      return this.button.set({
        type: 'snippets',
        global: true,
        toggle: true,
        subview: this.bindTo(this.panel = new Plugin.Panel())
      });
    },
    bindTo: function(view) {
      var _this = this;
      return view.on('insert:snippet', function(value) {
        return _this.triggerAction(value);
      });
    },
    insert: function(name, snippetName) {
      var snippet;
      snippet = Mercury.getSnippet(snippetName, true).on('rendered', function(view) {
        return Mercury.trigger('action', name, snippet, view);
      });
      return snippet.initialize(this.region);
    },
    onRegionFocus: function(region) {
      this.region = region;
      if (!this.config('toggleOnSnippetRegion')) {
        return;
      }
      if (this.region === this.lastRegion) {
        return;
      }
      this.lastRegion = this.region;
      return this.togglePanelByRegion();
    },
    togglePanelByRegion: function() {
      if (!this.panel) {
        return;
      }
      if (this.region.type() === 'snippet') {
        if (!this.panel.visible) {
          this.shownByRegion = true;
        }
        return this.panel.show();
      } else if (this.shownByRegion) {
        this.panel.hide();
        return this.shownByRegion = false;
      }
    }
  });

  Plugin.Panel = (function(_super) {
    __extends(Panel, _super);

    function Panel() {
      _ref = Panel.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Panel.prototype.mixins = [Mercury.View.Modules.FilterableList];

    Panel.prototype.template = 'snippets';

    Panel.prototype.className = 'mercury-snippets-panel';

    Panel.prototype.title = 'Snippets Panel';

    Panel.prototype.width = 300;

    Panel.prototype.hidden = true;

    Panel.prototype.events = {
      'click input.btn': function(e) {
        return this.trigger('insert:snippet', $(e.target).closest('[data-value]').data('value'));
      }
    };

    Panel.prototype.update = function() {
      var items;
      Panel.__super__.update.apply(this, arguments);
      items = this.$('li');
      return items.on('dragend', function() {
        return Mercury.dragHack = false;
      }).on('dragstart', function(e) {
        Mercury.dragHack = true;
        return e.originalEvent.dataTransfer.setData('snippet', $(e.target).data('value'));
      });
    };

    return Panel;

  })(Mercury.Panel);

  JST['/mercury/templates/snippets'] = function() {
    var controls, name, ret, snippet, _ref1;
    controls = "<div class=\"mercury-snippet-actions\">Drag or <input type=\"button\" value=\"Insert\" class=\"btn\"></div>";
    ret = '<input type="search" class="mercury-filter"><ul>';
    _ref1 = Mercury.Snippet.all();
    for (name in _ref1) {
      snippet = _ref1[name];
      ret += "<li data-filter=\"" + name + "\" data-value=\"" + name + "\">" + snippet.title + "<em>" + snippet.description + "</em>" + controls + "</li>";
    }
    return ret + '</ul>';
  };

}).call(this);
(function() {
  var Plugin, _ref,
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
      _ref = Select.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Select.prototype.template = 'styles';

    Select.prototype.className = 'mercury-styles-select';

    Select.prototype.events = {
      'click li': function(e) {
        return this.trigger('style:picked', $(e.target).data('value'));
      }
    };

    return Select;

  })(Mercury.ToolbarSelect);

  JST['/mercury/templates/styles'] = function() {
    var style, text;
    return "<ul>" + (((function() {
      var _ref1, _results;
      _ref1 = Plugin.config('styles');
      _results = [];
      for (style in _ref1) {
        text = _ref1[style];
        _results.push("<li data-value='" + style + "' class='" + style + "'>" + text + "</li>");
      }
      return _results;
    })()).join('')) + "</ul>";
  };

}).call(this);
(function() {
  var Plugin, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Plugin = Mercury.registerPlugin('table', {
    description: 'Provides interface for inserting and editing tables.',
    version: '1.0.0',
    actions: {
      table: 'insert'
    },
    events: {
      'mercury:edit:table': 'onButtonClick'
    },
    registerButton: function() {
      return this.button.set({
        type: 'table'
      });
    },
    onButtonClick: function() {
      return this.bindTo(new Plugin.Modal());
    },
    bindTo: function(view) {
      var _this = this;
      return view.on('form:submitted', function(value) {
        return _this.triggerAction(value);
      });
    },
    insert: function(name, editor) {
      return Mercury.trigger('action', name, editor);
    }
  });

  Plugin.Modal = (function(_super) {
    __extends(Modal, _super);

    function Modal() {
      _ref = Modal.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Modal.prototype.template = 'table';

    Modal.prototype.className = 'mercury-table-modal';

    Modal.prototype.title = 'Table Manager';

    Modal.prototype.width = 600;

    Modal.prototype.elements = {
      table: 'table'
    };

    Modal.prototype.events = {
      'click table': 'onCellClick',
      'click [data-action]': 'onActionClick'
    };

    Modal.prototype.update = function() {
      Modal.__super__.update.apply(this, arguments);
      return this.editor = new Mercury.TableEditor(this.$table, '&nbsp;');
    };

    Modal.prototype.onCellClick = function(e) {
      return this.editor.setCell($(e.target));
    };

    Modal.prototype.onActionClick = function(e) {
      this.prevent(e);
      return this.editor[$(e.target).closest('[data-action]').data('action')]();
    };

    Modal.prototype.onSubmit = function() {
      this.trigger('form:submitted', this.editor);
      return this.hide();
    };

    return Modal;

  })(Mercury.Modal);

  JST['/mercury/templates/table'] || (JST['/mercury/templates/table'] = function() {
    return "<form class=\"form-horizontal\">\n\n  <fieldset class=\"table-control\">\n    <table>\n      <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>\n      <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>\n      <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>\n    </table>\n  </fieldset>\n\n  <fieldset>\n    <div class=\"control-group buttons optional\">\n      <label class=\"buttons optional control-label\">Rows</label>\n      <div class=\"controls btn-group\">\n        <button class=\"btn\" data-action=\"addRowBefore\">Before</button>\n        <button class=\"btn\" data-action=\"addRowAfter\">After</button>\n        <button class=\"btn\" data-action=\"removeRow\">Remove</button>\n      </div>\n    </div>\n    <div class=\"control-group buttons optional\">\n      <label class=\"buttons optional control-label\">Columns</label>\n      <div class=\"controls btn-group\">\n        <button class=\"btn\" data-action=\"addColumnBefore\">Before</button>\n        <button class=\"btn\" data-action=\"addColumnAfter\">After</button>\n        <button class=\"btn\" data-action=\"removeColumn\">Remove</button>\n      </div>\n    </div>\n\n    <hr/>\n\n    <div class=\"control-group buttons optional\">\n      <label class=\"buttons optional control-label\">Row Span</label>\n      <div class=\"controls btn-group\">\n        <button class=\"btn\" data-action=\"increaseRowspan\">+</button>\n        <button class=\"btn\" data-action=\"decreaseRowspan\">-</button>\n      </div>\n    </div>\n    <div class=\"control-group buttons optional\">\n      <label class=\"buttons optional control-label\">Column Span</label>\n      <div class=\"controls btn-group\">\n        <button class=\"btn\" data-action=\"increaseColspan\">+</button>\n        <button class=\"btn\" data-action=\"decreaseColspan\">-</button>\n      </div>\n    </div>\n  </fieldset>\n\n  <fieldset>\n    <legend>Options</legend>\n    <div class=\"control-group select optional\">\n      <label class=\"select optional control-label\" for=\"table_alignment\">Alignment</label>\n      <div class=\"controls\">\n        <select class=\"select optional\" id=\"table_alignment\" name=\"table[align]\">\n          <option value=\"\">None</option>\n          <option value=\"right\">Right</option>\n          <option value=\"left\">Left</option>\n        </select>\n      </div>\n    </div>\n  </fieldset>\n\n  <div class=\"form-actions\">\n    <input class=\"btn btn-primary\" name=\"commit\" type=\"submit\" value=\"Insert Table\"/>\n  </div>\n</form>";
  });

}).call(this);
