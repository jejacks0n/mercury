require '/assets/mercury/mercury_editor.js'

describe "Mercury.Toolbar", ->

  template 'mercury/toolbar.html'

  beforeEach ->
    ajaxSpy = spyOn($, 'ajax').andCallFake (url, options) =>
      options.success('data') if options.success


  afterEach ->
    @toolbar = null
    delete(@toolbar)

  describe "constructor", ->

    beforeEach ->
      @buildSpy = spyOn(Mercury.Toolbar.prototype, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(Mercury.Toolbar.prototype, 'bindEvents').andCallFake(=>)
      @toolbar = new Mercury.Toolbar({appendTo: '#test', foo: true})

    it "accepts options as an argument", ->
      expect(@toolbar.options).toEqual({appendTo: '#test', foo: true})

    it "calls build", ->
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      expect(@bindEventsSpy.callCount).toEqual(1)


  describe "#height", ->

    beforeEach ->
      spyOn(Mercury.Toolbar.prototype, 'buildButton').andCallFake(=> $('<div>'))
      spyOn(Mercury.Toolbar.prototype, 'bindEvents').andCallFake(=>)
      @toolbar = new Mercury.Toolbar({appendTo: '#test'})

    it "knows it's own height", ->
      expect(@toolbar.height()).toEqual(200) # styled with css in the template


  describe "#build", ->

    beforeEach ->
      @buildButtonSpy = spyOn(Mercury.Toolbar.prototype, 'buildButton').andCallFake(=> $('<div>'))
      @toolbar = new Mercury.Toolbar({appendTo: '#toolbar_container'})

    it "builds an element", ->
      expect($('.mercury-toolbar-container').length).toEqual(1)

    it "can append to any element", ->
      expect($('#toolbar_container .mercury-toolbar-container').length).toEqual(1)

    it "builds out toolbar elements from the configuration", ->
      expect($('.mercury-primary-toolbar').length).toEqual(1)
      expect($('.mercury-editable-toolbar').length).toEqual(1)

    it "builds buttons etc.", ->
      expect(@buildButtonSpy.callCount).toBeGreaterThan(10)

    it "sets it's width back to 100%", ->
      expect(@toolbar.element.get(0).style.width).toEqual('100%')

    it "disables all but the primary toolbar", ->
      expect($('.mercury-editable-toolbar').hasClass('disabled')).toEqual(true)

    it "adds an expander when white-space: nowrap (meaning the toolbar shouldn't wrap)", ->
      expect($('.mercury-toolbar-button-container').length).toBeGreaterThan(1)
      expect($('.mercury-toolbar-expander').length).toEqual(1)


  describe "#buildButton", ->

    beforeEach ->
      @toolbar = new Mercury.Toolbar({appendTo: '#test'})

    it "throws an exception when invalid options are passed", ->
      expect(=> @toolbar.buildButton('foo', false)).toThrow('Unknown button structure -- please provide an array, object, or string for foo.')

    it "builds buttons", ->
      html = $('<div>').html(@toolbar.buildButton('foobutton', ['title', 'summary', {}])).html()
      expect(html).toContain('title="summary"')
      expect(html).toContain('class="mercury-button mercury-foobutton-button"')
      expect(html).toContain('<em>title</em>')

    it "builds button groups", ->
      html = $('<div>').html(@toolbar.buildButton('foogroup', {foobutton: ['title', 'summary', {}]})).html()
      expect(html).toContain('class="mercury-button-group mercury-foogroup-group"')
      expect(html).toContain('title="summary"')
      expect(html).toContain('class="mercury-button mercury-foobutton-button"')
      expect(html).toContain('<em>title</em>')

    it "builds separators", ->
      html = $('<div>').html(@toolbar.buildButton('foosep1', ' ')).html()
      expect(html).toEqual('<hr class="mercury-separator">')

      html = $('<div>').html(@toolbar.buildButton('foosep1', '-')).html()
      expect(html).toEqual('<hr class="mercury-line-separator">')

    it "builds buttons from configuration", ->
      expect($('.mercury-primary-toolbar .mercury-save-button').length).toEqual(1)
      expect($('.mercury-primary-toolbar .mercury-preview-button').length).toEqual(1)

    it "builds button groups from configuration", ->
      expect($('.mercury-editable-toolbar .mercury-decoration-group').length).toEqual(1)
      expect($('.mercury-editable-toolbar .mercury-script-group').length).toEqual(1)

    it "builds separators from configuration", ->
      expect($('.mercury-separator').length).toBeGreaterThan(1);
      expect($('.mercury-line-separator').length).toBeGreaterThan(1);


  describe "observed events", ->

    beforeEach ->
      @toolbar = new Mercury.Toolbar({appendTo: '#test'})

    describe "custom event: region:focused", ->

      it "enables toolbars for the region type", ->
        $('.mercury-editable-toolbar').addClass('disabled')
        Mercury.trigger('region:focused', {region: {type: 'editable'}})
        expect($('.mercury.editable-toolbar').hasClass('disabled')).toEqual(false)

    describe "custom event: region:blurred", ->

      it "disables toolbars for the region type", ->
        $('.mercury-editable-toolbar').removeClass('disabled')
        Mercury.trigger('region:blurred', {region: {type: 'editable'}})
        expect($('.mercury-editable-toolbar').hasClass('disabled')).toEqual(true)

    describe "click", ->

      it "triggers hide:dialogs", ->
        spy = spyOn(Mercury, 'trigger')

        jasmine.simulate.click(@toolbar.element.get(0))

        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual(['hide:dialogs'])
