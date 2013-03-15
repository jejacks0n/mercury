#= require spec_helper
#= require mercury/views/uploader
#= require mercury/core/region
#= require mercury/regions/modules/drop_indicator
#= require mercury/regions/gallery

describe "Mercury.GalleryRegion", ->

  Klass = Mercury.GalleryRegion
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    subject = new Klass('<div id="foo">')

  it "is defined correctly", ->
    expect( Klass.className ).to.eq('Mercury.GalleryRegion')
    expect( Klass.type ).to.eq('gallery')
    expect( subject.skipHistoryOn ).to.eql(['undo', 'redo'])
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
