describe "Mercury.lightview", ->

  template 'mercury/lightview.html'

  beforeEach ->
    $.fx.off = true
    Mercury.displayRect = {fullHeight: 200, width: 1000}
    Mercury.determinedLocale =
      top: {'hello world!': 'bork! bork!'}
      sub: {'foo': 'Bork!'}

  afterEach ->
    Mercury.config.localization.enabled = false
    Mercury.lightview.initialized = false
    Mercury.lightview.visible = false
    $(window).unbind('mercury:refresh')
    $(window).unbind('mercury:resize')
    $(document).unbind('keydown')

  describe "singleton method", ->

    beforeEach ->
      @showSpy = spyOn(Mercury.lightview, 'show').andCallFake(=>)

    it "calls show", ->
      Mercury.lightview('/foo')
      expect(@showSpy.callCount).toEqual(1)

    it "returns the function object", ->
      ret = Mercury.lightview('/foo')
      expect(ret).toEqual(Mercury.lightview)


  describe "#show", ->

    beforeEach ->
      @initializeSpy = spyOn(Mercury.lightview, 'initialize').andCallFake(=>)
      @updateSpy = spyOn(Mercury.lightview, 'update').andCallFake(=>)
      @appearSpy = spyOn(Mercury.lightview, 'appear').andCallFake(=>)

    it "triggers the focus:window event", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      Mercury.lightview.show()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:window'])

    it "calls initialize", ->
      Mercury.lightview.show()
      expect(@initializeSpy.callCount).toEqual(1)

    describe "if already visible", ->

      it "calls update", ->
        Mercury.lightview.visible = true
        Mercury.lightview.show()
        expect(@updateSpy.callCount).toEqual(1)

    describe "if not visible", ->

      it "calls appear", ->
        Mercury.lightview.show()
        expect(@appearSpy.callCount).toEqual(1)


  describe "#initialize", ->

    beforeEach ->
      @buildSpy = spyOn(Mercury.lightview, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(Mercury.lightview, 'bindEvents').andCallFake(=>)

    it "calls build", ->
      Mercury.lightview.initialize()
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      Mercury.lightview.initialize()
      expect(@bindEventsSpy.callCount).toEqual(1)

    it "does nothing if already initialized", ->
      Mercury.lightview.initialized = true
      Mercury.lightview.initialize()
      expect(@buildSpy.callCount).toEqual(0)

    it "sets initialized to true", ->
      Mercury.lightview.initialize()
      expect(Mercury.lightview.initialized).toEqual(true)


  describe "#build", ->

    beforeEach ->
      Mercury.lightview.options = {appendTo: $('#test')}

    it "builds an element", ->
      Mercury.lightview.build()
      expect($('#test .mercury-lightview').length).toEqual(1)

    it "builds an overlay element", ->
      Mercury.lightview.build()
      expect($('#test .mercury-lightview-overlay').length).toEqual(1)

    it "creates a titleElement", ->
      Mercury.lightview.build()
      expect($('#test .mercury-lightview-title').length).toEqual(1)
      expect($('#test .mercury-lightview-title').html()).toEqual("<span><\/span>")
      expect(Mercury.lightview.titleElement).toBeDefined()

    it "creates a contentElement", ->
      Mercury.lightview.build()
      expect($('#test .mercury-lightview-content').length).toEqual(1)
      expect(Mercury.lightview.contentElement).toBeDefined()

    it "appends to any element", ->
      Mercury.lightview.options = {appendTo: $('#lightview_container')}
      Mercury.lightview.build()
      expect($('#lightview_container .mercury-lightview').length).toEqual(1)
      expect($('#lightview_container .mercury-lightview-overlay').length).toEqual(1)

    it "creates a close button if asked to in the options", ->
      Mercury.lightview.options.closeButton = true
      Mercury.lightview.build()
      expect($('#test .mercury-lightview-close').length).toEqual(1)


  describe "observed events", ->

    beforeEach ->
      spyOn(Mercury.lightview, 'appear').andCallFake(=>)

    describe "without a close button", ->

      beforeEach ->
        Mercury.lightview('/foo', {appendTo: $('#test')})

      describe "custom event: refresh", ->

        it "calls resize telling it stay visible", ->
          spy = spyOn(Mercury.lightview, 'resize').andCallFake(=>)
          Mercury.trigger('refresh')
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual([true])

      describe "custom event: resize", ->

        beforeEach ->
          Mercury.lightview.visible = true

        it "calls position", ->
          spy = spyOn(Mercury.lightview, 'position').andCallFake(=>)
          Mercury.trigger('resize')
          expect(spy.callCount).toEqual(1)

      describe "clicking on the overlay", ->

        it "calls hide", ->
          spy = spyOn(Mercury.lightview, 'hide').andCallFake(=>)
          jasmine.simulate.click($('.mercury-lightview-overlay').get(0))
          expect(spy.callCount).toEqual(1)

      describe "pressing esc on document", ->

        beforeEach ->
          Mercury.lightview.visible = true

        it "calls hide", ->
          spy = spyOn(Mercury.lightview, 'hide').andCallFake(=>)
          jasmine.simulate.keydown(document, {keyCode: 27})
          expect(spy.callCount).toEqual(1)

    describe "with a close button", ->

      beforeEach ->
        Mercury.lightview('/foo', {appendTo: $('#test'), closeButton: true})

      describe "clicking on the close button", ->

        it "calls hide", ->
          spy = spyOn(Mercury.lightview, 'hide').andCallFake(=>)
          jasmine.simulate.click($('.mercury-lightview-close').get(0))
          expect(spy.callCount).toEqual(1)

      describe "clicking on the overlay", ->

        it "doesn't call hide", ->
          spy = spyOn(Mercury.lightview, 'hide').andCallFake(=>)
          jasmine.simulate.click($('.mercury-lightview-overlay').get(0))
          expect(spy.callCount).toEqual(0)

      describe "ajax:beforeSend", ->

        it "sets a success that will load the contents of the response", ->
          options = {}
          spy = spyOn(Mercury.lightview, 'loadContent').andCallFake(=>)
          Mercury.lightview.element.trigger('ajax:beforeSend', [null, options])
          expect(options.success).toBeDefined()
          options.success('new content')
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['new content'])


  describe "#appear", ->

    beforeEach ->
      Mercury.lightview.visible = true
      spyOn(Mercury.lightview, 'update').andCallFake(=>)
      @loadSpy = spyOn(Mercury.lightview, 'load').andCallFake(=>)
      @positionSpy = spyOn(Mercury.lightview, 'position').andCallFake(=>)
      Mercury.lightview('/evergreen/responses/blank.html', {appendTo: $('#test')})

    it "calls position", ->
      Mercury.lightview.appear()
      expect(@positionSpy.callCount).toEqual(1)

    it "shows the overlay", ->
      expect($('.mercury-lightview-overlay').css('display')).toEqual('none')
      Mercury.lightview.appear()
      expect($('.mercury-lightview-overlay').css('display')).toEqual('block')

    it "animates the overlay to full opacity", ->
      expect($('.mercury-lightview-overlay').css('opacity')).toEqual('0')
      Mercury.lightview.appear()
      expect($('.mercury-lightview-overlay').css('opacity')).toEqual('1')

    it "calls setTitle", ->
      spy = spyOn(Mercury.lightview, 'setTitle').andCallFake(=>)
      Mercury.lightview.appear()
      expect(spy.callCount).toEqual(1)

    it "shows the element", ->
      expect($('.mercury-lightview').css('display')).toEqual('none')
      Mercury.lightview.appear()
      expect($('.mercury-lightview').css('display')).toEqual('block')

    it "animates the element opacity", ->
      expect($('.mercury-lightview').css('opacity')).toEqual('0')
      Mercury.lightview.appear()
      expect($('.mercury-lightview').css('opacity')).toEqual('1')

    it "sets visible to true", ->
      Mercury.lightview.visible = false
      Mercury.lightview.appear()
      expect(Mercury.lightview.visible).toEqual(true)

    it "calls load", ->
      Mercury.lightview.appear()
      expect(@loadSpy.callCount).toEqual(1)


  describe "#resize", ->

    beforeEach ->
      spyOn(Mercury.lightview, 'appear').andCallFake(=>)
      Mercury.lightview('/evergreen/responses/blank.html', {appendTo: $('#test')})
      Mercury.lightview.contentPane = $()

    it "will keep the content element visible if asked to do so", ->
      $('.mercury-lightview-content').css('visibility', 'visible')
      Mercury.lightview.resize(true)
      expect($('.mercury-lightview-content').css('visibility')).toEqual('visible')

    it "resizes the element and adjusts it's position when empty", ->
      $('.mercury-lightview').css({display: 'block', visibility: 'visible', top: 0})
      Mercury.lightview.resize()
      expect($('.mercury-lightview').width()).toEqual(300)
      expect($('.mercury-lightview').offset()).toEqual({top: 35, left: 350})
      expect($('.mercury-lightview').height()).toEqual(150)

    it "resizes the element and adjusts it's position when it has content", ->
      Mercury.lightview.loadContent('<div style="width:600px;height:400px"></div>')
      $('.mercury-lightview').css({display: 'block', visibility: 'visible', top: 0})
      Mercury.lightview.resize()
      expect($('.mercury-lightview').width()).toEqual(300)
      expect($('.mercury-lightview').offset()).toEqual({top: 20, left: 350})
      expect($('.mercury-lightview').height()).toEqual(180)


  describe "#position", ->

    beforeEach ->
      spyOn(Mercury.lightview, 'appear').andCallFake(=>)

    # todo: test this
    it "positions the element", ->


  describe "#update", ->

    beforeEach ->
      @resetSpy = spyOn(Mercury.lightview, 'reset').andCallFake(=>)
      @resizeSpy = spyOn(Mercury.lightview, 'resize').andCallFake(=>)
      @loadSpy = spyOn(Mercury.lightview, 'load').andCallFake(=>)
      Mercury.lightview.update()

    it "calls reset", ->
      expect(@resetSpy.callCount).toEqual(1)

    it "calls resize", ->
      expect(@resizeSpy.callCount).toEqual(1)

    it "calls load", ->
      expect(@loadSpy.callCount).toEqual(1)


  describe "#load", ->

    beforeEach ->
      spyOn(Mercury.lightview, 'appear').andCallFake(=>)
      @ajaxSpy = spyOn($, 'ajax')
      Mercury.lightview('/evergreen/responses/blank.html', {appendTo: $('#test')})

    it "does nothing if there's no url", ->
      Mercury.lightview.url = null
      $('.mercury-lightview').removeClass('loading')
      Mercury.lightview.load()
      expect($('.mercury-lightview').hasClass('loading')).toEqual(false)

    it "sets the loading class on the element", ->
      Mercury.lightview.load()
      expect($('.mercury-lightview').hasClass('loading')).toEqual(true)

    it "calls setTitle", ->
      spy = spyOn(Mercury.lightview, 'setTitle').andCallFake(=>)
      Mercury.lightview.load()
      expect(spy.callCount).toEqual(1)

    describe "on a preloaded view", ->

      beforeEach ->
        @setTimeoutSpy = spyOn(window, 'setTimeout').andCallFake((timeout, callback) => callback())
        Mercury.preloadedViews = {'/evergreen/responses/blank.html': 'this is the preloaded content'}

      afterEach ->
        Mercury.preloadedViews = {}

      it "calls loadContent with the content in the preloaded view", ->
        spy = spyOn(Mercury.lightview, 'loadContent').andCallFake(=>)
        Mercury.lightview.load()
        expect(@setTimeoutSpy.callCount).toEqual(1)
        expect(spy.callCount).toEqual(1)

    describe "when not a preloaded view", ->

      it "makes an ajax request", ->
        @ajaxSpy.andCallFake(=>)
        spyOn(Mercury, 'ajaxHeaders').andCallFake(=> {'X-CSRFToken': 'f00'})
        Mercury.lightview.load()
        expect(@ajaxSpy.callCount).toEqual(1)
        expect(@ajaxSpy.argsForCall[0][1]['headers']).toEqual({'X-CSRFToken': 'f00'})

      describe "on success", ->

        beforeEach ->
          @ajaxSpy.andCallFake((url, options) => options.success('return value'))

        it "calls loadContent and passes the returned data", ->
          spy = spyOn(Mercury.lightview, 'loadContent').andCallFake(=>)
          Mercury.lightview.load()
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['return value'])

      describe "on failure", ->

        beforeEach ->
          @ajaxSpy.andCallFake((url, options) => options.error())

        it "calls hide", ->
          spyOn(window, 'alert').andCallFake(=>)
          spy = spyOn(Mercury.lightview, 'hide').andCallFake(=>)
          Mercury.lightview.load()
          expect(spy.callCount).toEqual(1)

        it "alerts an error message", ->
          spyOn(Mercury.lightview, 'hide').andCallFake(=>)
          spy = spyOn(window, 'alert').andCallFake(=>)
          Mercury.lightview.load()
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['Mercury was unable to load /evergreen/responses/blank.html for the lightview.'])


  describe "#loadContent", ->

    beforeEach ->
      spyOn(Mercury.lightview, 'appear').andCallFake(=>)
      @resizeSpy = spyOn(Mercury.lightview, 'resize').andCallFake(=>)
      Mercury.lightview('/evergreen/responses/blank.html', {appendTo: $('#test'), title: 'title'})

    it "accepts options and sets them to the instance options", ->
      Mercury.lightview.loadContent('content', {title: 'title'})
      expect(Mercury.lightview.options).toEqual({title: 'title'})

    it "calls initialize", ->
      spy = spyOn(Mercury.lightview, 'initialize').andCallFake(=>)
      Mercury.lightview.loadContent('content')
      expect(spy.callCount).toEqual(1)

    it "calls setTitle", ->
      spy = spyOn(Mercury.lightview, 'setTitle').andCallFake(=>)
      Mercury.lightview.loadContent('content')
      expect(spy.callCount).toEqual(1)

    it "sets loaded to true", ->
      Mercury.lightview.loaded = false
      Mercury.lightview.loadContent('content')
      expect(Mercury.lightview.loaded).toEqual(true)

    it "removes the loading class", ->
      $('.mercury-lightview').addClass('loading')
      Mercury.lightview.loadContent('content')
      expect($('.mercury-lightview').hasClass('loading')).toEqual(false)

    it "sets the content elements html to whatever was passed", ->
      Mercury.lightview.loadContent('<span>content</span>')
      expect($('.mercury-lightview-content').html()).toEqual('<span>content</span>')

    it "hides the contentElement", ->
      $('.mercury-lightview-content').css('display', 'block')
      Mercury.lightview.loadContent('content')
      expect($('.mercury-lightview-content').css('display')).toEqual('none')
      expect($('.mercury-lightview-content').css('visibility')).toEqual('hidden')

    it "calls an afterLoad callback (if provided in options)", ->
      callCount = 0
      Mercury.lightview.loadContent('content', {afterLoad: => callCount += 1})
      expect(callCount).toEqual(1)

    it "calls a handler method if one is set in lightviewHandlers", ->
      callCount = 0
      Mercury.lightviewHandlers['foo'] = => callCount += 1
      Mercury.lightview.loadContent('content', {handler: 'foo'})
      expect(callCount).toEqual(1)

    it "translates the content if configured", ->
      Mercury.config.localization.enabled = true
      Mercury.lightview.loadContent('<span>foo</span>')
      expect($('.mercury-lightview-content').html()).toEqual('<span>Bork!</span>')

    it "calls resize", ->
      Mercury.lightview.loadContent('content')
      expect(@resizeSpy.callCount).toEqual(1)


  describe "#setTitle", ->

    beforeEach ->
      spyOn(Mercury.lightview, 'appear').andCallFake(=>)
      Mercury.lightview('/evergreen/responses/blank.html', {appendTo: $('#test'), title: 'title'})

    it "sets the the title contents to what was provided in the options", ->
      Mercury.lightview.options = {title: 'new title'}
      Mercury.lightview.setTitle()
      expect($('.mercury-lightview-title span').html()).toEqual('new title')


  describe "#reset", ->

    beforeEach ->
      spyOn(Mercury.lightview, 'appear').andCallFake(=>)
      Mercury.lightview('/evergreen/responses/blank.html', {appendTo: $('#test'), title: 'title'})

    it "clears the title and content elements", ->
      $('.mercury-lightview-content').html('content')
      Mercury.lightview.reset()
      expect($('.mercury-lightview-content').html()).toEqual('')
      expect($('.mercury-lightview-title span').html()).toEqual('')


  describe "#hide", ->

    beforeEach ->
      spyOn(Mercury.lightview, 'appear').andCallFake(=>)
      Mercury.lightview('/evergreen/responses/blank.html', {appendTo: $('#test')})

    it "triggers the focus:frame event", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      Mercury.lightview.hide()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:frame'])

    it "hides the element", ->
      Mercury.lightview.element.css('display:block')
      Mercury.lightview.hide()
      expect($('.mercury-lightview').css('display')).toEqual('none')

    it "hides the overlay element", ->
      Mercury.lightview.overlay.css('display:block')
      Mercury.lightview.hide()
      expect($('.mercury-lightview-overlay').css('display')).toEqual('none')

    it "calls reset", ->
      spy = spyOn(Mercury.lightview, 'reset').andCallFake(=>)
      Mercury.lightview.hide()
      expect(spy.callCount).toEqual(1)

    it "sets visible to false", ->
      Mercury.lightview.visible = true
      Mercury.lightview.hide()
      expect(Mercury.lightview.visible).toEqual(false)
