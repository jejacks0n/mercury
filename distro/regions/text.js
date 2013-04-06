
/*!
The Text region is a simple multiline textarea region. It's up to you to put <br> tags in as line breaks if you want
them when you render the content.
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Region.Text = (function(_super) {

    __extends(Text, _super);

    function Text() {
      return Text.__super__.constructor.apply(this, arguments);
    }

    Text.define('Mercury.Region.Text', 'text');

    Text.include(Mercury.Region.Modules.FocusableTextarea);

    Text.supported = true;

    Text.prototype.value = function(value) {
      var _ref, _ref1;
      if (value == null) {
        value = null;
      }
      if (value === null || typeof value === 'undefined') {
        if (!this.config('regions:text:stripTags')) {
          return this.focusable.val();
        }
        return this.sanitizedValue();
      }
      if (this.config('regions:text:stripTags')) {
        this.focusable.val($('<div>').html(((_ref = value.val) != null ? _ref : value).replace(/<br\/?>/g, '\n').trim()).text());
      } else {
        this.focusable.val((_ref1 = value.val) != null ? _ref1 : value);
      }
      if (value.sel) {
        return this.setSerializedSelection(value.sel);
      }
    };

    Text.prototype.sanitizedValue = function() {
      var div;
      div = $('<div>').html(this.focusable.val().trim().replace(/\n/g, '<span>[!!!br!!!]</span>'));
      return div.text().replace(/\[!!!br!!!\]/g, '<br>');
    };

    return Text;

  })(Mercury.Region);

}).call(this);
