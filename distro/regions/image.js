
/*!
The Image region allows you to have a replaceable image region on your page. It provided the ability to drag/drop images
from the desktop -- which will get uploaded (and probably processed by your server) and will then replace the existing
image with the one that was uploaded.
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.configure('toolbars:image', {
    general: {
      crop: ['Crop Image'],
      resize: ['Resize Image'],
      sep1: '-'
    },
    alignment: {
      alignLeft: ['Align Left'],
      alignRight: ['Align Right'],
      alignTop: ['Align Top'],
      alignMiddle: ['Align Middle'],
      alignBottom: ['Align Bottom']
    }
  });

  Mercury.Region.Image = (function(_super) {

    __extends(Image, _super);

    function Image() {
      return Image.__super__.constructor.apply(this, arguments);
    }

    Image.define('Mercury.Region.Image', 'image');

    Image.include(Mercury.Region.Modules.DropIndicator);

    Image.supported = true;

    Image.prototype.toolbars = ['image'];

    Image.prototype.tag = 'img';

    Image.prototype.events = {
      'mousedown': 'onMousedown'
    };

    Image.prototype.value = function(value) {
      if (value === null || typeof value === 'undefined') {
        return this.attr('src');
      } else {
        return this.attr('src', value);
      }
    };

    Image.prototype.onMousedown = function(e) {
      e.preventDefault();
      return this.el.trigger('focus');
    };

    Image.prototype.onDropFile = function(files) {
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

    Image.prototype.onDropItem = function(e, data) {
      var url;
      if (url = $('<div>').html(data.getData('text/html')).find('img').attr('src')) {
        e.preventDefault();
        this.focus();
        return this.handleAction('image', {
          url: url
        });
      }
    };

    Image.prototype.actions = {
      file: function(file) {
        return this.value(file.get('url'));
      },
      image: function(image) {
        return this.value(image.get('url'));
      }
    };

    return Image;

  })(Mercury.Region);

}).call(this);
