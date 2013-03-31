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

    it "set css bottom to the element height", ->
      fixture.set(subject.el.css(height: 42))
      subject.hide()
      expect( subject.el.css('bottom') ).to.eq('-42px')


  describe "#show", ->

    it "set css bottom to 0", ->
      spyOn(subject, 'delay').yieldsOn(subject)
      subject.el.css(bottom: 42)
      subject.show()
      expect( subject.el.css('bottom') ).to.eq('0px')
