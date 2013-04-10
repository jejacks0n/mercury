#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/modules/text_selection

describe "Mercury.Region.Modules.TextSelection", ->

  Klass = null
  Module = Mercury.Region.Modules.TextSelection
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    class Klass extends Mercury.Region
      @include Module
    subject = new Klass('<div id="foo">')

  it "needs to be tested"
