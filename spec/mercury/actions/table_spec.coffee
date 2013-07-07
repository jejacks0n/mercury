#= require spec_helper
#= require mercury/actions/table

describe "Mercury.Action.Table", ->

  Klass = Mercury.Action.Table
  table = new Mercury.TableEditor($('<table><tr><td /><td /></tr></table>'))
  subject = null

  beforeEach ->
    subject = new Klass('table', table)

  describe "constructor", ->

    it "should have an editor", ->
      expect( subject.attributes ).to.eq(table)

  describe "#asHtml", ->

    it "returns the expected html", ->
      expect( subject.asHtml() ).to.eq('<table><tr><td /><td /></tr></table>')
