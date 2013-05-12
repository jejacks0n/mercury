#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/snippet

describe "Mercury.Region.Snippet", ->

  Klass = Mercury.Region.Snippet
  subject = null

  beforeEach ->
    Klass.supported = true
    subject = new Klass('<div id="foo">')

  it "is defined correctly", ->
    expect( Klass.klass ).to.eq('Mercury.Region.Snippet')
    expect( Klass.type ).to.eq('snippet')
    expect( Klass.supported ).to.be.true

  it "needs to be tested"
