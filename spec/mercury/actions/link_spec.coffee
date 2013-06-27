#= require spec_helper
#= require mercury/actions/link

describe "Mercury.Action.Link", ->

  Klass = Mercury.Action.Link
  subject = null

  beforeEach ->
    subject = new Klass('link', url: '/link/to/resource', text: 'name')

  describe "#asHtml", ->

    it "returns the expected html", ->
      expect( subject.asHtml() ).to.eq('<a href="/link/to/resource">name</a>')

    it "returns the expected html with a target tag", ->
      subject.set(target: '_blank')
      console.debug(subject.asHtml())
      expect( subject.asHtml() ).to.eq('<a href="/link/to/resource" target="_blank">name</a>')


  describe "#asMarkdown", ->

    it "returns the expected markdown", ->
      expect( subject.asMarkdown() ).to.eq('[name](/link/to/resource)')
