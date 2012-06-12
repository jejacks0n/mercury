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
    Mercury.lightview.instance = null
    $(window).unbind('mercury:refresh')
    $(window).unbind('mercury:resize')
    $(document).unbind('keydown')

  describe "singleton method", ->

    beforeEach ->
      @showSpy = spyOn(Mercury.Lightview.prototype, 'show').andCallFake(=>)

    it "calls show", ->
      Mercury.lightview('/foo')
      expect(@showSpy.callCount).toEqual(1)

    it "returns an instance", ->
      ret = Mercury.lightview('/foo')
      expect(ret).toEqual(Mercury.lightview.instance)
      expect(ret).toEqual(new Mercury.Lightview('/foo'))


  describe "#show", ->

    beforeEach ->
      @initializeSpy = spyOn(Mercury.Lightview.prototype, 'initializeLightview').andCallFake(=>)
      @updateSpy = spyOn(Mercury.Lightview.prototype, 'update').andCallFake(=>)
      @appearSpy = spyOn(Mercury.Lightview.prototype, 'appear').andCallFake(=>)

    it "triggers the focus:window event", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      new Mercury.Lightview().show()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:window'])

    it "calls initialize", ->
      new Mercury.Lightview().show()
      expect(@initializeSpy.callCount).toEqual(1)

    describe "if already visible", ->

      it "calls update", ->
        lightview = new Mercury.Lightview()
        lightview.visible = true
        lightview.show()
        expect(@updateSpy.callCount).toEqual(1)

    describe "if not visible", ->

      it "calls appear", ->
        lightview = new Mercury.Lightview()
        lightview.visible = false
        lightview.show()
        expect(@appearSpy.callCount).toEqual(1)


  describe "#initializeLightview", ->

    beforeEach ->
      @buildSpy = spyOn(Mercury.Lightview.prototype, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(Mercury.Lightview.prototype, 'bindEvents').andCallFake(=>)
      @lightview = new Mercury.Lightview()

    it "calls build", ->
      @lightview.initializeLightview()
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      @lightview.initializeLightview()
      expect(@bindEventsSpy.callCount).toEqual(1)

    it "does nothing if already initialized", ->
      @lightview.initialized = true
      @lightview.initializeLightview()
      expect(@buildSpy.callCount).toEqual(0)

    it "sets initialized to true", ->
      @lightview.initializeLightview()
      expect(@lightview.initialized).toEqual(true)


  describe "#build", ->

    beforeEach ->
      @lightview = new Mercury.Lightview('', {appendTo: $('#test')})

    it "builds an element", ->
      @lightview.build()
      expect($('#test .mercury-lightview').length).toEqual(1)

    it "builds an overlay element", ->
      @lightview.build()
      expect($('#test .mercury-lightview-overlay').length).toEqual(1)

    it "creates a titleElement", ->
      @lightview.build()
      expect($('#test .mercury-lightview-title').length).toEqual(1)
      expect($('#test .mercury-lightview-title').html()).toEqual("<span><\/span>")
      expect(@lightview.titleElement).toBeDefined()

    it "creates a contentElement", ->
      @lightview.build()
      expect($('#test .mercury-lightview-content').length).toEqual(1)
      expect(@lightview.contentElement).toBeDefined()

    it "appends to any element", ->
      @lightview.options = {appendTo: $('#lightview_container')}
      @lightview.build()
      expect($('#lightview_container .mercury-lightview').length).toEqual(1)
      expect($('#lightview_container .mercury-lightview-overlay').length).toEqual(1)

    it "creates a close button if asked to in the options", ->
      @lightview.options.closeButton = true
      @lightview.build()
      expect($('#test .mercury-lightview-close').length).toEqual(1)


  describe "observed events", ->

    beforeEach ->
      spyOn(Mercury.Lightview.prototype, 'appear').andCallFake(=>)

    describe "without a close button", ->

      beforeEach ->
        @lightview = Mercury.lightview('/foo', {appendTo: $('#test')})

      describe "custom event: refresh", ->

        it "calls resize telling it stay visible", ->
          spy = spyOn(@lightview, 'resize').andCallFake(=>)
          Mercury.trigger('refresh')
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual([true])

      describe "custom event: resize", ->

        beforeEach ->
          @lightview.visible = true

        it "calls position", ->
          spy = spyOn(@lightview, 'position').andCallFake(=>)
          Mercury.trigger('resize')
          expect(spy.callCount).toEqual(1)

      describe "clicking on the overlay", ->

        it "calls hide", ->
          spy = spyOn(@lightview, 'hide').andCallFake(=>)
          jasmine.simulate.click($('.mercury-lightview-overlay').get(0))
          expect(spy.callCount).toEqual(1)

      describe "pressing esc on document", ->

        beforeEach ->
          @lightview.visible = true

        it "calls hide", ->
          spy = spyOn(@lightview, 'hide').andCallFake(=>)
          jasmine.simulate.keydown(document, {keyCode: 27})
          expect(spy.callCount).toEqual(1)

    describe "with a close button", ->

      beforeEach ->
        @lightview = Mercury.lightview('/foo', {appendTo: $('#test'), closeButton: true})

      describe "clicking on the close button", ->

        it "calls hide", ->
          spy = spyOn(@lightview, 'hide').andCallFake(=>)
          jasmine.simulate.click($('.mercury-lightview-close').get(0))
          expect(spy.callCount).toEqual(1)

      describe "clicking on the overlay", ->

        it "doesn't call hide", ->
          spy = spyOn(@lightview, 'hide').andCallFake(=>)
          jasmine.simulate.click($('.mercury-lightview-overlay').get(0))
          expect(spy.callCount).toEqual(0)

      describe "ajax:beforeSend", ->

        it "sets a success that will load the contents of the response", ->
          options = {}
          spy = spyOn(@lightview, 'loadContent').andCallFake(=>)
          @lightview.element.trigger('ajax:beforeSend', [null, options])
          expect(options.success).toBeDefined()
          options.success('new content')
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['new content'])


  describe "#appear", ->

    beforeEach ->
      @lightview = new Mercury.Lightview('/blank.html', {appendTo: $('#test')})
      @lightview.visible = true
      spyOn(@lightview, 'update').andCallFake(=>)
      @loadSpy = spyOn(@lightview, 'load').andCallFake(=>)
      @positionSpy = spyOn(@lightview, 'position').andCallFake(=>)
      @lightview.show()

    it "calls position", ->
      @lightview.appear()
      expect(@positionSpy.callCount).toEqual(1)

    it "shows the overlay", ->
      expect($('.mercury-lightview-overlay').css('display')).toEqual('none')
      @lightview.appear()
      expect($('.mercury-lightview-overlay').css('display')).toEqual('block')

    it "animates the overlay to full opacity", ->
      expect($('.mercury-lightview-overlay').css('opacity')).toEqual('0')
      @lightview.appear()
      expect($('.mercury-lightview-overlay').css('opacity')).toEqual('1')

    it "calls setTitle", ->
      spy = spyOn(@lightview, 'setTitle').andCallFake(=>)
      @lightview.appear()
      expect(spy.callCount).toEqual(1)

    it "shows the element", ->
      expect($('.mercury-lightview').css('display')).toEqual('none')
      @lightview.appear()
      expect($('.mercury-lightview').css('display')).toEqual('block')

    it "animates the element opacity", ->
      expect($('.mercury-lightview').css('opacity')).toEqual('0')
      @lightview.appear()
      expect($('.mercury-lightview').css('opacity')).toEqual('1')

    it "sets visible to true", ->
      @lightview.visible = false
      @lightview.appear()
      expect(@lightview.visible).toEqual(true)

    it "calls load", ->
      @lightview.appear()
      expect(@loadSpy.callCount).toEqual(1)


  describe "#resize", ->

    beforeEach ->
      @lightview = new Mercury.Lightview('/blank.html', {appendTo: $('#test')})
      spyOn(@lightview, 'appear').andCallFake(=>)
      @lightview.show()
      @lightview.contentPane = $()

    it "will keep the content element visible if asked to do so", ->
      $('.mercury-lightview-content').css('visibility', 'visible')
      @lightview.resize(true)
      expect($('.mercury-lightview-content').css('visibility')).toEqual('visible')

    it "resizes the element and adjusts it's position when empty", ->
      $('.mercury-lightview').css({display: 'block', visibility: 'visible', top: 0})
      @lightview.resize()
      expect($('.mercury-lightview').width()).toEqual(300)
      expect($('.mercury-lightview').offset()).toEqual({top: 35, left: 350})
      expect($('.mercury-lightview').height()).toEqual(150)

    it "resizes the element and adjusts it's position when it has content", ->
      @lightview.loadContent('<div style="width:600px;height:400px"></div>')
      $('.mercury-lightview').css({display: 'block', visibility: 'visible', top: 0})
      @lightview.resize()
      expect($('.mercury-lightview').width()).toEqual(300)
      expect($('.mercury-lightview').offset()).toEqual({top: 20, left: 350})
      expect($('.mercury-lightview').height()).toEqual(180)


  describe "#position", ->

    beforeEach ->
      spyOn(Mercury.Lightview.prototype, 'appear').andCallFake(=>)

    # todo: test this
    it "positions the element", ->


  describe "#update", ->

    beforeEach ->
      @lightview = new Mercury.Lightview()
      @resetSpy = spyOn(@lightview, 'reset').andCallFake(=>)
      @resizeSpy = spyOn(@lightview, 'resize').andCallFake(=>)
      @loadSpy = spyOn(@lightview, 'load').andCallFake(=>)
      @lightview.update()

    it "calls reset", ->
      expect(@resetSpy.callCount).toEqual(1)

    it "calls resize", ->
      expect(@resizeSpy.callCount).toEqual(1)

    it "calls load", ->
      expect(@loadSpy.callCount).toEqual(1)


  describe "#load", ->

    beforeEach ->
      spyOn(Mercury.Lightview.prototype, 'appear').andCallFake(=>)
      @ajaxSpy = spyOn($, 'ajax')
      @lightview = Mercury.lightview('/blank.html', {appendTo: $('#test')})

    it "does nothing if there's no url", ->
      @lightview.url = null
      $('.mercury-lightview').removeClass('loading')
      @lightview.load()
      expect($('.mercury-lightview').hasClass('loading')).toEqual(false)

    it "sets the loading class on the element", ->
      @lightview.load()
      expect($('.mercury-lightview').hasClass('loading')).toEqual(true)

    it "calls setTitle", ->
      spy = spyOn(@lightview, 'setTitle').andCallFake(=>)
      @lightview.load()
      expect(spy.callCount).toEqual(1)

    describe "on a preloaded view", ->

      beforeEach ->
        @setTimeoutSpy = spyOn(window, 'setTimeout').andCallFake((callback, timeout) => callback())
        Mercury.preloadedViews = {'/blank.html': 'this is the preloaded content'}

      afterEach ->
        Mercury.preloadedViews = {}

      it "calls loadContent with the content in the preloaded view", ->
        spy = spyOn(@lightview, 'loadContent').andCallFake(=>)
        @lightview.load()
        expect(@setTimeoutSpy.callCount).toEqual(1)
        expect(spy.callCount).toEqual(1)

    describe "when not a preloaded view", ->

      it "makes an ajax request", ->
        @ajaxSpy.andCallFake(=>)
        spyOn(Mercury, 'ajaxHeaders').andCallFake(=> {'X-CSRFToken': 'f00'})
        @lightview.load()
        expect(@ajaxSpy.callCount).toEqual(1)
        expect(@ajaxSpy.argsForCall[0][1]['headers']).toEqual({'X-CSRFToken': 'f00'})

      describe "on success", ->

        beforeEach ->
          @ajaxSpy.andCallFake((url, options) => options.success('return value'))

        it "calls loadContent and passes the returned data", ->
          spy = spyOn(@lightview, 'loadContent').andCallFake(=>)
          @lightview.load()
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['return value'])

      describe "on failure", ->

        beforeEach ->
          @ajaxSpy.andCallFake((url, options) => options.error())

        it "calls hide", ->
          spyOn(window, 'alert').andCallFake(=>)
          spy = spyOn(@lightview, 'hide').andCallFake(=>)
          @lightview.load()
          expect(spy.callCount).toEqual(1)

        it "alerts an error message", ->
          spyOn(@lightview, 'hide').andCallFake(=>)
          spy = spyOn(window, 'alert').andCallFake(=>)
          @lightview.load()
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['Mercury was unable to load /blank.html for the lightview.'])


  describe "#loadContent", ->

    beforeEach ->
      spyOn(Mercury.Lightview.prototype, 'appear').andCallFake(=>)
      @resizeSpy = spyOn(Mercury.Lightview.prototype, 'resize').andCallFake(=>)
      @lightview = Mercury.lightview('/blank.html', {appendTo: $('#test'), title: 'title'})

    it "accepts options and sets them to the instance options", ->
      @lightview.loadContent('content', {title: 'title'})
      expect(@lightview.options).toEqual({title: 'title'})

    it "calls initializeLightview", ->
      spy = spyOn(@lightview, 'initializeLightview').andCallFake(=>)
      @lightview.loadContent('content')
      expect(spy.callCount).toEqual(1)

    it "calls setTitle", ->
      spy = spyOn(@lightview, 'setTitle').andCallFake(=>)
      @lightview.loadContent('content')
      expect(spy.callCount).toEqual(1)

    it "sets loaded to true", ->
      @lightview.loaded = false
      @lightview.loadContent('content')
      expect(@lightview.loaded).toEqual(true)

    it "removes the loading class", ->
      $('.mercury-lightview').addClass('loading')
      @lightview.loadContent('content')
      expect($('.mercury-lightview').hasClass('loading')).toEqual(false)

    it "sets the content elements html to whatever was passed", ->
      @lightview.loadContent('<span>content</span>')
      expect($('.mercury-lightview-content').html()).toEqual('<span>content</span>')

    it "hides the contentElement", ->
      $('.mercury-lightview-content').css('display', 'block')
      @lightview.loadContent('content')
      expect($('.mercury-lightview-content').css('display')).toEqual('none')
      expect($('.mercury-lightview-content').css('visibility')).toEqual('hidden')

    it "calls an afterLoad callback (if provided in options)", ->
      callCount = 0
      @lightview.loadContent('content', {afterLoad: => callCount += 1})
      expect(callCount).toEqual(1)

    it "calls a handler method if one is set in lightviewHandlers", ->
      callCount = 0
      Mercury.lightviewHandlers['foo'] = => callCount += 1
      @lightview.loadContent('content', {handler: 'foo'})
      expect(callCount).toEqual(1)

    it "translates the content if configured", ->
      Mercury.config.localization.enabled = true
      @lightview.loadContent('<span>foo</span>')
      expect($('.mercury-lightview-content').html()).toEqual('<span>Bork!</span>')

    it "calls resize", ->
      @lightview.loadContent('content')
      expect(@resizeSpy.callCount).toEqual(1)


  describe "#setTitle", ->

    beforeEach ->
      spyOn(Mercury.Lightview.prototype, 'appear').andCallFake(=>)
      @lightview = Mercury.lightview('/blank.html', {appendTo: $('#test'), title: 'title'})

    it "sets the the title contents to what was provided in the options", ->
      @lightview.options = {title: 'new title'}
      @lightview.setTitle()
      expect($('.mercury-lightview-title span').html()).toEqual('new title')


  describe "#reset", ->

    beforeEach ->
      spyOn(Mercury.Lightview.prototype, 'appear').andCallFake(=>)
      @lightview = Mercury.lightview('/blank.html', {appendTo: $('#test'), title: 'title'})

    it "clears the title and content elements", ->
      $('.mercury-lightview-content').html('content')
      @lightview.reset()
      expect($('.mercury-lightview-content').html()).toEqual('')
      expect($('.mercury-lightview-title span').html()).toEqual('')


  describe "#hide", ->

    beforeEach ->
      spyOn(Mercury.Lightview.prototype, 'appear').andCallFake(=>)
      @lightview = Mercury.lightview('/blank.html', {appendTo: $('#test')})

    it "triggers the focus:frame event", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      @lightview.hide()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:frame'])

    it "hides the element", ->
      @lightview.element.css('display:block')
      @lightview.hide()
      expect($('.mercury-lightview').css('display')).toEqual('none')

    it "hides the overlay element", ->
      @lightview.overlay.css('display:block')
      @lightview.hide()
      expect($('.mercury-lightview-overlay').css('display')).toEqual('none')

    it "calls reset", ->
      spy = spyOn(@lightview, 'reset').andCallFake(=>)
      @lightview.hide()
      expect(spy.callCount).toEqual(1)

    it "sets visible to false", ->
      @lightview.visible = true
      @lightview.hide()
      expect(@lightview.visible).toEqual(false)
