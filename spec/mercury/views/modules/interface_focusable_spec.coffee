#= require spec_helper
#= require mercury/core/view
#= require mercury/views/modules/interface_focusable

describe "Mercury.View.Modules.InterfaceFocusable", ->

  Klass = null
  Module = Mercury.View.Modules.InterfaceFocusable
  subject = null

  beforeEach ->
    class Klass extends Mercury.View
      @include Module
    subject = new Klass()

  describe "#included", ->

    beforeEach ->
      @mock =
        on: spy(),
        buildInterfaceFocusable: ->

    it "binds to the build event", ->
      Module.included.call(@mock)
      expect( @mock.on ).calledWith('build', @mock.buildInterfaceFocusable)


  describe "#buildInterfaceFocusable", ->

    beforeEach ->
      subject.revertFocusOn = 'foo, bar'

    it "does nothing if we aren't reverting focus", ->
      subject.revertFocusOn = false
      expect( subject.buildInterfaceFocusable() ).to.be.undefined

    it "calls #delegateEvents", ->
      spyOn(subject, 'delegateEvents')
      subject.buildInterfaceFocusable()
      expect( subject.delegateEvents ).calledWith
        mousedown: 'handleFocusableEvent'
        mouseup: 'handleFocusableEvent'
        click: 'handleFocusableEvent'

    it "calls #delegateRevertedFocus", ->
      spyOn(subject, 'delegateRevertedFocus')
      subject.buildInterfaceFocusable()
      expect( subject.delegateRevertedFocus ).calledWith('foo, bar')


  describe "#delegateRevertedFocus", ->

    beforeEach ->
      spyOn(subject, 'delegateEvents')

    it "adds a mousedown and click event for the matcher provided", ->
      subject.delegateRevertedFocus('_matcher_')
      expect( subject.delegateEvents ).calledWith
        'mousedown _matcher_': 'revertInterfaceFocus'
        'click _matcher_': 'revertInterfaceFocus'


  describe "#handleFocusableEvent", ->

    beforeEach ->
      @e =
        target: '<div>'
        preventDefault: spy()
        stopPropagation: spy()

    it "stops propagation of the event", ->
      subject.handleFocusableEvent(@e)
      expect( @e.stopPropagation ).called

    it "prevents the event if the target is in the focusableSelector, or falls back to the default", ->
      spyOn($.fn, 'is', -> false)
      subject.handleFocusableEvent(@e)
      expect( @e.preventDefault ).called
      expect( $.fn.is ).calledWith(':input, [tabindex]')
      subject.focusableSelector = 'foo'
      subject.handleFocusableEvent(@e)
      expect( $.fn.is ).calledWith('foo')


  describe "#revertInterfaceFocus", ->

    it "triggers a global focus event in a delay", ->
      spyOn(Mercury, 'trigger')
      spyOn(subject, 'delay').yieldsOn(subject)
      subject.revertInterfaceFocus()
      expect( subject.delay ).calledWith(1, sinon.match.func)
      expect( Mercury.trigger ).calledWith('focus')
