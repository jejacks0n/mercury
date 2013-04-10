#= require spec_helper
#= require mercury/views/toolbar_button

describe "Mercury.ToolbarButton", ->

  Klass = Mercury.ToolbarButton
  subject = null

  beforeEach ->
    Mercury.configure 'logging:enabled', false
    subject = new Klass()

  it "needs to be tested"
