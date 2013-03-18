#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/modules/focusable_textarea

describe "Mercury.Region.Modules.FocusableTextarea", ->

  Klass = null
  Module = Mercury.Region.Modules.FocusableTextarea
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    class Klass extends Mercury.Region
      @include Module
    subject = new Klass('<div id="foo">')

  describe "#included", ->

    it "sets up the @preview element", ->
      expect( subject.preview.is('.mercury-unknown-region-preview') ).to.be.true

    it "sets up the @focusable element", ->
      expect( subject.focusable.is('.mercury-unknown-region-textarea') ).to.be.true


  describe "#buildFocusable (via the build event)", ->

    it "determines if we should auto size", ->
      Mercury.configure 'regions:unknown:autoSize', true
      subject.buildFocusable()
      expect( subject.autoSize ).to.be.true

    it "sets @editableDropBehavior", ->
      subject.trigger('build')
      expect( subject.editableDropBehavior ).to.be.true
      subject.editableDropBehavior = false
      subject.trigger('build')
      expect( subject.editableDropBehavior ).to.be.false

    it "empties the element", ->
      spyOn(subject.el, 'empty')
      subject.buildFocusable()
      expect( subject.el.empty ).called

    it "sets the value and css for the focusable element", ->
      spyOn(subject, 'html', -> ' _&lt;html&gt;_ ')
      subject.buildFocusable()
      expect( subject.focusable.val() ).to.eq('_<html>_')
      expect( subject.focusable.css('width') ).to.eq('100%')
      expect( subject.focusable.css('height') ).to.eq('20px')
      expect( subject.focusable.css('resize') ).to.eq('vertical')

    it "appends the preview and focusable elements", ->
      expect( subject.preview.parent().get(0) ).to.eql(subject.el.get(0))
      expect( subject.focusable.parent().get(0) ).to.eql(subject.el.get(0))

    it "calls #resizeFocusable", ->
      spyOn(subject, 'resizeFocusable')
      subject.buildFocusable()
      expect( subject.resizeFocusable ).called

    it "calls #delegateEvents", ->
      spyOn(subject, 'delegateEvents')
      subject.buildFocusable()
      expect( subject.delegateEvents ).called


  describe "#releaseFocusable (via the release event)", ->

    it "sets the html back to the converted value of the textarea", ->
      spyOn(subject, 'html')
      subject.convertedValue = -> '_converted_value_'
      subject.trigger('release')
      expect( subject.html ).calledWith('_converted_value_')

    it "falls back to setting the html back to the value", ->
      spyOn(subject, 'value', -> '_value_')
      spyOn(subject, 'html')
      subject.trigger('release')
      expect( subject.html ).calledWith('_value_')


  describe "#value", ->

    it "returns the value if no value was passed", ->
      subject.focusable.val('_value_')
      expect( subject.value() ).to.eq('_value_')

    describe "setting the value", ->

      it "sets the @focusable value", ->
        subject.value('_value_')
        expect( subject.focusable.val() ).to.eq('_value_')

      it "can use an object to set the value and selection", ->
        subject.setSerializedSelection = spy()
        subject.value(val: '_value_', sel: {start: 1, end: 2})
        expect( subject.setSerializedSelection ).calledWith(start: 1, end: 2)
        expect( subject.focusable.val() ).to.eq('_value_')


  describe "#resizeFocusable (via the action event)", ->

    beforeEach ->
      subject.autoSize = true

    it "sets the height on the focusable element", ->
      spyOn(subject.focusable, 'css', -> subject.focusable)
      subject.resizeFocusable()
      expect( subject.focusable.css ).calledWith(height: 1)
      expect( subject.focusable.css ).calledWith(height: 0)

    it "sets the scrollTop on body", ->
      spyOn($.fn, 'scrollTop', -> 42)
      subject.resizeFocusable()
      expect( $.fn.scrollTop ).calledWith(42)

    it "does nothing if we aren't autosizing", ->
      subject.autoSize = false
      spyOn($.fn, 'scrollTop', -> 42)
      subject.resizeFocusable()
      expect( $.fn.scrollTop ).not.called


  describe "#toggleFocusablePreview (via the preview event)", ->

    describe "when previewing", ->

      beforeEach ->
        subject.previewing = true

      it "hides the focusable", ->
        spyOn(subject.focusable, 'hide')
        subject.trigger('preview')
        expect( subject.focusable.hide ).called

      it "sets the html of the preview element and shows it (using #convertedValue when available)", ->
        spyOn(subject.preview, 'show')
        spyOn(subject, 'value', -> '_value_')
        subject.trigger('preview')
        expect( subject.preview.html() ).to.eq('_value_')
        expect( subject.preview.show ).called
        subject.convertedValue = -> '_converted_value_'
        subject.trigger('preview')
        expect( subject.preview.html() ).to.eq('_converted_value_')

    describe "when not previewing", ->

      beforeEach ->
        subject.previewing = false

      it "hides the preview and shows the focusable elements", ->
        spyOn(subject.preview, 'hide')
        spyOn(subject.focusable, 'show')
        subject.trigger('preview')
        expect( subject.preview.hide ).called
        expect( subject.focusable.show ).called


  describe "#handleKeyEvent", ->

    beforeEach ->
      spyOn(subject, 'handleAction')
      @e = preventDefault: spy(), metaKey: false, keyCode: 0

    it "calls #resizeFocusable with a delay", ->
      spyOn(subject, 'resizeFocusable')
      spyOn(subject, 'delay').yieldsOn(subject)
      subject.handleKeyEvent(@e)
      expect( subject.delay ).calledWith(1, sinon.match.func)
      expect( subject.resizeFocusable ).called

    it "calls #onReturnKey if it was a return, and the method exists", ->
      subject.handleKeyEvent($.extend(@e, keyCode: 13))
      subject.onReturnKey = spy()
      subject.handleKeyEvent($.extend(@e, keyCode: 13))
      expect( subject.onReturnKey ).calledWith(@e)

    it "calls #resizeFocusable", ->
      spyOn(subject, 'resizeFocusable')
      spyOn(subject, 'delay')
      subject.handleKeyEvent(@e)
      expect( subject.resizeFocusable ).called

    it "calls #pushHistory", ->
      spyOn(subject, 'pushHistory')
      subject.handleKeyEvent(@e)
      expect( subject.pushHistory ).calledWith(0)

    it "does nothing on arrows", ->
      spyOn(subject, 'delay')
      subject.handleKeyEvent($.extend(@e, keyCode: 37))
      subject.handleKeyEvent($.extend(@e, keyCode: 38))
      subject.handleKeyEvent($.extend(@e, keyCode: 39))
      subject.handleKeyEvent($.extend(@e, keyCode: 40))
      expect( subject.delay ).not.called
      subject.handleKeyEvent($.extend(@e, keyCode: 41))
      expect( subject.delay ).called

    it "only resizes on undo/redo (meta+z/Z)", ->
      spyOn(subject, 'delay')
      spyOn(subject, 'pushHistory')
      subject.handleKeyEvent($.extend(@e, metaKey: true, keyCode: 90))
      expect( subject.delay ).called
      expect( subject.pushHistory ).not.called

    describe "common actions", ->

      describe "bolding using meta+b", ->

        beforeEach ->
          @e = $.extend(@e, metaKey: true, keyCode: 66) # b

        it "calls e.preventDefault", ->
          subject.handleKeyEvent(@e)
          expect( @e.preventDefault ).called

        it "calls #handleAction", ->
          subject.handleKeyEvent(@e)
          expect( subject.handleAction ).calledWith('bold')

      describe "italicizing using meta+i", ->

        beforeEach ->
          @e = $.extend(@e, metaKey: true, keyCode: 73) # i

        it "calls e.preventDefault", ->
          subject.handleKeyEvent(@e)
          expect( @e.preventDefault ).called

        it "calls #handleAction", ->
          subject.handleKeyEvent(@e)
          expect( subject.handleAction ).calledWith('italic')

      describe "underline using meta+u", ->

        beforeEach ->
          @e = $.extend(@e, metaKey: true, keyCode: 85) # u

        it "calls e.preventDefault", ->
          subject.handleKeyEvent(@e)
          expect( @e.preventDefault ).called

        it "calls #handleAction", ->
          subject.handleKeyEvent(@e)
          expect( subject.handleAction ).calledWith('underline')

