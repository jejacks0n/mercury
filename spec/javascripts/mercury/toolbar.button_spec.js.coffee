describe "Mercury.Toolbar.Button", ->

  template 'mercury/toolbar.button.html'

  beforeEach ->
    Mercury.displayRect = {0, 0, 500, 200}
    Mercury.Toolbar.Button.contexts.foo = -> true
    @region = {
      type: 'editable'
      element: $('<div class="mercury-region">')
      currentElement: -> $('<div>')
    }
    Mercury.preloadedViews['/nothing'] = 'nothing'

  afterEach ->
    @button = null
    delete(@button)
    $(document).unbind('mercury:region:update')
    $(document).unbind('mercury:button')

  describe "constructor", ->

    it "expects name and title values", ->
      @button = new Mercury.Toolbar.Button('foo', 'title')
      html = $('<div>').html(@button).html()
      expect(html).toContain('title="title"')
      expect(html).toContain('class="mercury-button mercury-foo-button"')
      expect(html).toContain('<em>title</em>')

    it "accepts summary, types and options", ->
      @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {palette: '/nothing'}, {appendDialogsTo: $('#test')})
      html = $('<div>').html(@button).html()
      expect(html).toContain('title="summary"')
      expect(html).toContain('class="mercury-button mercury-foo-button mercury-button-palette"')
      expect(html).toContain('<em>title</em>')

    it "calls build", ->
      spy = spyOn(Mercury.Toolbar.Button.prototype, 'build').andCallFake(=>)
      spyOn(Mercury.Toolbar.Button.prototype, 'bindEvents').andCallFake(=>)
      @button = new Mercury.Toolbar.Button('foo', 'title')
      expect(spy.callCount).toEqual(1)

    it "calls bindEvents", ->
      spyOn(Mercury.Toolbar.Button.prototype, 'build').andCallFake(=>)
      spy = spyOn(Mercury.Toolbar.Button.prototype, 'bindEvents').andCallFake(=>)
      @button = new Mercury.Toolbar.Button('foo', 'title')
      expect(spy.callCount).toEqual(1)


  describe "#build for various button types", ->

    it "attaches an element meant for the expander in button data", ->
      @button = new Mercury.Toolbar.Button('foo', 'title')
      expect(@button.data('expander')).toEqual('<div class="mercury-expander-button" data-button="foo"><em></em><span>title</span></div>')

    it "builds toggle buttons, that when clicked toggle their state", ->
      @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {toggle: true})

      jasmine.simulate.click(@button.get(0))
      expect(@button.hasClass('pressed')).toEqual(true)

      jasmine.simulate.click(@button.get(0))
      expect(@button.hasClass('pressed')).toEqual(false)

    it "builds mode buttons, that when clicked fire a mode event", ->
      @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {mode: true})
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)

      jasmine.simulate.click(@button.get(0))
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['mode', {mode: 'foo'}])

    it "builds buttons that understand context", ->
      @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {context: true})

      expect(@button.hasClass('active')).toEqual(false)
      Mercury.trigger('region:update', {region: @region})
      expect(@button.hasClass('active')).toEqual(true)

    it "builds panel buttons (and assigns toggle)", ->
      @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {panel: '/evergreen/responses/blank.html'}, {appendDialogsTo: $('#test')})
      expect($('#test .mercury-panel').length).toEqual(1)

      jasmine.simulate.click(@button.get(0))
      expect(@button.hasClass('pressed')).toEqual(true)

      jasmine.simulate.click(@button.get(0))
      expect(@button.hasClass('pressed')).toEqual(false)

    it "builds palette buttons", ->
      @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {palette: '/evergreen/responses/blank.html'}, {appendDialogsTo: $('#test')})
      expect($('#test .mercury-palette').length).toEqual(1)

    it "builds select buttons", ->
      @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {select: '/evergreen/responses/blank.html'}, {appendDialogsTo: $('#test')})
      expect($('#test .mercury-select').length).toEqual(1)

    it "builds modal buttons", ->
      @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {modal: '/evergreen/responses/blank.html'}, {appendDialogsTo: $('#test')})
      # nothing unique about this in building -- the modal is built/fired on click

    it "builds lightview buttons", ->
      @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {lightview: '/evergreen/responses/blank.html'}, {appendDialogsTo: $('#test')})
      # nothing unique about this in building -- the lightview is built/fired on click

    it "throws an error when an unknown type is encountered", ->
      expect(=>
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {foo: '/evergreen/responses/blank.html'})
      ).toThrow('Unknown button type "foo" used for the "foo" button.')


  describe "observed events", ->

    describe "custom event: button", ->

      it "calls click on the button itself", ->
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {context: true})
        spy = spyOn(@button, 'click').andCallFake(=>)

        Mercury.trigger('button', {action: 'foo'})
        expect(spy.callCount).toEqual(1)

    describe "custom event: mode", ->

      it "toggles a button when that mode is triggered and the button is toggleable", ->
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {mode: 'preview', toggle: true})
        spy = spyOn(Mercury.Toolbar.Button.prototype, 'togglePressed').andCallFake(=>)

        Mercury.trigger('mode', {mode: 'preview'})
        expect(spy.callCount).toEqual(1)

    describe "custom event: region:update", ->

      it "calls contexts if one is available and set", ->
        contextSpy = spyOn(Mercury.Toolbar.Button.contexts, 'foo').andCallFake(-> true)
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {context: true})

        expect(@button.hasClass('active')).toEqual(false)

        Mercury.trigger('region:update', {region: @region})
        expect(contextSpy.callCount).toEqual(1)
        expect(@button.hasClass('active')).toEqual(true)

    describe "custom event: region:focused", ->

      it "disables if the region type isn't supported", ->
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {context: true, regions: ['foo']})
        @button.removeClass('disabled')
        Mercury.trigger('region:focused', {region: @region})
        expect(@button.hasClass('disabled')).toEqual(true)

      it "enables if the region type is supported", ->
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {context: true, regions: ['editable']})
        @button.addClass('disabled')
        Mercury.trigger('region:focused', {region: @region})
        expect(@button.hasClass('disabled')).toEqual(false)

    describe "custom event: region:blurred", ->

      it "disables if it's a button for specific region types", ->
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {context: true, regions: ['editable']})
        @button.addClass('disabled')
        Mercury.trigger('region:blurred', {region: @region})
        expect(@button.hasClass('disabled')).toEqual(true)

    describe "mousedown", ->

      it "sets the active state", ->
        @button = new Mercury.Toolbar.Button('foo', 'title')

        expect(@button.hasClass('active')).toEqual(false)
        jasmine.simulate.mousedown(@button.get(0))
        expect(@button.hasClass('active')).toEqual(true)

    describe "mouseup", ->

      it "removes the active state", ->
        @button = new Mercury.Toolbar.Button('foo', 'title')
        @button.addClass('active')

        jasmine.simulate.mouseup(@button.get(0))
        expect(@button.hasClass('active')).toEqual(false)

    describe "click for various button types", ->

      it "does nothing if the button is disabled", ->
        spy = spyOn(Mercury.Toolbar.Button.prototype, 'togglePressed').andCallThrough()
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {toggle: true})

        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(1)

        @button.addClass('disabled')
        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(1)

      it "triggers an action event", ->
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary')
        spy = spyOn(Mercury, 'trigger').andCallFake(=>)

        jasmine.simulate.click(@button.get(0))
        expect(spy.argsForCall[0]).toEqual(['action', {action: 'foo'}])

      it "triggers a focus:frame event", ->
        spy = spyOn(Mercury, 'trigger').andCallFake(=>)
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {}, {regions: ['editable']})

        jasmine.simulate.click(@button.get(0))
        expect(spy.argsForCall[1]).toEqual(['focus:frame'])

      it "toggles toggle button pressed state", ->
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {toggle: true})

        jasmine.simulate.click(@button.get(0))
        expect(@button.hasClass('pressed')).toEqual(true)

        jasmine.simulate.click(@button.get(0))
        expect(@button.hasClass('pressed')).toEqual(false)

      it "triggers a mode event", ->
        spy = spyOn(Mercury, 'trigger').andCallFake(=>)
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {mode: true})

        jasmine.simulate.click(@button.get(0))
        expect(spy.argsForCall[0]).toEqual(['mode', {mode: 'foo'}])

      it "opens a modal window", ->
        spy = spyOn(Mercury, 'modal').andCallFake(=>)
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {modal: '/evergreen/responses/blank.html'})

        jasmine.simulate.click(@button.get(0))
        expect(spy.argsForCall[0]).toEqual(['/evergreen/responses/blank.html', {title: 'summary', handler: 'foo'}])

      it "opens a lightview window", ->
        spy = spyOn(Mercury, 'lightview').andCallFake(=>)
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {lightview: '/evergreen/responses/blank.html'})

        jasmine.simulate.click(@button.get(0))
        expect(spy.argsForCall[0]).toEqual(['/evergreen/responses/blank.html', {title: 'summary', handler: 'foo', closeButton: true}])

      it "shows and hides palettes", ->
        spy = spyOn(Mercury.Palette.prototype, 'toggle').andCallFake(=>)
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {palette: '/evergreen/responses/blank.html'})

        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(1)

        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(2)

      it "shows and hides selects", ->
        spy = spyOn(Mercury.Select.prototype, 'toggle').andCallFake(=>)
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {select: '/evergreen/responses/blank.html'})

        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(1)

        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(2)

      it "shows and hides panels, and toggles the button pressed state", ->
        spy = spyOn(Mercury.Panel.prototype, 'toggle').andCallFake(=>)
        @button = new Mercury.Toolbar.Button('foo', 'title', 'summary', {panel: '/evergreen/responses/blank.html'})

        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(1)

        jasmine.simulate.click(@button.get(0))
        expect(spy.callCount).toEqual(2)


