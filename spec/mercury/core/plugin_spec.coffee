#= require spec_helper
#= require mercury/core/plugin

describe "Mercury.Plugin", ->

  Klass = ->
  Module = Mercury.Plugin.Module
  subject = null

  beforeEach ->
    class Klass extends Mercury.Plugin
    subject = new Klass(name: 'name')

  describe "Modules", ->

    it "includes in the expected modules", ->
      expect( Klass.log ).to.be.a('Function')
      expect( Klass.t ).to.be.a('Function')
      expect( subject.config ).to.be.a('Function')
      expect( subject.on ).to.be.a('Function')
      expect( subject.t ).to.be.a('Function')
      expect( subject.log ).to.be.a('Function')


  describe ".register", ->

    it "instantiates and returns the plugin definition it instantiated", ->
      spyOn(Mercury.Plugin, 'Definition', -> definition: '_definition_')
      expect( Klass.register('foo', foo: 'bar') ).to.eql(definition: '_definition_')
      expect( Mercury.Plugin.Definition ).calledWith(name: 'foo', foo: 'bar')


  describe ".get", ->

    beforeEach ->
      @definition = Klass.register('foo', foo: 'bar')

    it "returns the registered plugin definition by name", ->
      expect( Klass.get('foo') ).to.eql(@definition)

    it "returns a new plugin instance from the definition if asked", ->
      spyOn(Mercury, 'Plugin', -> plugin: '_plugin_')
      expect( Klass.get('foo', true) ).to.eql(plugin: '_plugin_')
      expect( Mercury.Plugin ).calledWith(name: 'foo', foo: 'bar')

    it "throws an error if there's no plugin with that name", ->
      expect(-> Klass.get('bar') ).to.throw('unable to locate the bar plugin')


  describe ".all", ->

    beforeEach ->
      @definition = Klass.register('foo', foo: 'bar')

    it "returns all the registered plugin definitions", ->
      expect( Klass.all()['foo'] ).to.eql(@definition)


  describe ".unregister", ->

    beforeEach ->
      @definition = Klass.register('foo', foo: 'bar')

    it "removes the definition from the list of registered plugin definitions", ->
      Klass.unregister('foo')
      expect( Klass.all()['foo'] ).to.be.undefined

    it "throws an error if there's no plugin with that name", ->
      expect(-> Klass.unregister('bar') ).to.throw('unable to locate the bar plugin')


  describe "#constructor", ->

    it "assigns instance vars from options passed", ->
      subject = new Klass(name: 'foo', foo: 'bar', config: '_config_')
      expect( subject.foo ).to.eq('bar')
      expect( subject.configuration ).to.eq('_config_')
      expect( subject.config ).to.be.a.func

    it "throws an exception if there was no name provided", ->
      expect(-> new Klass() ).to.throw('must provide a name for plugins')

    it "defaults the actions/actionsArray", ->
      subject = new Klass(name: 'foo')
      expect( subject.actionsArray ).to.eql([])
      expect( subject.actions ).to.eql({})
      subject = new Klass(name: 'foo', actions: {foo: 'config'})
      expect( subject.actions ).to.eql(foo: 'config')

    it "merges the events with constructor.events", ->
      Klass.events = event1: 'config'
      subject = new Klass(name: 'foo', events: {event2: 'config'})
      expect( subject.events ).to.eql(event1: 'config', event2: 'config')

    it "calls #delegateEvents", ->
      spyOn(Klass::, 'delegateEvents')
      subject = new Klass(name: 'foo', events: {foo: 'bar'})
      expect( subject.delegateEvents ).calledWith
        foo: 'bar'
        'mercury:region:focus': 'onRegionFocus'
        'button:click': 'onButtonClick'

    it "calls #appendActions", ->
      spyOn(Klass::, 'appendActions')
      subject = new Klass(name: 'foo', actions: {foo: 'bar'})
      expect( subject.appendActions ).calledWith(foo: 'bar')

    it "calls super", ->
      spyOn(Klass.__super__, 'constructor')
      subject = new Klass(name: 'foo')
      expect( Klass.__super__.constructor ).called


  describe "#buttonRegistered", ->

    beforeEach ->
      @mock = get: (prop) ->
        return foo: 'baz', bar: 'foo' if prop == 'settings'
        return '_action_' if prop == 'actionName'

    it "assigns @button", ->
      subject.buttonRegistered(@mock)
      expect( subject.button ).to.eq(@mock)

    it "merges configuration with button settings", ->
      subject.configuration = foo: 'bar'
      subject.buttonRegistered(@mock)
      expect( subject.configuration.foo ).to.eq('baz')
      expect( subject.configuration.bar ).to.eq('foo')

    it "prepends the button action if @prependButtonAction is set", ->
      spyOn(subject, 'prependAction')
      subject.prependButtonAction = 'config'
      subject.buttonRegistered(@mock)
      expect( subject.prependAction ).calledWith('_action_', 'config')

    it "calls #registerButton if it's defined", ->
      subject.registerButton = spy()
      subject.buttonRegistered(@mock)
      expect( subject.registerButton ).called


  describe "#regionSupported", ->

    beforeEach ->
      subject.actionsArray = [
        ['html', spy()]
        ['text', spy()]
      ]
      @mock = hasAction: stub()

    it "asks the region if it can handle any of our actions", ->
      subject.regionSupported(@mock)
      expect( @mock.hasAction ).calledWith('html')
      expect( @mock.hasAction ).calledWith('text')

    it "returns true if an action is supported", ->
      @mock.hasAction.returns(true)
      expect( subject.regionSupported(@mock) ).to.be.true
      expect( @mock.hasAction ).calledOnce

    it "returns false if the region can't handle any of our actions", ->
      @mock.hasAction.returns(false)
      expect( subject.regionSupported(@mock) ).to.be.false
      expect( @mock.hasAction ).calledTwice

    it "calls #regionContext if it's defined", ->
      subject.regionContext = spy()
      @mock.hasAction.returns(true)
      subject.regionSupported(@mock)
      expect( subject.regionContext ).calledOnce


  describe "#triggerAction", ->

    beforeEach ->
      subject.actionsArray = [
        ['html', spy()]
        ['text', spy()]
      ]
      @mock = hasAction: stub()
      subject.region = @mock

    it "returns false if there's no region", ->
      subject.region = null
      expect( subject.triggerAction(1, 2, 'foo') ).to.be.false

    it "calls hasAction on region until a supported action is found", ->
      @mock.hasAction.returns(true)
      subject.triggerAction(1, 2, 'foo')
      expect( @mock.hasAction ).calledWith('html')
      expect( @mock.hasAction ).not.calledWith('text')

    it "triggers a global focus event", ->
      spyOn(Mercury, 'trigger')
      @mock.hasAction.returns(true)
      subject.triggerAction(1, 2, 'foo')
      expect( Mercury.trigger ).calledWith('focus')

    it "calls the handler with the correct args within the scope of itself", ->
      @mock.hasAction.returns(true)
      subject.triggerAction(1, 2, 'foo')
      expect( subject.actionsArray[0][1] ).calledWith('html', 1, 2, 'foo')
      expect( subject.actionsArray[0][1] ).calledOn(subject)

    it "returns true if the handler was called", ->
      @mock.hasAction.returns(true)
      expect( subject.triggerAction(1, 2, 'foo') ).to.be.true

    it "returns false if nothing has been handled", ->
      @mock.hasAction.returns(false)
      expect( subject.triggerAction(1, 2, 'foo') ).to.be.false


  describe "#config", ->

    beforeEach ->
      subject.configuration = foo: {bar: 'baz'}

    it "returns the configuration base on the path", ->
      expect( subject.config('foo:bar') ).to.eq('baz')

    it "falls back to Mercury.configuration", ->
      Mercury.configure 'foo:bar', '_baz_'
      expect( subject.config('foo:bar') ).to.eq('baz')
      Mercury.configure 'foo:baz', '_bar_'
      expect( subject.config('foo:baz') ).to.eq('_bar_')
      expect( subject.config({}) ).to.be.undefined


  describe "#configure", ->

    beforeEach ->
      subject.configuration = null

    it "sets the configuration object (if the path is an object)", ->
      expect( subject.configure(foo: 'bar') ).to.eql(foo: 'bar')
      expect( subject.configuration ).to.eql(foo: 'bar')

    it "creates and sets the value of the provided path", ->
      expect( subject.configure('foo:bar', a: 1) ).to.eql(a: 1)
      expect( subject.configuration.foo.bar ).to.eql(a: 1)

    it "updates the value of the provided path", ->
      subject.configuration = foo: {bar: '_old_value_'}
      expect( subject.configure('foo:bar', '_new_value_') ).to.eq('_new_value_')
      expect( subject.configuration.foo.bar ).to.eq('_new_value_')

    it "merges the value of the provided path", ->
      subject.configuration = foo: {bar: 'bar'}
      subject.configure('foo', true, baz: 'baz')
      expect( subject.configuration ).to.eql(foo: {bar: 'bar', baz: 'baz'})


  describe "#release", ->

    it "calls Mercury.off for all of our global handlers", ->
      subject.__global_handlers__ = foo: 'bar'
      spyOn(Mercury, 'off')
      subject.release()
      expect( Mercury.off ).calledWith('foo', 'bar')

    it "calls #off", ->
      spyOn(subject, 'off')
      subject.release()
      expect( subject.off ).called


  describe "#onRegionFocus", ->

    it "assigns @region", ->
      subject.onRegionFocus('_region_')
      expect( subject.region ).to.eq('_region_')


  describe "#onButtonClick", ->

    it "does nothing", ->
      subject.onButtonClick()


  describe "#appendActions", ->

    beforeEach ->
      subject.actionsArray = [['bar', spy()]]

    describe "binding to a callback directly", ->

      it "resolves the action", ->
        callback = spy()
        subject.appendActions(action: callback)
        subject.actionsArray[1][1](1, 2, '3')
        expect( callback ).calledWith(1, 2, '3')

    describe "binding to a method (by string)", ->

      it "locates the method and resolves the action", ->
        spyOn(subject, 'release')
        subject.appendActions(action: 'release')
        subject.actionsArray[1][1](1, 2, '3')
        expect( subject.release ).called

      it "throws an exception if the method doesn't exist", ->
        expect(-> subject.appendActions(event: 'foo') ).to.throw(Error, "foo doesn't exist")


  describe "#prependAction", ->

    beforeEach ->
      subject.actionsArray = [['bar', spy()]]

    describe "binding to a callback directly", ->

      it "resolves the action", ->
        callback = spy()
        subject.prependAction('action', callback)
        subject.actionsArray[0][1](1, 2, '3')
        expect( callback ).calledWith(1, 2, '3')

    describe "binding to a method (by string)", ->

      it "locates the method and resolves the action", ->
        spyOn(subject, 'release')
        subject.prependAction('action', 'release')
        subject.actionsArray[0][1](1, 2, '3')
        expect( subject.release ).called

      it "throws an exception if the method doesn't exist", ->
        expect(-> subject.prependAction('event', 'foo') ).to.throw(Error, "foo doesn't exist")


  describe "#delegateEvents", ->

    beforeEach ->
      spyOn(subject, 'on')

    describe "binding to a callback directly", ->

      it "adds the event", ->
        callback = spy()
        subject.delegateEvents(event: callback)
        expect( subject.on ).calledWith('event', sinon.match.func)
        subject.on.callArg(1, 'foo')
        expect( callback ).calledWith('foo')
        expect( callback ).calledOn(subject)

    describe "binding to a method (by string)", ->

      it "locates the method and binds the event", ->
        subject.eventHandler = spy()
        subject.delegateEvents(event: 'eventHandler')
        expect( subject.on ).calledWith('event', sinon.match.func)
        subject.on.callArg(1, 'foo')
        expect( subject.eventHandler ).calledWith('foo')

      it "throws an exception if the method doesn't exist", ->
        expect(-> subject.delegateEvents(event: 'foo') ).to.throw(Error, "foo doesn't exist")

    describe "binding to global events (by using : in the event name)", ->

      beforeEach ->
        spyOn(Mercury, 'on')

      it "calls the global Mercury.on", ->
        callback = spy()
        subject.delegateEvents('mercury:global:event': callback)
        expect( Mercury.on ).calledWith('global:event')
        Mercury.on.callArg(1, 'foo')
        expect( callback ).calledWith('foo')
        expect( callback ).calledOn(subject)
        expect( subject.__global_handlers__['global:event'] ).to.be.a.func


  describe "Module", ->

    it "is defined correctly", ->
      expect( Module.registerPlugin ).to.eq(Klass.register)
      expect( Module.getPlugin ).to.eq(Klass.get)


