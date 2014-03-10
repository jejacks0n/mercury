
/*!
The gallery region is provided an an example of how you can easily (generally speaking) create your own regions. It
allows drag/drop of images and provides a simple implementation of a slide show with the ability to remove items. You
can use this as an example of how you could embed an entire backbone/spine app within a region.

Configuration:
  regions:gallery:
    mimeTypes: ['image/jpeg']                            # file types - overrides general uploading configuration

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

    Gallery.include(Mercury.Region.Modules.DropItem);

    Gallery.supported = true;

    Gallery.elements = {
      controls: '.mercury-gallery-region-controls',
      slides: '.slides',
      paginator: '.paginator'
    };

    Gallery.events = {
      'click .mercury-gallery-region-controls li': 'gotoSlide'
    };

    Gallery.prototype.skipHistoryOn = ['undo', 'redo', 'next', 'prev', 'togglePlay'];

    Gallery.prototype.init = function() {
      this.speed || (this.speed = 3000);
      this.index = 0;
      if (this.playing == null) {
        this.playing = true;
      }
      return this.refresh(true);
    };

    Gallery.prototype.build = function() {
      if (!this.$('.slides').length) {
        this.append('<div class="slides">');
      }
      if (!this.$('.paginator').length) {
        return this.append('<div class="paginator">');
      }
    };

    Gallery.prototype.value = function(value) {
      var el;
      if (value === null || typeof value === 'undefined') {
        el = $('<div>').html(this.html());
        el.find('.mercury-gallery-region-controls').remove();
        el.find('.slide').show();
        el.find('.paginator').empty();
        return el.html();
      }
      return Gallery.__super__.value.apply(this, arguments);
    };

    Gallery.prototype.refresh = function(controls) {
      if (controls == null) {
        controls = false;
      }
      clearTimeout(this.timeout);
      this.images = this.$('.slide').hide();
      if (this.index > this.images.length) {
        this.index = 1;
      }
      if (this.index < 1) {
        this.index = this.images.length;
      }
      this.$(".slide:nth-child(" + this.index + ")").show();
      this.refreshPaginator();
      if (controls) {
        this.refreshControls();
      }
      if (this.playing) {
        return this.timeout = this.delay(this.speed, (function(_this) {
          return function() {
            return _this.nextSlide();
          };
        })(this));
      }
    };

    Gallery.prototype.refreshPaginator = function() {
      this.$paginator.html(Array(this.images.length + 1).join('<span>&bull;</span>'));
      return this.$paginator.find("span:nth-child(" + this.index + ")").addClass('active');
    };

    Gallery.prototype.refreshControls = function() {
      var slide, src, _i, _len, _ref;
      this.$controls.remove();
      this.append('<ul class="mercury-gallery-region-controls"></ul>');
      _ref = this.images;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        slide = _ref[_i];
        src = $(slide).find('img').attr('src');
        this.$controls.append($("<li><img src=\"" + src + "\"/></li>"));
      }
      if (this.focused) {
        return this.$controls.show();
      }
    };

    Gallery.prototype.prevSlide = function() {
      this.index -= 1;
      return this.refresh();
    };

    Gallery.prototype.nextSlide = function() {
      this.index += 1;
      return this.refresh();
    };

    Gallery.prototype.gotoSlide = function(e) {
      this.index = $(e.target).closest('li').prevAll('li').length + 1;
      return this.refresh();
    };

    Gallery.prototype.appendSlide = function(slide) {
      this.$slides.append(slide);
      this.refresh(true);
      this.pushHistory();
      return this.trigger('focused');
    };

    Gallery.prototype.removeSlide = function() {
      this.$(".slide:nth-child(" + this.index + ")").remove();
      this.refresh(true);
      return this.pushHistory();
    };

    Gallery.prototype.onDropFile = function(files) {
      var uploader;
      uploader = new Mercury[this.config('interface:uploader')](files, {
        mimeTypes: this.options.mimeTypes
      });
      return uploader.on('uploaded', (function(_this) {
        return function(file) {
          _this.focus();
          return _this.handleAction('file', file);
        };
      })(this));
    };

    Gallery.prototype.onFocus = function() {
      if (!this.previewing) {
        return this.$controls.show();
      }
    };

    Gallery.prototype.onBlur = function() {
      return this.$controls.hide();
    };

    Gallery.prototype.onUndo = function() {
      Gallery.__super__.onUndo.apply(this, arguments);
      return this.refresh(true);
    };

    Gallery.prototype.onRedo = function() {
      Gallery.__super__.onRedo.apply(this, arguments);
      return this.refresh(true);
    };

    Gallery.prototype.release = function() {
      clearTimeout(this.timeout);
      this.html(this.value());
      return Gallery.__super__.release.apply(this, arguments);
    };

    return Gallery;

  })(Mercury.Region);

  Mercury.Region.Gallery.addToolbar({
    general: {
      prev: ['Previous Slide'],
      next: ['Next Slide'],
      remove: ['Delete Slide'],
      togglePlay: ['Play/Pause']
    }
  });

  Mercury.Region.Gallery.addAction({
    prev: function() {
      return this.prevSlide();
    },
    next: function() {
      return this.nextSlide();
    },
    remove: function() {
      return this.removeSlide();
    },
    togglePlay: function() {
      this.playing = !this.playing;
      return this.refresh();
    },
    file: function(file) {
      if (file.isImage()) {
        return this.handleAction('image', {
          url: file.get('url')
        });
      }
    },
    image: function(image) {
      return this.appendSlide("<div class=\"slide\"><img src=\"" + (image.get('url')) + "\"/></div>");
    }
  });

  Mercury.Region.Gallery.addContext({
    togglePlay: function() {
      return this.playing;
    }
  });

}).call(this);
