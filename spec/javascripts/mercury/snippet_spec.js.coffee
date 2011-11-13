describe "Mercury.Snippet", ->

  template 'mercury/snippet.html'

  afterEach ->
    Mercury.Snippet.all = []

  describe "constructor", ->

    beforeEach ->
      @setOptionsSpy = spyOn(Mercury.Snippet.prototype, 'setOptions').andCallFake(=>)
      @snippet = new Mercury.Snippet('foo', 'identity', {foo: 'bar'})

    it "expects name and identity", ->
      expect(@snippet.name).toEqual('foo')
      expect(@snippet.identity).toEqual('identity')

    it "sets the version", ->
      expect(@snippet.version).toEqual(0)
      expect(@snippet.identity).toEqual('identity')

    it "creates a history buffer", ->
      expect(@snippet.history).toBeDefined()

    it "calls setOptions", ->
      expect(@setOptionsSpy.callCount).toEqual(1)


  describe "#getHTML", ->

    beforeEach ->
      @loadPreviewSpy = spyOn(Mercury.Snippet.prototype, 'loadPreview').andCallFake(=>)
      @snippet = new Mercury.Snippet('foo', 'identity', {foo: 'bar'})

    it "builds an element (in whatever context is provided", ->
      ret = @snippet.getHTML($(document))
      html = $('<div>').html(ret).html()
      expect(html).toContain('class="mercury-snippet"')
      expect(html).toContain('contenteditable="false"')
      expect(html).toContain('data-snippet="identity"')
      expect(html).toContain('data-version="1"')

    it "sets the default content to the identity", ->
      ret = @snippet.getHTML($(document))
      expect(ret.html()).toEqual('[identity]')

    it "calls loadPreview", ->
      @snippet.getHTML($(document))
      expect(@loadPreviewSpy.callCount).toEqual(1)

    it "passes callback method to loadPreview", ->
      callback = =>
      @snippet.getHTML($(document), callback)
      expect(@loadPreviewSpy.argsForCall[0][1]).toEqual(callback)


  describe "#getText", ->

    beforeEach ->
      @snippet = new Mercury.Snippet('foo', 'identity', {foo: 'bar'})

    it "returns an identity string", ->
      expect(@snippet.getText()).toEqual('[--identity--]')


  describe "#loadPreview", ->

    beforeEach ->
      @ajaxSpy = spyOn($, 'ajax')
      @snippet = new Mercury.Snippet('foo', 'identity', {foo: 'bar'})

    it "makes an ajax request", ->
      @ajaxSpy.andCallFake(=>)
      spyOn(Mercury, 'ajaxHeaders').andCallFake(=> {'X-CSRFToken': 'f00'})
      @snippet.loadPreview()
      expect(@ajaxSpy.callCount).toEqual(1)
      expect(@ajaxSpy.argsForCall[0][0]).toEqual("/mercury/snippets/foo/preview.html")
      expect(@ajaxSpy.argsForCall[0][1]['data']).toEqual({foo: 'bar'})
      expect(@ajaxSpy.argsForCall[0][1]['type']).toEqual('POST')
      expect(@ajaxSpy.argsForCall[0][1]['headers']).toEqual({'X-CSRFToken': 'f00'})

    describe "ajax success", ->

      beforeEach ->
        @ajaxSpy.andCallFake((url, options) => options.success('data'))

      it "sets the data", ->
        @snippet.loadPreview($('#snippet'))
        expect(@snippet.data).toEqual('data')

      it "puts the data into the element", ->
        @snippet.loadPreview($('#snippet'))
        expect($('#snippet').html()).toEqual('data')

      it "calls the callback if one was provided", ->
        callCount = 0
        callback = => callCount += 1
        @snippet.loadPreview($('#snippet'), callback)
        expect(callCount).toEqual(1)

    describe "ajax failure", ->

      beforeEach ->
        @ajaxSpy.andCallFake((url, options) => options.error())

      it "alerts the error", ->
        spy = spyOn(window, 'alert').andCallFake(=>)
        @snippet.loadPreview($('#snippet'))
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual(['Error loading the preview for the "foo" snippet.'])


  describe "#displayOptions", ->

    beforeEach ->
      @modalSpy = spyOn(Mercury, 'modal').andCallFake(=>)
      @snippet = new Mercury.Snippet('foo', 'identity', {foo: 'bar'})

    it "sets the global snippet to itself", ->
      @snippet.displayOptions()
      expect(Mercury.snippet).toEqual(@snippet)

    it "opens a modal", ->
      @snippet.displayOptions()
      expect(@modalSpy.callCount).toEqual(1)


  describe "#setOptions", ->

    beforeEach ->
      @snippet = new Mercury.Snippet('foo', 'identity', {foo: 'bar'})

    it "removes rails form default options that aren't for storing", ->
      @snippet.setOptions({foo: 'baz', utf8: 'check', authenticity_token: 'auth_token'})
      expect(@snippet.options).toEqual({foo: 'baz'})

    it "increases the version", ->
      @snippet.setOptions({foo: 'baz'})
      expect(@snippet.version).toEqual(2)

    it "pushes the options to the history buffer", ->
      @snippet.setOptions({foo: 'baz'})
      expect(@snippet.history.stack.length).toEqual(2)


  describe "#setVersion", ->

    beforeEach ->
      @snippet = new Mercury.Snippet('foo', 'identity', {foo: 'bar'})
      @snippet.history.stack = [1, 2, {foo: 'baz'}, 4, 5, 6, 7, 8, 9, 10]

    it "sets the version", ->
      @snippet.setVersion(5)
      expect(@snippet.version).toEqual(4)

    it "accepts a version (can be a string)", ->
      @snippet.setVersion('2')
      expect(@snippet.version).toEqual(1)

    it "pulls the version out of the history buffer", ->
      @snippet.setVersion(3)
      expect(@snippet.options).toEqual({foo: 'baz'})

    it "returns true if successful", ->
      ret = @snippet.setVersion('2')
      expect(ret).toEqual(true)

    it "returns false if not successful", ->
      ret = @snippet.setVersion('abc')
      expect(ret).toEqual(false)


  describe "#serialize", ->

    beforeEach ->
      @snippet = new Mercury.Snippet('foo', 'identity', {foo: 'bar'})

    it "returns an object with name and options", ->
      ret = @snippet.serialize()
      expect(ret).toEqual({name: 'foo', options: {foo: 'bar'}})



