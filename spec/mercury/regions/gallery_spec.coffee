#= require spec_helper
#= require mercury/views/uploader
#= require mercury/core/region
#= require mercury/regions/modules/drop_indicator
#= require mercury/regions/gallery

describe "Mercury.Region.Gallery", ->

  Klass = Mercury.Region.Gallery
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    subject = new Klass('<div id="foo">')

  it "is defined correctly", ->
    expect( Klass.className ).to.eq('Mercury.Region.Gallery')
    expect( Klass.type ).to.eq('gallery')
    expect( subject.skipHistoryOn ).to.eql(['undo', 'redo'])
    expect( subject.toolbars ).to.eql(['gallery'])
    expect( subject.elements ).to.have.keys [
      'controls',
      'slides',
      'paginator'
      ]
    expect( subject.events ).to.have.keys [
      'click .mercury-gallery-region-controls em',
      'click .mercury-gallery-region-controls img'
      ]

  # the gallery region is an example and not a core feature, and thus doesn't need to be tested further.