describe "Mercury.Plugin.Definition", ->

  Klass = ->
  subject = null

  beforeEach ->
    class Klass extends Mercury.Plugin.Definition
    @func = ->
    subject = new Klass(name: 'definition', config: {foo: 'bar'}, func: @func)

  describe "#constructor", ->

    it "sets @configuration and @name from the options", ->
      expect( subject.configuration ).to.eql(foo: 'bar')

    it "registers the definition", ->
      expect( Mercury.Plugin.get('definition') ).to.eq(subject)


  describe "#signature", ->

    it "returns a clone of the @options", ->
      expect( subject.signature() ).to.eql(name: 'definition', config: {foo: 'bar'}, func: @func)
      expect( subject.signature(false) ).to.eql(name: 'definition', config: {foo: 'bar'})


  describe "#config", ->

    beforeEach ->
      subject.configuration = foo: {bar: 'baz'}

    it "returns the configuration base on the path", ->
      expect( subject.config('foo:bar') ).to.eq('baz')

    it "falls back to Mercury.configuration", ->
      Mercury.configure 'foo:bar', '_baz_'
      expect( subject.config('foo:bar') ).to.eq('baz')
      Mercury.configure 'foo:baz', '_bar_'
      expect( subject.config('foo:baz') ).to.eq('_bar_')
      expect( subject.config({}) ).to.be.undefined


  describe "#configure", ->

    beforeEach ->
      subject.configuration = null

    it "sets the configuration object (if the path is an object)", ->
      expect( subject.configure(foo: 'bar') ).to.eql(foo: 'bar')
      expect( subject.configuration ).to.eql(foo: 'bar')

    it "creates and sets the value of the provided path", ->
      expect( subject.configure('foo:bar', a: 1) ).to.eql(a: 1)
      expect( subject.configuration.foo.bar ).to.eql(a: 1)

    it "updates the value of the provided path", ->
      subject.configuration = foo: {bar: '_old_value_'}
      expect( subject.configure('foo:bar', '_new_value_') ).to.eq('_new_value_')
      expect( subject.configuration.foo.bar ).to.eq('_new_value_')

    it "merges the value of the provided path", ->
      subject.configuration = foo: {bar: 'bar'}
      subject.configure('foo', true, baz: 'baz')
      expect( subject.configuration ).to.eql(foo: {bar: 'bar', baz: 'baz'})
