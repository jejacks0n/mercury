#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/modules/content_editable
#= require mercury/regions/modules/html_selection
#= require mercury/regions/modules/selection_value
#= require mercury/regions/plain

describe "Mercury.Region.Plain", ->

  Klass = Mercury.Region.Plain
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    subject = new Klass('<div id="foo">')

  it "is defined correctly", ->
    expect( Klass.className ).to.eq('Mercury.Region.Plain')
    expect( Klass.type ).to.eq('plain')
    expect( Klass.supported ).to.be.true

  it "needs to be tested eventually"
