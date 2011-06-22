require '/assets/mercury/mercury.js'

describe "Mercury.Regions.Editable", ->

  template 'mercury/regions/editable.html'

  beforeEach ->
    @regionElement = $('#editable_region1')

  describe "constructor", ->

     beforeEach ->
       @buildSpy = spyOn(Mercury.Regions.Editable.prototype, 'build').andCallFake(=>)
       @bindEventsSpy = spyOn(Mercury.Regions.Editable.prototype, 'bindEvents').andCallFake(=>)

     it "expects an element and window", ->
       @region = new Mercury.Regions.Editable(@regionElement, window)
       expect(@region.element.get(0)).toEqual($('#editable_region1').get(0))
       expect(@region.window).toEqual(window)

     it "accepts options", ->
       @region = new Mercury.Regions.Editable(@regionElement, window, {foo: 'something'})
       expect(@region.options).toEqual({foo: 'something'})

     it "sets it's type", ->
       @region = new Mercury.Regions.Editable(@regionElement, window)
       expect(@region.type).toEqual('editable')

     it "calls build", ->
       @region = new Mercury.Regions.Editable(@regionElement, window)
       expect(@buildSpy.callCount).toEqual(1)

     it "calls bindEvents", ->
       @region = new Mercury.Regions.Editable(@regionElement, window)
       expect(@bindEventsSpy.callCount).toEqual(1)


  describe "#build", ->

    it "sets the content to &nbsp; if the content is blank [mozilla only]", ->

    it "sets the current overflow to the element data", ->

    it "resets the elements overflow to auto", ->

    it "sets the container to have special handling if it's not a div [mozilla only]", ->

    it "turns on contentEditable", ->

    it "sets the version to 1 on any snippets within it", ->

    it "enables and disables some basic contentEditable features (only once)", ->

    it "sets mercuryEditing on the document", ->


  describe "observed events", ->

    describe "custom event: region:update", ->

      it "sets a timeout and forces a selection", ->

      it "sets up the table editor if we're in a table", ->

      it "displays a tooltip if the selection is within an anchor", ->

      it "hides the tooltip if the selection is not within an anchor", ->

      it "does nothing if previewing", ->

      it "does nothing if it's not the active region", ->

    describe "custom event: possible:drop", ->

      it "does nothing if previewing", ->

      describe "when a snippet image is in the content", ->

        it "calls focus", ->

        it "calls displayOptionsFor for the snippet", ->

        it "calls the native undo", ->

    describe "dragenter", ->

      it "does nothing if previewing", ->

      it "it prevents the default action if shift is pressed", ->

    describe "dragover", ->

      it "does nothing if previewing", ->

      it "it prevents the default action if shift is pressed", ->

    describe "drop", ->

      it "triggers the possible:drop event in a setTimeout", ->

      it "does nothing if previewing", ->

      describe "when a file is dropped", ->

        it "prevents the default action", ->

        it "calls focus", ->

        it "loads the uploader", ->

    describe "paste", ->

      it "tells mercury that changes have been made", ->

      # mozilla: doesn't seem to handle pasting in elements besides divs.
      it "prevents the default if it's a special container", ->

      it "calls handle paste with the pre-paste content in a setTimeout", ->

      it "does nothing if previewing", ->

      it "does nothing if it's not the active region", ->

    describe "focus", ->

      it "sets the active region", ->

      it "forces a selection", ->

      it "triggers a region:focused event", ->

      it "does nothing if previewing", ->

    describe "blur", ->

      it "triggers a region:blurred event", ->

      it "hides the tooltip", ->

      it "does nothing if previewing", ->

    describe "click", ->

      it "sets anchor targets to top if previewing", ->

    describe "dblclick", ->

      it "does nothing if previewing", ->

      describe "on an image", ->

        it "selects the image element", ->

        it "triggers the button event with the insertMedia action", ->

    describe "mouseup", ->

      it "calls pushHistory", ->

      it "triggers the region:update event", ->

      it "does nothing if previewing", ->

    describe "keydown", ->

      it "does nothing if previewing", ->

      it "calls pushHistory", ->

      it "calls execCommand with undo on meta+z", ->

      it "calls execCommand with redo on shift+meta+z", ->

      describe "pressing enter in a list", ->

        it "prevents the default event", ->
        it "calls execCommand with insertLineBreak", ->

      describe "pressing enter when it's a special container (not a div)", ->

        it "prevents the default event", ->
        it "calls execCommand with insertHTML and <br/>", ->

      describe "pressing tab", ->

        it "calls execCommand with inserHTML and two spaces", ->

      describe "pressing tab in a list", ->

        it "calls execCommand with indent", ->

        it "calls execCommand with outdent if shift is used", ->

        it "doesn't call execCommand with inserHTML and two spaces", ->

      describe "with common actions", ->

        it "calls execCommand with bold on meta+b", ->

        it "calls execCommand with italic on meta+i", ->

        it "calls execCommand with underline on meta+u", ->

    describe "keyup", ->

      it "triggers the region:update event", ->

      it "does nothing if previewing", ->


  describe "#focus", ->

    it "calls focus on the element", ->

    it "sets a timeout that forces the selection", ->

    it "triggers the region:update event", ->


  describe "#content", ->

    describe "when setting the content", ->

      it "sanitizes the html (in case there's anything malformed)", ->

      it "fills in any snippets with their stored content", ->

      it "sets the html", ->

      it "creates a selection if there's markers", ->

    describe "when getting the content", ->

      it "removes any meta tags", ->

      it "places markers if asked", ->

      it "sanitizes the html (in case there's anything malformed)", ->

      it "replaces the snippet contents with an identifier if asked", ->

      it "returns the content", ->


  describe "#togglePreview", ->

    describe "when not previewing", ->

      it "replaces the content with whatever the content is", ->

      it "turns contentEditable off", ->

      it "sets the overflow back to what was stored on the element", ->

      it "blurs the element", ->

    describe "when previewing", ->

      it "turns contentEditable on", ->

      it "sets the overflow to auto", ->


  describe "#execCommand", ->

    describe "when a handler exists", ->

      it "calls it if one is defined in Mercury.config.behaviors", ->

      it "calls it if one is defined in actions", ->

    describe "when a handler doesn't exist", ->

      it "gets the html value of a jQuery element if one is passed in with the insertHTML action", ->

      it "calls the native execCommand", ->

      # mozilla has a weird bug when indenting.. if there's only one element in the region it will put the blockquote
      # outside the region, so we have to remove it so it seems like nothing happened.
      it "removes the previous sibling if it doesn't match what used to be there on indent [mozilla only]", ->


  describe "#pushHistory", ->

    it "clears the history timeout", ->

    it "immediately pushes to the history buffer", ->

    it "remembers the last key pressed if one was passed", ->

    describe "when pressing enter, delete, or backspace", ->

      it "immediately pushes to the history buffer", ->

      it "only pushes once for each keyCode (eg. enter enter enter results in one push)", ->

    describe "when pressing any other key", ->

      it "waits for 2.5 seconds and then pushes to the history buffer", ->


  describe "#selection", ->

    it "returns a new instance of the selection helper class", ->


  describe "#path", ->

    it "returns an array of parents from the element with the selection to the region element", ->

    it "returns an empty array if there's no selection", ->


  describe "#currentElement", ->

    it "returns the element that's closest to the node or element with the selection", ->

    it "returns an empty array if there's no selection", ->


  describe "#handlePaste", ->

    it "removes any regions that might have been pasted", ->

    describe "when it looks like MS word content", ->

      it "calls the native undo to remove the pasted content", ->

      it "inserts the cleaned content (which is the text version of what was pasted)", ->

      describe "when undo throws an exception", ->

        it "sets the content to what it was before the paste", ->

        it "opens a modal (featuring clippy)", ->

    describe "when it's configured to strip styles", ->

      it "calls the native undo to remove the pasted content", ->

      it "strips style attributes from the pasted content and inserts the cleaned html", ->


