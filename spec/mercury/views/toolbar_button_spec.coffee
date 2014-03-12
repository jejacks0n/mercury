#= require spec_helper
#= require mercury/views/toolbar
#= require mercury/views/toolbar_button

describe "Mercury.ToolbarButton", ->

  Klass = Mercury.ToolbarButton
  subject = null

  beforeEach ->
    Mercury.getPlugin ||= ->
    subject = new Klass('name', 'label', [])

  afterEach ->
    subject.$el ||= $('<div>')
    subject.release()

  describe ".create", ->

    it "instantiates a Mercury.ToolbarButton", ->
      spyOn(Mercury, 'ToolbarButton', -> inst: '_toolbar_button_')
      Klass.create('_name_', '_label_')
      expect( Mercury.ToolbarButton ).calledWith('_name_', '_label_', {})

    it "allows specifying a button class in the options, which instantiates Mercury.Toolbar[ButtonName]", ->
      Mercury.ToolbarCustomButton = spy()
      Klass.create('_name1_', '_label_', button: 'custom_button')
      expect( Mercury.ToolbarCustomButton ).calledWith('_name1_', '_label_', button: 'custom_button')
      Klass.create('_name2_', '_label_', button: 'customButton')
      expect( Mercury.ToolbarCustomButton ).calledWith('_name2_', '_label_', button: 'customButton')

    it "allows plugins to specify a custom button class", ->
      plugin = Button: spy()
      spyOn(Mercury, 'getPlugin', -> plugin)
      Klass.create('_name_', '_label_', plugin: '_plugin_')
      expect( Mercury.getPlugin ).calledWith('_plugin_')
      expect( plugin.Button ).calledWith('_name_', '_label_', plugin: '_plugin_')


  describe "#constructor", ->

    beforeEach ->
      spyOn(Klass::, 'determineAction')
      spyOn(Klass::, 'determineTypes')
      spyOn(Klass::, 'handleSpecial')
      spyOn(Klass.__super__, 'constructor')

    it "calls #determineAction", ->
      subject = new Klass()
      expect( subject.determineAction ).called

    it "calls #determineTypes", ->
      subject = new Klass()
      expect( subject.determineTypes ).called

    it "sets @icon from name", ->
      subject = new Klass('fooBar')
      expect( subject.icon ).to.eq('foo-bar')

    it "calls super", ->
      subject = new Klass()
      expect( Klass.__super__.constructor ).called

    it "calls #handleSpecial", ->
      subject = new Klass()
      expect( subject.handleSpecial ).called


  describe "#determineAction", ->

    it "determines the action from options.action", ->
      subject.options = action: '_action_'
      subject.determineAction()
      expect( subject.action ).to.eql(['_action_'])
      expect( subject.actionName ).to.eq('_action_')

    it "falls back to the name being the action", ->
      subject.determineAction()
      expect( subject.action ).to.eql(['name'])
      expect( subject.actionName ).to.eq('name')

    it "allows providing an array for action that includes action and arguments", ->
      subject.options = action: ['_custom_action_', foo: 'bar']
      subject.determineAction()
      expect( subject.action ).to.eql(['_custom_action_', foo: 'bar'])
      expect( subject.actionName ).to.eq('_custom_action_')


  describe "#determineTypes", ->

    it "determines the types from options.type", ->
      subject.options = type: '_type_'
      subject.determineTypes()
      expect( subject.types ).to.eql(['_type_'])

    it "adds types for all the unknown options", ->
      subject.options = title: '_title_', icon: '_icon_', action: '_action_', global: false, button: '_button_', settings: '_settings_', foo: 'bar', bar: 'baz'
      subject.determineTypes()
      expect( subject.types ).to.eql(['foo', 'bar'])
      expect( subject.type ).to.eql('foo')


  describe "#build", ->

    beforeEach ->
      spyOn(subject, 'registerPlugin')

    it "calls #registerPlugin", ->
      subject.build()
      expect( subject.registerPlugin ).called

    it "sets the data-type attribute", ->
      subject.type = '_type_'
      subject.build()
      expect( subject.$el.data('type') ).to.eq('_type_')

    it "adds the right icon class", ->
      subject.icon = 'table'
      subject.build()
      expect( subject.$el.is('.mercury-icon-table') ).to.be.true

    it "sets the title", ->
      subject.options.title = '_title_'
      subject.build()
      expect( subject.$el.attr('title') ).to.eq('_title_')

    it "sets the html to include the label", ->
      subject.label = '_label_'
      subject.build()
      expect( subject.$el.html() ).to.eql('<em>_label_</em>')

    it "calls #buildSubview and appends that if there's a result", ->
      mock = appendTo: spy()
      spyOn(subject, 'buildSubview', -> mock)
      subject.build()
      expect( subject.buildSubview ).called
      expect( mock.appendTo ).calledWith(subject)


  describe "#handleSpecial", ->

    it "calls #makeSaveButton if our event is 'save'", ->
      spyOn(subject, 'makeSaveButton')
      subject.event = 'save'
      subject.handleSpecial()
      expect( subject.makeSaveButton ).called

    it "calls #makeModeButton if we have a mode", ->
      spyOn(subject, 'makeModeButton')
      subject.mode = 'preview'
      subject.handleSpecial()
      expect( subject.makeModeButton ).called


  describe "#makeSaveButton", ->

    beforeEach ->
      @events = null
      spyOn(subject, 'delegateEvents', (events) => @events = events)
      subject.makeSaveButton()

    it "delegates events for save/save:complete", ->
      expect( subject.delegateEvents ).calledWith
        'mercury:save': sinon.match.func
        'mercury:save:complete': sinon.match.func

    it "adds a loading indicator class on save", ->
      spyOn(subject, 'addClass')
      @events['mercury:save'].call(subject)
      expect( subject.addClass ).calledWith('mercury-loading-indicator')

    it "removes the loading indicator class on save:complete", ->
      spyOn(subject, 'removeClass')
      @events['mercury:save:complete'].call(subject)
      expect( subject.removeClass ).calledWith('mercury-loading-indicator')


  describe "#makeModeButton", ->

    beforeEach ->
      @events = null
      spyOn(subject, 'delegateEvents', (events) => @events = events)
      subject.mode = '_mode_'
      subject.makeModeButton()

    it "delegates events for mode", ->
      expect( subject.delegateEvents ).calledWith
        'mercury:mode': sinon.match.func

    it "toggles the button on mode change if the mode is the same as ours", ->
      spyOn(subject, 'untoggled')
      spyOn(subject, 'toggled')
      subject.isToggled = true
      @events['mercury:mode'].call(subject, 'foo')
      expect( subject.untoggled ).not.called

      @events['mercury:mode'].call(subject, '_mode_')
      expect( subject.untoggled ).called

      subject.isToggled = false
      @events['mercury:mode'].call(subject, '_mode_')
      expect( subject.toggled ).called


  describe "#registerPlugin", ->

    beforeEach ->
      subject.plugin = '_plugin_'
      @mock = buttonRegistered: spy()
      spyOn(Mercury, 'getPlugin', => @mock)

    it "gets an instance of that plugin", ->
      subject.registerPlugin()
      expect( Mercury.getPlugin ).calledWith('_plugin_', true)

    it "tells the plugin that this button has registered for it", ->
      subject.registerPlugin()
      expect( @mock.buttonRegistered ).calledWith(subject)

    it "does nothing if there's no plugin", ->
      subject.plugin = false
      subject.registerPlugin()
      expect( Mercury.getPlugin ).not.called


  describe "#buildSubview", ->

    describe "when a subview is provided", ->

      beforeEach ->
        subject.subview = release: spy(), on: ->
        spyOn(subject.subview, 'on').yieldsOn(subject)

      it "binds to show of the subview and calls #toggeled (if we're toggleable) and #activated", ->
        spyOn(subject, 'toggled')
        spyOn(subject, 'activate')
        subject.buildSubview()
        expect( subject.subview.on ).calledWith('show', sinon.match.func)
        expect( subject.activate ).called
        expect( subject.toggled ).not.called

        subject.toggle = true
        subject.buildSubview()
        expect( subject.toggled ).called

      it "binds to hide of the subview and untoggles/deactivates", ->
        spyOn(subject, 'untoggled')
        spyOn(subject, 'deactivate')
        subject.buildSubview()
        expect( subject.subview.on ).calledWith('hide', sinon.match.func)
        expect( subject.deactivate ).called
        expect( subject.untoggled ).called

      it "returns the subview", ->
        expect( subject.buildSubview() ).to.eq(subject.subview)

    describe "building a subview based on type", ->

      beforeEach ->
        Mercury.ToolbarFoo = spy(-> release: spy())
        subject.type = 'foo'

      it "instantiates the view based on type and assigns it to @subview", ->
        subject.options.foo = foo: 'bar'
        subject.buildSubview()
        expect( Mercury.ToolbarFoo ).calledWith(foo: 'bar')

      it "passes a template if one was provided", ->
        subject.options.foo = '_template_'
        subject.buildSubview()
        expect( Mercury.ToolbarFoo ).calledWith(template: '_template_')


  describe "#triggerAction", ->

    beforeEach ->
      spyOn(Mercury, 'trigger')
      spyOn(subject, 'trigger')

    it "calls #toggled or #untoggled if it's a toggle button", ->
      subject.toggle = true
      spyOn(subject, 'toggled')
      spyOn(subject, 'untoggled')
      subject.isToggled = true
      subject.triggerAction()
      expect( subject.untoggled ).called
      subject.isToggled = false
      subject.triggerAction()
      expect( subject.toggled ).called

    it "calls #activate or #deactivate based on if the subview is visible or not (and toggles it)", ->
      spyOn(subject, 'deactivate')
      spyOn(subject, 'activate')
      subject.subview = visible: true, toggle: spy()
      subject.triggerAction()
      expect( subject.deactivate ).called
      expect( subject.subview.toggle ).called
      subject.subview = visible: false, toggle: spy(), release: ->
      subject.triggerAction()
      expect( subject.activate ).called
      expect( subject.subview.toggle ).called

    it "triggers a click event", ->
      subject.triggerAction()
      expect( subject.trigger ).calledWith('click')

    it "returns if there's a plugin or subview", ->
      expect( subject.triggerAction() ).to.be.undefined
      expect( subject.trigger ).called

    it "triggers a global event if it's an event button", ->
      subject.event = '_event_'
      subject.triggerAction()
      expect( Mercury.trigger ).calledWith('_event_')

    it "triggers a mode event if it's a mode button", ->
      subject.mode = '_mode_'
      subject.triggerAction()
      expect( Mercury.trigger ).calledWith('mode', '_mode_')

    it "triggers an action event", ->
      subject.action = ['_action_', 1, 2, 'foo']
      subject.triggerAction()
      expect( Mercury.trigger ).calledWith('action', '_action_', 1, 2, 'foo')

    it "does nothing if disabled", ->
      subject.isEnabled = false
      expect( subject.triggerAction() ).to.be.undefined
      expect( subject.trigger ).not.called


  describe "#release", ->

    beforeEach ->
      spyOn(Klass.__super__, 'release')

    it "calls release on the subview", ->
      subject.subview = release: spy()
      subject.release()
      expect( subject.subview.release ).called

    it "calls super", ->
      subject.release()
      expect( Klass.__super__.release ).called


  describe "#regionSupported", ->

    beforeEach ->
      @region = hasAction: spy()

    it "asks the region if it handles our action", ->
      subject.actionName = '_action_name_'
      subject.regionSupported(@region)
      expect( @region.hasAction ).calledWith('_action_name_')

    it "tells the plugin about the region if there's a plugin (and then returns)", ->
      subject.plugin = regionSupported: spy()
      subject.regionSupported(@region)
      expect( subject.plugin.regionSupported ).calledWith(@region)
      expect( @region.hasAction ).not.called


  describe "#onRegionFocus", ->

    it "calls #onRegionUpdate in a delay", ->
      spyOn(subject, 'delay').yieldsOn(subject)
      spyOn(subject, 'onRegionUpdate')
      subject.onRegionFocus('_region_')
      expect( subject.delay ).calledWith(100, sinon.match.func)
      expect( subject.onRegionUpdate ).calledWith('_region_')


  describe "#onRegionUpdate", ->

    beforeEach ->
      @region = hasContext: ->
      Mercury.interface.activeRegion = => @region

    it "calls #deactivate unless the subview is visible", ->
      spyOn(subject, 'regionSupported')
      subject.subview = visible: false
      spyOn(subject, 'deactivate')
      subject.onRegionUpdate(@region)
      expect( subject.deactivate ).called

      subject.subview = visible: true, release: ->
      subject.onRegionUpdate(@region)
      expect( subject.deactivate ).calledOnce

    it "calls #enable if the region supports us or we're global", ->
      subject.regionSupported = spy(-> false)
      spyOn(subject, 'enable')
      subject.onRegionUpdate(@region)
      expect( subject.enable ).not.called

      subject.global = true
      subject.onRegionUpdate(@region)
      expect( subject.enable ).called

      subject.global = false
      subject.regionSupported = spy(-> true)
      subject.onRegionUpdate(@region)
      expect( subject.enable ).calledTwice

    it "calls #activate if the region supports us or we're global and the region has context for us", ->
      spyOn(subject, 'activate')
      spyOn(@region, 'hasContext', -> true)
      subject.global = true
      subject.onRegionUpdate(@region)
      expect( subject.activate ).called
      expect( @region.hasContext ).calledWith(subject.name, true)

    it "calls #disable if not supported or not global", ->
      subject.global = false
      subject.regionSupported = spy(-> false)
      spyOn(subject, 'disable')
      subject.onRegionUpdate(@region)
      expect( subject.disable ).called

    it "does nothing if the region is different than the one Mercury.interface has", ->
      subject.global = false
      subject.regionSupported = spy(-> false)
      Mercury.interface.region = '_current_region_'
      spyOn(subject, 'disable')
      spyOn(subject, 'enable')
      subject.onRegionUpdate('_new_region_')
      expect( subject.disable ).not.called
      expect( subject.enable ).not.called


  describe "#get", ->

    it "returns a given attribute or method", ->
      subject.foo = '_foo_'
      expect( subject.get('foo') ).to.eq('_foo_')
      expect( subject.get('enabled') ).to.eq(subject.enabled)


  describe "#set", ->

    it "sets attributes based on different arguments styles", ->
      subject.set(foo: 'bar')
      expect( subject.foo ).to.eq('bar')
      subject.set('bar', 'baz')
      expect( subject.bar ).to.eq('baz')


  describe "#toggled", ->

    beforeEach ->
      subject.isToggled = false
      spyOn(subject, 'addClass')

    it "sets @isToggled to true", ->
      subject.toggled()
      expect( subject.isToggled ).to.be.true

    it "adds the toggled class", ->
      subject.toggled()
      expect( subject.addClass ).calledWith('mercury-button-toggled')


  describe "#untoggled", ->

    beforeEach ->
      subject.isToggled = true
      spyOn(subject, 'removeClass')

    it "sets @isToggled to false", ->
      subject.untoggled()
      expect( subject.isToggled ).to.be.false

    it "removes the toggled class", ->
      subject.untoggled()
      expect( subject.removeClass ).calledWith('mercury-button-toggled')


  describe "#activate", ->

    beforeEach ->
      subject.isActive = false
      spyOn(subject, 'addClass')

    it "sets @isActive to true", ->
      subject.activate()
      expect( subject.isActive ).to.be.true

    it "adds the active class", ->
      subject.activate()
      expect( subject.addClass ).calledWith('mercury-button-active')


  describe "#deactivate", ->

    beforeEach ->
      subject.isActive = true
      spyOn(subject, 'removeClass')

    it "set @isActive to false", ->
      subject.deactivate()
      expect( subject.isActive ).to.be.false

    it "removes the active class", ->
      subject.deactivate()
      expect( subject.removeClass ).calledWith('mercury-button-active')


  describe "#enable", ->

    beforeEach ->
      subject.isEnabled = false
      spyOn(subject, 'removeClass')

    it "sets @isEnabled to true", ->
      subject.enable()
      expect( subject.isEnabled ).to.be.true

    it "removes the disabled class", ->
      subject.enable()
      expect( subject.removeClass ).calledWith('mercury-button-disabled')


  describe "#disable", ->

    beforeEach ->
      subject.isEnabled = true
      spyOn(subject, 'addClass')

    it "sets @isEnabled to false", ->
      subject.disable()
      expect( subject.isEnabled ).to.be.false

    it "adds the disabled class", ->
      subject.disable()
      expect( subject.addClass ).calledWith('mercury-button-disabled')


  describe "#indicate", ->

    beforeEach ->
      subject.isIndicated = false
      spyOn(subject, 'addClass')

    it "sets @isIndicated to true", ->
      subject.indicate()
      expect( subject.isIndicated ).to.be.true

    it "adds the pressed/indicated class if not disabled", ->
      subject.isEnabled = false
      subject.indicate()
      expect( subject.addClass ).not.called
      subject.isEnabled = true
      subject.indicate()
      expect( subject.addClass ).calledWith('mercury-button-pressed')

    it "calls #deactivate and prevents/stops the event if our subview is visible (the subview will likely handle it)", ->
      e = preventDefault: spy(), stopPropagation: spy()
      subject.subview = visible: true, release: ->
      spyOn(subject, 'deactivate')
      subject.indicate(e)
      expect( subject.deactivate ).called
      expect( e.preventDefault ).called
      expect( e.stopPropagation ).called


  describe "#deindicate", ->

    beforeEach ->
      subject.isIndicated = true
      spyOn(subject, 'removeClass')

    it "sets @isIndicated to false", ->
      subject.deindicate()
      expect( subject.isIndicated ).to.be.false

    it "removes the pressed/indicated class", ->
      subject.deindicate()
      expect( subject.removeClass ).calledWith('mercury-button-pressed')


  describe "#isDisabled", ->

    it "returns false if disabled or if a parent is disabled", ->
      subject.isEnabled = false
      expect( subject.isDisabled() ).to.be.true
      subject.isEnabled = true
      subject.addClass('mercury-button-disabled')
      expect( subject.isDisabled() ).to.be.true

    it "returns true if not disabled and no parents are disabled", ->
      subject.isEnabled = true
      expect( subject.isDisabled() ).to.be.false
