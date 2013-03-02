(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mercury.GalleryRegion = (function(_super) {

    __extends(GalleryRegion, _super);

    function GalleryRegion() {
      return GalleryRegion.__super__.constructor.apply(this, arguments);
    }

    GalleryRegion.supported = true;

    GalleryRegion.define('Mercury.GalleryRegion', 'gallery', {
      undo: 'undo',
      redo: 'redo'
    });

    GalleryRegion.prototype.className = 'mercury-gallery-region';

    GalleryRegion.prototype.elements = {
      controls: '.mercury-gallery-region-controls',
      slides: '.slides',
      paginator: '.paginator'
    };

    GalleryRegion.prototype.events = {
      'click .mercury-gallery-region-controls em': 'removeSlide',
      'click .mercury-gallery-region-controls img': 'gotoSlide'
    };

    GalleryRegion.prototype.build = function() {
      var _this = this;
      this.speed || (this.speed = 3000);
      this.append('<ul class="mercury-gallery-region-controls"></ul>');
      this.index = 1;
      this.refresh(true);
      this.delay(this.speed, function() {
        return _this.nextSlide();
      });
      return this.pushStack(this.el.html());
    };

    GalleryRegion.prototype.onBlur = function() {
      return this.controls.hide();
    };

    GalleryRegion.prototype.onFocus = function() {
      return this.controls.show();
    };

    GalleryRegion.prototype.undo = function() {
      var html;
      if (html = this.undoStack()) {
        this.html(html);
      }
      return this.refresh(true);
    };

    GalleryRegion.prototype.redo = function() {
      var html;
      if (html = this.redoStack()) {
        this.html(html);
      }
      return this.refresh(true);
    };

    GalleryRegion.prototype.refresh = function(controls) {
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

    GalleryRegion.prototype.refreshControls = function() {
      var slide, _i, _len, _ref, _results;
      this.controls.html('');
      _ref = this.images;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        slide = _ref[_i];
        _results.push(this.addLink($(slide)));
      }
      return _results;
    };

    GalleryRegion.prototype.nextSlide = function() {
      var _this = this;
      this.index += 1;
      this.refresh();
      return this.timeout = this.delay(this.speed, function() {
        return _this.nextSlide();
      });
    };

    GalleryRegion.prototype.gotoSlide = function(e) {
      var _this = this;
      clearTimeout(this.timeout);
      this.index = $(e.target).closest('li').prevAll('li').length + 1;
      this.refresh();
      return this.timeout = this.delay(this.speed, function() {
        return _this.nextSlide();
      });
    };

    GalleryRegion.prototype.addLink = function(slide) {
      var src;
      src = slide.find('img').attr('src');
      return this.controls.append($("<li><img src=\"" + src + "\"/><em>&times;</em></li>").data({
        slide: slide
      }));
    };

    GalleryRegion.prototype.dropFile = function(files) {
      var uploader,
        _this = this;
      uploader = new Mercury.Uploader(files, {
        mimeTypes: this.config('regions:gallery:mimeTypes')
      });
      return uploader.on('uploaded', function() {
        return _this.appendSlide.apply(_this, arguments);
      });
    };

    GalleryRegion.prototype.appendSlide = function(file) {
      var slide;
      if (!file.isImage()) {
        return;
      }
      slide = $("<div class=\"slide\"><img src=\"" + (file.get('url')) + "\"/></div>");
      this.slides.append(slide);
      this.addLink(slide);
      this.refresh();
      return this.pushStack(this.el.html());
    };

    GalleryRegion.prototype.removeSlide = function(e) {
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
      return this.pushStack(this.el.html());
    };

    return GalleryRegion;

  })(Mercury.Region);

}).call(this);
