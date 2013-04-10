#= require spec_helper
#= require mercury/views/toolbar_select

describe "Mercury.ToolbarSelect", ->

  Klass = Mercury.ToolbarSelect
  subject = null

  beforeEach ->
    Mercury.configure 'logging:enabled', false
    subject = new Klass()

  it "needs to be tested"