describe "Mercury.Toolbar.Button.contexts", ->

  template 'mercury/toolbar.button.html'

  beforeEach ->
    @contexts = Mercury.Toolbar.Button.contexts
    @region = $('#context_container')
    @element = $('#context_button')

  it "handles background color", ->
    @contexts.backColor.call(@, $('#context_backcolor'), @region)
    expect(@element.css('background-color')).toEqual('rgb(255, 0, 0)')

    @contexts.backColor.call(@, $('#context_none'), @region)
    if $.browser.mozilla
      expect(@element.css('background-color')).toEqual('transparent')
    else
      expect(@element.css('background-color')).toEqual('rgba(0, 0, 0, 0)')

  it "handles foreground color", ->
    @contexts.foreColor.call(@, $('#context_forecolor'), @region)
    expect(@element.css('background-color')).toEqual('rgb(0, 255, 0)')

    @contexts.foreColor.call(@, $('#context_none'), @region)
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
    expect(@contexts.justifyLeft.call(@, $('#context_justifyLeft span'), @region)).toEqual(true)
    expect(@contexts.justifyLeft.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is justified center", ->
    expect(@contexts.justifyCenter.call(@, $('#context_justifyCenter span'), @region)).toEqual(true)
    expect(@contexts.justifyCenter.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is justified right", ->
    expect(@contexts.justifyRight.call(@, $('#context_justifyRight span'), @region)).toEqual(true)
    expect(@contexts.justifyRight.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is justified fully", ->
    expect(@contexts.justifyFull.call(@, $('#context_justifyFull span'), @region)).toEqual(true)
    expect(@contexts.justifyFull.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is inside an ordered list", ->
    expect(@contexts.insertOrderedList.call(@, $('#context_orderedlist span'), @region)).toEqual(true)
    expect(@contexts.insertOrderedList.call(@, $('#context_none'), @region)).toEqual(false)

  it "knows when something is inside an unordered list", ->
    expect(@contexts.insertUnorderedList.call(@, $('#context_unorderedlist span'), @region)).toEqual(true)
    expect(@contexts.insertUnorderedList.call(@, $('#context_none'), @region)).toEqual(false)

# todo: fix in jquery
#  it "understands nested text-decoration styles", ->
#    expect(@contexts.underline.call(@, $('#context_decoration'), @region)).toEqual(true)
