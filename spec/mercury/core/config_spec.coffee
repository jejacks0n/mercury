#= require spec_helper
#= require mercury/core/config

describe "Mercury.Config", ->

  Klass = ->
  subject = null

  beforeEach ->
    Klass.prototype = Mercury.Config.Module
    subject = Mercury.Config

  describe ".get", ->

    beforeEach ->
      subject.configuration =
        foo: 'bar'
        bar:
          prop1: '_value1_'
          prop2: '_value2_'

    it "returns the @configuration if not path was provided", ->
      expect( subject.get() ).to.eq(subject.configuration)

    it "returns the expected value from @configuration", ->
      expect( subject.get('foo') ).to.eq('bar')

    it "traverses the provided path to find the right value", ->
      expect( subject.get('bar:prop1') ).to.eq('_value1_')

    it "returns undefined for properties that aren't found", ->
      expect( subject.get('foo:bar') ).to.be.undefined

    it "falls back (to Mercury.configuration / empty object)", ->
      Mercury.configuration = null
      subject.configuration = null
      expect( subject.get('foo') ).to.be.undefined


  describe ".set", ->

    beforeEach ->
      subject.configuration = null

    it "sets the configuration hash (if path wasn't provided)", ->
      expect( subject.set(foo: 'bar') ).to.eql(foo: 'bar')
      expect( subject.configuration ).to.eql(foo: 'bar')

    it "creates and sets the value of the provided path", ->
      expect( subject.set('foo:bar', a: 1) ).to.eql(a: 1)
      expect( subject.configuration.foo.bar ).to.eql(a: 1)

    it "updates the value of the provided path", ->
      subject.configuration = foo: {bar: '_old_value_'}
      expect( subject.set('foo:bar', '_new_value_') ).to.eq('_new_value_')
      expect( subject.configuration.foo.bar ).to.eq('_new_value_')

    it "falls back (to Mercury.configuration / empty object)", ->
      Mercury.configuration = null
      subject.configuration = null
      expect( subject.set('foo:bar', '_new_value_') ).to.eq('_new_value_')
      expect( Mercury.configuration.foo.bar ).to.eq('_new_value_')


  describe "Module", ->

    beforeEach ->
      subject = new Klass()
      subject.configuration =
        foo: 'bar'
        bar:
          prop1: '_value1_'
          prop2: '_value2_'

    describe "#config", ->

      it "returns the expected value from @configuration", ->
        expect( subject.config('foo') ).to.eq('bar')

      it "traverses the provided path to find the right value", ->
        expect( subject.config('bar:prop1') ).to.eq('_value1_')

      it "returns undefined for properties that aren't found", ->
        expect( subject.config('foo:bar') ).to.be.undefined
