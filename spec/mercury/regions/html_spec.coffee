#= require spec_helper
#= require mercury/views/uploader
#= require mercury/core/region
#= require mercury/regions/modules/content_editable
#= require mercury/regions/modules/drop_indicator
#= require mercury/regions/modules/html_selection
#= require mercury/regions/modules/selection_value
#= require mercury/regions/html

describe "Mercury.Region.Html", ->

  Klass = Mercury.Region.Html
  subject = null

  beforeEach ->
    Klass.supported = true
    Mercury.configure 'regions:identifier', 'id'
    subject = new Klass('<div id="foo">')

  it "is defined correctly", ->
    expect( Klass.className ).to.eq('Mercury.Region.Html')
    expect( Klass.type ).to.eq('html')
    expect( Klass.supported ).to.be.true

  it "needs to be tested eventually"
