#= require spec_helper
#= require mercury/views/toolbar_expander

describe "Mercury.ToolbarExpander", ->

  Klass = Mercury.ToolbarExpander
  subject = null

  beforeEach ->
    subject = new Klass()

  afterEach ->
    subject.release()

  it "needs to be tested"
