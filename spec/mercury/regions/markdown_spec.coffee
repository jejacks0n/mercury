#= require spec_helper
#= require mercury/views/uploader
#= require mercury/core/region
#= require mercury/regions/modules/drop_indicator
#= require mercury/regions/modules/text_selection
#= require mercury/regions/modules/focusable_textarea
#= require mercury/regions/modules/selection_value
#= require mercury/regions/markdown

describe "Mercury.Region.Markdown", ->

  Klass = Mercury.Region.Markdown
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    subject = new Klass('<div id="foo">')

  it "is defined correctly", ->
    expect( Klass.className ).to.eq('Mercury.Region.Markdown')
    expect( Klass.type ).to.eq('markdown')
    expect( subject.editableDropBehavior ).to.be.true
    expect( subject.wrappers ).to.be.defined
    expect( subject.blocks ).to.be.defined

  describe "#constructor", ->

    beforeEach ->
      spyOn(Showdown, 'converter').throws()

    it "notifies if showdown is unavailable", ->
      spyOn(Klass::, 'notify')
      subject = new Klass()
      expect( subject.notify ).calledWith('requires Showdown')

    it "allows overriding the converter", ->
      subject = new Klass('<div id="foo">', converter: ->)


  describe "#convertedValue", ->

    it "converts the value", ->
      subject.focusable.val('_value_')
      expect( subject.convertedValue() ).to.eq('<p><em>value</em></p>')


  describe "#onDropFile", ->

    beforeEach ->
      Mercury.configure 'regions:markdown:mimeTypes', ['image/foo']

    it "instantiates a new uploader", ->
      spyOn(Mercury, 'Uploader', -> on: spy())
      subject.onDropFile([1, 2])
      expect(Mercury.Uploader).calledWith([1, 2], mimeTypes: ['image/foo'])

    it "calls #focus and #handleAction on the uploaded event", ->
      spyOn(Mercury, 'Uploader', -> on: stub().yieldsOn(subject, '_file_'))
      spyOn(subject, 'focus')
      spyOn(subject, 'handleAction')
      subject.onDropFile([1, 2])
      expect( subject.focus ).called
      expect( subject.handleAction ).calledWith('file', '_file_')


  describe "#onDropItem", ->

    beforeEach ->
      @e = preventDefault: spy()
      @data = getData: -> '<img src="/teabag/fixtures/image.gif"><meta>'

    it "prevents the default event", ->
      subject.onDropItem(@e, @data)
      expect( @e.preventDefault ).called

    it "calls #focus", ->
      spyOn(subject, 'focus')
      subject.onDropItem(@e, @data)
      expect( subject.focus ).called

    it "calls #handleAction", ->
      spyOn(subject, 'handleAction')
      subject.onDropItem(@e, @data)
      expect( subject.handleAction ).calledWith('image', url: '/teabag/fixtures/image.gif')

    it "does nothing if there's no url", ->
      @data.getData = -> null
      subject.onDropItem(@e, @data)
      expect( @e.preventDefault ).not.called


  describe "#onReturnKey", ->

    beforeEach ->
      spyOn(subject, 'replaceSelection')
      spyOn(subject, 'replaceSelectedLine')
      spyOn(subject, 'getSelection')
      @stub = spyOn(subject, 'expandSelectionToLines')
      @e = preventDefault: spy()

    describe "with unordered lists", ->

      beforeEach ->
        @stub.returns(text: '- abc')

      it "calls preventDefault on the event", ->
        subject.onReturnKey(@e)
        expect( @e.preventDefault ).called

      it "calls #replaceSelection if there's content after the indicator", ->
        subject.onReturnKey(@e)
        expect( subject.replaceSelection ).calledWith('\n- ')

      it "calls #replaceSelectedLine if it's an empty list item", ->
        @stub.returns(text: '- ')
        subject.onReturnKey(@e)
        expect( subject.replaceSelectedLine ).calledWith(text: '- ')

    describe "with ordered lists", ->

      beforeEach ->
        @stub.returns(text: '1. abc')

      it "calls preventDefault on the event", ->
        subject.onReturnKey(@e)
        expect( @e.preventDefault ).called

      it "calls #replaceSelection if there's content after the indicator", ->
        subject.onReturnKey(@e)
        expect( subject.replaceSelection ).calledWith('\n2. ')

      it "calls #replaceSelectedLine if it's an empty list item", ->
        @stub.returns(text: '1. ')
        subject.onReturnKey(@e)
        expect( subject.replaceSelectedLine ).calledWith(text: '1. ')

    describe "with indentation", ->

      beforeEach ->
        @stub.returns(text: '> > > abc')

      it "calls preventDefault on the event", ->
        subject.onReturnKey(@e)
        expect( @e.preventDefault ).called

      it "calls #replaceSelection if there's content after the indicator", ->
        subject.onReturnKey(@e)
        expect( subject.replaceSelection ).calledWith('\n> > > ')

      it "calls #replaceSelectedLine if it's an empty indented line", ->
        @stub.returns(text: '> ')
        subject.onReturnKey(@e)
        expect( subject.replaceSelectedLine ).calledWith(text: '> ')


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
