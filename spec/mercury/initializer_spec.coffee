#= require spec_helper
#= require mercury/initializer

describe "Mercury", ->

  Klass = null

  beforeEach ->
    Klass = $.extend({}, MockMercury)

  it "has the exepected version", ->
    expect( Klass.version ).to.eq('2.0.1 pre alpha')

  it "provides a reference to JST", ->
    expect( Klass.JST ).to.eq(JST)

  it "extends Config and adds the .configure method", ->
    expect( Klass.Module.extend ).calledWith(Klass.Config)
    expect( Klass.configure ).to.be.a('function')

  it "extends Events", ->
    expect( Klass.Module.extend ).calledWith(Klass.Events)

  it "extends I18n", ->
    expect( Klass.Module.extend ).calledWith(Klass.I18n)

  it "extends Logger", ->
    expect( Klass.Module.extend ).calledWith(Klass.Logger)

  it "extends Plugin", ->
    expect( Klass.Module.extend ).calledWith(Klass.Plugin)

  it "extends Snippet", ->
    expect( Klass.Module.extend ).calledWith(Klass.Snippet)

  it "detects various browser for support purposes", ->
    expect( Klass.support ).to.have.keys(['webkit', 'gecko', 'trident', 'chrome', 'safari', 'ie10', 'wysiwyg'])

  it "defines the .init method", ->
    expect( Klass.init ).to.be.a('function')


  describe ".init", ->

    beforeEach ->
      Klass.interface = false
      spyOn(Klass, 'Interface')
      spyOn(Klass, 'loadScript')
      Klass.config = stub().returns('Interface')

    it "sets @initialized", ->
      Klass.init(foo: 'bar')
      expect( Klass.interface ).to.eql({})

    it "triggers the configure event", ->
      spyOn(Klass, 'trigger')
      Klass.init()
      expect( Klass.trigger ).calledWith('configure')

    it "instantiated the interface that's configured", ->
      Klass.init(foo: 'bar')
      expect( Klass.Interface ).calledWith(foo: 'bar')

    it "calls #loadScript", ->
      Klass.init()
      expect( Klass.loadScript ).called

    it "does nothing if already initialized", ->
      Klass.interface = {}
      Klass.init()
      expect( Klass.Interface ).not.called


  describe ".load", ->

    it "sets @loadedJSON to the passed argument", ->
      Klass.load()
      expect( Klass.loadedJSON ).to.be.undefined
      Klass.load(foo: 'bar')
      expect( Klass.loadedJSON ).to.eql(foo: 'bar')

    it "calls load on the interface if we have one", ->
      Klass.interface = load: spy()
      Klass.load(foo: 'bar')
      expect( Klass.interface.load ).calledWith(foo: 'bar')


  describe ".loadUrl", ->

    beforeEach ->
      @server = sinon.fakeServer.create()
      @server.respondWith('GET', '/foo/bar/baz', [200, {'Content-Type': 'application/json'}, '{"foo": "bar"}'])

    it "makes an ajax request for the json data", ->
      spyOn($, 'ajax')
      Klass.loadUrl('/foo/bar/baz')
      expect( $.ajax ).calledWith('/foo/bar/baz', async: false, type: 'get', dataType: 'json', success: sinon.match.func)

    it "call #load with the parsed json", ->
      spyOn(Klass, 'load')
      Klass.loadUrl('/foo/bar/baz')
      expect( Klass.load ).calledWith(foo: 'bar')


  describe ".loadScript", ->

    beforeEach ->
      spyOn(Klass, 'load')

    it "calls #load with the json within a json/mercury script", ->
      spyOn(window, '$', -> text: -> '{"foo": "bar"}')
      Klass.loadScript()
      expect( $ ).calledWith('script[type="json/mercury"]')
      expect( Klass.load ).calledWith(foo: "bar")

    it "calls #load with null if there was no json/mercury script found", ->
      Klass.loadScript()
      expect( Klass.load ).calledWith(null)


  describe ".release", ->

    beforeEach ->
      @interface = release: spy()
      Klass.interface = @interface

    it "triggers the released event", ->
      spyOn(Klass, 'trigger')
      Klass.release()
      expect( Klass.trigger ).calledWith('released')

    it "calls release on the interface", ->
      Klass.release()
      expect( @interface.release ).called

    it "deletes the reference to @interface", ->
      Klass.release()
      expect( Klass.interface ).to.be.undefined

    it "calls .off", ->
      spyOn(Klass, 'off')
      Klass.release()
      expect( Klass.off ).called

    it "does nothing if there's no interface", ->
      Klass.interface = false
      Klass.release()
      expect( @interface.release ).not.called


  describe ".configure", ->

    beforeEach ->
      Klass.one = stub()
      Klass.trigger = stub()
      Klass.configuration = {}
      Klass.Config.set = stub()

    describe "after configuration has been loaded", ->

      it "triggers the configure event", ->
        Klass.configure('foo:bar', foo: 'bar')
        expect( Klass.trigger ).calledWith('configure')

      it "calls @Config.set", ->
        Klass.configure('foo:bar', foo: 'bar')
        expect( Klass.Config.set ).calledWith('foo:bar', foo: 'bar')

    describe "before configuration has been loaded", ->

      beforeEach ->
        Klass.configuration = null

      it "binds to the configure method so it can be configured later", ->
        Klass.configure('foo:bar', foo: 'bar')
        expect( Klass.one ).calledWith('configure', sinon.match.func)

      it "calls @Config.set", ->
        Klass.one.yieldsOn(Klass)
        Klass.configure('foo:bar', foo: 'bar')
        expect( Klass.Config.set ).calledWith('foo:bar', true, foo: 'bar')


  describe "method -> event proxies", ->

    beforeEach ->
      spyOn(Klass, 'trigger')

    describe ".focus", ->

      it "triggers a focus event", ->
        Klass.focus()
        expect( Klass.trigger ).calledWith('focus')

    describe ".blur", ->

      it "triggers a blur event", ->
        Klass.blur()
        expect( Klass.trigger ).calledWith('blur')

    describe ".save", ->

      it "triggers a save event", ->
        Klass.save()
        expect( Klass.trigger ).calledWith('save')

    describe ".initialize", ->

      it "triggers a initialize event", ->
        Klass.initialize()
        expect( Klass.trigger ).calledWith('initialize')

    describe ".reinitialize", ->

      it "triggers a reinitialize event", ->
        Klass.reinitialize()
        expect( Klass.trigger ).calledWith('reinitialize')

    describe ".toggle", ->

      it "triggers a interface:toggle event", ->
        Klass.toggle()
        expect( Klass.trigger ).calledWith('interface:toggle')

    describe ".show", ->

      it "triggers a interface:show event", ->
        Klass.show()
        expect( Klass.trigger ).calledWith('interface:show')

    describe ".hide", ->

      it "triggers a interface:hide event", ->
        Klass.hide()
        expect( Klass.trigger ).calledWith('interface:hide')
