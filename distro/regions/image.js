
/*!
The Image region allows you to have a replaceable image region on your page. It provided the ability to drag/drop images
from the desktop -- which will get uploaded (and probably processed by your server) and will then replace the existing
image with the one that was uploaded.
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.ImageRegion = (function(_super) {

    __extends(ImageRegion, _super);

    function ImageRegion() {
      return ImageRegion.__super__.constructor.apply(this, arguments);
    }

    ImageRegion.define('Mercury.ImageRegion', 'image');

    ImageRegion.include(Mercury.Region.Modules.DropIndicator);

    ImageRegion.supported = true;

    ImageRegion.prototype.tag = 'img';

    ImageRegion.prototype.events = {
      'mousedown': 'onMousedown'
    };

    ImageRegion.prototype.value = function(value) {
      if (value === null || typeof value === 'undefined') {
        return this.attr('src');
      } else {
        return this.attr('src', value);
      }
    };

    ImageRegion.prototype.onMousedown = function(e) {
      e.preventDefault();
      return this.el.trigger('focus');
    };

    ImageRegion.prototype.onDropFile = function(files) {
      var uploader,
        _this = this;
      uploader = new Mercury.Uploader(files, {
        mimeTypes: this.config('regions:image:mimeTypes')
      });
      return uploader.on('uploaded', function(file) {
        _this.focus();
        return _this.handleAction('file', file);
      });
    };

    ImageRegion.prototype.actions = {
      file: function(file) {
        return this.value(file.get('url'));
      },
      image: function(url) {
        return this.value(url);
      }
    };

    return ImageRegion;

  })(Mercury.Region);

}).call(this);
