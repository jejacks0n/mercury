#= require spec_helper
#= require mercury/views/toolbar_palette

describe "Mercury.ToolbarPalette", ->

  Klass = Mercury.ToolbarPalette
  subject = null

  beforeEach ->
    Mercury.configure 'logging:enabled', false
    subject = new Klass()

  describe "#constructor", ->

    it "calls super", ->
      spyOn(Klass.__super__, 'constructor')
      subject = new Klass()
      expect( Klass.__super__.constructor ).called
