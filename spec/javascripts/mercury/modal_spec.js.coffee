require '/assets/mercury.js'

describe "Mercury.modal", ->

  template 'mercury/modal.html'

  beforeEach ->
    $.fx.off = true
    Mercury.displayRect = {fullHeight: 200}

  afterEach ->
    Mercury.modal.initialized = false
    Mercury.modal.visible = false
    $(document).unbind('mercury:refresh')
    $(document).unbind('mercury:resize')

  describe "singleton method", ->

    beforeEach ->
      @showSpy = spyOn(Mercury.modal, 'show').andCallFake(=>)

    it "calls show", ->
      Mercury.modal('/foo')
      expect(@showSpy.callCount).toEqual(1)

    it "returns the function object", ->
      ret = Mercury.modal('/foo')
      expect(ret).toEqual(Mercury.modal)


  describe "#show", ->

    beforeEach ->
      @initializeSpy = spyOn(Mercury.modal, 'initialize').andCallFake(=>)
      @updateSpy = spyOn(Mercury.modal, 'update').andCallFake(=>)
      @appearSpy = spyOn(Mercury.modal, 'appear').andCallFake(=>)

    it "triggers the focus:window event", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      Mercury.modal.show()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:window'])

    it "calls initialize", ->
      Mercury.modal.show()
      expect(@initializeSpy.callCount).toEqual(1)

    describe "if already visible", ->

      it "calls update", ->
        Mercury.modal.visible = true
        Mercury.modal.show()
        expect(@updateSpy.callCount).toEqual(1)

    describe "if not visible", ->

      it "calls appear", ->
        Mercury.modal.show()
        expect(@appearSpy.callCount).toEqual(1)


  describe "#initialize", ->

    beforeEach ->
      @buildSpy = spyOn(Mercury.modal, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(Mercury.modal, 'bindEvents').andCallFake(=>)

    it "calls build", ->
      Mercury.modal.initialize()
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      Mercury.modal.initialize()
      expect(@bindEventsSpy.callCount).toEqual(1)

    it "does nothing if already initialized", ->
      Mercury.modal.initialized = true
      Mercury.modal.initialize()
      expect(@buildSpy.callCount).toEqual(0)

    it "sets initialized to true", ->
      Mercury.modal.initialize()
      expect(Mercury.modal.initialized).toEqual(true)


  describe "#build", ->

    beforeEach ->
      Mercury.modal.options = {appendTo: $('#test')}

    it "builds an element", ->
      Mercury.modal.build()
      expect($('#test .mercury-modal').length).toEqual(1)

    it "builds an overlay element", ->
      Mercury.modal.build()
      expect($('#test .mercury-modal-overlay').length).toEqual(1)

    it "creates a titleElement", ->
      Mercury.modal.build()
      expect($('#test .mercury-modal-title').length).toEqual(1)
      expect($('#test .mercury-modal-title').html()).toEqual('<span></span><a>×</a>')
      expect(Mercury.modal.titleElement).toBeDefined()

    it "creates a contentContainerElement", ->
      Mercury.modal.build()
      expect($('#test .mercury-modal-content-container').length).toEqual(1)
      expect(Mercury.modal.contentContainerElement).toBeDefined()

    it "creates a contentElement", ->
      Mercury.modal.build()
      expect($('#test .mercury-modal-content-container .mercury-modal-content').length).toEqual(1)
      expect(Mercury.modal.contentElement).toBeDefined()

    it "appends to any element", ->
      Mercury.modal.options = {appendTo: $('#modal_container')}
      Mercury.modal.build()
      expect($('#modal_container .mercury-modal').length).toEqual(1)
      expect($('#modal_container .mercury-modal-overlay').length).toEqual(1)

    it "updates the title to reflect what was passed in the options", ->
      Mercury.modal.options.title = 'title'
      Mercury.modal.build()
      expect($('#test .mercury-modal-title span').html()).toEqual('title')


  describe "observed events", ->

    beforeEach ->
      spyOn(Mercury.modal, 'appear').andCallFake(=>)
      Mercury.modal('/foo', {appendTo: $('#test')})

    describe "custom event: refresh", ->

      it "calls resize telling it stay visible", ->
        spy = spyOn(Mercury.modal, 'resize').andCallFake(=>)
        Mercury.trigger('refresh')
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual([true])

    describe "custom event: resize", ->

      it "calls position", ->
        spy = spyOn(Mercury.modal, 'position').andCallFake(=>)
        Mercury.trigger('resize')
        expect(spy.callCount).toEqual(1)

    describe "clicking on the overlay", ->

      it "calls hide", ->
        spy = spyOn(Mercury.modal, 'hide').andCallFake(=>)
        jasmine.simulate.click($('.mercury-modal-overlay').get(0))
        expect(spy.callCount).toEqual(1)

    describe "clicking on the close button", ->

      it "calls hide", ->
        spy = spyOn(Mercury.modal, 'hide').andCallFake(=>)
        jasmine.simulate.click($('.mercury-modal-title a').get(0))
        expect(spy.callCount).toEqual(1)


  describe "#appear", ->

    beforeEach ->
      Mercury.modal.visible = true
      spyOn(Mercury.modal, 'update').andCallFake(=>)
      @loadSpy = spyOn(Mercury.modal, 'load').andCallFake(=>)
      @positionSpy = spyOn(Mercury.modal, 'position').andCallFake(=>)
      Mercury.modal('/evergreen/responses/blank.html', {appendTo: $('#test')})

    it "calls position", ->
      Mercury.modal.appear()
      expect(@positionSpy.callCount).toEqual(1)

    it "shows the overlay", ->
      expect($('.mercury-modal-overlay').css('display')).toEqual('none')
      Mercury.modal.appear()
      expect($('.mercury-modal-overlay').css('display')).toEqual('block')

    it "animates the overlay to full opacity", ->
      expect($('.mercury-modal-overlay').css('opacity')).toEqual('0')
      Mercury.modal.appear()
      expect($('.mercury-modal-overlay').css('opacity')).toEqual('1')

    it "calls setTitle", ->
      spy = spyOn(Mercury.modal, 'setTitle').andCallFake(=>)
      Mercury.modal.appear()
      expect(spy.callCount).toEqual(1)

    it "shows the element", ->
      expect($('.mercury-modal').css('display')).toEqual('none')
      Mercury.modal.appear()
      expect($('.mercury-modal').css('display')).toEqual('block')

    it "animates the element down", ->
      expect($('.mercury-modal').css('top')).toEqual('-100px')
      Mercury.modal.appear()
      expect($('.mercury-modal').css('top')).toEqual('0px')

    it "sets visible to true", ->
      Mercury.modal.visible = false
      Mercury.modal.appear()
      expect(Mercury.modal.visible).toEqual(true)

    it "calls load", ->
      Mercury.modal.appear()
      expect(@loadSpy.callCount).toEqual(1)


  describe "#resize", ->

    beforeEach ->
      spyOn(Mercury.modal, 'appear').andCallFake(=>)
      Mercury.modal('/evergreen/responses/blank.html', {appendTo: $('#test')})
      Mercury.modal.contentPane = $()

    it "will keep the content element visible if asked to do so", ->
      $('.mercury-modal-content').css('visibility', 'visible')
      Mercury.modal.resize(true)
      expect($('.mercury-modal-content').css('visibility')).toEqual('visible')

    it "resizes the element and adjusts it's position", ->
      Mercury.displayRect.width = 1000
      $('.mercury-modal').css({display: 'block', visibility: 'visible', top: 0})
      Mercury.modal.resize()
      expect($('.mercury-modal').width()).toEqual(400)
      expect($('.mercury-modal').offset()).toEqual({top: 0, left: 300})
      expect($('.mercury-modal').height()).toBeGreaterThan(20)

    it "respects minWidth provided in options", ->
      Mercury.modal.minWidth = 500
      Mercury.modal.resize()
      expect($('.mercury-modal').width()).toEqual(500)


  describe "#position", ->

    beforeEach ->
      spyOn(Mercury.modal, 'appear').andCallFake(=>)

    it "positions the element", ->


  describe "#update", ->

    beforeEach ->
      @resetSpy = spyOn(Mercury.modal, 'reset').andCallFake(=>)
      @resizeSpy = spyOn(Mercury.modal, 'resize').andCallFake(=>)
      @loadSpy = spyOn(Mercury.modal, 'load').andCallFake(=>)
      Mercury.modal.update()

    it "calls reset", ->
      expect(@resetSpy.callCount).toEqual(1)

    it "calls resize", ->
      expect(@resizeSpy.callCount).toEqual(1)

    it "calls load", ->
      expect(@loadSpy.callCount).toEqual(1)


  describe "#load", ->

    beforeEach ->
      spyOn(Mercury.modal, 'appear').andCallFake(=>)
      @ajaxSpy = spyOn($, 'ajax')
      Mercury.modal('/evergreen/responses/blank.html', {appendTo: $('#test')})

    it "sets the loading class on the element", ->
      Mercury.modal.load()
      expect($('.mercury-modal').hasClass('loading')).toEqual(true)

    it "calls setTitle", ->
      spy = spyOn(Mercury.modal, 'setTitle').andCallFake(=>)
      Mercury.modal.load()
      expect(spy.callCount).toEqual(1)

    describe "on a preloaded view", ->

      beforeEach ->
        @setTimeoutSpy = spyOn(window, 'setTimeout').andCallFake((callback) => callback())
        Mercury.preloadedViews = {'/evergreen/responses/blank.html': 'this is the preloaded content'}

      afterEach ->
        Mercury.preloadedViews = {}

      it "calls loadContent with the content in the preloaded view", ->
        spy = spyOn(Mercury.modal, 'loadContent').andCallFake(=>)
        Mercury.modal.load()
        expect(@setTimeoutSpy.callCount).toEqual(1)
        expect(spy.callCount).toEqual(1)

    describe "when not a preloaded view", ->

      it "makes an ajax request", ->
        @ajaxSpy.andCallFake(=>)
        Mercury.modal.load()
        expect(@ajaxSpy.callCount).toEqual(1)

      describe "on success", ->

        beforeEach ->
          @ajaxSpy.andCallFake((url, options) => options.success('return value'))

        it "calls loadContent and passes the returned data", ->
          spy = spyOn(Mercury.modal, 'loadContent').andCallFake(=>)
          Mercury.modal.load()
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['return value'])

      describe "on failure", ->

        beforeEach ->
          @ajaxSpy.andCallFake((url, options) => options.error())

        it "calls hide", ->
          spyOn(window, 'alert').andCallFake(=>)
          spy = spyOn(Mercury.modal, 'hide').andCallFake(=>)
          Mercury.modal.load()
          expect(spy.callCount).toEqual(1)

        it "alerts an error message", ->
          spyOn(Mercury.modal, 'hide').andCallFake(=>)
          spy = spyOn(window, 'alert').andCallFake(=>)
          Mercury.modal.load()
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['Mercury was unable to load /evergreen/responses/blank.html for the modal.'])


  describe "#loadContent", ->

    beforeEach ->
      spyOn(Mercury.modal, 'appear').andCallFake(=>)
      @resizeSpy = spyOn(Mercury.modal, 'resize').andCallFake(=>)
      Mercury.modal('/evergreen/responses/blank.html', {appendTo: $('#test'), title: 'title'})

    it "accepts options and sets them to the instance options", ->
      Mercury.modal.loadContent('content', {title: 'title'})
      expect(Mercury.modal.options).toEqual({title: 'title'})

    it "calls initialize", ->
      spy = spyOn(Mercury.modal, 'initialize').andCallFake(=>)
      Mercury.modal.loadContent('content')
      expect(spy.callCount).toEqual(1)

    it "calls setTitle", ->
      spy = spyOn(Mercury.modal, 'setTitle').andCallFake(=>)
      Mercury.modal.loadContent('content')
      expect(spy.callCount).toEqual(1)

    it "sets loaded to true", ->
      Mercury.modal.loaded = false
      Mercury.modal.loadContent('content')
      expect(Mercury.modal.loaded).toEqual(true)

    it "removes the loading class", ->
      $('.mercury-modal').addClass('loading')
      Mercury.modal.loadContent('content')
      expect($('.mercury-modal').hasClass('loading')).toEqual(false)

    it "sets the content elements html to whatever was passed", ->
      Mercury.modal.loadContent('content')
      expect($('.mercury-modal-content').html()).toEqual('content')

    it "hides the contentElement", ->
      $('.mercury-modal-content').css('display', 'block')
      Mercury.modal.loadContent('content')
      expect($('.mercury-modal-content').css('display')).toEqual('none')
      expect($('.mercury-modal-content').css('visibility')).toEqual('hidden')

    it "finds the content panes and control elements in case they were added with the content", ->
      Mercury.modal.loadContent('<div class="mercury-modal-pane-container"></div><div class="mercury-modal-controls"></div>')
      expect(Mercury.modal.contentPane.get(0)).toEqual($('#test .mercury-modal-pane-container').get(0))
      expect(Mercury.modal.contentControl.get(0)).toEqual($('#test .mercury-modal-controls').get(0))

    it "calls an afterLoad callback (if provided in options)", ->
      callCount = 0
      Mercury.modal.loadContent('content', {afterLoad: => callCount += 1})
      expect(callCount).toEqual(1)

    it "calls a handler method if one is set in modalHandlers", ->
      callCount = 0
      Mercury.modalHandlers['foo'] = => callCount += 1
      Mercury.modal.loadContent('content', {handler: 'foo'})
      expect(callCount).toEqual(1)

    it "calls resize", ->
      Mercury.modal.loadContent('content')
      expect(@resizeSpy.callCount).toEqual(1)


  describe "#setTitle", ->

    beforeEach ->
      spyOn(Mercury.modal, 'appear').andCallFake(=>)
      Mercury.modal('/evergreen/responses/blank.html', {appendTo: $('#test'), title: 'title'})

    it "sets the the title contents to what was provided in the options", ->
      Mercury.modal.options = {title: 'new title'}
      Mercury.modal.setTitle()
      expect($('.mercury-modal-title span').html()).toEqual('new title')


  describe "#reset", ->

    beforeEach ->
      spyOn(Mercury.modal, 'appear').andCallFake(=>)
      Mercury.modal('/evergreen/responses/blank.html', {appendTo: $('#test'), title: 'title'})

    it "clears the title and content elements", ->
      $('.mercury-modal-content').html('content')
      Mercury.modal.reset()
      expect($('.mercury-modal-content').html()).toEqual('')
      expect($('.mercury-modal-title span').html()).toEqual('')


  describe "#hide", ->

    beforeEach ->
      spyOn(Mercury.modal, 'appear').andCallFake(=>)
      Mercury.modal('/evergreen/responses/blank.html', {appendTo: $('#test')})

    it "triggers the focus:frame event", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      Mercury.modal.hide()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:frame'])

    it "hides the element", ->
      Mercury.modal.element.css('display:block')
      Mercury.modal.hide()
      expect($('.mercury-modal').css('display')).toEqual('none')

    it "hides the overlay element", ->
      Mercury.modal.overlay.css('display:block')
      Mercury.modal.hide()
      expect($('.mercury-modal-overlay').css('display')).toEqual('none')

    it "calls reset", ->
      spy = spyOn(Mercury.modal, 'reset').andCallFake(=>)
      Mercury.modal.hide()
      expect(spy.callCount).toEqual(1)

    it "sets visible to false", ->
      Mercury.modal.visible = true
      Mercury.modal.hide()
      expect(Mercury.modal.visible).toEqual(false)


