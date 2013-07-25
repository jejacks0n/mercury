#= require spec_helper
#= require mercury/core/utility/table_editor
#= require mercury/actions/table

describe "Mercury.Action.Table", ->

  Klass = Mercury.Action.Table
  subject = null

  beforeEach ->
    subject = new Klass('table', {})


  describe "#asHtml", ->

    it "returns the expected html (by calling through to the editor)", ->
      subject.attributes = asHtml: -> '<_table_>'
      expect( subject.asHtml() ).to.eq('<_table_>')
