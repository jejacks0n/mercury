#= require spec_helper
#= require mercury/views/toolbar_button

describe "Mercury.ToolbarButton", ->

  Klass = Mercury.ToolbarButton
  subject = null

  beforeEach ->
    subject = new Klass()

  afterEach ->
    subject.release()

  it "needs to be tested"
