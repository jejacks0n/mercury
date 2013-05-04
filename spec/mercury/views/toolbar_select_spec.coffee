#= require spec_helper
#= require mercury/views/toolbar_select

describe "Mercury.ToolbarSelect", ->

  Klass = Mercury.ToolbarSelect
  subject = null

  beforeEach ->
    Mercury.configure 'logging:enabled', false
    subject = new Klass()

  afterEach ->
    subject.release()

  describe "#constructor", ->

    beforeEach ->
      subject.release()

    it "calls super", ->
      spyOn(Klass.__super__, 'constructor', false)
      subject = new Klass()
      expect( Klass.__super__.constructor ).called
