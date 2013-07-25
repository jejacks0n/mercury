#= require spec_helper
#= require mercury/actions/media

describe "Mercury.Action.Media", ->

  Klass = Mercury.Action.Media
  subject = null

  describe "with an image", ->

    beforeEach ->
      subject = new Klass('media', type: 'image', src: 'image_url', width: "", height: "", align: "")

    describe "#asHtml", ->

      it "returns the expected html", ->
        expect( subject.asHtml() ).to.eq('<img src="image_url" align="" width="" height=""/>')


    describe "#asMarkdown", ->

      it "returns the expected markdown", ->
        expect( subject.asMarkdown() ).to.eq('![](image_url)')


  describe "with a youtube video", ->

    beforeEach ->
      subject = new Klass('media', type: 'youtube', src: 'youtube_video_link', width: 400, height: 300)

    describe "#asHtml", ->

      it "returns the expected html", ->
        expect( subject.asHtml() ).to.eq('<iframe src="youtube_video_link" width="400" height="300" frameborder="0" allowFullScreen></iframe>')


    describe "#asMarkdown", ->

      it "actually returns html", ->
        expect( subject.asMarkdown() ).to.eq('<iframe src="youtube_video_link" width="400" height="300" frameborder="0" allowFullScreen></iframe>')


  describe "with a vimeo video", ->

    beforeEach ->
      subject = new Klass('media', type: 'youtube', src: 'vimeo_video_link', width: 400, height: 300)

    describe "#asHtml", ->

      it "returns the expected html", ->
        expect( subject.asHtml() ).to.eq('<iframe src="vimeo_video_link" width="400" height="300" frameborder="0" allowFullScreen></iframe>')


    describe "#asMarkdown", ->

      it "actually returns html", ->
        expect( subject.asMarkdown() ).to.eq('<iframe src="vimeo_video_link" width="400" height="300" frameborder="0" allowFullScreen></iframe>')
