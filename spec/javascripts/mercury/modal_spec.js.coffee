describe "Mercury.modal", ->

  template 'mercury/modal.html'

  beforeEach ->
    $.fx.off = true
    Mercury.displayRect = {fullHeight: 200}
    Mercury.determinedLocale =
      top: {'hello world!': 'bork! bork!'}
      sub: {'foo': 'Bork!'}

  afterEach ->
    Mercury.config.localization.enabled = false
    Mercury.modal.instance = false
    $(window).unbind('mercury:refresh')
    $(window).unbind('mercury:resize')
    $(document).unbind('keydown')

  describe "builder method", ->

    beforeEach ->
      @showSpy = spyOn(Mercury.Modal.prototype, 'show').andCallFake(=>)

    it "calls show", ->
      Mercury.modal('/foo')
      expect(@showSpy.callCount).toEqual(1)

    it "returns an instance", ->
      ret = Mercury.modal('/foo')
      expect(ret.constructor).toEqual(Mercury.Modal)
      expect(ret).toEqual(new Mercury.Modal('/foo'))


  describe "#show", ->

    beforeEach ->
      @initializeSpy = spyOn(Mercury.Modal.prototype, 'initializeModal').andCallFake(=>)
      @updateSpy = spyOn(Mercury.Modal.prototype, 'update').andCallFake(=>)
      @appearSpy = spyOn(Mercury.Modal.prototype, 'appear').andCallFake(=>)

    it "triggers the focus:window event", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      new Mercury.Modal().show()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:window'])

    it "calls initialize", ->
      new Mercury.Modal().show()
      expect(@initializeSpy.callCount).toEqual(1)

    describe "if already visible", ->

      it "calls update", ->
        modal = new Mercury.Modal()
        modal.visible = true
        modal.show()
        expect(@updateSpy.callCount).toEqual(1)

    describe "if not visible", ->

      it "calls appear", ->
        modal = new Mercury.Modal()
        modal.visible = false
        modal.show()
        expect(@appearSpy.callCount).toEqual(1)


  describe "#initializeModal", ->

    beforeEach ->
      @buildSpy = spyOn(Mercury.Modal.prototype, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(Mercury.Modal.prototype, 'bindEvents').andCallFake(=>)
      @modal = new Mercury.Modal()

    it "calls build", ->
      @modal.initializeModal()
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      @modal.initializeModal()
      expect(@bindEventsSpy.callCount).toEqual(1)

    it "does nothing if already initialized", ->
      @modal.initialized = true
      @modal.initializeModal()
      expect(@buildSpy.callCount).toEqual(0)

    it "sets initialized to true", ->
      @modal.initializeModal()
      expect(@modal.initialized).toEqual(true)


  describe "#build", ->

    beforeEach ->
      @modal = new Mercury.Modal('', {appendTo: $('#test')})

    it "builds an element", ->
      @modal.build()
      expect($('#test .mercury-modal').length).toEqual(1)

    it "builds an overlay element", ->
      @modal.build()
      expect($('#test .mercury-modal-overlay').length).toEqual(1)

    it "creates a titleElement", ->
      @modal.build()
      expect($('#test .mercury-modal-title').length).toEqual(1)
      expect($('#test .mercury-modal-title').html()).toMatch(/<span><\/span><a>.+<\/a>/)
      expect(@modal.titleElement).toBeDefined()

    it "creates a contentContainerElement", ->
      @modal.build()
      expect($('#test .mercury-modal-content-container').length).toEqual(1)
      expect(@modal.contentContainerElement).toBeDefined()

    it "creates a contentElement", ->
      @modal.build()
      expect($('#test .mercury-modal-content-container .mercury-modal-content').length).toEqual(1)
      expect(@modal.contentElement).toBeDefined()

    it "appends to any element", ->
      @modal.options = {appendTo: $('#modal_container')}
      @modal.build()
      expect($('#modal_container .mercury-modal').length).toEqual(1)
      expect($('#modal_container .mercury-modal-overlay').length).toEqual(1)


  describe "observed events", ->

    beforeEach ->
      spyOn(Mercury.Modal.prototype, 'appear').andCallFake(=>)
      @modal = Mercury.modal('/foo', {appendTo: $('#test')})

    describe "custom event: refresh", ->

      it "calls resize telling it stay visible", ->
        spy = spyOn(@modal, 'resize').andCallFake(=>)
        Mercury.trigger('refresh')
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual([true])

    describe "custom event: resize", ->

      it "calls position", ->
        spy = spyOn(@modal, 'position').andCallFake(=>)
        Mercury.trigger('resize')
        expect(spy.callCount).toEqual(1)

    describe "clicking on the overlay (options.allowHideUsingOverlay = true)", ->

      it "calls hide", ->
        @modal.options.allowHideUsingOverlay = true
        spy = spyOn(@modal, 'hide').andCallFake(=>)
        jasmine.simulate.click($('.mercury-modal-overlay').get(0))
        expect(spy.callCount).toEqual(1)

    describe "clicking on the overlay (options.allowHideUsingOverlay = false)", ->

      it "doesn't call hide", ->
        spy = spyOn(@modal, 'hide').andCallFake(=>)
        jasmine.simulate.click($('.mercury-modal-overlay').get(0))
        expect(spy.callCount).toEqual(0)

    describe "clicking on the close button", ->

      it "calls hide", ->
        spy = spyOn(@modal, 'hide').andCallFake(=>)
        jasmine.simulate.click($('.mercury-modal-title a').get(0))
        expect(spy.callCount).toEqual(1)

    describe "pressing esc on document", ->

      beforeEach ->
        @modal.visible = true

      it "calls hide", ->
        spy = spyOn(@modal, 'hide').andCallFake(=>)
        jasmine.simulate.keydown(document, {keyCode: 27})
        expect(spy.callCount).toEqual(1)

    describe "ajax:beforeSend", ->

      it "sets a success that will load the contents of the response", ->
        options = {}
        spy = spyOn(@modal, 'loadContent').andCallFake(=>)
        @modal.element.trigger('ajax:beforeSend', [null, options])
        expect(options.success).toBeDefined()
        options.success('new content')
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual(['new content'])


  describe "#appear", ->

    beforeEach ->
      @modal = new Mercury.Modal('/blank.html', {appendTo: $('#test')})
      @modal.visible = true
      spyOn(@modal, 'update').andCallFake(=>)
      @loadSpy = spyOn(@modal, 'load').andCallFake(=>)
      @positionSpy = spyOn(@modal, 'position').andCallFake(=>)
      @modal.show()

    it "calls position", ->
      @modal.appear()
      expect(@positionSpy.callCount).toEqual(1)

    it "shows the overlay", ->
      expect($('.mercury-modal-overlay').css('display')).toEqual('none')
      @modal.appear()
      expect($('.mercury-modal-overlay').css('display')).toEqual('block')

    it "animates the overlay to full opacity", ->
      expect($('.mercury-modal-overlay').css('opacity')).toEqual('0')
      @modal.appear()
      expect($('.mercury-modal-overlay').css('opacity')).toEqual('1')

    it "calls setTitle", ->
      spy = spyOn(@modal, 'setTitle').andCallFake(=>)
      @modal.appear()
      expect(spy.callCount).toEqual(1)

    it "shows the element", ->
      expect($('.mercury-modal').css('display')).toEqual('none')
      @modal.appear()
      expect($('.mercury-modal').css('display')).toEqual('block')

    it "animates the element down", ->
      expect($('.mercury-modal').css('top')).toEqual('-100px')
      @modal.appear()
      expect($('.mercury-modal').css('top')).toEqual('0px')

    it "sets visible to true", ->
      @modal.visible = false
      @modal.appear()
      expect(@modal.visible).toEqual(true)

    it "calls load", ->
      @modal.appear()
      expect(@loadSpy.callCount).toEqual(1)


  describe "#resize", ->

    beforeEach ->
      @modal = new Mercury.Modal('/blank.html', {appendTo: $('#test')})
      spyOn(@modal, 'appear').andCallFake(=>)
      @modal.show()
      @modal.contentPane = $()

    it "will keep the content element visible if asked to do so", ->
      $('.mercury-modal-content').css('visibility', 'visible')
      @modal.resize(true)
      expect($('.mercury-modal-content').css('visibility')).toEqual('visible')

    it "resizes the element and adjusts it's position", ->
      Mercury.displayRect.width = 1000
      $('.mercury-modal').css({display: 'block', visibility: 'visible', top: 0})
      @modal.resize()
      expect($('.mercury-modal').width()).toEqual(400)
      expect($('.mercury-modal').offset()).toEqual({top: 0, left: 300})
      expect($('.mercury-modal').height()).toBeGreaterThan(20)

    it "respects minWidth provided in options", ->
      @modal.options.minWidth = 500
      @modal.resize()
      expect($('.mercury-modal').width()).toEqual(500)


  describe "#position", ->

    beforeEach ->
      spyOn(Mercury.Modal.prototype, 'appear').andCallFake(=>)

    # todo: test this
    it "positions the element", ->


  describe "#update", ->

    beforeEach ->
      @modal = new Mercury.Modal()
      @resetSpy = spyOn(@modal, 'reset').andCallFake(=>)
      @resizeSpy = spyOn(@modal, 'resize').andCallFake(=>)
      @loadSpy = spyOn(@modal, 'load').andCallFake(=>)
      @modal.update()

    it "calls reset", ->
      expect(@resetSpy.callCount).toEqual(1)

    it "calls resize", ->
      expect(@resizeSpy.callCount).toEqual(1)

    it "calls load", ->
      expect(@loadSpy.callCount).toEqual(1)


  describe "#load", ->

    beforeEach ->
      spyOn(Mercury.Modal.prototype, 'appear').andCallFake(=>)
      @ajaxSpy = spyOn($, 'ajax')
      @modal = Mercury.modal('/blank.html', {appendTo: $('#test')})

    it "does nothing if there's no url", ->
      @modal.url = null
      $('.mercury-modal').removeClass('loading')
      @modal.load()
      expect($('.mercury-modal').hasClass('loading')).toEqual(false)

    it "sets the loading class on the element", ->
      @modal.load()
      expect($('.mercury-modal').hasClass('loading')).toEqual(true)

    it "calls setTitle", ->
      spy = spyOn(@modal, 'setTitle').andCallFake(=>)
      @modal.load()
      expect(spy.callCount).toEqual(1)

    describe "on a preloaded view", ->

      beforeEach ->
        @setTimeoutSpy = spyOn(window, 'setTimeout').andCallFake((callback, timeout) => callback())
        Mercury.preloadedViews = {'/blank.html': 'this is the preloaded content'}

      afterEach ->
        Mercury.preloadedViews = {}

      it "calls loadContent with the content in the preloaded view", ->
        spy = spyOn(@modal, 'loadContent').andCallFake(=>)
        @modal.load()
        expect(@setTimeoutSpy.callCount).toEqual(1)
        expect(spy.callCount).toEqual(1)

    describe "when not a preloaded view", ->

      it "makes an ajax request", ->
        @ajaxSpy.andCallFake(=>)
        spyOn(Mercury, 'ajaxHeaders').andCallFake(=> {'X-CSRFToken': 'f00'})
        @modal.load()
        expect(@ajaxSpy.callCount).toEqual(1)
        expect(@ajaxSpy.argsForCall[0][1]['headers']).toEqual({'X-CSRFToken': 'f00'})

      describe "on success", ->

        beforeEach ->
          @ajaxSpy.andCallFake((url, options) => options.success('return value'))

        it "calls loadContent and passes the returned data", ->
          spy = spyOn(@modal, 'loadContent').andCallFake(=>)
          @modal.load()
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['return value'])

      describe "on failure", ->

        beforeEach ->
          @ajaxSpy.andCallFake((url, options) => options.error())

        it "calls hide", ->
          spyOn(window, 'alert').andCallFake(=>)
          spy = spyOn(@modal, 'hide').andCallFake(=>)
          @modal.load()
          expect(spy.callCount).toEqual(1)

        it "alerts an error message", ->
          spyOn(@modal, 'hide').andCallFake(=>)
          spy = spyOn(window, 'alert').andCallFake(=>)
          @modal.load()
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['Mercury was unable to load /blank.html for the modal.'])


  describe "#loadContent", ->

    beforeEach ->
      spyOn(Mercury.Modal.prototype, 'appear').andCallFake(=>)
      @resizeSpy = spyOn(Mercury.Modal.prototype, 'resize').andCallFake(=>)
      @modal = Mercury.modal('/blank.html', {appendTo: $('#test'), title: 'title'})

    it "accepts options and sets them to the instance options", ->
      @modal.loadContent('content', {title: 'title'})
      expect(@modal.options).toEqual({title: 'title'})

    it "calls initialize", ->
      spy = spyOn(@modal, 'initializeModal').andCallFake(=>)
      @modal.loadContent('content')
      expect(spy.callCount).toEqual(1)

    it "calls setTitle", ->
      spy = spyOn(@modal, 'setTitle').andCallFake(=>)
      @modal.loadContent('content')
      expect(spy.callCount).toEqual(1)

    it "sets loaded to true", ->
      @modal.loaded = false
      @modal.loadContent('content')
      expect(@modal.loaded).toEqual(true)

    it "removes the loading class", ->
      $('.mercury-modal').addClass('loading')
      @modal.loadContent('content')
      expect($('.mercury-modal').hasClass('loading')).toEqual(false)

    it "sets the content elements html to whatever was passed", ->
      @modal.loadContent('<span>content</span>')
      expect($('.mercury-modal-content').html()).toEqual('<span>content</span>')

    it "hides the contentElement", ->
      $('.mercury-modal-content').css('display', 'block')
      @modal.loadContent('content')
      expect($('.mercury-modal-content').css('display')).toEqual('none')
      expect($('.mercury-modal-content').css('visibility')).toEqual('hidden')

    it "finds the content panes and control elements in case they were added with the content", ->
      @modal.loadContent('<div class="mercury-display-pane-container"></div><div class="mercury-display-controls"></div>')
      expect(@modal.contentPane.get(0)).toEqual($('#test .mercury-display-pane-container').get(0))
      expect(@modal.contentControl.get(0)).toEqual($('#test .mercury-display-controls').get(0))

    it "calls an afterLoad callback (if provided in options)", ->
      callCount = 0
      @modal.loadContent('content', {afterLoad: => callCount += 1})
      expect(callCount).toEqual(1)

    it "calls a handler method if one is set in modalHandlers", ->
      callCount = 0
      Mercury.modalHandlers['foo'] = => callCount += 1
      @modal.loadContent('content', {handler: 'foo'})
      expect(callCount).toEqual(1)

    it "translates the content if configured", ->
      Mercury.config.localization.enabled = true
      @modal.loadContent('<span>foo</span>')
      expect($('.mercury-modal-content').html()).toEqual('<span>Bork!</span>')

    it "calls resize", ->
      @modal.loadContent('content')
      expect(@resizeSpy.callCount).toEqual(1)


  describe "#setTitle", ->

    beforeEach ->
      spyOn(Mercury.Modal.prototype, 'appear').andCallFake(=>)
      @modal = Mercury.modal('/blank.html', {appendTo: $('#test'), title: 'title'})

    it "sets the the title contents to what was provided in the options", ->
      @modal.options = {title: 'new title'}
      @modal.setTitle()
      expect($('.mercury-modal-title span').html()).toEqual('new title')
      expect($('.mercury-modal-title a').css('display')).toEqual('inline')

    it "hides the close button if the options.closeButton is false", ->
      @modal.options = {title: 'new title', closeButton: false}
      @modal.setTitle()
      expect($('.mercury-modal-title a').css('display')).toEqual('none')


  describe "#reset", ->

    beforeEach ->
      spyOn(Mercury.Modal.prototype, 'appear').andCallFake(=>)
      @modal = Mercury.modal('/blank.html', {appendTo: $('#test'), title: 'title'})

    it "clears the title and content elements", ->
      $('.mercury-modal-content').html('content')
      @modal.reset()
      expect($('.mercury-modal-content').html()).toEqual('')
      expect($('.mercury-modal-title span').html()).toEqual('')


  describe "#hide", ->

    beforeEach ->
      spyOn(Mercury.Modal.prototype, 'appear').andCallFake(=>)
      @modal = Mercury.modal('/blank.html', {appendTo: $('#test')})

    it "triggers the focus:frame event", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      @modal.hide()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:frame'])

    it "hides the element", ->
      @modal.element.css('display:block')
      @modal.hide()
      expect($('.mercury-modal').css('display')).toEqual('none')

    it "hides the overlay element", ->
      @modal.overlay.css('display:block')
      @modal.hide()
      expect($('.mercury-modal-overlay').css('display')).toEqual('none')

    it "calls reset", ->
      spy = spyOn(@modal, 'reset').andCallFake(=>)
      @modal.hide()
      expect(spy.callCount).toEqual(1)

    it "sets visible to false", ->
      @modal.visible = true
      @modal.hide()
      expect(@modal.visible).toEqual(false)

    it "does nothing if the modal is still in the process of showing", ->
      spy = spyOn(@modal, 'reset').andCallFake(=>)
      @modal.showing = true
      @modal.hide()
      expect(spy.callCount).toEqual(0)
