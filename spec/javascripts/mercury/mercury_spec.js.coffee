describe "Mercury", ->

  describe ".supported", ->

    it "knows if the browser is supported or not", ->


  describe "#beforeUnload", ->

    it "returns a message if changes were made", ->
    it "does nothing if in silent mode", ->


  describe "#refresh", ->

    it "triggers an event telling everyone to refresh themselves", ->


  describe "#bind", ->

    it "expects an event name, and callback", ->
    it "binds an event prefixed with 'mercury:' to document", ->


  describe "#trigger", ->

    it "expects an eventname", ->
    it "accepts additional arguments", ->
    it "triggers an event prefixed with 'mercury:' on document", ->


  describe "#log", ->

    it "does nothing if debug mode isn't on", ->
    it "does nothing if there's no console", ->
    it "tries to call console.debug", ->