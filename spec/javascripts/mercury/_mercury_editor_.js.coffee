require '/assets/mercury/mercury_editor.js'

describe "MercuryEditor", ->

  template 'mercury/mercury_editor.html'

  describe "constructor", ->

    it "throws an error if it's not supported", ->
    it "throws an error if it's already instantiated", ->
    it "sets the mercuryInstance to window", ->
    it "gets the save url out of the options", ->
    it "calls initializeInterface", ->
    it "gets the csrf token if there's one available", ->


  describe "#initializeInterface", ->

    it "builds a focusable element (so we can get focus off the iframe)", ->
    it "builds an iframe and appends it to the body", ->
    it "instantiates the toolbar", ->
    it "instantiates the statusbar", ->


  describe "#initializeFrame", ->

    it "does nothing if the iframe is already loaded", ->
    it "tells the iframe that it's loaded", ->
    it "gets the document from the iframe", ->
    it "calls bindEvents", ->
    it "calls initializeRegions", ->
    it "calls finalizeInterface", ->
    it "shows the iframe", ->
    it "captures errors and alerts them", ->


  describe "#initializeRegions", ->

    it "it calls buildRegion for all the regions found in a document", ->
    it "focuses the first region", ->


  describe "#buildRegion", ->

    it "expects an element", ->
    it "gets the type of region from the data attribute", ->
    it "instantiates the region", ->
    it "pushes into the regions array", ->
    it "alerts on errors", ->


  describe "#finalizeInterface", ->

    it "it builds a snippetToolbar", ->
    it "hijacks the links", ->
    it "calls resize", ->


  describe "observed events", ->

    describe "custom event: initialize:frame", ->
    describe "custom event: focus:frame", ->
    describe "custom event: focus:window", ->
    describe "custom event: action", ->
    describe "mousedown on document", ->
    describe "window resize", ->
    describe "onbeforeunload", ->


  describe "#resize", ->

    it "sets the display rectangle to displayRect", ->
    it "resizes the iframe", ->
    it "triggers a resize event", ->


  describe "#iframeSrc", ->

    it "takes the location and removes the /edit", ->


  describe "#save", ->

    it "uses the save url passed in via options, or the iframe src", ->
    it "serializes the data in json", ->
    it "can serialize as form values", ->
    it "makes an ajax request", ->

    describe "on successful ajax request", ->

      it "sets changes back to false", ->

    describe "on failed ajax request", ->

      it "alerts with the url", ->


  describe "#serialize", ->

    it "calls serialize on all it's regions", ->
    it "returns an object with the region name, and it's serialized value", ->



describe "Mercury Static Methods", ->

  describe ".supported", ->

    it "knows if the browser is supported or not", ->


  describe "#beforeUnload", ->

    it "returns a message if changes were made", ->
    it "does nothing if in silent mode", ->


  describe "#hijackLinks", ->

    it "expects a document", ->
    it "finds all links that aren't in regions and set their target to top if it's not already set"


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

    beforeEach ->

    it "does nothing if debug mode isn't on", ->
    it "does nothing if there's no console", ->
    it "tries to call console.debug", ->