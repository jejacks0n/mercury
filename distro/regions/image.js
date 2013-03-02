(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.ImageRegion = (function(_super) {

    __extends(ImageRegion, _super);

    function ImageRegion() {
      return ImageRegion.__super__.constructor.apply(this, arguments);
    }

    ImageRegion.supported = true;

    ImageRegion.define('Mercury.ImageRegion', 'image', {
      undo: 'undo',
      redo: 'redo'
    });

    ImageRegion.prototype.tag = 'img';

    ImageRegion.prototype.className = 'mercury-image-region';

    ImageRegion.prototype.build = function() {
      return this.pushStack(this.attr('src') || null);
    };

    ImageRegion.prototype.dropFile = function(files) {
      var uploader,
        _this = this;
      uploader = new Mercury.Uploader([files[0]], {
        mimeTypes: this.config('regions:gallery:mimeTypes')
      });
      return uploader.on('uploaded', function() {
        return _this.updateImage.apply(_this, arguments);
      });
    };

    ImageRegion.prototype.updateImage = function(file) {
      this.setSrc(file.get('url'));
      return this.pushStack(this.attr('src'));
    };

    ImageRegion.prototype.setSrc = function(src) {
      if (src === null) {
        return;
      }
      return this.attr({
        src: src
      });
    };

    ImageRegion.prototype.undo = function() {
      return this.setSrc(this.undoStack());
    };

    ImageRegion.prototype.redo = function() {
      return this.setSrc(this.redoStack());
    };

    ImageRegion.prototype.toJSON = function() {
      return {
        name: this.name,
        type: this.constructor.type,
        data: this.data(),
        src: this.attr('src')
      };
    };

    return ImageRegion;

  })(Mercury.Region);

}).call(this);
