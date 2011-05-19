require '/assets/carmenta/carmenta_editor.js'

describe "Carmenta.Toolbar.ButtonGroup", ->

  template 'carmenta/toolbar.button_group.html'

  beforeEach ->
    Carmenta.Toolbar.ButtonGroup.contexts.foo = -> false
    @region = {
      element: $('<div class="carmenta-region">')
      currentElement: -> $('<div>')
    }

  afterEach ->
    @buttonGroup = null
    delete(@buttonGroup)
    $(document).unbind('carmenta:region:update')

  describe "constructor", ->

    beforeEach ->
      @buildSpy = spyOn(Carmenta.Toolbar.ButtonGroup.prototype, 'build').andCallThrough()
      @bindEventsSpy = spyOn(Carmenta.Toolbar.ButtonGroup.prototype, 'bindEvents').andCallThrough()
      @buttonGroup = new Carmenta.Toolbar.ButtonGroup('foo', {_context: true})

    it "returns an element", ->
      html = $('<div>').html(@buttonGroup).html()
      expect(html).toEqual('<div class="carmenta-button-group carmenta-foo-group disabled"></div>')

    it "calls build", ->
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      expect(@bindEventsSpy.callCount).toEqual(1)


  describe "observed events", ->

    beforeEach ->
      @buttonGroup = new Carmenta.Toolbar.ButtonGroup('foo', {_context: true})

    describe "custom event: region:update", ->

      it "sets disabled/enabled state based on it's context", ->
        contextSpy = spyOn(Carmenta.Toolbar.ButtonGroup.contexts, 'foo').andCallFake(-> true)

        expect(@buttonGroup.hasClass('disabled')).toEqual(true)

        Carmenta.trigger('region:update', {region: @region})
        expect(contextSpy.callCount).toEqual(1)
        expect(@buttonGroup.hasClass('disabled')).toEqual(false)



describe "Carmenta.Toolbar.ButtonGroup.contexts", ->

  template 'carmenta/toolbar.button_group.html'

  beforeEach ->
    @contexts = Carmenta.Toolbar.ButtonGroup.contexts
    @region = $('#context_container')

  describe "table", ->

    it "looks up for a table tag", ->
      expect(@contexts.table($('#context_td'), @region)).toEqual(true)
      expect(@contexts.table($('#context_em'), @region)).toEqual(false)
