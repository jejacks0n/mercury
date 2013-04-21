#= require spec_helper
#= require mercury/views/toolbar_select

describe "Mercury.ToolbarSelect", ->

  Klass = Mercury.ToolbarSelect
  subject = null

  beforeEach ->
    Mercury.configure 'logging:enabled', false
    subject = new Klass()

  describe "#constructor", ->

    it "calls super", ->
      spyOn(Klass.__super__, 'constructor')
      subject = new Klass()
      expect( Klass.__super__.constructor ).called
