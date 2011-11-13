describe "Mercury.Regions.Markupable", ->

  template 'mercury/regions/markupable.html'

  beforeEach ->
    @regionElement = $('#markupable_region1')

  describe "constructor", ->

     beforeEach ->
       @buildSpy = spyOn(Mercury.Regions.Markupable.prototype, 'build').andCallFake(=>)
       @bindEventsSpy = spyOn(Mercury.Regions.Markupable.prototype, 'bindEvents').andCallFake(=>)
       spyOn(Mercury.Regions.Markupable.prototype, 'pushHistory').andCallFake(=>)

     it "expects an element and window", ->
       @region = new Mercury.Regions.Markupable(@regionElement, window)
       expect(@region.element.get(0)).toEqual($('#markupable_region1').get(0))
       expect(@region.window).toEqual(window)

     it "accepts options", ->
       @region = new Mercury.Regions.Markupable(@regionElement, window, {foo: 'something'})
       expect(@region.options).toEqual({foo: 'something'})

     it "sets it's type", ->
       @region = new Mercury.Regions.Markupable(@regionElement, window)
       expect(@region.type).toEqual('markupable')

     it "creates a markdown converter using Showdown", ->
       spy = spyOn(Showdown, 'converter').andCallFake(=>)
       @region = new Mercury.Regions.Markupable(@regionElement, window)
       expect(spy.callCount).toEqual(1)
       expect(@region.converter).toBeDefined()

     it "calls build", ->
       @region = new Mercury.Regions.Markupable(@regionElement, window)
       expect(@buildSpy.callCount).toEqual(1)

     it "calls bindEvents", ->
       @region = new Mercury.Regions.Markupable(@regionElement, window)
       expect(@bindEventsSpy.callCount).toEqual(1)


  describe "#build", ->

    it "creates a textarea", ->

    it "fills the textarea with the contents of the element", ->

    it "sets some styles on the textarea", ->

    it "appends the textarea to the element", ->

    it "creates a preview element", ->

    it "appends the preview element to the element", ->

    it "element is reassigned to the textarea", ->

    it "calls resize", ->


  describe "#focus", ->

    it "calls focus on the element", ->


  describe "observed events", ->

    describe "custom event: mode", ->

      it "calls togglePreview if the mode is preview", ->

    describe "custom event: focus:frame", ->

      it "calls focus", ->

      it "does nothing if previewing", ->

      it "does nothing if it's not the active region", ->

    describe "custom event: action", ->

      it "calls execCommand", ->

      it "does nothing if previewing", ->

      it "does nothing if it's not the active region", ->

    describe "custom event: unfocus:regions", ->

      it "blurs the element", ->

      it "removes the focus class from the element", ->

      it "triggers the region:blurred event", ->

      it "does nothing if previewing", ->

      it "does nothing if it's not the active region", ->

    describe "dragenter", ->

      it "prevents the default action", ->

      it "does nothing if previewing", ->

    describe "dragover", ->

      it "prevents the default action", ->

      it "does nothing if previewing", ->

    describe "drop", ->

      it "does nothing if previewing", ->

      describe "when there's an active snippet", ->

        it "calls focus", ->

        it "calls displayOptionsFor for the snippet", ->

        it "calls the native undo", ->

      describe "when a file is dropped", ->

        it "calls focus", ->

        it "loads the uploader", ->

    describe "focus", ->

      it "does nothing if previewing", ->

      it "sets the active region to itself", ->

      it "adds the focus class to the element", ->

      it "triggers the region:focused event", ->

    describe "keydown", ->

      it "does nothing if previewing", ->

      it "tells mercury that changes have been made", ->

      it "calls pushHistory", ->

      it "calls execCommand with undo on meta+z", ->

      it "calls execCommand with redo on shift+meta+z", ->

      describe "pressing enter in a list", ->

        it "prevents the default event", ->

        it "adds a new line with the next number or just dash for unordered lists", ->

      describe "pressing tab", ->

        it "calls execCommand with inserHTML and two spaces", ->

      describe "with common actions", ->

        it "calls execCommand with bold on meta+b", ->

        it "calls execCommand with italic on meta+i", ->

        it "calls execCommand with underline on meta+u", ->

    describe "keyup", ->

      it "triggers the region:update event", ->

      it "does nothing if previewing", ->

    describe "mouseup", ->

      it "calls focus", ->

      it "triggers the region:update event", ->

      it "does nothing if previewing", ->

    describe "click on the preview element", ->

      it "sets anchor targets to top if previewing", ->


  describe "#content", ->

    describe "when setting the content using a string", ->

      it "sets the value of the element", ->

    describe "when setting the content using an object (with a selection)", ->

      it "sets the value of the element", ->

      it "selects using the selection start/end from the object", ->

    describe "when getting the content", ->

      it "returns the element value", ->


  describe "#togglePreview", ->

    describe "when not previewing", ->

      it "sets the value of the preview element to the html from the markdown converter", ->

      it "shows the preview element", ->

      it "hides the element", ->

    describe "when previewing", ->

      it "hides the preview element", ->

      it "shows the element", ->


  describe "#execCommand", ->

    it "calls resize", ->

    describe "when a handler exists", ->

      it "calls it if one is defined in actions", ->


  describe "#htmlAndSelection", ->

    it "returns an object with the content and the selection start/end", ->


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


  describe "#resize", ->


  describe "#snippets", ->



describe "Mercury.Regions.Markupable.actions", ->

  template 'mercury/regions/markupable.html'

  beforeEach ->
    #@region = new Mercury.Regions.Markupable($('#markupable_region1'), window)
    #@actions = Mercury.Regions.Markupable.actions

  describe ".undo", ->

    it "calls undo on the history buffer", ->

    it "sets the contents", ->


  describe ".redo", ->

    it "calls redo on the history buffer", ->

    it "sets the contents", ->


  describe ".insertHTML", ->

    it "gets the html value if it's a jQuery object", ->

    it "replaces the selection with the content", ->


  describe ".insertImage", ->

    it "replaces the selection with the image markup", ->


  describe ".insertLink", ->

    it "replaces the selection with the link markup", ->


  describe ".insertUnorderedList", ->

    it "replaces the selection with the unordered list markup", ->


  describe ".insertOrderedList", ->

    it "replaces the selection with the ordered list markup", ->


  describe ".style", ->

    it "wraps the selection in a span tag with a given class", ->


  describe ".formatblock", ->

    it "unwraps the line of the selection of any block format markup", ->

    it "wraps the line of the selection with the given block format markup", ->


  describe ".bold", ->

    it "wraps the selection in the bold markup (**)", ->


  describe ".italic", ->

    it "wraps the selection in the italics markup (_)", ->


  describe ".subscript", ->

    it "wraps the selection in a sub tag", ->


  describe ".superscript", ->

    it "wraps the selection in a sup tag", ->


  describe ".indent", ->

    it "adds a > to the front of the line", ->


  describe ".outdent", ->

    it "removes a > from the front of the line", ->


  describe ".horizontalRule", ->

    it "replaces the selection with the hr markup (- - -)", ->


  describe ".insertSnippet", ->

    it "replaces the selection with the content returned from the snippets getText", ->