describe "Mercury.Regions.Editable.actions", ->

  template 'mercury/regions/editable.html'

  beforeEach ->
    #@region = new Mercury.Regions.Editable($('#editable_region1'), window)
    #@actions = Mercury.Regions.Editable.actions

  # behaviors
  describe "*horizontalRule", ->
  describe "*htmlEditor", ->

  # native actions
  describe "-formatblock", ->
  describe "-foreColor", ->
  describe "-bold", ->
  describe "-italic", ->
  describe "-strikethrough", ->
  describe "-underline", ->
  describe "-subscript", ->
  describe "-superscript", ->
  describe "-justifyLeft", ->
  describe "-justifyCenter", ->
  describe "-justifyRight", ->
  describe "-justifyFull", ->
  describe "-insertUnorderedList", ->
  describe "-insertOrderedList", ->
  describe "-outdent", ->
  describe "-indent", ->

  # custom actions
  describe ".style", ->
  describe ".backColor", ->
  describe ".removeFormatting", ->
  describe ".overline", ->
  describe ".insertRowBefore", ->
  describe ".insertRowAfter", ->
  describe ".deleteRow", ->
  describe ".insertColumnBefore", ->
  describe ".insertColumnAfter", ->
  describe ".deleteColumn", ->
  describe ".increaseColspan", ->
  describe ".decreaseColspan", ->
  describe ".increaseRowspan", ->
  describe ".decreaseRowspan", ->
  describe ".undo", ->
  describe ".redo", ->
  describe ".replaceHTML", ->
  describe ".insertImage", ->
  describe ".insertLink", ->
  describe ".replaceLink", ->
  describe ".insertSnippet", ->
  describe ".editSnippet", ->
  describe ".removeSnippet", ->

