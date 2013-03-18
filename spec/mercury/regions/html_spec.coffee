#= require spec_helper
#= require mercury/views/uploader
#= require mercury/core/region
#= require mercury/regions/modules/content_editable
#= require mercury/regions/modules/drop_indicator
#= require mercury/regions/modules/html_selection
#= require mercury/regions/modules/selection_value
#= require mercury/regions/html

describe "Mercury.HtmlRegion", ->

  Klass = Mercury.HtmlRegion
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    subject = new Klass('<div id="foo">')

  it "is defined correctly", ->
    expect( Klass.className ).to.eq('Mercury.HtmlRegion')
    expect( Klass.type ).to.eq('html')
    expect( Klass.supported ).to.be.true
    expect( subject.skipHistoryOnInitialize ).to.be.true

  it "needs to be tested eventually"
