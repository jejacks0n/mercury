#= require spec_helper
#= require mercury/core/view
#= require mercury/views/modules/interface_page_manager

describe "Mercury.View.Modules.InterfacePageManager", ->

  Klass = null
  Module = Mercury.View.Modules.InterfacePageManager
  subject = null

  beforeEach ->
    class Klass extends Mercury.View
      @tag: 'bar'
      @include Module
    subject = new Klass()

  it "needs to be tested"
