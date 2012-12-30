describe "Mercury.Toolbar.ButtonGroup", ->

  beforeEach ->
    fixture.load('mercury/toolbar.button_group.html')
    Mercury.Toolbar.ButtonGroup.contexts.foo = -> false
    @region = {
      element: $('<div>')
      currentElement: -> $('<div>')
    }

  afterEach ->
    @buttonGroup = null
    delete(@buttonGroup)
    $(window).unbind('mercury:region:update')

  describe "constructor", ->

    beforeEach ->
      @buildSpy = spyOn(Mercury.Toolbar.ButtonGroup.prototype, 'build').andCallThrough()
      @bindEventsSpy = spyOn(Mercury.Toolbar.ButtonGroup.prototype, 'bindEvents').andCallThrough()
      @buttonGroup = new Mercury.Toolbar.ButtonGroup('foo', {_context: true})

    it "returns an element", ->
      html = $('<div>').html(@buttonGroup).html()
      expect(html).toEqual('<div class="mercury-button-group mercury-foo-group disabled"></div>')

    it "calls build", ->
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      expect(@bindEventsSpy.callCount).toEqual(1)


  describe "observed events", ->

    describe "custom event: region:update", ->

      it "sets disabled/enabled state based on it's context", ->
        @buttonGroup = new Mercury.Toolbar.ButtonGroup('foo', {_context: true})
        contextSpy = spyOn(Mercury.Toolbar.ButtonGroup.contexts, 'foo').andCallFake(-> true)

        expect(@buttonGroup.hasClass('disabled')).toEqual(true)

        Mercury.trigger('region:update', {region: @region})
        expect(contextSpy.callCount).toEqual(1)
        expect(@buttonGroup.hasClass('disabled')).toEqual(false)

    describe "custom event: region:focused", ->

      beforeEach ->
        @region = {
          type: -> 'full'
          element: $('<div>')
        }

      it "disables if the region type isn't supported", ->
        @buttonGroup = new Mercury.Toolbar.ButtonGroup('foo', {_regions: ['foo']})
        @buttonGroup.removeClass('disabled')
        Mercury.trigger('region:focused', {region: @region})
        expect(@buttonGroup.hasClass('disabled')).toEqual(true)

      it "enables if the region type is supported", ->
        @buttonGroup = new Mercury.Toolbar.ButtonGroup('foo', {_regions: ['full']})
        @buttonGroup.addClass('disabled')
        Mercury.trigger('region:focused', {region: @region})
        expect(@buttonGroup.hasClass('disabled')).toEqual(false)

    describe "custom event: region:blurred", ->

      it "disables if it's a button group for specific region types", ->
        @buttonGroup = new Mercury.Toolbar.ButtonGroup('foo', {_regions: ['full']})
        @buttonGroup.removeClass('disabled')
        Mercury.trigger('region:blurred', {region: @region})



describe "Mercury.Toolbar.ButtonGroup.contexts", ->

  beforeEach ->
    fixture.load('mercury/toolbar.button_group.html')
    @contexts = Mercury.Toolbar.ButtonGroup.contexts
    @region = $('#context_container')

  describe "table", ->

    it "looks up for a table tag", ->
      expect(@contexts.table($('#context_td'), @region)).toEqual(true)
      expect(@contexts.table($('#context_em'), @region)).toEqual(false)
