describe "Mercury.tooltip", ->

  template 'mercury/tooltip.html'

  beforeEach ->
    @forElement = $('#for_element')
    $.fx.off = true

  afterEach ->
    Mercury.tooltip.visible = false
    Mercury.tooltip.initialized = false

  describe "singleton method", ->

    beforeEach ->
      @showSpy = spyOn(Mercury.tooltip, 'show').andCallFake(=>)

    it "calls show", ->
      Mercury.tooltip()
      expect(@showSpy.callCount).toEqual(1)

    it "returns the function object", ->
      ret = Mercury.tooltip()
      expect(ret).toEqual(Mercury.tooltip)


  describe "#show", ->

    beforeEach ->
      @initializeSpy = spyOn(Mercury.tooltip, 'initialize').andCallFake(=>)
      @updateSpy = spyOn(Mercury.tooltip, 'update').andCallFake(=>)
      @appearSpy = spyOn(Mercury.tooltip, 'appear').andCallFake(=>)

    it "gets the document from the element passed in", ->
      Mercury.tooltip.show(@forElement, 'content')
      expect(Mercury.tooltip.document).toEqual(document)

    it "calls initialize", ->
      Mercury.tooltip.show(@forElement, 'content')
      expect(@initializeSpy.callCount).toEqual(1)

    describe "if visible", ->

      beforeEach ->
        Mercury.tooltip.visible = true

      it "calls update", ->
        Mercury.tooltip.show(@forElement, 'content')
        expect(@updateSpy.callCount).toEqual(1)

    describe "if not visible", ->

      beforeEach ->
        Mercury.tooltip.visible = false

      it "calls appear", ->
        Mercury.tooltip.show(@forElement, 'content')
        expect(@appearSpy.callCount).toEqual(1)


  describe "#initialize", ->

    it "calls build", ->
      spy = spyOn(Mercury.tooltip, 'build').andCallFake(=>)
      spyOn(Mercury.tooltip, 'bindEvents').andCallFake(=>)
      Mercury.tooltip.initialize()
      expect(spy.callCount).toEqual(1)

    it "calls bindEvents", ->
      spy = spyOn(Mercury.tooltip, 'bindEvents').andCallFake(=>)
      Mercury.tooltip.initialize()
      expect(spy.callCount).toEqual(1)

    it "sets initialized to true", ->
      Mercury.tooltip.initialize()
      expect(Mercury.tooltip.initialized).toEqual(true)

    it "does nothing if already initialized", ->
      spy = spyOn(Mercury.tooltip, 'bindEvents').andCallFake(=>)
      Mercury.tooltip.initialized = true
      Mercury.tooltip.initialize()
      expect(spy.callCount).toEqual(0)


  describe "#build", ->

    it "builds an element", ->
      Mercury.tooltip.build()
      html = $('<div>').html(Mercury.tooltip.element).html()
      expect(html).toContain('class="mercury-tooltip"')

    it "can append to any element", ->
      Mercury.tooltip.options = {appendTo: '#tooltip_container'}
      Mercury.tooltip.build()
      expect($('#tooltip_container').html()).toContain('class="mercury-tooltip"')


  describe "observed events", ->

    describe "custom event: resize", ->

      it "call position if visible", ->
        Mercury.tooltip.visible = true
        spy = spyOn(Mercury.tooltip, 'position').andCallFake(=>)
        Mercury.trigger('resize')
        expect(spy.callCount).toEqual(1)

        Mercury.tooltip.visible = false
        Mercury.trigger('resize')
        expect(spy.callCount).toEqual(1)

    describe "document scrolling", ->

      # untestable
      it "calls position if visible", ->

    describe "element mousedown", ->

      # untestable
      it "stops the event", ->


  describe "#appear", ->

    beforeEach ->
      Mercury.tooltip.build()
      @updateSpy = spyOn(Mercury.tooltip, 'update').andCallFake(=>)

    it "calls update", ->
      Mercury.tooltip.appear()
      expect(@updateSpy.callCount).toEqual(1)

    it "shows the element", ->
      Mercury.tooltip.appear()
      expect(Mercury.tooltip.element.css('display')).toEqual('block')
      expect(Mercury.tooltip.element.css('opacity')).toEqual('1')

    it "sets visible to true", ->
      Mercury.tooltip.visible = false
      Mercury.tooltip.appear()
      expect(Mercury.tooltip.visible).toEqual(true)


  describe "#update", ->

    beforeEach ->
      Mercury.tooltip.build()
      @positionSpy = spyOn(Mercury.tooltip, 'position').andCallFake(=>)

    it "sets the html", ->
      Mercury.tooltip.content = 'foo'
      Mercury.tooltip.update()
      expect(Mercury.tooltip.element.html()).toEqual('foo')

    it "calls position", ->
      Mercury.tooltip.update()
      expect(@positionSpy.callCount).toEqual(1)


  describe "#position", ->

    beforeEach ->
      Mercury.tooltip.build()
      Mercury.displayRect = {top: 0, left: 0, width: 200, height: 200}

    it "positions based on the element we're showing for", ->
      Mercury.tooltip.forElement = @forElement
      Mercury.tooltip.position()
      expect(Mercury.tooltip.element.offset()).toEqual({top: 20 + @forElement.outerHeight(), left: 42})


  describe "#hide", ->

    beforeEach ->
      Mercury.tooltip.build()
      Mercury.tooltip.initialized = true

    it "hides the element", ->
      Mercury.tooltip.element.css({display: 'block'})
      Mercury.tooltip.hide()
      expect(Mercury.tooltip.element.css('display')).toEqual('none')

    it "sets visible to false", ->
      Mercury.tooltip.visible = true
      Mercury.tooltip.hide()
      expect(Mercury.tooltip.visible).toEqual(false)
