require '/assets/carmenta/carmenta_editor.js'

describe "Carmenta.Toolbar.Button", ->

  template 'carmenta/toolbar.button.html'

  beforeEach ->
    Carmenta.displayRect = {0, 0, 500, 200}
    Carmenta.Toolbar.Button.contexts.foo = -> false
    @region = {
      element: $('<div class="carmenta-region">')
      currentElement: -> $('<div>')
    }

  afterEach ->
    @button = null
    delete(@button)
    $(document).unbind('carmenta:region:update')

  describe "constructor", ->

    it "expects name and title values", ->
      @button = new Carmenta.Toolbar.Button('foo', 'title')
      html = $('<div>').html(@button).html()
      expect(html).toEqual('<div title="title" class="carmenta-button carmenta-foo-button"><em>title</em></div>')

    it "accepts summary, types and options", ->
      @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {palette: '/nothing'}, {appendDialogsTo: $('#test')})
      html = $('<div>').html(@button).html()
      expect(html).toEqual('<div title="summary" class="carmenta-button carmenta-foo-button carmenta-button-palette"><em>title</em></div>')

    it "calls build", ->
      spy = spyOn(Carmenta.Toolbar.Button.prototype, 'build').andCallFake(=>)
      spyOn(Carmenta.Toolbar.Button.prototype, 'bindEvents').andCallFake(=>)
      @button = new Carmenta.Toolbar.Button('foo', 'title')
      expect(spy.callCount).toEqual(1)

    it "calls bindEvents", ->
      spyOn(Carmenta.Toolbar.Button.prototype, 'build').andCallFake(=>)
      spy = spyOn(Carmenta.Toolbar.Button.prototype, 'bindEvents').andCallFake(=>)
      @button = new Carmenta.Toolbar.Button('foo', 'title')
      expect(spy.callCount).toEqual(1)


  describe "#build for various button types", ->

    it "attaches an element meant for the expander in button data", ->
      @button = new Carmenta.Toolbar.Button('foo', 'title')
      expect(@button.data('expander')).toEqual('<div class="carmenta-expander-button" data-button="foo"><em></em><span>title</span></div>')

    it "builds toggle buttons, that when clicked toggle their state", ->
      @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {toggle: true})

      jasmine.simulate.click(@button.get(0))
      expect(@button.hasClass('pressed')).toEqual(true)

      jasmine.simulate.click(@button.get(0))
      expect(@button.hasClass('pressed')).toEqual(false)

    it "builds mode buttons, that when clicked fire a mode event", ->
      @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {mode: true})
      spy = spyOn(Carmenta, 'trigger').andCallFake(=>)

      jasmine.simulate.click(@button.get(0))
      expect(spy.callCount).toEqual(2)
      expect(spy.argsForCall[0]).toEqual(['mode', {mode: 'foo'}])

    it "builds buttons that understand context", ->
      @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {context: true})

      contextSpy = spyOn(Carmenta.Toolbar.Button.contexts, 'foo').andCallFake(-> true)

      expect(@button.hasClass('active')).toEqual(false)

      Carmenta.trigger('region:update', {region: @region})
      expect(contextSpy.callCount).toEqual(1)
      expect(@button.hasClass('active')).toEqual(true)

    it "builds panel buttons (and assigns toggle)", ->
      @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {panel: '/evergreen/responses/blank.html'}, {appendDialogsTo: $('#test')})
      expect($('#test .carmenta-panel').length).toEqual(1)

      jasmine.simulate.click(@button.get(0))
      expect(@button.hasClass('pressed')).toEqual(true)

      jasmine.simulate.click(@button.get(0))
      expect(@button.hasClass('pressed')).toEqual(false)

    it "builds palette buttons", ->
      @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {palette: '/evergreen/responses/blank.html'}, {appendDialogsTo: $('#test')})
      expect($('#test .carmenta-palette').length).toEqual(1)

    it "builds select buttons", ->
      @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {select: '/evergreen/responses/blank.html'}, {appendDialogsTo: $('#test')})
      expect($('#test .carmenta-select').length).toEqual(1)

    it "builds modal buttons", ->
      @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {modal: '/evergreen/responses/blank.html'}, {appendDialogsTo: $('#test')})
      # nothing unique about this in building -- the modal is built/fired on click

    it "throws an error when an unknown type is encountered", ->
      expect(=>
        @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {foo: '/evergreen/responses/blank.html'})
      ).toThrow('Unknown button type foo used for the foo button.')


  describe "observed events", ->

    describe "custom event: region:update", ->

      it "calls contexts if one is available and set", ->
        contextSpy = spyOn(Carmenta.Toolbar.Button.contexts, 'foo').andCallFake(-> true)
        @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {context: true})

        expect(@button.hasClass('active')).toEqual(false)

        Carmenta.trigger('region:update', {region: @region})
        expect(contextSpy.callCount).toEqual(1)
        expect(@button.hasClass('active')).toEqual(true)

    describe "mousedown", ->

      it "sets the active state", ->
        @button = new Carmenta.Toolbar.Button('foo', 'title')

        expect(@button.hasClass('active')).toEqual(false)
        jasmine.simulate.mousedown(@button.get(0))
        expect(@button.hasClass('active')).toEqual(true)

    describe "click for various button types", ->

      it "does nothing if the button is disabled", ->
        spy = spyOn(Carmenta.Toolbar.Button.prototype, 'togglePressed').andCallThrough()
        @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {toggle: true})

        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(1)

        @button.addClass('disabled')
        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(1)

      it "triggers an action event", ->
        @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary')
        spy = spyOn(Carmenta, 'trigger').andCallFake(=>)

        jasmine.simulate.click(@button.get(0))
        expect(spy.argsForCall[0]).toEqual(['action', {action: 'foo'}])

      it "triggers a focus:frame event", ->
        spy = spyOn(Carmenta, 'trigger').andCallFake(=>)
        @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary')

        jasmine.simulate.click(@button.get(0))
        expect(spy.argsForCall[1]).toEqual(['focus:frame'])

      it "toggles toggle button pressed state", ->
        @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {toggle: true})

        jasmine.simulate.click(@button.get(0))
        expect(@button.hasClass('pressed')).toEqual(true)

        jasmine.simulate.click(@button.get(0))
        expect(@button.hasClass('pressed')).toEqual(false)

      it "triggers a mode event", ->
        spy = spyOn(Carmenta, 'trigger').andCallFake(=>)
        @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {mode: true})

        jasmine.simulate.click(@button.get(0))
        expect(spy.argsForCall[0]).toEqual(['mode', {mode: 'foo'}])

      it "opens a modal window", ->
        spy = spyOn(Carmenta, 'modal').andCallFake(=>)
        @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {modal: '/evergreen/responses/blank.html'})

        jasmine.simulate.click(@button.get(0))
        expect(spy.argsForCall[0]).toEqual(['/evergreen/responses/blank.html', {title: 'summary', handler: 'foo'}])

      it "shows and hides palettes", ->
        spy = spyOn(Carmenta.Palette.prototype, 'toggle').andCallFake(=>)
        @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {palette: '/evergreen/responses/blank.html'})

        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(1)

        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(2)

      it "shows and hides selects", ->
        spy = spyOn(Carmenta.Select.prototype, 'toggle').andCallFake(=>)
        @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {select: '/evergreen/responses/blank.html'})

        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(1)

        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(2)

      it "shows and hides panels, and toggles the button pressed state", ->
        spy = spyOn(Carmenta.Panel.prototype, 'toggle').andCallFake(=>)
        @button = new Carmenta.Toolbar.Button('foo', 'title', 'summary', {panel: '/evergreen/responses/blank.html'})

        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(1)

        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(2)


