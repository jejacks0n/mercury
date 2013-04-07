#= require spec_helper
#= require mercury/views/frame_interface

describe "Mercury.FrameInterface", ->

  Klass = Mercury.FrameInterface
  subject = null

  beforeEach ->
    Mercury.configure 'logging:enabled', false
    spyOn($.fn, 'before')
    spyOn(Klass::, 'focusActiveRegion')
    subject = new Klass(frame: '<iframe>')

  describe "#initialze", ->

    it "adds the classname to the frame", ->
      expect( subject.frame.hasClass('mercury-frame-interface-frame') ).to.be.true

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
        subject.frame = []
        spyOn(Klass.__super__, 'reinitialize')
        subject.reinitialize()
        expect( Klass.__super__.reinitialize ).called


  describe "#bindDefaultEvents", ->

    it "binds to @frame.load", ->
      spyOn(subject, 'initializeFrame')
      spyOn(subject.frame, 'on').yieldsOn(subject)
      subject.bindDefaultEvents()
      expect( subject.frame.on ).calledWith('load', sinon.match.func)
      expect( subject.initializeFrame ).called

    it "binds to initialize", ->
      spyOn(subject, 'initializeFrame')
      spyOn(Mercury, 'on')
      subject.bindDefaultEvents()
      expect( Mercury.on ).calledWith('initialize', sinon.match.func)
      Mercury.on.getCall(0).callArg(1)
      expect( subject.initializeFrame ).called


  describe "#initializeFrame", ->

    beforeEach ->
      spyOn(subject, 'setupDocument')
      spyOn(subject, 'addAllRegions')

    it "calls #setupDocument", ->
      subject.initializeFrame()
      expect( subject.setupDocument ).called

    it "calls #addAllRegions", ->
      subject.initializeFrame()
      expect( subject.addAllRegions ).called

    it "triggers initialized", ->
      spyOn(Mercury, 'trigger')
      subject.initializeFrame()
      expect( Mercury.trigger ).calledWith('initialized')

    it "does nothing if already initialize", ->
      subject.initialized = true
      spyOn(Mercury, 'trigger')
      subject.initializeFrame()
      expect( Mercury.trigger ).not.called


  describe "#setupDocument", ->

    beforeEach ->
      @contentWindow = document: '<div class="test-document">'
      subject.frame = get: => contentWindow: @contentWindow

    it "sets @document", ->
      subject.setupDocument()
      expect( subject.document.is('.test-document') ).to.be.true

    it "exposes Mercury to the frame window", ->
      subject.setupDocument()
      expect( @contentWindow.Mercury ).to.eq(Mercury)
