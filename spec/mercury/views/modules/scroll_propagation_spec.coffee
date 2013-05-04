#= require spec_helper
#= require mercury/core/view
#= require mercury/views/modules/scroll_propagation

describe "Mercury.View.Modules.ScrollPropagation", ->

  Klass = null
  Module = Mercury.View.Modules.ScrollPropagation
  subject = null

  beforeEach ->
    class Klass extends Mercury.View
      @include Module
    subject = new Klass()
    @el =
      on: ->
      scrollTop: -> 42
      get: -> scrollHeight: 200
      height: -> 100


  describe "#preventScrollPropagation", ->

    it "binds to the mousewheel/DOMMouseScroll events", ->
      spyOn(@el, 'on')
      subject.preventScrollPropagation(@el)
      expect( @el.on ).calledWith('mousewheel DOMMouseScroll', sinon.match.func)

    describe "callback", ->

      beforeEach ->
        @callback = null
        spyOn(@el, 'on', => @callback = arguments[1])
        subject.preventScrollPropagation(@el)

      it "returns false when we can't scroll up anymore", ->
        spyOn(@el, 'scrollTop', -> 0)
        expect( @callback(originalEvent: wheelDelta: 1) ).to.be.false
        expect( @callback(originalEvent: detail: -1) ).to.be.false

      it "returns false when we can't scroll down anymore", ->
        spyOn(@el, 'scrollTop', -> 100)
        expect( @callback(originalEvent: wheelDelta: -1) ).to.be.false
        expect( @callback(originalEvent: detail: 1) ).to.be.false

      it "returns true when we can scroll", ->
        spyOn(@el, 'scrollTop', -> 10)
        expect( @callback(originalEvent: wheelDelta: -1) ).to.be.true
        expect( @callback(originalEvent: detail: 1) ).to.be.true
