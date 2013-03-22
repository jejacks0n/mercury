
/*!
The Gallery region is really just an example of how you can build your own more complex regions.

By default it provides the ability to have a simplistic slide show, and allows dropping images from the desktop -- which
will get uploaded (and probably processed by your server) and will then insert the returned images as slides in the
slideshow.

You can use the control panel to see thumbnails of each slide, to jump to a given slide, or to remove them. This example
also takes into account undo/redo support using the keyboard or buttons.
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.Region.Gallery = (function(_super) {

    __extends(Gallery, _super);

    function Gallery() {
      return Gallery.__super__.constructor.apply(this, arguments);
    }

    Gallery.define('Mercury.Region.Gallery', 'gallery');

    Gallery.include(Mercury.Region.Modules.DropIndicator);

    Gallery.supported = true;

    Gallery.prototype.skipHistoryOn = ['undo', 'redo'];

    Gallery.prototype.elements = {
      controls: '.mercury-gallery-region-controls',
      slides: '.slides',
      paginator: '.paginator'
    };

    Gallery.prototype.events = {
      'click .mercury-gallery-region-controls em': 'removeSlide',
      'click .mercury-gallery-region-controls img': 'gotoSlide'
    };

    Gallery.prototype.build = function() {
      var _this = this;
      this.speed || (this.speed = 3000);
      this.index = 1;
      this.append('<ul class="mercury-gallery-region-controls"></ul>');
      this.refresh(true);
      return this.delay(this.speed, function() {
        return _this.nextSlide();
      });
    };

    Gallery.prototype.refresh = function(controls) {
      if (controls == null) {
        controls = false;
      }
      this.images = this.$('.slide').hide();
      if (this.index > this.images.length) {
        this.index = 1;
      }
      this.$(".slide:nth-child(" + this.index + ")").show();
      this.paginator.html(Array(this.images.length + 1).join('<span>&bull;</span>'));
      this.paginator.find("span:nth-child(" + this.index + ")").addClass('active');
      if (controls) {
        return this.refreshControls();
      }
    };

    Gallery.prototype.refreshControls = function() {
      var slide, _i, _len, _ref;
      this.controls.html('');
      _ref = this.images;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        slide = _ref[_i];
        this.addControlLink($(slide));
      }
      if (this.focused) {
        return this.controls.show();
      }
    };

    Gallery.prototype.addControlLink = function(slide) {
      var src;
      src = slide.find('img').attr('src');
      return this.controls.append($("<li><img src=\"" + src + "\"/><em>&times;</em></li>").data({
        slide: slide
      }));
    };

    Gallery.prototype.nextSlide = function() {
      var _this = this;
      this.index += 1;
      this.refresh();
      return this.timeout = this.delay(this.speed, function() {
        return _this.nextSlide();
      });
    };

    Gallery.prototype.gotoSlide = function(e) {
      var _this = this;
      clearTimeout(this.timeout);
      this.index = $(e.target).closest('li').prevAll('li').length + 1;
      this.refresh();
      return this.timeout = this.delay(this.speed, function() {
        return _this.nextSlide();
      });
    };

    Gallery.prototype.appendSlide = function(slide) {
      this.slides.append(slide);
      this.addControlLink(slide);
      this.refresh();
      this.pushHistory();
      return this.trigger('focused');
    };

    Gallery.prototype.removeSlide = function(e) {
      var el, index, slide,
        _this = this;
      el = $(e.target).closest('li');
      slide = el.data('slide');
      index = slide.prevAll('.slide').length + 1;
      slide.remove();
      el.remove();
      if (index < this.index) {
        this.index -= 1;
      } else if (index === this.index) {
        clearTimeout(this.timeout);
        this.timeout = this.delay(this.speed, function() {
          return _this.nextSlide();
        });
      }
      this.refresh();
      return this.pushHistory();
    };

    Gallery.prototype.onDropFile = function(files) {
      var uploader,
        _this = this;
      uploader = new Mercury.Uploader(files, {
        mimeTypes: this.config('regions:gallery:mimeTypes')
      });
      return uploader.on('uploaded', function(file) {
        if (!file.isImage()) {
          return;
        }
        _this.focus();
        return _this.appendSlide($("<div class=\"slide\"><img src=\"" + (file.get('url')) + "\"/></div>"));
      });
    };

    Gallery.prototype.onDropItem = function(e, data) {
      var url;
      if (url = $('<div>').html(data.getData('text/html')).find('img').attr('src')) {
        e.preventDefault();
        this.focus();
        return this.appendSlide($("<div class=\"slide\"><img src=\"" + url + "\"/></div>"));
      }
    };

    Gallery.prototype.onFocus = function() {
      return this.controls.show();
    };

    Gallery.prototype.onBlur = function() {
      return this.controls.hide();
    };

    Gallery.prototype.onUndo = function() {
      Gallery.__super__.onUndo.apply(this, arguments);
      return this.refresh(true);
    };

    Gallery.prototype.onRedo = function() {
      Gallery.__super__.onRedo.apply(this, arguments);
      return this.refresh(true);
    };

    return Gallery;

  })(Mercury.Region);

}).call(this);
