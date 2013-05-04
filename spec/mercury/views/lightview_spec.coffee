#= require spec_helper
#= require mercury/views/lightview

describe "Mercury.Lightview", ->

  Klass = Mercury.Lightview
  subject = null

  beforeEach ->
    subject = new Klass()

  afterEach ->
    subject.release()

  describe "#build", ->

    it "calls super", ->
      spyOn(Klass.__super__, 'build')
      subject.build()
      expect( Klass.__super__.build ).called

    it "calls #defaultPosition", ->
      spyOn(subject, 'defaultPosition')
      subject.build()
      expect( subject.defaultPosition ).called


  describe "#defaultPosition", ->

    it "sets the margin-top of the dialog", ->
      spyOn($.fn, 'height', -> 100)
      spyOn(subject.$dialog, 'css')
      subject.defaultPosition()
      expect( subject.$dialog.css ).calledWith(marginTop: 12.5)


  describe "#resize", ->

    beforeEach ->
      spyOn(subject.$titleContainer, 'outerHeight', -> 6)
      spyOn(subject.$content, 'outerHeight', -> 42)

    it "clears the @showContentTimeout", ->
      spyOn(window, 'clearTimeout')
      subject.showContentTimeout = '_timeout_'
      subject.resize()
      expect( window.clearTimeout ).calledWith('_timeout_')

    it "adds the mercury-no-animation class if we're not animating", ->
      spyOn(subject, 'addClass')
      subject.resize(false)
      expect( subject.addClass ).calledWith('mercury-no-animation')

    it "sets the content container height to auto", ->
      spyOn(subject.$contentContainer, 'css')
      subject.resize()
      expect( subject.$contentContainer.css ).calledWith(height: 'auto')

    it "set the content css to the correct width", ->
      spyOn(Math, 'min', -> 42)
      spyOn(subject.$content, 'css')
      subject.resize()
      expect( subject.$content.css ).calledWith(width: 42)

    it "sets the dialog margin-top and height", ->
      spyOn(Math, 'min', -> 42)
      spyOn($.fn, 'height', -> 100)
      spyOn(subject.$dialog, 'css')
      subject.resize()
      expect( subject.$dialog.css ).calledWith(marginTop: (100 - 42) / 2, height: 42)

    it "sets the content width to auto", ->
      spyOn(subject.$content, 'css')
      subject.resize()
      expect( subject.$content.css ).calledWith(width: 'auto')

    it "sets the contentContainer height", ->
      spyOn(Math, 'min', -> 42)
      spyOn(subject.$contentContainer, 'css')
      subject.resize()
      expect( subject.$contentContainer.css ).calledWith(height: 42 - 6)

    it "calls #showContent (in a delay if animating)", ->
      spyOn(subject, 'delay').yieldsOn(subject)
      spyOn(subject, 'showContent')
      subject.resize(false)
      expect( subject.showContent ).calledWith(false)
      subject.resize(true)
      expect( subject.delay ).calledWith(300, subject.showContent)
      expect( subject.showContent ).called

    it "removes the mercury-no-animation class", ->
      spyOn(subject, 'removeClass')
      subject.resize()
      expect( subject.removeClass ).calledWith('mercury-no-animation')

    it "sets animate to false if you pass an object for the first arg", ->
      spyOn(subject, 'delay')
      subject.resize({})
      expect( subject.delay ).not.called


  describe "#onHide", ->

    it "calls super", ->
      spyOn(Klass.__super__, 'onHide')
      subject.onHide()
      expect( Klass.__super__.onHide ).called

    it "calls #defaultPosition after a delay", ->
      spyOn(subject, 'defaultPosition')
      spyOn(subject, 'delay').yieldsOn(subject)
      subject.onHide()
      expect( subject.delay ).called
      expect( subject.defaultPosition ).called
