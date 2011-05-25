require '/assets/mercury/mercury_editor.js'

describe "Mercury.Region", ->

  template 'mercury/region.html'

  afterEach ->
    @region = null
    delete(@region)
    $(document).unbind('mercury:mode')
    $(document).unbind('mercury:focus:frame')
    $(document).unbind('mercury:action')

  describe "constructor", ->

    beforeEach ->
      @buildSpy = spyOn(Mercury.Region.prototype, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(Mercury.Region.prototype, 'bindEvents').andCallFake(=>)
      @pushHistorySpy = spyOn(Mercury.Region.prototype, 'pushHistory').andCallFake(=>)

    it "expects an element and window (for context)", ->
      @region = new Mercury.Region($('#region'), window)
      expect(@region.element.get(0)).toEqual($('#region').get(0))

    it "accepts options", ->
      @region = new Mercury.Region($('#region'), window, {foo: 'bar'})
      expect(@region.options).toEqual({foo: 'bar'})

    it "sets variables we need", ->
      @region = new Mercury.Region($('#region'), window, {foo: 'bar'})
      expect(@region.name).toEqual('region')
      expect(@region.history).toBeDefined()

    it "calls build", ->
      @region = new Mercury.Region($('#region'), window, {foo: 'bar'})
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      @region = new Mercury.Region($('#region'), window, {foo: 'bar'})
      expect(@bindEventsSpy.callCount).toEqual(1)

    it "pushes the initial state to the history buffer", ->
      @region = new Mercury.Region($('#region'), window, {foo: 'bar'})
      expect(@pushHistorySpy.callCount).toEqual(1)


  describe "#build", ->

    it "does nothing and is there as an interface"


  describe "#focus", ->

    it "does nothing and is there as an interface"


  describe "observed events", ->

    beforeEach ->
      @region = new Mercury.Region($('#region'), window)

    describe "custom event: mode", ->

      it "calls togglePreview if the mode is preview", ->
        spy = spyOn(Mercury.Region.prototype, 'togglePreview').andCallFake(=>)
        Mercury.trigger('mode', {mode: 'foo'})
        expect(spy.callCount).toEqual(0)
        Mercury.trigger('mode', {mode: 'preview'})
        expect(spy.callCount).toEqual(1)

    describe "custom event: focus:frame", ->

      beforeEach ->
        @focusSpy = spyOn(Mercury.Region.prototype, 'focus').andCallFake(=>)

      it "does nothing if in preview mode", ->
        @region.previewing = true
        Mercury.trigger('focus:frame', {region: @region})
        expect(@focusSpy.callCount).toEqual(0)

      it "does nothing if it's not active region", ->
        Mercury.region = {}
        Mercury.trigger('focus:frame', {region: @region})
        expect(@focusSpy.callCount).toEqual(0)

      it "calls focus", ->
        Mercury.region = @region
        Mercury.trigger('focus:frame', {region: @region})
        expect(@focusSpy.callCount).toEqual(1)

    describe "custom event: action", ->

      beforeEach ->
        @execCommandSpy = spyOn(Mercury.Region.prototype, 'execCommand').andCallFake(=>)

      it "does nothing if in preview mode", ->
        @region.previewing = true
        Mercury.trigger('action', {action: 'foo', value: 'bar'})
        expect(@execCommandSpy.callCount).toEqual(0)

      it "does nothing if it's not active region", ->
        Mercury.region = {}
        Mercury.trigger('action', {action: 'foo', value: 'bar'})
        expect(@execCommandSpy.callCount).toEqual(0)

      it "calls execCommand with the action and options", ->
        Mercury.region = @region
        Mercury.trigger('action', {action: 'foo', value: 'bar'})
        expect(@execCommandSpy.callCount).toEqual(1)
        expect(@execCommandSpy.argsForCall[0]).toEqual(['foo', {action: 'foo', value: 'bar'}])


  describe "#html", ->


  describe "#togglePreview", ->

    beforeEach ->
      Mercury.region = @region
      @focusSpy = spyOn(Mercury.Region.prototype, 'focus').andCallFake(=>)
      @region = new Mercury.Region($('#region'), window)

    describe "when not previewing", ->

      beforeEach ->
        @region.togglePreview()

      it "sets previewing to true", ->
        expect(@region.previewing).toEqual(true)

      it "swaps classes on the element", ->
        expect(@region.element.hasClass('mercury-region')).toEqual(false)
        expect(@region.element.hasClass('mercury-region-preview')).toEqual(true)

      it "triggers a blur event", ->

    describe "when previewing", ->

      it "sets previewing to true", ->
      it "swaps classes on the element", ->
      it "calls focus if it's the active region", ->


  describe "#execCommand", ->

    it "calls focus", ->
    it "pushes to the history (unless the action is redo)", ->
    it "tells Mercury that changes have been made", ->


  describe "#pushHistory", ->

    it "pushes the current content (html) of the region to the history buffer", ->


  describe "#snippets", ->

    it "...", ->


  describe "#serialize", ->

    it "returns an object with it's type, value, and snippets", ->
