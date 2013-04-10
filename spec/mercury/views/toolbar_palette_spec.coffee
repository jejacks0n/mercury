#= require spec_helper
#= require mercury/views/toolbar_palette

describe "Mercury.ToolbarPalette", ->

  Klass = Mercury.ToolbarPalette
  subject = null

  beforeEach ->
    Mercury.configure 'logging:enabled', false
    subject = new Klass()

  it "needs to be tested"
