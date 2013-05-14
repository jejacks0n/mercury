#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/modules/focusable_textarea
#= require mercury/regions/text

describe "Mercury.Region.Text", ->

  Klass = Mercury.Region.Text
  subject = null

  beforeEach ->
    subject = new Klass('<div id="foo">')

  it "is defined correctly", ->
    expect( Klass.klass ).to.eq('Mercury.Region.Text')
    expect( Klass.type ).to.eq('text')
    expect( Klass.supported ).to.be.true
