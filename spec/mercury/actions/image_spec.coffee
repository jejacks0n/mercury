#= require spec_helper
#= require mercury/actions/image

describe "Mercury.Action.Image", ->

  Klass = Mercury.Action.Image
  subject = null

  beforeEach ->
    @image = url: '/teaspoon/fixtures/image.gif'
    subject = new Klass('image', @image)

  describe "#asHtml", ->

    it "returns the expected html", ->
      expect( subject.asHtml() ).to.eq('<img src="/teaspoon/fixtures/image.gif">')
