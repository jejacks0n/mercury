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

    it "throws an exception by default", ->
      expect(-> subject.notify('_message_') ).to.throw(Error, 'Mercury: _message_')

    it "uses the prefix", ->
      subject.logPrefix = 'Foo:'
      expect(-> subject.notify('_message_') ).to.throw(Error, 'Foo: _message_')
      subject.logPrefix = null
      expect(-> subject.notify('_message_') ).to.throw(Error, '_message_')

    it "calls console.error with the expected message", ->
      Mercury.configure 'logging:notifier', 'console'
      subject.notify('_message_')
      expect( console.error ).calledWith('Mercury: _message_')

    it "calls console.error with the expected message", ->
      Mercury.configure 'logging:notifier', 'alert'
      spyOn(window, 'alert')
      subject.notify('_message_')
      expect( alert ).calledWith('Mercury: _message_')
