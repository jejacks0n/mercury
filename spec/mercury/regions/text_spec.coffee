#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/modules/focusable_textarea
#= require mercury/regions/modules/text_selection
#= require mercury/regions/modules/selection_value
#= require mercury/regions/text

describe "Mercury.Region.Text", ->

  Klass = Mercury.Region.Text
  subject = null

  beforeEach ->
    subject = new Klass('<div id="foo">')

  it "is defined correctly", ->
    expect( Klass.klass ).to.eq('Mercury.Region.Text')
    expect( Klass.type ).to.eq('text')
    expect( Klass.supported ).to.be.true

  describe "#originalContent", ->

    it "returns the expected content", ->
      spyOn(subject, 'html', -> ' _&lt;html&gt;_<br/><br  ><br   /><br><tag>')
      expect( subject.originalContent() ).to.eq('_<html>_\n\n\n\n<tag>')
