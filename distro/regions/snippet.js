/*!
The snippet region isn't editable per se, and only allows placing snippets within it. Snippets can then be edited,
reordered or removed. This region provides a lot of controlled functionality and is especially useful if you're
providing complex elements that might need more tailoring than regular html allows.
*/


(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Region.Snippet = (function(_super) {
    __extends(Snippet, _super);

    function Snippet() {
      _ref = Snippet.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Snippet.include(Mercury.Region.Modules.DropIndicator);

    Snippet.include(Mercury.Region.Modules.Snippetable);

    Snippet.define('Mercury.Region.Snippet', 'snippet');

    Snippet.supported = true;

    Snippet.prototype.skipHistoryOn = ['undo', 'redo'];

    Snippet.prototype.onDropSnippet = function(snippet) {
      var _this = this;
      return snippet.on('rendered', function(view) {
        _this.focus();
        return _this.handleAction('snippet', snippet, view);
      });
    };

    return Snippet;

  })(Mercury.Region);

  Mercury.Region.Snippet.addToolbar({
    general: {
      remove: ['Remove Snippet']
    }
  });

  Mercury.Region.Snippet.addAction({
    remove: function() {
      return console.debug('remove');
    },
    snippet: function(snippet) {
      this.append(snippet.getRenderedView(this));
      return this.pushHistory();
    }
  });

}).call(this);
