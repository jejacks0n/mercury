describe "Mercury.Panel", ->

  template 'mercury/panel.html'

  beforeEach ->
    Mercury.displayRect = {top: 20, left: 20, width: 200, height: 200}
    $.fx.off = true
    Mercury.determinedLocale =
      top: {'hello world!': 'bork! bork!'}
      sub: {'foo': 'Bork!'}

  afterEach ->
    Mercury.config.localization.enabled = false
    delete(@panel)
    $(window).unbind('mercury:resize')
    $(window).unbind('mercury:hide:panels')

  describe "#build", ->

    it "builds an element", ->
      @panel = new Mercury.Panel('/evergreen/resources/panel.html', 'foo', {appendTo: '#test', title: 'foo panel'})
      html = $('<div>').html(@panel.element).html()
      expect(html).toContain('class="mercury-panel loading"')
      expect(html).toContain('style="display:none;"')
      expect(html).toContain('<h1>foo panel</h1><div class="mercury-panel-pane"></div>')
      expect(html).not.toContain('class="mercury-panel-close"')

    it "appends to any element", ->
      @panel = new Mercury.Panel('/evergreen/resources/panel.html', 'foo', {appendTo: '#panel_container', title: 'foo panel'})
      expect($('#panel_container .mercury-panel').length).toEqual(1)

    it "creates a close button if it should", ->
      @panel = new Mercury.Panel('/evergreen/resources/panel.html', 'foo', {appendTo: '#test', title: 'foo panel', closeButton: true})
      html = $('<div>').html(@panel.element).html()
      expect(html).toContain('class="mercury-panel-close"')
      expect(@panel.element.find('.mercury-panel-close').css('opacity')).toEqual('0')


  describe "observed events", ->

    beforeEach ->
      @panel = new Mercury.Panel('/evergreen/resources/panel.html', 'foo', {appendTo: '#test', title: 'foo panel', for: $('#button'), closeButton: true})

    describe "custom event: resize", ->

      it "calls position", ->
        spy = spyOn(Mercury.Panel.prototype, 'position').andCallFake(=>)
        Mercury.trigger('resize')
        expect(spy.callCount).toEqual(1)

    describe "custom event: hide:panels", ->

      it "hides", ->
        @panel.element.css({display: 'block'})
        Mercury.trigger('hide:panels')
        expect(@panel.element.css('display')).toEqual('none')

      it "doesn't hide if it's the same dialog", ->
        @panel.element.css({display: 'block'})
        Mercury.trigger('hide:panels', @panel)
        expect(@panel.element.css('display')).toEqual('block')

    describe "ajax:beforeSend", ->

      it "sets a success that will load the contents of the response", ->
        options = {}
        loadContentSpy = spyOn(Mercury.Panel.prototype, 'loadContent').andCallFake(=>)
        resizeSpy = spyOn(Mercury.Panel.prototype, 'resize').andCallFake(=>)
        @panel.element.trigger('ajax:beforeSend', [null, options])
        expect(options.success).toBeDefined()
        options.success('new content')
        expect(loadContentSpy.callCount).toEqual(1)
        expect(loadContentSpy.argsForCall[0]).toEqual(['new content'])
        expect(resizeSpy.callCount).toEqual(1)

    describe "clicking on the close button", ->

      it "calls hide:panels", ->
        spy = spyOn(Mercury, 'trigger').andCallFake(=>)
        jasmine.simulate.click(@panel.element.find('.mercury-panel-close').get(0))
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual(['hide:panels'])


  describe "#show", ->

    beforeEach ->
      @panel = new Mercury.Panel('/evergreen/resources/panel.html', 'foo', {appendTo: '#test', title: 'foo panel'})

    it "hides other panels and dialogs", ->
      spyOn(Mercury.Panel.prototype, 'position')
      spyOn(Mercury.Panel.prototype, 'appear')
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      @panel.show()
      expect(spy.callCount).toEqual(2)
      expect(spy.argsForCall[0]).toEqual(['hide:panels', @panel])
      expect(spy.argsForCall[1]).toEqual(['hide:dialogs', @panel])


  describe "#resize", ->

    beforeEach ->
      @panel = new Mercury.Panel('/evergreen/resources/panel.html', 'foo', {appendTo: '#panel_container', title: 'foo panel'})
      @panel.element.css({display: 'block'})
      @panel.visible = true

    it "figures out what size it should be and resizes", ->
      @panel.resize()
      expect(@panel.element.offset()).toEqual({top: 42, left: 84})
      expect(@panel.element.css('display')).toEqual('block')

    it "calls makeDraggable", ->
      spy = spyOn(Mercury.Panel.prototype, 'makeDraggable').andCallFake(=>)
      @panel.resize()
      expect(spy.callCount).toEqual(1)

    it "keeps it hidden if it's not supposed to be visible", ->
      @panel.visible = false
      @panel.resize()
      expect(@panel.element.css('display')).toEqual('none')


  describe "#position", ->

    beforeEach ->
      @panel = new Mercury.Panel('/evergreen/resources/panel.html', 'foo', {appendTo: '#panel_container', title: 'foo panel'})
      @panel.element.css({display: 'block'})
      @panel.visible = true

    it "positions based on the display rectangle", ->
      @panel.position(true)
      expect(@panel.element.offset()).toEqual({top: 70, left: 122})
      expect(@panel.element.css('display')).toEqual('block')

    it "calls makeDraggable", ->
      spy = spyOn(Mercury.Panel.prototype, 'makeDraggable').andCallFake(=>)
      @panel.position()
      expect(spy.callCount).toEqual(1)

    it "keeps it hidden if it's not supposed to be visible", ->
      @panel.visible = false
      @panel.position()
      expect(@panel.element.css('display')).toEqual('none')


  describe "#loadContent", ->

    beforeEach ->
      @panel = new Mercury.Panel('/evergreen/resources/panel.html', 'foo', {appendTo: '#test', title: 'foo panel'})

    it "sets loaded to be true", ->
      @panel.loadContent()
      expect(@panel.loaded).toEqual(true)

    it "removes the loading class from the element", ->
      @panel.loadContent()
      expect(@panel.element.hasClass('loading')).toEqual(false)

    it "sets the element html to be the data passed to it", ->
      @panel.loadContent('<span>hello world!</span>')
      html = @panel.element.html()
      expect(html).toContain('<h1>foo panel</h1>')
      expect(html).toContain('class="mercury-panel-pane"')
      expect(html).toContain('style="visibility: hidden;')
      expect(html).toContain('hello world!')

    it "sets the element html to be the data passed to it", ->
      Mercury.config.localization.enabled = true
      @panel.loadContent('<span>hello world!</span>')
      html = @panel.element.html()
      expect(html).toContain('<h1>foo panel</h1>')
      expect(html).toContain('class="mercury-panel-pane"')
      expect(html).toContain('style="visibility: hidden;')
      expect(html).toContain('bork! bork!')


  describe "#makesDraggable", ->

    beforeEach ->
      @panel = new Mercury.Panel('/evergreen/resources/panel.html', 'foo', {appendTo: '#test', title: 'foo panel'})

    it "makes the element draggable", ->
      spy = spyOn($.fn, 'draggable').andCallFake(=>)
      @panel.makeDraggable()
      expect(spy.callCount).toEqual(1)
