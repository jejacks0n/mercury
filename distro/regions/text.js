
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

    Text.include(Mercury.Region.Modules.TextSelection);

    Text.include(Mercury.Region.Modules.SelectionValue);

    Text.supported = true;

    Text.prototype.originalContent = function() {
      return this.html().replace('&gt;', '>').replace('&lt;', '<').trim().replace(/<br\s*\/?>/gi, '\n');
    };

    return Text;

  })(Mercury.Region);

}).call(this);
