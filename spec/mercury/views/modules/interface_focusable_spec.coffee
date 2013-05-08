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
        on: spy()
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
      $.fn.is.restore()
      spyOn($.fn, 'is', -> true)
      subject.handleFocusableEvent(@e)
      expect( $.fn.is ).calledWith('foo')


  describe "#revertInterfaceFocus", ->

    it "triggers a global focus event in a delay", ->
      spyOn(Mercury, 'trigger')
      spyOn(subject, 'delay').yieldsOn(subject)
      subject.revertInterfaceFocus()
      expect( subject.delay ).calledWith(1, sinon.match.func)
      expect( Mercury.trigger ).calledWith('focus')


  describe "#preventFocusOut", ->

    beforeEach ->
      @el =
        off: spy(=> @el)
        on: spy(=> @el)

    it "binds to the release and hide events", ->
      spyOn(subject, 'clearFocusoutTimeout')
      spyOn(subject, 'on').yieldsOn(subject)
      subject.preventFocusout(@el)
      expect( subject.on ).calledWith('release', sinon.match.func)
      expect( subject.on ).calledWith('hide', sinon.match.func)
      expect( subject.clearFocusoutTimeout ).calledTwice

    it "binds to the focusout and keydown events", ->
      subject.preventFocusout(@el, ->)
      expect( @el.off ).calledWith('focusout')
      expect( @el.on ).calledWith('focusout', sinon.match.func)
      expect( @el.on ).calledWith('keydown')

    describe "focusout", ->

      beforeEach ->
        @el.on = spy(-> arguments[1]() if arguments[0] == 'focusout')
        @handler = spy()
        spyOn(subject, 'delay').yieldsOn(subject)
        spyOn(subject, '_activeElementIsBody', -> false)

      it "calls the handler if it's provided on focusout if the newly focused element isn't within it", ->
        spyOn($, 'contains', -> false)
        subject.preventFocusout(@el, @handler)
        expect( subject.delay ).calledWith(150, sinon.match.func)
        expect( @handler ).called

      it "doesn't call the handler if the focusable is within the element", ->
        spyOn($, 'contains', -> true)
        subject.preventFocusout(@el, @handler)
        expect( subject.delay ).calledWith(150, sinon.match.func)
        expect( @handler ).not.called

      it "doesn't call the handler if the focusable is the body", ->
        subject._activeElementIsBody.restore()
        spyOn($, 'contains', -> false)
        subject.preventFocusout(@el, @handler)
        expect( subject.delay ).calledWith(150, sinon.match.func)
        expect( @handler ).not.called


    describe "keydown", ->

      beforeEach ->
        spyOn(subject, 'prevent')
        @el.on = spy(=> arguments[1](@e) if arguments[0] == 'keydown')
        @el.find = spy(=> @focusables)
        @focusables = ['_first_', '_second_', '_last_']
        @e =
          keyCode: 9
          target: '_first_'
          shiftKey: false

      it "does nothing it's not a tab", ->
        @e.keyCode = 0
        subject.preventFocusout(@el)
        expect( @el.find ).not.called

      it "doesn't continue if there's no focusables", ->
        @focusables = []
        subject.preventFocusout(@el)
        expect( @el.find ).calledWith(':input[tabindex != "-1"]')
        expect( subject.prevent ).not.called

      it "prevents the event if we're at the first focusable and using the shift key (going backwards)", ->
        @e.shiftKey = true
        subject.preventFocusout(@el)
        expect( subject.prevent ).calledWith(@e, true)

      it "prevents the event if we're at the last focusable and not using the shift key (going forwards)", ->
        @e.target = '_last_'
        subject.preventFocusout(@el)
        expect( subject.prevent ).calledWith(@e, true)

      it "doesn't prevent if it shouldn't", ->
        @e.target = '_second_'
        subject.preventFocusout(@el)
        expect( subject.prevent ).not.called


  describe "#clearFocusoutTimeout", ->

    it "clears the @preventFocusoutTimeout", ->
      spyOn(window, 'clearTimeout')
      subject.preventFocusoutTimeout = '_prevent_focusout_timeout_'
      subject.clearFocusoutTimeout()
      expect( clearTimeout ).calledWith('_prevent_focusout_timeout_')
