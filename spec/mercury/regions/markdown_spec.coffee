#= require spec_helper
#= require mercury/views/uploader
#= require mercury/core/region
#= require mercury/regions/modules/drop_indicator
#= require mercury/regions/modules/drop_item
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
    expect( Klass.klass ).to.eq('Mercury.Region.Markdown')
    expect( Klass.type ).to.eq('markdown')
    expect( subject.editableDropBehavior ).to.be.true
    expect( subject.wrappers ).to.be.defined
    expect( subject.blocks ).to.be.defined

  describe "#constructor", ->

    beforeEach ->
      spyOn(Klass::, 'setupConverter')

    it "notifies if marked is unavailable", ->
      spyOn(Klass::, 'notify')
      subject = new Klass('<div id="foo">', converter: false)
      expect( subject.notify ).calledWith('requires a markdown converter')

    it "allows overriding the converter", ->
      options = converter: spy()
      subject = new Klass('<div id="foo">', options)
      subject.convertedValue()
      expect( options.converter ).called

    it "calls #setupConverter", ->
      subject = new Klass('<div id="foo">')
      expect( Klass::setupConverter ).called


  describe "#setupConverter", ->

    it "calls setOptions on the converter", ->
      spyOn(subject.converter, 'setOptions')
      subject.setupConverter()
      expect( subject.converter.setOptions ).calledWith({})


  describe "#convertedValue", ->

    it "converts the value", ->
      subject.$focusable.val('_value_')
      expect( subject.convertedValue() ).to.eq('<p><em>value</em></p>\n')


  describe "#toJSON", ->

    beforeEach ->
      spyOn(subject, 'convertedValue', -> '_converted_')

    it "includes the converted value if saving", ->
      json = subject.toJSON(true)
      expect( json ).to.include.keys('converted')
      expect( json.converted ).to.eq('_converted_')


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

    describe "with pre", ->

      beforeEach ->
        @stub.returns(text: '    abc')

      it "calls #replaceSelection if there's content after the indicator", ->
        subject.onReturnKey(@e)
        expect( subject.replaceSelection ).calledWith('\n    ')

      it "calls #replaceSelectedLine if it's an empty indented line", ->
        @stub.returns(text: '    ')
        subject.onReturnKey(@e)
        expect( subject.replaceSelectedLine ).calledWith(text: '    ')


  describe "actions", ->

    beforeEach ->
      subject.focused = true
      spyOn(subject, 'toggleWrapSelectedWords')
      spyOn(subject, 'replaceSelectionWithParagraph')
      spyOn(subject, 'wrapSelectedParagraphs')
      spyOn(subject, 'unwrapSelectedParagraphs')

    it "needs to be fully tested"

    describe "#bold", ->

      it "calls #toggleWrapSelectedWords", ->
        subject.handleAction('bold')
        expect( subject.toggleWrapSelectedWords ).calledWith('bold')

    describe "#italic", ->

      it "calls #toggleWrapSelectedWords", ->
        subject.handleAction('italic')
        expect( subject.toggleWrapSelectedWords ).calledWith('italic')

    describe "#underline", ->

      it "calls #toggleWrapSelectedWords", ->
        subject.handleAction('underline')
        expect( subject.toggleWrapSelectedWords ).calledWith('underline')

    describe "#strike", ->

      it "calls #toggleWrapSelectedWords", ->
        subject.handleAction('strike')
        expect( subject.toggleWrapSelectedWords ).calledWith('strike')

    describe "#subscript", ->

      it "calls #toggleWrapSelectedWords", ->
        subject.handleAction('subscript')
        expect( subject.toggleWrapSelectedWords ).calledWith('subscript')

    describe "#superscript", ->

      it "calls #toggleWrapSelectedWords", ->
        subject.handleAction('superscript')
        expect( subject.toggleWrapSelectedWords ).calledWith('superscript')

    describe "#rule", ->

      it "calls #replaceSelectionWithParagraph", ->
        subject.handleAction('rule')
        expect( subject.replaceSelectionWithParagraph ).calledWith('- - -')

    describe "#indent", ->

      it "calls #wrapSelectedParagraphs", ->
        subject.handleAction('indent')
        expect( subject.wrapSelectedParagraphs ).calledWith('blockquote')

    describe "#outdent", ->

      it "calls #unwrapSelectedParagraphs", ->
        subject.handleAction('outdent')
        expect( subject.unwrapSelectedParagraphs ).calledWith('blockquote')

    describe "#orderedList", ->
    describe "#unorderedList", ->
    describe "#style", ->
    describe "#html", ->
    describe "#block", ->
    describe "#character", ->
    describe "#table", ->
    describe "#file", ->
    describe "#link", ->
    describe "#image", ->


  describe "context", ->

    beforeEach ->
      spyOn(subject, 'isWithinLineToken')
      spyOn(subject, 'firstLineMatches')
      spyOn(subject, 'paragraphMatches')
      spyOn(subject, 'isWithinToken')

    describe "#h1", ->

      it "calls #isWithinLineToken", ->
        subject.hasContext('h1')
        expect( subject.isWithinLineToken ).calledWith('h1')

    describe "#h2", ->

      it "calls #isWithinLineToken", ->
        subject.hasContext('h2')
        expect( subject.isWithinLineToken ).calledWith('h2')

    describe "#h3", ->

      it "calls #isWithinLineToken", ->
        subject.hasContext('h3')
        expect( subject.isWithinLineToken ).calledWith('h3')

    describe "#h4", ->

      it "calls #isWithinLineToken", ->
        subject.hasContext('h4')
        expect( subject.isWithinLineToken ).calledWith('h4')

    describe "#h5", ->

      it "calls #isWithinLineToken", ->
        subject.hasContext('h5')
        expect( subject.isWithinLineToken ).calledWith('h5')

    describe "#h6", ->

      it "calls #isWithinLineToken", ->
        subject.hasContext('h6')
        expect( subject.isWithinLineToken ).calledWith('h6')

    describe "#blockquote", ->

      it "calls #firstLineMatches", ->
        subject.hasContext('blockquote')
        expect( subject.firstLineMatches ).calledWith(/^> /)

    describe "#pre", ->

      it "calls #paragraphMatches and falls back to firstLineMatches", ->
        subject.hasContext('pre')
        expect( subject.paragraphMatches ).calledWith(/^```|```$/)
        expect( subject.firstLineMatches ).calledWith(/^(> )*\s{4}/)

    describe "#bold", ->

      it "calls #isWithinToken", ->
        subject.hasContext('bold')
        expect( subject.isWithinToken ).calledWith('bold')

    describe "#italic", ->

      it "calls #isWithinToken", ->
        subject.hasContext('italic')
        expect( subject.isWithinToken ).calledWith('italic')

    describe "#underline", ->

      it "calls #isWithinToken", ->
        subject.hasContext('underline')
        expect( subject.isWithinToken ).calledWith('underline')

    describe "#strike", ->

      it "calls #isWithinToken", ->
        subject.hasContext('strike')
        expect( subject.isWithinToken ).calledWith('strike')

    describe "#subscript", ->

      it "calls #isWithinToken", ->
        subject.hasContext('subscript')
        expect( subject.isWithinToken ).calledWith('subscript')

    describe "#superscript", ->

      it "calls #isWithinToken", ->
        subject.hasContext('superscript')
        expect( subject.isWithinToken ).calledWith('superscript')

    describe "#unorderedList", ->

      it "calls #firstLineMatches", ->
        subject.hasContext('unorderedList')
        expect( subject.firstLineMatches ).calledWith(/^(> )*- /)

    describe "#orderedList", ->

      it "calls #firstLineMatches", ->
        subject.hasContext('orderedList')
        expect( subject.firstLineMatches ).calledWith(/^(> )*\d+\./)
