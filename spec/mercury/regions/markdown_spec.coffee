#= require spec_helper
#= require mercury/views/uploader
#= require mercury/core/region
#= require mercury/regions/modules/drop_indicator
#= require mercury/regions/modules/text_selection
#= require mercury/regions/modules/focusable_textarea
#= require mercury/regions/markdown

describe "Mercury.MarkdownRegion", ->

  Klass = Mercury.MarkdownRegion
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    subject = new Klass('<div id="foo">')

  it "is defined correctly", ->
    expect( Klass.className ).to.eq('Mercury.MarkdownRegion')
    expect( Klass.type ).to.eq('markdown')
    expect( subject.editableDragOver ).to.be.true


  describe "#constructor", ->

    beforeEach ->
      spyOn(Showdown, 'converter').throws()

    it "notifies if showdown is unavailable", ->
      spyOn(Klass.prototype, 'notify')
      subject = new Klass()
      expect( subject.notify ).calledWith('requires Showdown')

    it "allows overriding the converter", ->
      subject = new Klass('<div id="foo">', converter: ->)


  describe "#value", ->

    it "returns the value if no value was passed", ->
      subject.focusable.val('_value_')
      expect( subject.value() ).to.eq('_value_')

    describe "setting the value", ->

      it "sets the @focusable value", ->
        subject.value('_value_')
        expect( subject.focusable.val() ).to.eq('_value_')

      it "can use an object to set the value and selection", ->
        spyOn(subject, 'setSelection')
        subject.value(val: '_value_', sel: {start: 1, end: 2})
        expect( subject.setSelection ).calledWith(start: 1, end: 2)
        expect( subject.focusable.val() ).to.eq('_value_')


  describe "#convertedValue", ->

    it "converts the value", ->
      subject.focusable.val('_value_')
      expect( subject.convertedValue() ).to.eq('<p><em>value</em></p>')


  describe "#valueForStack", ->

    it "returns the selection and value", ->
      spyOn(subject, 'value', -> '_value_')
      spyOn(subject, 'getSelection', -> {start: 1, end: 2})
      expect( subject.valueForStack() ).to.eql(sel: {start: 1, end: 2}, val: '_value_')


  describe "#pushHistory", ->

    beforeEach ->
      spyOn(subject, 'valueForStack')

    it "pushes to the stack", ->
      subject.pushHistory()
      expect( subject.valueForStack ).called

    describe "with a keycode", ->

      it "pushes to the stack on return, delete, or backspace", ->
        subject.pushHistory(13)
        expect( subject.valueForStack ).calledOnce
        subject.pushHistory(46)
        expect( subject.valueForStack ).calledTwice
        subject.pushHistory(8)
        expect( subject.valueForStack ).calledThrice

      it "delays pushing to the stack", ->
        spyOn(subject, 'delay').yields()
        subject.pushHistory(42)
        expect( subject.delay ).calledWith(2500, sinon.match.func)


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


  # todo: these remain untested until this is hashed out more
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
