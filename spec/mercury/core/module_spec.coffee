#= require spec_helper
#= require mercury/core/module

describe "Mercury.Module", ->

  Klass = ->
  subject = null

  beforeEach ->
    class Klass extends Mercury.Module
    subject = Klass

  describe ".extend", ->

    it "throws if the argument wasn't an object", ->
      expect(-> subject.extend() ).to.throw(Error, 'extend expects an object')

    it "adds properties to itself from the object", ->
      subject.extend(foo: 'foo')
      expect( subject.foo ).to.eq('foo')

    it "excludes properties that are module keywords", ->
      subject.extend
        foo: 'foo'
        included: ->
        extended: ->
        'private': ->
      expect( subject.foo ).to.eq('foo')
      expect( subject.included ).to.be.undefined
      expect( subject.extended ).to.be.undefined
      expect( subject['private'] ).to.be.undefined

    it "calls extended if it exists", ->
      obj = extended: spy()
      subject.extend(obj)
      expect( obj.extended ).called


  describe ".include", ->

    it "throws if the argument wasn't an object", ->
      expect(-> subject.include() ).to.throw(Error, 'include expects an object')

    it "adds properties to its prototype from the object", ->
      subject.include(foo: 'foo')
      expect( subject::foo ).to.eq('foo')

    it "excludes properties that are module keywords", ->
      subject.include
          foo: 'foo'
          included: ->
          extended: ->
          'private': ->
      expect( subject::foo ).to.eq('foo')
      expect( subject::included ).to.be.undefined
      expect( subject::extended ).to.be.undefined
      expect( subject::['private'] ).to.be.undefined

    it "calls included if it exists", ->
      obj = included: spy()
      subject.include(obj)
      expect( obj.included ).called


  describe ".mixin", ->

    it "calls .include with the object, and .extend with object.klass", ->
      spyOn(subject, 'extend')
      spyOn(subject, 'include')
      subject.mixin(klass: {foo: 'bar'}, bar: 'foo')
      expect( subject.extend ).calledWith(foo: 'bar')
      expect( subject.include ).calledWith(bar: 'foo')



  describe ".proxy", ->

    it "calls the function", ->
      func = spy()
      subject.proxy(func)(1, 2, 3)
      expect( func ).calledWith(1, 2, 3)


  describe "#constructor", ->

    it "calls init if it's set", ->
      subject::init = spy()
      new subject(1, 2, 3)
      expect( subject::init ).calledWith(1, 2, 3)

    it "duplicates the event handlers", ->
      subject::__handlers__ = foo: 'bar'
      spyOn($, 'extend')
      new subject()
      expect( $.extend ).calledWith(true, {}, subject::__handlers__)

    it "doesn't call init if it's not a function", ->
      subject::init = 'foo'
      new subject(1, 2, 3)

    it "triggers an init event if it can", ->
      subject::trigger = spy()
      new subject()
      expect( subject::trigger ).calledWith('init')


  describe "#proxy", ->

    beforeEach ->
      subject = new subject()

    it "calls the function", ->
      func = spy()
      subject.proxy(func)(1, 2, 3)
      expect( func ).calledWith(1, 2, 3)
