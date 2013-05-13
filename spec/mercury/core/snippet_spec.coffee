#= require spec_helper
#= require mercury/core/snippet

describe "Mercury.Snippet", ->

  Klass = ->
  Module = Mercury.Snippet.Module
  subject = null

  beforeEach ->
    class Klass extends Mercury.Snippet
    subject = new Klass(name: 'name')

  describe "Modules", ->

    it "includes in the expected modules", ->
      expect( Klass.t ).to.be.a('Function')


  describe ".register", ->

    it "instantiates and returns the snippet definition it instantiated", ->
      spyOn(Mercury.Snippet, 'Definition', -> definition: '_definition_')
      expect( Klass.register('foo', foo: 'bar') ).to.eql(definition: '_definition_')
      expect( Mercury.Snippet.Definition ).calledWith(name: 'foo', foo: 'bar')


  describe ".get", ->

    beforeEach ->
      @definition = Klass.register('foo', foo: 'bar')

    it "returns the registered snippet definition by name", ->
      expect( Klass.get('foo') ).to.eql(@definition)

    it "returns a new snippet instance from the definition if asked", ->
      spyOn(Mercury, 'Snippet', -> snippet: '_snippet_')
      expect( Klass.get('foo', true) ).to.eql(snippet: '_snippet_')
      expect( Mercury.Snippet ).calledWith(name: 'foo', foo: 'bar')

    it "throws an error if there's no snippet with that name", ->
      expect(-> Klass.get('bar') ).to.throw('unable to locate the bar snippet')


  describe ".all", ->

    beforeEach ->
      @definition = Klass.register('foo', foo: 'bar')

    it "returns all the registered snippet definitions", ->
      expect( Klass.all()['foo'] ).to.eql(@definition)


  describe ".unregister", ->

    beforeEach ->
      @definition = Klass.register('foo', foo: 'bar')

    it "removes the definition from the list of registered snippet definitions", ->
      Klass.unregister('foo')
      expect( Klass.all()['foo'] ).to.be.undefined

    it "throws an error if there's no snippet with that name", ->
      expect(-> Klass.unregister('bar') ).to.throw('unable to locate the bar snippet')
