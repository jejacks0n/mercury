#= require spec_helper
#= require mercury/core/action

describe "Mercury.Action", ->

  Klass = ->
  subject = null

  beforeEach ->
    class @Model
    class Klass extends Mercury.Action
    subject = new Klass('unknown', foo: 'bar')

  describe ".create", ->

    describe "when plain object", ->

      beforeEach ->
        Mercury.Action.Foo = null

      it "instantiates a matching action", ->
        Mercury.Action.Foo = spy()
        Klass.create('foo', bar: 'baz')
        expect( Mercury.Action.Foo ).calledWith(bar: 'baz')
        Klass.create('foo')
        expect( Mercury.Action.Foo ).calledWith({})


      it "falls back to the base action", ->
        spyOn(Mercury, 'Action')
        Klass.create('foo', bar: 'baz')
        expect( Mercury.Action ).calledWith('foo', bar: 'baz')

    describe "model instance", ->

      it "returns the model", ->
        model = new @Model()
        expect( Klass.create('foo', model) ).to.eq(model)


  describe "#constructor", ->

    it "assigns @name and @attributes", ->
      subject = new Klass('foo', bar: 'baz')
      expect( subject.name ).to.eq('foo')
      expect( subject.attributes ).to.eql(bar: 'baz')

    it "calls super", ->
      spyOn(Klass.__super__, 'constructor')
      subject = new Klass()
      expect( Klass.__super__.constructor ).called


  describe "#get", ->

    it "returns the value from the attributes", ->
      expect( subject.get('foo') ).to.eq('bar')


  describe "#set", ->

    beforeEach ->
      subject.attributes = {foo: 'bar'}

    it "sets the attributes", ->
      subject.set('foo', 'baz')
      expect( subject.attributes.foo ).to.eq('baz')

    it "allows passing an object instead of key/value", ->
      subject.set(foo: 'baz')
      expect( subject.attributes.foo ).to.eq('baz')
