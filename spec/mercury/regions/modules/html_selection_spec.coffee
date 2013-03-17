#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/modules/html_selection

describe "Mercury.Region.Modules.HtmlSelection", ->

  Klass = null
  Module = Mercury.Region.Modules.HtmlSelection
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    class Klass extends Mercury.Region
      @include Module
    subject = new Klass('<div id="foo">')

  it "should be tested eventually"
