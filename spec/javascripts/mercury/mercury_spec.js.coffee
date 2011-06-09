require '/assets/mercury/mercury.js'

describe "Mercury", ->

  describe "supported:", ->

    # this is here for documentation -- unable to test, because this is evaluated on script load
    it "checks document.getElementById", ->
    it "checks document.designMode", ->
    it "disallows konqueror and msie", ->

  describe "#beforeUnload", ->

    beforeEach ->
      Mercury.silent = false
      Mercury.changes = true

    it "returns a message if changes were made", ->
      expect(Mercury.beforeUnload()).toEqual('You have unsaved changes.  Are you sure you want to leave without saving them first?')

      Mercury.changes = false
      expect(Mercury.beforeUnload()).toEqual(null)

    it "does nothing if in silent mode", ->
      Mercury.silent = true
      expect(Mercury.beforeUnload()).toEqual(null)


  describe "#refresh", ->

    it "triggers an event telling everyone to refresh themselves", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      Mercury.refresh()
      expect(spy.callCount).toEqual(1)


  describe "#bind", ->

    it "binds an event prefixed with 'mercury:' to document", ->
      callCount = 0
      Mercury.bind('test', -> callCount += 1)
      $(document).trigger("mercury:test")
      expect(callCount).toEqual(1)


  describe "#trigger", ->

    it "triggers an event prefixed with 'mercury:' on document", ->
      argsForCall = []
      callCount = 0
      Mercury.bind('test', -> argsForCall[callCount] = arguments; callCount += 1)
      Mercury.trigger("test", {foo: 'bar'})
      expect(callCount).toEqual(1)
      expect(argsForCall[0][1]).toEqual({foo: 'bar'})


  describe "#log", ->

    beforeEach ->
      window.console = {debug: -> ''}
      @debugSpy = spyOn(window.console, 'debug').andCallFake(=>)
      Mercury.debug = true

    it "calls console.debug", ->
      Mercury.log(1, 2)
      expect(@debugSpy.callCount).toEqual(1)

    it "does nothing if debug mode isn't on", ->
      Mercury.debug = false
      Mercury.log(1, 2)
      expect(@debugSpy.callCount).toEqual(0)

    it "does nothing if there's no console", ->
      window.console = null
      Mercury.log(1, 2)
      expect(@debugSpy.callCount).toEqual(0)
