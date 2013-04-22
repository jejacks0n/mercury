
/*!
The Image region allows you to have a replaceable image region on your page. It provided the ability to drag/drop images
from the desktop -- which will get uploaded (and probably processed by your server) and will then replace the existing
image with the one that was uploaded. You can change the image alignment, which will be provided in the data on
serialization to the server.
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Region.Image = (function(_super) {

    __extends(Image, _super);

    function Image() {
      return Image.__super__.constructor.apply(this, arguments);
    }

    Image.define('Mercury.Region.Image', 'image');

    Image.include(Mercury.Region.Modules.DropIndicator);

    Image.include(Mercury.Region.Modules.DropItem);

    Image.supported = true;

    Image.tag = 'img';

    Image.events = {
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
      return this.$el.trigger('focus');
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

    return Image;

  })(Mercury.Region);

  Mercury.Region.Image.addToolbar({
    general: {
      crop: ['Crop Image'],
      resize: ['Resize Image']
    },
    alignment: {
      alignLeft: ['Align Left'],
      alignRight: ['Align Right'],
      alignTop: ['Align Top'],
      alignMiddle: ['Align Middle'],
      alignBottom: ['Align Bottom'],
      alignNone: ['Align None']
    }
  });

  Mercury.Region.Image.addData({
    align: function(val) {
      return this.attr({
        align: val
      });
    }
  });

  Mercury.Region.Image.addAction({
    alignLeft: function() {
      return this.data({
        align: 'left'
      });
    },
    alignRight: function() {
      return this.data({
        align: 'right'
      });
    },
    alignTop: function() {
      return this.data({
        align: 'top'
      });
    },
    alignMiddle: function() {
      return this.data({
        align: 'middle'
      });
    },
    alignBottom: function() {
      return this.data({
        align: 'bottom'
      });
    },
    alignNone: function() {
      return this.data({
        align: null
      });
    },
    file: function(file) {
      if (file.isImage()) {
        return this.handleAction('image', {
          url: file.get('url')
        });
      }
    },
    image: function(img) {
      return this.value(img.get('url'));
    }
  });

  Mercury.Region.Image.addContext({
    alignLeft: function() {
      return this.data('align') === 'left';
    },
    alignRight: function() {
      return this.data('align') === 'right';
    },
    alignTop: function() {
      return this.data('align') === 'top';
    },
    alignMiddle: function() {
      return this.data('align') === 'middle';
    },
    alignBottom: function() {
      return this.data('align') === 'bottom';
    },
    alignNone: function() {
      return !this.data('align');
    }
  });

}).call(this);
