#= require spec_helper
#= require mercury/core/events

describe "Mercury.Events", ->

  Klass = ->
  subject = null

  beforeEach ->
    Klass.prototype = Mercury.Events
    @handler1 = stub()
    @handler2 = stub()
    @handler3 = stub().returns(false)
    subject = new Klass()
    subject.__handlers__ =
      event1: [@handler1, @handler2]
      event2: [@handler3, @handler1]

  describe "#on", ->

    beforeEach ->
      subject.__handlers__ = null

    it "keeps track of the events/handlers", ->
      subject.on('event', @handler1)
      handlers = subject.__handlers__
      expect( handlers ).to.include.keys('event')
      expect( handlers['event'][0] ).to.eq(@handler1)

    it "allows for multiple event assignment", ->
      subject.on('event1 event2', @handler1)
      handlers = subject.__handlers__
      expect( handlers ).to.include.keys('event1')
      expect( handlers ).to.include.keys('event2')
      expect( handlers['event1'][0] ).to.eq(@handler1)

    it "returns itself for chaining", ->
      expect( subject.on('foo') ).to.eq(subject)


  describe "#one", ->

    it "calls #on", ->
      spyOn(subject, 'on')
      subject.one('event1 event2', @handler1)
      expect( subject.on ).calledWith('event1 event2')

    it "calls the handler and removes it after being triggered once", ->
      spyOn(subject, 'off')
      subject.one('event1', @handler1)
      subject.trigger('event1', 1, 2)
      expect( @handler1 ).calledWith(1, 2)
      expect( subject.off ).calledWith('event1')

    it "returns itself for chaining", ->
      expect( subject.on('foo') ).to.eq(subject)


  describe "#off", ->

    it "returns itself for chaining", ->
      expect( subject.off() ).to.eq(subject)

    describe "with no event", ->

      it "clears all events", ->
        subject.off()
        expect( subject.__handlers__ ).to.be.empty

    describe "with an event that we don't know about", ->

      it "doesn't remove anything from the handlers", ->
        subject.off('foo')
        expect( subject.__handlers__ ).to.not.be.empty

    describe "without a handler", ->

      it "removes all handlers for that event", ->
        subject.off('event1')
        handlers = subject.__handlers__
        expect( handlers['event1'] ).to.be.undefined

    describe "with an event and a handler", ->

      it "removes the handler from the event array", ->
        subject.off('event1', @handler1)
        handlers = subject.__handlers__
        expect( handlers['event1'] ).to.have.length(1)

    describe "with a handler that's not been registered", ->

      it "doesn't remove it since it's not there", ->
        subject.off('event1', ->)
        handlers = subject.__handlers__
        expect( handlers['event1'] ).to.have.length(2)


  describe "#trigger", ->

    it "logs the event and args", ->
      subject.log = ->
      spyOn(subject, 'log')
      subject.trigger('foo', 1, 2)
      expect( subject.log ).calledWith('foo', [1, 2])

    it "calls the handlers for the event", ->
      result = subject.trigger('event1', 1, 2)
      expect( @handler1 ).calledWith(1, 2)
      expect( @handler2 ).calledWith(1, 2)
      expect( result ).to.be.true

    it "allows stopping propagation by returning false from a handler", ->
      result = subject.trigger('event2', 1, 2)
      @handler1.returns(false)
      expect( @handler3 ).calledWith(1, 2)
      expect( @handler1 ).not.called
      expect( result ).to.be.true

    it "does nothing if the event is in the handlers", ->
      result = subject.trigger('foo', 1, 2)
      expect( @handler1 ).not.called
      expect( @handler2 ).not.called
      expect( result ).to.be.false