describe "Carmenta.Toolbar.Button.contexts", ->

  template 'carmenta/toolbar.button.html'

  beforeEach ->
    @contexts = Carmenta.Toolbar.Button.contexts
    @region = $('#context_container')
    @element = $('#context_button')

  it "handles background color", ->
    @contexts.backcolor.call(@, $('#context_backcolor'), @region)
    expect(@element.css('background-color')).toEqual('rgb(255, 0, 0)')

    @contexts.backcolor.call(@, $('#context_none'), @region)
    expect(@element.css('background-color')).toEqual('rgba(0, 0, 0, 0)')

  it "handles foreground color", ->
    @contexts.forecolor.call(@, $('#context_forecolor'), @region)
    expect(@element.css('background-color')).toEqual('rgb(0, 255, 0)')

    @contexts.forecolor.call(@, $('#context_none'), @region)
    expect(@element.css('background-color')).toEqual('rgb(0, 0, 0)')

  it "knows when something is bold", ->
    expect(@contexts.bold.call(@, $('#context_bold1 span'), @region)).toEqual(true)
    expect(@contexts.bold.call(@, $('#context_bold2 span'), @region)).toEqual(true)
    expect(@contexts.bold.call(@, $('#context_bold3 span'), @region)).toEqual(true)
    expect(@contexts.bold.call(@, $('#context_bold4 span'), @region)).toEqual(true)
    expect(@contexts.bold.call(@, $('#context_bold5 span'), @region)).toEqual(false)
    expect(@contexts.bold.call(@, $('#context_bold6 span'), @region)).toEqual(true)
    expect(@contexts.bold.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is italic", ->
    expect(@contexts.italic.call(@, $('#context_italic1 span'), @region)).toEqual(true)
    expect(@contexts.italic.call(@, $('#context_italic2 span'), @region)).toEqual(true)
    expect(@contexts.italic.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is overlined", ->
    expect(@contexts.overline.call(@, $('#context_overline'), @region)).toEqual(true)
    expect(@contexts.overline.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is striked through", ->
    expect(@contexts.strikethrough.call(@, $('#context_strikethrough1 span'), @region)).toEqual(true)
    expect(@contexts.strikethrough.call(@, $('#context_strikethrough2'), @region)).toEqual(true)
    expect(@contexts.strikethrough.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is underlined", ->
    expect(@contexts.underline.call(@, $('#context_underline1 span'), @region)).toEqual(true)
    expect(@contexts.underline.call(@, $('#context_underline2'), @region)).toEqual(true)
    expect(@contexts.underline.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is subscript", ->
    expect(@contexts.subscript.call(@, $('#context_subscript span'), @region)).toEqual(true)
    expect(@contexts.subscript.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is superscript", ->
    expect(@contexts.superscript.call(@, $('#context_superscript span'), @region)).toEqual(true)
    expect(@contexts.superscript.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is justified left", ->
    expect(@contexts.justifyleft.call(@, $('#context_justifyleft span'), @region)).toEqual(true)
    expect(@contexts.justifyleft.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is justified center", ->
    expect(@contexts.justifycenter.call(@, $('#context_justifycenter span'), @region)).toEqual(true)
    expect(@contexts.justifycenter.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is justified right", ->
    expect(@contexts.justifyright.call(@, $('#context_justifyright span'), @region)).toEqual(true)
    expect(@contexts.justifyright.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is justified fully", ->
    expect(@contexts.justifyfull.call(@, $('#context_justifyfull span'), @region)).toEqual(true)
    expect(@contexts.justifyfull.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is inside an ordered list", ->
    expect(@contexts.insertorderedlist.call(@, $('#context_orderedlist span'), @region)).toEqual(true)
    expect(@contexts.insertorderedlist.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is inside an unordered list", ->
    expect(@contexts.insertunorderedlist.call(@, $('#context_unorderedlist span'), @region)).toEqual(true)
    expect(@contexts.insertunorderedlist.call(@, $('#context_none'), @region)).toEqual(false)

# todo: fix in jquery
#  it "understands nested text-decoration styles", ->
#    expect(@contexts.underline.call(@, $('#context_decoration'), @region)).toEqual(true)
