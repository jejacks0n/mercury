require '/assets/mercury/mercury.js'

describe "Mercury.Toolbar.ButtonGroup", ->

  template 'mercury/toolbar.button_group.html'

  beforeEach ->
    Mercury.Toolbar.ButtonGroup.contexts.foo = -> false
    @region = {
      element: $('<div class="mercury-region">')
      currentElement: -> $('<div>')
    }

  afterEach ->
    @buttonGroup = null
    delete(@buttonGroup)
    $(document).unbind('mercury:region:update')

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

    beforeEach ->
      @buttonGroup = new Mercury.Toolbar.ButtonGroup('foo', {_context: true})

    describe "custom event: region:update", ->

      it "sets disabled/enabled state based on it's context", ->
        contextSpy = spyOn(Mercury.Toolbar.ButtonGroup.contexts, 'foo').andCallFake(-> true)

        expect(@buttonGroup.hasClass('disabled')).toEqual(true)

        Mercury.trigger('region:update', {region: @region})
        expect(contextSpy.callCount).toEqual(1)
        expect(@buttonGroup.hasClass('disabled')).toEqual(false)



describe "Mercury.Toolbar.ButtonGroup.contexts", ->

  template 'mercury/toolbar.button_group.html'

  beforeEach ->
    @contexts = Mercury.Toolbar.ButtonGroup.contexts
    @region = $('#context_container')

  describe "table", ->

    it "looks up for a table tag", ->
      expect(@contexts.table($('#context_td'), @region)).toEqual(true)
      expect(@contexts.table($('#context_em'), @region)).toEqual(false)
