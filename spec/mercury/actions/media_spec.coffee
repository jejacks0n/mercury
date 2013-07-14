#= require spec_helper
#= require mercury/actions/media

describe "Mercury.Action.Media", ->

  Klass = Mercury.Action.Media
  subject_youtube = null
  subject_vimeo = null
  subject_image = null

  beforeEach ->
    subject_youtube = new Klass('media', type: 'youtube', src: 'youtube_video_link', width: 400, height: 300)
    subject_vimeo = new Klass('media', type: 'youtube', src: 'vimeo_video_link', width: 400, height: 300)
    subject_image = new Klass('media', type: 'image', src: 'image_url', width: "", height: "", align: "")

  describe "youtube", ->

    describe "#asHtml", ->
      it "returns the expected html", ->
        expect( subject_youtube.asHtml() ).to.eq('<iframe src="youtube_video_link" width="400" height="300" frameborder="0" allowFullScreen></iframe>')

    describe "#asMarkdown", ->
      it "actually returns html", ->
        expect( subject_youtube.asMarkdown() ).to.eq('<iframe src="youtube_video_link" width="400" height="300" frameborder="0" allowFullScreen></iframe>')


  describe "vimeo", ->

    describe "#asHtml", ->
      it "returns the expected html", ->
        expect( subject_vimeo.asHtml() ).to.eq('<iframe src="vimeo_video_link" width="400" height="300" frameborder="0" allowFullScreen></iframe>')

    describe "#asMarkdown", ->
      it "actually returns html", ->
        expect( subject_vimeo.asMarkdown() ).to.eq('<iframe src="vimeo_video_link" width="400" height="300" frameborder="0" allowFullScreen></iframe>')


  describe "image", ->

    describe "#asHtml", ->
      it "returns the expected html", ->
        expect( subject_image.asHtml() ).to.eq('<img src="image_url" align="" width="" height=""></img>')

    describe "#asMarkdown", ->
      it "returns the expected markdown", ->
        expect( subject_image.asMarkdown() ).to.eq('![](image_url)')

