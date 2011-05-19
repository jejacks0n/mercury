require '/assets/carmenta/carmenta_editor.js'

describe "Carmenta.Toolbar", ->

  template 'carmenta/toolbar.html'

  afterEach ->
    @toolbar = null
    delete(@toolbar)

  describe "constructor", ->

    beforeEach ->
      @buildSpy = spyOn(Carmenta.Toolbar.prototype, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(Carmenta.Toolbar.prototype, 'bindEvents').andCallFake(=>)
      @toolbar = new Carmenta.Toolbar({appendTo: '#test', foo: true})

    it "accepts options as an argument", ->
      expect(@toolbar.options).toEqual({appendTo: '#test', foo: true})

    it "calls build", ->
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      expect(@bindEventsSpy.callCount).toEqual(1)


  describe "#height", ->

    beforeEach ->
      spyOn(Carmenta.Toolbar.prototype, 'buildButton').andCallFake(=> $('<div>'))
      spyOn(Carmenta.Toolbar.prototype, 'bindEvents').andCallFake(=>)
      @toolbar = new Carmenta.Toolbar({appendTo: '#test'})

    it "knows it's own height", ->
      expect(@toolbar.height()).toEqual(200) # styled with css in the template


  describe "#build", ->

    beforeEach ->
      @buildButtonSpy = spyOn(Carmenta.Toolbar.prototype, 'buildButton').andCallFake(=> $('<div>'))
      @toolbar = new Carmenta.Toolbar({appendTo: '#toolbar_container'})

    it "builds an element", ->
      expect($('.carmenta-toolbar-container').length).toEqual(1)

    it "can append to any element", ->
      expect($('#toolbar_container .carmenta-toolbar-container').length).toEqual(1)

    it "builds out toolbar elements from the configuration", ->
      expect($('.carmenta-primary-toolbar').length).toEqual(1)
      expect($('.carmenta-editable-toolbar').length).toEqual(1)

    it "builds buttons etc.", ->
      expect(@buildButtonSpy.callCount).toBeGreaterThan(10)

    it "sets it's width back to 100%", ->
      expect(@toolbar.element.get(0).style.width).toEqual('100%')

    it "disables all but the primary toolbar", ->
      expect($('.carmenta-editable-toolbar').hasClass('disabled')).toEqual(true)

    it "adds an expander when white-space: nowrap (meaning the toolbar shouldn't wrap)", ->
      expect($('.carmenta-toolbar-button-container').length).toBeGreaterThan(1)
      expect($('.carmenta-toolbar-expander').length).toEqual(1)


  describe "#buildButton", ->

    beforeEach ->
      @toolbar = new Carmenta.Toolbar({appendTo: '#test'})

    it "throws an exception when invalid options are passed", ->
      expect(=> @toolbar.buildButton('foo', false)).toThrow('Unknown button structure -- please provide an array, object, or string for foo.')

    it "builds buttons", ->
      html = $('<div>').html(@toolbar.buildButton('foobutton', ['title', 'summary', {}])).html()
      expect(html).toEqual('<div title="summary" class="carmenta-button carmenta-foobutton-button"><em>title</em></div>')

    it "builds button groups", ->
      html = $('<div>').html(@toolbar.buildButton('foogroup', {foobutton: ['title', 'summary', {}]})).html()
      expect(html).toEqual('<div class="carmenta-button-group carmenta-foogroup-group"><div title="summary" class="carmenta-button carmenta-foobutton-button"><em>title</em></div></div>')

    it "builds separators", ->
      html = $('<div>').html(@toolbar.buildButton('foosep1', ' ')).html()
      expect(html).toEqual('<hr class="carmenta-separator">')

      html = $('<div>').html(@toolbar.buildButton('foosep1', '-')).html()
      expect(html).toEqual('<hr class="carmenta-line-separator">')

    it "builds buttons from configuration", ->
      expect($('.carmenta-primary-toolbar .carmenta-save-button').length).toEqual(1)
      expect($('.carmenta-primary-toolbar .carmenta-preview-button').length).toEqual(1)

    it "builds button groups from configuration", ->
      expect($('.carmenta-editable-toolbar .carmenta-decoration-group').length).toEqual(1)
      expect($('.carmenta-editable-toolbar .carmenta-script-group').length).toEqual(1)

    it "builds separators from configuration", ->
      expect($('.carmenta-separator').length).toBeGreaterThan(1);
      expect($('.carmenta-line-separator').length).toBeGreaterThan(1);


  describe "observed events", ->

    beforeEach ->
      @toolbar = new Carmenta.Toolbar({appendTo: '#test'})

    describe "custom event: region:focused", ->

      it "enables toolbars for the region type", ->
        $('.carmenta-editable-toolbar').addClass('disabled')
        Carmenta.trigger('region:focused', {region: {type: 'editable'}})
        expect($('.carmenta.editable-toolbar').hasClass('disabled')).toEqual(false)

    describe "custom event: region:blurred", ->

      it "disables toolbars for the region type", ->
        $('.carmenta-editable-toolbar').removeClass('disabled')
        Carmenta.trigger('region:blurred', {region: {type: 'editable'}})
        expect($('.carmenta-editable-toolbar').hasClass('disabled')).toEqual(true)

    describe "click", ->

      it "triggers hide:dialogs", ->
        spy = spyOn(Carmenta, 'trigger')

        jasmine.simulate.click(@toolbar.element.get(0))

        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual(['hide:dialogs'])
