#= require spec_helper
#= require mercury/views/panel

describe "Mercury.Panel", ->

  Klass = Mercury.Panel
  subject = null

  beforeEach ->
    subject = new Klass()

  afterEach ->
    subject.release()

  describe "#setWidth", ->

    it "sets the width of the element", ->
      spyOn(subject, 'css')
      subject.setWidth(42)
      expect( subject.css ).calledWith(width: 42)


  describe "#onShow", ->

    beforeEach ->
      spyOn(Mercury, 'trigger')

    it "triggers a global panels:hide event", ->
      subject.onShow()
      expect( Mercury.trigger ).calledWith('panels:hide')


  describe "#onHide", ->

    beforeEach ->
      spyOn(Mercury, 'trigger')

    it "triggers a global focus event", ->
      subject.onHide()
      expect( Mercury.trigger ).calledWith('focus')
