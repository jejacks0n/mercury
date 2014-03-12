#= require spec_helper
#= require mercury/views/toolbar

describe "Mercury.Toolbar", ->

  Klass = Mercury.Toolbar
  subject = null

  beforeEach ->
    subject = new Klass()

  afterEach ->
    subject.release()

  describe "#build", ->

    beforeEach ->
      Mercury.configure 'toolbars:primary', primary: '_toolbar_'
      spyOn(subject, 'append')
      spyOn(Mercury, 'ToolbarItem', (name, type) -> result: "_#{name}_#{type}_")

    it "appends the primary container ToolbarItem", ->
      subject.build()
      expect( Mercury.ToolbarItem ).calledWith('primary', 'container', primary: '_toolbar_')
      expect( subject.append ).calledWith(result: '_primary_container_')
      expect( subject.append ).calledTwice

    it "only appends the primary container if configured to do so", ->
      Mercury.configure 'toolbars:primary', null
      subject.build()
      expect( subject.append ).calledOnce

    it "appends a secondary container ToolbarItem", ->
      subject.build()
      expect( Mercury.ToolbarItem ).calledWith('secondary', 'container', {})
      expect( subject.append ).calledWith(result: '_secondary_container_')


  describe "#buildToolbar", ->

    beforeEach ->
      Mercury.configure 'toolbars:foo', foo: 'bar'
      spyOn(Mercury, 'ToolbarItem', -> inst: '_toolbar_item_')

    it "appends a collection ToolbarItem based on the name", ->
      spyOn(subject, 'appendView')
      subject.$toolbar = show: -> subject.$toolbar
      subject.buildToolbar('foo')
      expect( Mercury.ToolbarItem ).calledWith('foo', 'collection', foo: 'bar')
      expect( subject.appendView ).calledWith(subject.$toolbar, inst: '_toolbar_item_')

    it "hides the toolbar if there's no buttons (or configuration)", ->
      subject.$toolbar = hide: spy()
      subject.buildToolbar('bar')
      expect( subject.$toolbar.hide ).called


  describe "#show", ->

    beforeEach ->
      subject.visibilityTimeout = '_timer_'
      spyOn(window, 'clearTimeout')

    it "does nothing if the interface is floating and is already visible", ->
      Mercury.interface.floating = true
      subject.visible = true
      expect( subject.show() ).to.be.undefined
      expect( clearTimeout ).not.called

    it "calls clearTimeout", ->
      subject.show()
      expect( clearTimeout ).calledWith('_timer_')

    it "sets @visible to true", ->
      subject.visible = false
      subject.show()
      expect( subject.visible ).to.be.true

    it "shows the element", ->
      spyOn(subject.$el, 'show')
      subject.show()
      expect( subject.$el.show ).called

    it "delays setting the elements css top", ->
      spyOn(subject, 'delay').yieldsOn(subject)
      spyOn(subject.$el, 'hide')
      subject.show()
      expect( subject.delay ).calledWith(50, sinon.match.func)
      expect( subject.$el.css('top') ).to.eq('0px')


  describe "#hide", ->

    beforeEach ->
      subject.visibilityTimeout = '_timer_'
      spyOn(window, 'clearTimeout')

    it "does nothing if the interface is floating", ->
      Mercury.interface.floating = true
      expect( subject.hide() ).to.be.undefined
      expect( clearTimeout ).not.called

    it "calls clearTimeout", ->
      subject.hide()
      expect( clearTimeout ).calledWith('_timer_')

    it "sets @visible to false", ->
      subject.visible = true
      subject.hide()
      expect( subject.visible ).to.be.false

    it "sets css top to the element height", ->
      fixture.set(subject.$el.css(height: 42))
      subject.hide()
      expect( subject.$el.css('top') ).to.eq('-42px')

    it "delays hiding the element", ->
      spyOn(subject, 'delay').yieldsOn(subject)
      spyOn(subject.$el, 'hide')
      subject.hide()
      expect( subject.delay ).calledWith(250, sinon.match.func)
      expect( subject.$el.hide ).called


  describe "#height", ->

    it "returns 0 if the interface isn't visible", ->
      expect( subject.height() ).to.eq(0)

    it "returns the element height", ->
      Mercury.interface.visible = true
      spyOn(subject.$el, 'outerHeight', -> 42)
      expect( subject.height() ).to.eq(42)


  describe "#onMousedown", ->

    beforeEach ->
      @e = preventDefault: spy()
      spyOn(Mercury, 'trigger')

    it "prevents the default event", ->
      subject.onMousedown(@e)
      expect( @e.preventDefault ).called

    it "triggers a global dialogs:hide event", ->
      subject.onMousedown(@e)
      expect( Mercury.trigger ).calledWith('dialogs:hide')

    it "triggers a global focus event", ->
      subject.onMousedown(@e)
      expect( Mercury.trigger ).calledWith('focus')


  describe "#onRegionFocus", ->

    beforeEach ->
      spyOn(Mercury, 'trigger')

    it "sets @region to the region passed", ->
      subject.onRegionFocus('_region_')
      expect( subject.region ).to.eq('_region_')

    it "removes any toolbar collections", ->
      mock = remove: spy()
      spyOn(subject, '$', -> mock)
      subject.onRegionFocus('_region_')
      expect( subject.$ ).calledWith('.mercury-toolbar-collection')
      expect( mock.remove ).called

    it "calls #releaseSubviews", ->
      spyOn(subject, 'releaseSubviews')
      subject.onRegionFocus('_region_')
      expect( subject.releaseSubviews ).called

    it "calls #buildToolbar for all the region toolbars", ->
      spyOn(subject, 'buildToolbar')
      subject.onRegionFocus(toolbars: [1, 2, 'foo'])
      expect( subject.buildToolbar ).calledWith(1)
      expect( subject.buildToolbar ).calledWith(2)
      expect( subject.buildToolbar ).calledWith('foo')

    it "triggers a region:update event", ->
      subject.onRegionFocus('_region_')
      expect( Mercury.trigger ).calledWith('region:update', '_region_')

    it "does nothing if @region is the same as the one passed", ->
      subject.region = '_region_'
      subject.onRegionFocus('_region_')
      expect( Mercury.trigger ).not.called
