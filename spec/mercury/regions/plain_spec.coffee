#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/modules/content_editable
#= require mercury/regions/modules/html_selection
#= require mercury/regions/modules/selection_value
#= require mercury/regions/plain

describe "Mercury.Region.Plain", ->

  Klass = Mercury.Region.Plain
  subject = null

  beforeEach ->
    Klass.supported = true
    Mercury.configure 'regions:plain:actions', true
    subject = new Klass('<div id="foo">')

  it "is defined correctly", ->
    expect( Klass.klass ).to.eq('Mercury.Region.Plain')
    expect( Klass.type ).to.eq('plain')
    expect( subject.events ).to.have.keys [
      'keydown'
      'paste'
    ]

  describe "#constructor", ->

    it "notifies if rangy can't init", ->
      spyOn(window.rangy, 'init').throws('foo')
      spyOn(Klass::, 'notify')
      subject = new Klass('<div id="foo">')
      expect( Klass::notify ).calledWith('requires Rangy')

    it "clears the actions if we don't allow actions", ->
      Mercury.configure 'regions:plain:allowActs', false
      subject = new Klass('<div id="foo">')
      expect( subject.actions ).to.eql({})


  describe "onDropItem", ->

    beforeEach ->
      @e = preventDefault: spy()

    it "calls preventDefault on the event", ->
      subject.onDropItem(@e)
      expect( @e.preventDefault ).called


  describe "#onPaste", ->

    it "needs to be re-tested"


  describe "#onKeyEvent", ->

    beforeEach ->
      spyOn(subject, 'handleAction')
      spyOn(subject, 'pushHistory')
      @e = preventDefault: spy(), metaKey: false, keyCode: 0

    it "calls preventDefault on return, and nothing more", ->
      subject.onKeyEvent($.extend(@e, keyCode: 13))
      expect( @e.preventDefault ).called
      expect( subject.pushHistory ).not.called

    it "allows return/enter if newlines are allowed", ->
      subject.options.newlines = true
      subject.onKeyEvent($.extend(@e, keyCode: 13))
      expect( @e.preventDefault ).not.called
      expect( subject.pushHistory ).called

    it "calls #pushHistory", ->
      subject.onKeyEvent(@e)
      expect( subject.pushHistory ).calledWith(0)

    it "does nothing on arrows", ->
      subject.onKeyEvent($.extend(@e, keyCode: 37))
      subject.onKeyEvent($.extend(@e, keyCode: 38))
      subject.onKeyEvent($.extend(@e, keyCode: 39))
      subject.onKeyEvent($.extend(@e, keyCode: 40))
      expect( subject.pushHistory ).not.called
      subject.onKeyEvent($.extend(@e, keyCode: 41))
      expect( subject.pushHistory ).calledWith(41)

    it "does nothing on undo/redo (meta+z/Z)", ->
      subject.onKeyEvent($.extend(@e, metaKey: true, keyCode: 90))
      expect( subject.pushHistory ).not.called

    describe "common actions", ->

      describe "bolding using meta+b", ->

        beforeEach ->
          @e = $.extend(@e, metaKey: true, keyCode: 66) # b

        it "calls e.preventDefault", ->
          subject.onKeyEvent(@e)
          expect( @e.preventDefault ).called

        it "calls #handleAction", ->
          subject.onKeyEvent(@e)
          expect( subject.handleAction ).calledWith('bold')

      describe "italicizing using meta+i", ->

        beforeEach ->
          @e = $.extend(@e, metaKey: true, keyCode: 73) # i

        it "calls e.preventDefault", ->
          subject.onKeyEvent(@e)
          expect( @e.preventDefault ).called

        it "calls #handleAction", ->
          subject.onKeyEvent(@e)
          expect( subject.handleAction ).calledWith('italic')

      describe "underline using meta+u", ->

        beforeEach ->
          @e = $.extend(@e, metaKey: true, keyCode: 85) # u

        it "calls e.preventDefault", ->
          subject.onKeyEvent(@e)
          expect( @e.preventDefault ).called

        it "calls #handleAction", ->
          subject.onKeyEvent(@e)
          expect( subject.handleAction ).calledWith('underline')


  describe "actions", ->

    it "needs to be tested"
