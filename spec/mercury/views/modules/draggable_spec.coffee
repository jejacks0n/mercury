#= require spec_helper
#= require mercury/core/view
#= require mercury/views/modules/draggable

describe "Mercury.View.Modules.Draggable", ->

  Klass = null
  Module = Mercury.View.Modules.Draggable
  subject = null

  beforeEach ->
    class Klass extends Mercury.View
      @include Module
    subject = new Klass()

  it "needs to be tested"
