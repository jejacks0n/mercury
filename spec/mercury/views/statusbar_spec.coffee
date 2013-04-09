#= require spec_helper
#= require mercury/views/statusbar

describe "Mercury.Statusbar", ->

  Klass = Mercury.Statusbar
  subject = null

  beforeEach ->
    subject = new Klass()

  describe "#build", ->

    it "calls #setPath", ->
      spyOn(subject, 'setPath')
      subject.build()
      expect( subject.setPath ).called


  describe "#setPath", ->

    it "builds a path from the path elements", ->
      subject.setPath(['foo', '<span>bar</span>'])
      expect( subject.path.html() ).to.eq('<b>Path: </b>foo » <span>bar</span>')


  describe "#onRegionUpdate", ->

    it "calls #setPath with the region path", ->
      spyOn(subject, 'setPath')
      subject.onRegionUpdate({})
      subject.onRegionUpdate(path: -> [])
      expect( subject.setPath ).calledOnce


  describe "#hide", ->

    beforeEach ->
      subject.visibilityTimeout = '_timer_'

    it "calls clearTimeout", ->
      spyOn(window, 'clearTimeout')
      subject.hide()
      expect( window.clearTimeout ).calledWith('_timer_')

    it "sets @visible to false", ->
      subject.visible = true
      subject.hide()
      expect( subject.visible ).to.be.false

    it "sets css bottom to the element height", ->
      fixture.set(subject.el.css(height: 42))
      subject.hide()
      expect( subject.el.css('bottom') ).to.eq('-42px')

    it "delays hiding the element", ->
      spyOn(subject, 'delay').yieldsOn(subject)
      spyOn(subject.el, 'hide')
      subject.hide()
      expect( subject.delay ).calledWith(250, sinon.match.func)
      expect( subject.el.hide ).called


  describe "#show", ->

    beforeEach ->
      subject.visibilityTimeout = '_timer_'

    it "calls clearTimeout", ->
      spyOn(window, 'clearTimeout')
      subject.show()
      expect( window.clearTimeout ).calledWith('_timer_')

    it "sets @visible to true", ->
      subject.visible = false
      subject.show()
      expect( subject.visible ).to.be.true

    it "shows the element", ->
      spyOn(subject.el, 'show')
      subject.show()
      expect( subject.el.show ).called

    it "delays setting the elements css bottom", ->
      spyOn(subject, 'delay').yieldsOn(subject)
      spyOn(subject.el, 'hide')
      subject.show()
      expect( subject.delay ).calledWith(1, sinon.match.func)
      expect( subject.el.css('bottom') ).to.eq('0px')
