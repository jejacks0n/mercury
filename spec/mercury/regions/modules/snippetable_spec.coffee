#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/modules/snippetable

describe "Mercury.Region.Modules.Snippetable", ->

  Klass = null
  Module = Mercury.Region.Modules.Snippetable
  subject = null

  beforeEach ->
    class Klass extends Mercury.Region
      @include Module
    subject = new Klass('<div id="foo">')

  it "needs to be tested"
