#= require spec_helper
#= require mercury/actions/link

describe "Mercury.Action.Link", ->

  Klass = Mercury.Action.Link
  subject = null

  beforeEach ->
    @link =
      url: '/link/to/resource'
      text: 'name'
    subject = new Klass('link', @link)

  describe "#asHtml", ->

    it "returns the expected html", ->
      expect( subject.asHtml() ).to.match(/^\<a href="\/link\/to\/resource" \>\s*name\s*\<\/a\>$/)

    it "returns the expected html with a target tag", ->
      subject = new Klass 'link',
        url: '/link/to/resource'
        text: 'name'
        target: '_blank'
      expect( subject.asHtml() ).to.match ///
        ^\<a\s+
          href="/link/to/resource"\s+
          target="_blank"\s*
        \>
          \s*name\s*
        \</a\>$///

  describe "#asMarkdown", ->

    it "returns the expected markdown", ->
      expect( subject.asMarkdown() ).to.match(/^\[name\]\(\/link\/to\/resource\)$/)
