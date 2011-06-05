require '/assets/mercury/mercury_editor.js'

describe "Mercury.Snippet", ->

  describe "constructor", ->

    it "expects name, identity, and options", ->
    it "sets the version", ->
    it "creates a history buffer", ->
    it "calls setOptions", ->


  describe "#getHTML", ->

    it "expects context (so it can create elements)", ->
    it "accepts a callback method (for loadPreview)", ->
    it "builds an element", ->
    it "sets the default content to the identity", ->
    it "calls loadPreview", ->


  describe "#getText", ->

    it "returns an identity string", ->


  describe "#loadPreview", ->

    it "expects an element", ->
    it "accepts a callback method", ->
    it "makes an ajax request", ->

    describe "ajax success", ->

      it "sets the data", ->
      it "puts the data into the element", ->
      it "calls the callback", ->

    describe "ajax failure", ->

      it "alerts the error", ->


  describe "#displayOptions", ->

    it "sets the global snippet to itself", ->
    it "opens a modal", ->


  describe "#setOptions", ->

    it "expects options", ->
    it "removes rails form default options that aren't for storing", ->
    it "increases the version", ->
    it "pushes the options to the history buffer", ->


  describe "#setVersion", ->

    it "accepts a version (can be a string)", ->
    it "sets the version", ->
    it "pulls the version out of the history buffer", ->
    it "returns true if successful", ->
    it "returns false if not successful", ->


  describe "#serialize", ->

    it "returns an object with name and options", ->



describe "Mercury.Snippet class methods", ->

  describe ".displayOptionsFor", ->

    it "expects name", ->
    it "opens a modal", ->
    it "sets the snippet back to nothing", ->


  describe ".create", ->

    it "expects name and options", ->
    it "creates a new instance of Mercury.Snippet", ->
    it "pushes into the collection array", ->
    it "returns the instance", ->


  describe ".find", ->

    it "finds a snippet by identity", ->
    it "returns null if no snippet was found", ->


  describe ".load", ->

    it "it expects an object of snippets", ->
    it "creates a new instance for each item in the collection", ->
    it "adds each instance into the collection", ->

