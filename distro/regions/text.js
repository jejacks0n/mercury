
/*!
The Text region is a multiline plain text input. This region can be used to collect only text in cases when you don't
want to allow more complex HTML. It's up to you to render <br> tags when displaying the content within the page.

Configuration:
  regions:text:
    autoSize : true                                      # the region will auto-resize to the content within it
    wrapping : true                                      # enables/disables soft line wrapping
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
