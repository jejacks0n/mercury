#= require spec_helper
#= require mercury/views/uploader
#= require mercury/core/region
#= require mercury/regions/modules/drop_indicator
#= require mercury/regions/modules/html_selection
#= require mercury/regions/modules/selection_value
#= require mercury/regions/html

describe "Mercury.HtmlRegion", ->

  Klass = Mercury.HtmlRegion
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    subject = new Klass('<div id="foo">')

  it "is defined correctly", ->
    expect( Klass.className ).to.eq('Mercury.HtmlRegion')
    expect( Klass.type ).to.eq('html')
    expect( Klass.supported ).to.be.true
    expect( subject.skipHistoryOnInitialize ).to.be.true

  describe "#constructor", ->

  describe "#build", ->

  describe "#makeEditable", ->

  describe "#setEditPreferences", ->

  describe "#handleKeyEvent", ->

  describe "actions", ->

    it "should be tested eventually"

    describe "#bold", ->
    describe "#italic", ->
    describe "#underline", ->
    describe "#subscript", ->
    describe "#superscript", ->
    describe "#rule", ->
    describe "#indent", ->
    describe "#outdent", ->
    describe "#style", ->
    describe "#html", ->
    describe "#block", ->
    describe "#orderedList", ->
    describe "#unorderedList", ->
    describe "#snippet", ->
    describe "#file", ->
    describe "#link", ->
    describe "#image", ->
