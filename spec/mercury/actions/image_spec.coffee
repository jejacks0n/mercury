#= require spec_helper
#= require mercury/actions/image

describe "Mercury.Action.Image", ->

  Klass = Mercury.Action.Image
  subject = null

  beforeEach ->
    @image = url: '/teabag/fixtures/image.gif'
    subject = new Klass('image', @image)

  describe "#asHtml", ->

    it "returns the expected html", ->
      expect( subject.asHtml() ).to.eq('<img src="/teabag/fixtures/image.gif">')
