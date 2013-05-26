#= require spec_helper
#= require mercury/views/frame_interface

fixture.preload('link_hijacking.html')

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


  describe "#load", ->

    beforeEach ->
      spyOn(Klass.__super__, 'load')

    it "sets @loadedJSON to whatever was passed in", ->
      subject.load(foo: 'bar')
      expect( subject.loadedJSON ).to.eql(foo: 'bar')

    it "calls super if we're initialized", ->
      subject.initialized = true
      subject.load(foo: 'bar')
      expect( Klass.__super__.load ).calledWith(foo: 'bar')


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
        subject.$frame = $()
        spyOn(Klass.__super__, 'reinitialize')
        subject.reinitialize()
        expect( Klass.__super__.reinitialize ).called


  describe "#bindDefaultEvents", ->

    beforeEach ->
      spyOn(subject, 'reinitializeFrame')
      spyOn(subject, 'initializeFrame')
      spyOn(subject, 'load')

    it "binds to @frame.load", ->
      subject.loadedJSON = foo: 'bar'
      spyOn(subject.$frame, 'on').yieldsOn(subject)
      subject.bindDefaultEvents()
      expect( subject.$frame.on ).calledWith('load', sinon.match.func)
      expect( subject.initializeFrame ).called
      expect( subject.load ).calledWith(foo: 'bar')
      expect( subject.reinitializeFrame ).called

    it "binds to initialize", ->
      spyOn(Mercury, 'on')
      subject.bindDefaultEvents()
      expect( Mercury.on ).calledWith('initialize', sinon.match.func)
      Mercury.on.getCall(0).callArg(1)
      expect( subject.initializeFrame ).called


  describe "#bindDocumentEvents", ->

    beforeEach ->
      spyOn(Klass.__super__, 'bindDocumentEvents')
      @mock = on: spy(), css: spy(), off: ->
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

    it "sets @regions", ->
      subject.initializeFrame()
      expect( subject.regions ).to.eql([])

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
      spyOn(subject, 'trigger')
      spyOn(Mercury, 'trigger')
      subject.initializeFrame()
      expect( Mercury.trigger ).calledWith('initialized')
      expect( subject.trigger ).calledWith('initialized')

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


  describe "#reinitializeFrame", ->

    beforeEach ->
      spyOn(subject, 'release')
      spyOn(subject, 'initializeFrame')
      spyOn(subject, 'load')

    it "reinitializes if there's a location (frame location isn't available when it's not our domain)", ->
      subject.loadedJSON = foo: 'bar'
      spyOn(subject, 'frameLocation', -> 'http://foo.bar')
      subject.reinitializeFrame()
      expect( subject.initialized ).to.be.false
      expect( subject.regions ).to.eql([])
      expect( subject.initializeFrame ).called
      expect( subject.load ).calledWith(foo: 'bar')

    it "alerts and then releases if we're not editing a page on our domain", ->
      spyOn(subject, 'frameLocation', -> false)
      spyOn(window, 'alert')
      subject.reinitializeFrame()
      expect( alert ).calledWith("You've left editing the page you were on, please refresh the page.")
      expect( subject.release ).called
      subject.release.restore()


  describe "#frameLocation", ->

    afterEach ->
      subject.$frame.get.restore()

    it "returns the location.href of the frame", ->
      spyOn(subject.$frame, 'get', -> contentWindow: {location: href: '_href_'})
      expect( subject.frameLocation() ).to.eq('_href_')


  describe "#setupDocument", ->

    beforeEach ->
      @contentWindow = document: '<div class="test-document">'
      subject.$frame = css: spy(), get: => contentWindow: @contentWindow

    it "sets @window", ->
      subject.setupDocument()
      expect( subject.window ).to.eq(@contentWindow)

    it "sets @window.Mercury if it's not defined", ->
      subject.setupDocument()
      expect( subject.window.Mercury ).to.eq(Mercury)

    it "sets @window.Mercury.interface", ->
      subject.setupDocument()
      expect( subject.window.Mercury.interface ).to.eq(subject)

    it "sets @document", ->
      subject.setupDocument()
      expect( subject.document.is('.test-document') ).to.be.true


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
      @mock = scrollTop: spy(-> 20), css: spy(), off: ->
      spyOn(window, '$', => @mock)

    it "adjusts the top -- subtracting the current scrollTop", ->
      subject.document = '_document_'
      expect( subject.positionForRegion() ).to.eql(top: 22, left: 0)
      expect( $ ).calledWith('body', '_document_')
      expect( @mock.scrollTop ).called


  describe "#hijackLinksAndForms", ->

    beforeEach ->
      Mercury.configure 'interface:nohijack', ['nohijack']
      Mercury.configure 'regions:attribute', 'custom-region-attribute'
      fixture.load('link_hijacking.html')
      @el = subject.document = fixture.$el
      subject.hijackLinksAndForms()

    it "doesn't change the targets of anchors/forms that are within a region", ->
      expect( @el.find('#anchor1region').attr('target') ).to.eql('_top')
      expect( @el.find('#anchor2region').attr('target') ).to.eql('_blank')
      expect( @el.find('#anchor3region').attr('target') ).to.eql('_self')
      expect( @el.find('#anchor4region').attr('target') ).to.eql('foo')
      expect( @el.find('#anchor5region').attr('target') ).to.be.undefined
      expect( @el.find('#form1region').attr('target') ).to.eql('_top')
      expect( @el.find('#form2region').attr('target') ).to.eql('_blank')
      expect( @el.find('#form3region').attr('target') ).to.eql('_self')
      expect( @el.find('#form4region').attr('target') ).to.eql('foo')
      expect( @el.find('#form5region').attr('target') ).to.be.undefined

    it "sets the targets on links and forms to top if it should", ->
      expect( @el.find('#anchor1').attr('target') ).to.eql('_top')
      expect( @el.find('#anchor2').attr('target') ).to.eql('_blank')
      expect( @el.find('#anchor3').attr('target') ).to.eql('_parent')
      expect( @el.find('#anchor4').attr('target') ).to.eql('foo')
      expect( @el.find('#anchor5').attr('target') ).to.eql('_parent')
      expect( @el.find('#anchor6').attr('target') ).to.eql('_top')
      expect( @el.find('#anchor7').attr('target') ).to.eql('_blank')
      expect( @el.find('#anchor8').attr('target') ).to.eql('_self')
      expect( @el.find('#anchor9').attr('target') ).to.eql('foo')
      expect( @el.find('#anchorA').attr('target') ).to.be.undefined

    it "doesn't change anchors/forms that are ignored", ->
      expect( @el.find('#form1').attr('target') ).to.eql('_top')
      expect( @el.find('#form2').attr('target') ).to.eql('_blank')
      expect( @el.find('#form3').attr('target') ).to.eql('_parent')
      expect( @el.find('#form4').attr('target') ).to.eql('foo')
      expect( @el.find('#form5').attr('target') ).to.eql('_parent')
      expect( @el.find('#form6').attr('target') ).to.eql('_top')
      expect( @el.find('#form7').attr('target') ).to.eql('_blank')
      expect( @el.find('#form8').attr('target') ).to.eql('_self')
      expect( @el.find('#form9').attr('target') ).to.eql('foo')
      expect( @el.find('#formA').attr('target') ).to.be.undefined


  describe "#release", ->

    beforeEach ->
      spyOn(subject, 'frameLocation', -> false)
      spyOn(Klass.__super__, 'release')
      @mock = off: spy(), css: spy()
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
