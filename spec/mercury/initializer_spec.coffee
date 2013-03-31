#= require spec_helper
#= require mercury/initializer

describe "Mercury", ->

  Klass = MockMercury

  it "has the exepected version", ->
    expect( Klass.version ).to.eq('0.0.1alpha')

  it "extends Config and adds the .configure method", ->
    expect( Klass.Module.extend ).calledWith(Klass.Config)
    expect( Klass.configure ).to.be.a('function')

  it "extends Events", ->
    expect( Klass.Module.extend ).calledWith(Klass.Events)

  it "extends I18n", ->
    expect( Klass.Module.extend ).calledWith(Klass.I18n)

  it "extends Logger", ->
    expect( Klass.Module.extend ).calledWith(Klass.Logger)

  it "detects various browser for support purposes", ->
    expect( Klass.support ).to.have.keys(['webkit', 'gecko', 'trident', 'chrome', 'safari', 'ie10', 'wysiwyg'])

  it "defines the .init method", ->
    expect( Klass.init ).to.be.a('function')

  describe ".init", ->

    beforeEach ->
      Klass.initialized = false
      spyOn(Klass, 'Editor')
      Klass.config = stub().returns('Editor')

    it "sets @initialized", ->
      Klass.init(foo: 'bar')
      expect( Klass.initialized ).to.be.true

    it "instantiated the editor that's configured", ->
      Klass.init(foo: 'bar')
      expect( Klass.Editor ).calledWith(foo: 'bar')

    it "does nothing if already initialized", ->
      Klass.initialized = true
      Klass.init()
      expect( Klass.Editor ).not.called


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
