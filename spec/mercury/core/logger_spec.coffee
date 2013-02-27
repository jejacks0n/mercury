#= require spec_helper
#= require mercury/core/logger

describe "Mercury.Logger", ->

  Klass = ->
  subject = null

  beforeEach ->
    Mercury.configure 'logging:enabled', true
    Klass.prototype = Mercury.Logger
    subject = new Klass()
    spyOn(console, 'debug')
    spyOn(console, 'error')
    spyOn(console, 'trace')

  describe "#log", ->

    it "calls console.debug with the expected args", ->
      subject.log(1, 2, '3')
      expect( console.debug ).calledWith('Mercury:', 1, 2, '3')

    it "uses the prefix", ->
      subject.logPrefix = 'Foo:'
      subject.log(1, 2, '3')
      expect( console.debug ).calledWith('Foo:', 1, 2, '3')
      subject.logPrefix = null
      subject.log(1, 2, '3')
      expect( console.debug ).calledWith(1, 2, '3')

    it "doesn't log if logging is disabled in configuration", ->
      Mercury.configure 'logging:enabled', false
      subject.log(1, 2, '3')
      expect( console.debug ).not.called

    it "doesn't error if there's no console.log", ->
      original = console.debug
      console.debug = undefined
      subject.log(1, 2, '3')
      console.debug = original


  describe "#notify", ->

    it "calls console.error with the expected message", ->
      subject.notify('_message_')
      expect( console.error ).calledWith('Mercury: _message_')

    it "uses the prefix", ->
      subject.logPrefix = 'Foo:'
      subject.notify('_message_')
      expect( console.error ).calledWith('Foo: _message_')
      subject.logPrefix = null
      subject.notify('_message_')
      expect( console.error ).calledWith('_message_')

    it "calls console.trace if it's available", ->
      subject.notify('_message_')
      expect( console.trace ).called

    describe "with fallback strategies", ->

      beforeEach ->
        @original = console.error
        console.error = undefined

      afterEach ->
        console.error = @original

      it "throws an exception if there's no console.error", ->
        Mercury.configure 'logging:notifier', 'error'
        expect(-> subject.notify('_message_') ).to.throw(Error, 'Mercury: _message_')

      it "alerts if there's no console.error", ->
        Mercury.configure 'logging:notifier', 'alert'
        spyOn(window, 'alert')
        subject.notify('_message_')
        expect( window.alert ).calledWith('Mercury: _message_')

      it "does neither if configured", ->
        Mercury.configure 'logging:notifier', false
        spyOn(window, 'alert')
        subject.notify('_message_')
        expect( window.alert ).not.called
