#= require spec_helper
#= require mercury/views/frame_interface

describe "Mercury.FrameInterface", ->

  Klass = Mercury.FrameInterface
  subject = null

  beforeEach ->
    spyOn($.fn, 'before')
    spyOn(Klass::, 'focusActiveRegion')
    subject = new Klass(frame: '<iframe>')

  afterEach ->
    subject.release()

  describe "#initialze", ->

    it "adds the classname to the frame", ->
      expect( subject.$frame.hasClass('mercury-frame-interface-frame') ).to.be.true

    it "calls super if there's no frame", ->
      spyOn(Klass.__super__, 'initialize')
      subject.frame = null
      subject.initialize()
      expect( Klass.__super__.initialize ).called


  describe "#reinitialze", ->

    describe "with frame", ->

      beforeEach ->
        spyOn(subject, 'initializeFrame')

      it "resets @initialized", ->
        subject.reinitialize()
        expect( subject.initialized ).to.be.false

      it "calls #initializeFrame", ->
        subject.reinitialize()
        expect( subject.initializeFrame ).called

    describe "with fallback", ->

      it "calls super", ->
        subject.$frame = []
        spyOn(Klass.__super__, 'reinitialize')
        subject.reinitialize()
        expect( Klass.__super__.reinitialize ).called


  describe "#bindDefaultEvents", ->

    it "binds to @frame.load", ->
      spyOn(subject, 'initializeFrame')
      spyOn(subject.$frame, 'on').yieldsOn(subject)
      subject.bindDefaultEvents()
      expect( subject.$frame.on ).calledWith('load', sinon.match.func)
      expect( subject.initializeFrame ).called

    it "binds to initialize", ->
      spyOn(subject, 'initializeFrame')
      spyOn(Mercury, 'on')
      subject.bindDefaultEvents()
      expect( Mercury.on ).calledWith('initialize', sinon.match.func)
      Mercury.on.getCall(0).callArg(1)
      expect( subject.initializeFrame ).called


  describe "#bindDocumentEvents", ->

    beforeEach ->
      spyOn(Klass.__super__, 'bindDocumentEvents')
      @mock = on: spy(), off: ->
      spyOn(window, '$', => @mock)

    it "binds to the scroll event on the window", ->
      spyOn(subject, 'onScroll')
      subject.window = '_window_'
      subject.bindDocumentEvents()
      expect( $ ).calledWith('_window_')
      expect( @mock.on ).calledWith('scroll', subject.onScroll)


  describe "#initializeFrame", ->

    beforeEach ->
      spyOn(subject, 'setupDocument')
      spyOn(subject, 'addAllRegions')
      spyOn(subject, 'bindDocumentEvents')
      spyOn(subject, 'delay')

    it "calls #setupDocument", ->
      subject.initializeFrame()
      expect( subject.setupDocument ).called

    it "calls #bindDocumentEvents", ->
      subject.initializeFrame()
      expect( subject.bindDocumentEvents ).called

    it "calls #addAllRegions", ->
      subject.initializeFrame()
      expect( subject.addAllRegions ).called

    it "triggers initialized", ->
      spyOn(Mercury, 'trigger')
      subject.initializeFrame()
      expect( Mercury.trigger ).calledWith('initialized')

    it "delays a call to #focusDefaultRegion", ->
      spyOn(subject, 'focusDefaultRegion')
      subject.delay.yieldsOn(subject)
      subject.initializeFrame()
      expect( subject.delay ).calledWith(100, sinon.match.func)
      expect( subject.focusDefaultRegion ).called

    it "does nothing if already initialize", ->
      subject.initialized = true
      spyOn(Mercury, 'trigger')
      subject.initializeFrame()
      expect( Mercury.trigger ).not.called


  describe "#setupDocument", ->

    beforeEach ->
      @contentWindow = document: '<div class="test-document">'
      subject.$frame = get: => contentWindow: @contentWindow

    it "sets @document", ->
      subject.setupDocument()
      expect( subject.document.is('.test-document') ).to.be.true

    it "exposes Mercury to the frame window", ->
      subject.setupDocument()
      expect( @contentWindow.Mercury ).to.eq(Mercury)


  describe "#hide", ->

    it "sets the frame size", ->
      spyOn(subject.$frame, 'css')
      subject.hide()
      expect( subject.$frame.css ).calledWith(top: 0, height: '100%')

    it "calls super", ->
      spyOn(Klass.__super__, 'hide')
      subject.hide()
      expect( Klass.__super__.hide ).called


  describe "#positionForRegion", ->

    beforeEach ->
      spyOn(Klass.__super__, 'positionForRegion', -> top: 42, left: 0)
      @mock = scrollTop: spy(-> 20), off: ->
      spyOn(window, '$', => @mock)

    it "adjusts the top -- subtracting the current scrollTop", ->
      subject.document = '_document_'
      expect( subject.positionForRegion() ).to.eql(top: 22, left: 0)
      expect( $ ).calledWith('body', '_document_')
      expect( @mock.scrollTop ).called


  describe "#release", ->

    beforeEach ->
      spyOn(Klass.__super__, 'release')
      @mock = off: spy()
      spyOn(window, '$', => @mock)

    it "calls super", ->
      subject.release()
      expect( Klass.__super__.release ).called

    it "unbinds the window scroll event", ->
      subject.window = '_window_'
      subject.release()
      expect( $ ).calledWith('_window_')
      expect( @mock.off ).calledWith('scroll', subject.onScroll)


  describe "#onScroll", ->

    it "calls #position", ->
      spyOn(subject, 'position')
      subject.onScroll()
      expect( subject.position ).called


  describe "#onResize", ->

    beforeEach ->
      spyOn(Klass.__super__, 'onResize', -> top: 42, height: 420)

    it "sets the frame size", ->
      spyOn(subject.$frame, 'css')
      subject.onResize()
      expect( subject.$frame.css ).calledWith(top: 42, height: 420)