describe "Mercury.Snippet class methods", ->

  afterEach ->
    Mercury.Snippet.all = []

  describe ".displayOptionsFor", ->

    beforeEach ->
      @modalSpy = spyOn(Mercury, 'modal').andCallFake(=>)

    it "opens a modal with the name in the url", ->
      Mercury.Snippet.displayOptionsFor('foo')
      expect(@modalSpy.callCount).toEqual(1)
      expect(@modalSpy.argsForCall[0]).toEqual(["/mercury/snippets/foo/options.html", {title: 'Snippet Options', handler: 'insertSnippet', snippetName: 'foo'}])

    it "sets the snippet back to nothing", ->
      Mercury.snippet = 'foo'
      Mercury.Snippet.displayOptionsFor('foo')
      expect(Mercury.snippet).toEqual(null)


  describe ".create", ->

    beforeEach ->
      Mercury.Snippet.all = []

    it "creates a new instance of Mercury.Snippet", ->
      ret = Mercury.Snippet.create('foo', {foo: 'bar'})
      expect(ret.options).toEqual({foo: 'bar'})

    it "generates an identity and passes it to the instance", ->
      ret = Mercury.Snippet.create('foo', {foo: 'bar'})
      expect(ret.identity).toEqual('snippet_0')

    it "pushes into the collection array", ->
      Mercury.Snippet.create('foo', {foo: 'bar'})
      expect(Mercury.Snippet.all.length).toEqual(1)


  describe ".find", ->

    beforeEach ->
      Mercury.Snippet.create('foo', {foo: 'bar'})

    it "finds a snippet by identity", ->
      expect(Mercury.Snippet.find('snippet_0').options).toEqual({foo: 'bar'})

    it "returns null if no snippet was found", ->
      expect(Mercury.Snippet.find('snippet_x')).toEqual(null)


  describe ".load", ->

    beforeEach ->
      @snippets = {
        snippet_1: {name: 'foo', options: {foo: 'bar'}}
        snippet_2: {name: 'bar', options: {baz: 'pizza'}}
      }

    it "creates a new instance for each item in the collection", ->
      Mercury.Snippet.load(@snippets)
      expect(Mercury.Snippet.all.length).toEqual(2)
