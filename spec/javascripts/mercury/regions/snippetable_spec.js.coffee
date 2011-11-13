describe "Mercury.Regions.Snippetable", ->

  template 'mercury/regions/snippetable.html'

  beforeEach ->
    @regionElement = $('#snippetable_region1')

  afterEach ->
    @region = null
    delete(@region)

  describe "constructor", ->

    beforeEach ->
      @buildSpy = spyOn(Mercury.Regions.Snippetable.prototype, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(Mercury.Regions.Snippetable.prototype, 'bindEvents').andCallFake(=>)
      @makeSortableSpy = spyOn(Mercury.Regions.Snippetable.prototype, 'makeSortable').andCallFake(=>)

    it "expects an element and window", ->
      @region = new Mercury.Regions.Snippetable(@regionElement, window)
      expect(@region.element.get(0)).toEqual($('#snippetable_region1').get(0))
      expect(@region.window).toEqual(window)

    it "accepts options", ->
      @region = new Mercury.Regions.Snippetable(@regionElement, window, {foo: 'something'})
      expect(@region.options).toEqual({foo: 'something'})

    it "sets it's type", ->
      @region = new Mercury.Regions.Snippetable(@regionElement, window)
      expect(@region.type).toEqual('snippetable')

    it "calls build", ->
      @region = new Mercury.Regions.Snippetable(@regionElement, window)
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      @region = new Mercury.Regions.Snippetable(@regionElement, window)
      expect(@bindEventsSpy.callCount).toEqual(1)

    it "makes the snippets sortable", ->
      @region = new Mercury.Regions.Snippetable(@regionElement, window)
      expect(@makeSortableSpy.callCount).toEqual(1)


  describe "#build", ->

    beforeEach ->
      spyOn(Mercury.Regions.Snippetable.prototype, 'bindEvents').andCallFake(=>)

    it "sets the element min-height to 20 if it's min-height is 0 (or not set)", ->
      @region = new Mercury.Regions.Snippetable(@regionElement, window)
      expect($('#snippetable_region1').css('minHeight')).toEqual('20px')


  describe "observed events", ->

    beforeEach ->
      @region = new Mercury.Regions.Snippetable(@regionElement, window)
      Mercury.region = @region

    describe "custom event: unfocus:regions", ->

      it "removes the focus class", ->
        @region.element.addClass('focus')
        Mercury.trigger('unfocus:regions')
        expect(@region.element.hasClass('focus')).toEqual(false)

      it "destroys the sortable", ->
        spy = spyOn($.fn, 'sortable').andCallFake(=>)
        Mercury.trigger('unfocus:regions')
        expect(spy.argsForCall[0]).toEqual(['destroy'])

      it "triggers the region:blurred event", ->
        spy = spyOn(Mercury, 'trigger').andCallThrough()
        Mercury.trigger('unfocus:regions')
        expect(spy.callCount).toEqual(2)
        expect(spy.argsForCall[1]).toEqual(['region:blurred', {region: @region}])

      it "does nothing if previewing", ->
        @region.previewing = true
        @region.element.addClass('focus')
        Mercury.trigger('unfocus:regions')
        expect(@region.element.hasClass('focus')).toEqual(true)

      it "does nothing if it's not the active region", ->
        Mercury.region = null
        @region.element.addClass('focus')
        Mercury.trigger('unfocus:regions')
        expect(@region.element.hasClass('focus')).toEqual(true)

    describe "custom event: focus:window", ->

      it "removes the focus class", ->
        @region.element.addClass('focus')
        Mercury.trigger('focus:window')
        expect(@region.element.hasClass('focus')).toEqual(false)

      it "destroys the sortable", ->
        spy = spyOn($.fn, 'sortable').andCallFake(=>)
        Mercury.trigger('focus:window')
        expect(spy.argsForCall[0]).toEqual(['destroy'])

      it "triggers the region:blurred event", ->
        spy = spyOn(Mercury, 'trigger').andCallThrough()
        Mercury.trigger('focus:window')
        expect(spy.callCount).toEqual(2)
        expect(spy.argsForCall[1]).toEqual(['region:blurred', {region: @region}])

      it "does nothing if previewing", ->
        @region.previewing = true
        @region.element.addClass('focus')
        Mercury.trigger('focus:window')
        expect(@region.element.hasClass('focus')).toEqual(true)

      it "does nothing if it's not the active region", ->
        Mercury.region = null
        @region.element.addClass('focus')
        Mercury.trigger('focus:window')
        expect(@region.element.hasClass('focus')).toEqual(true)

    describe "keydown on document (for undo / redo)", ->

      it "calls execCommand with undo on meta+z", ->
        spy = spyOn(Mercury.Regions.Snippetable.prototype, 'execCommand')
        jasmine.simulate.keydown(document, {shiftKey: false, metaKey: true, keyCode: 90})
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual(['undo'])

      it "calls execCommand with redo on shift+meta+z", ->
        spy = spyOn(Mercury.Regions.Snippetable.prototype, 'execCommand')
        jasmine.simulate.keydown(document, {shiftKey: true, metaKey: true, keyCode: 90})
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual(['redo'])

      it "does nothing if previewing", ->
        @region.previewing = true
        spy = spyOn(Mercury.Regions.Snippetable.prototype, 'execCommand')
        jasmine.simulate.keydown(document, {shiftKey: true, metaKey: true, keyCode: 90})
        expect(spy.callCount).toEqual(0)

      it "does nothing if it's not the active region", ->
        Mercury.region = null
        spy = spyOn(Mercury.Regions.Snippetable.prototype, 'execCommand')
        jasmine.simulate.keydown(document, {shiftKey: true, metaKey: true, keyCode: 90})
        expect(spy.callCount).toEqual(0)

    describe "mouseup", ->

      it "calls focus", ->
        spy = spyOn(Mercury.Regions.Snippetable.prototype, 'focus')
        jasmine.simulate.mouseup(@region.element.get(0))
        expect(spy.callCount).toEqual(1)

      it "triggers the region:focused event", ->
        spy = spyOn(Mercury, 'trigger')
        jasmine.simulate.mouseup(@region.element.get(0))
        expect(spy.callCount).toEqual(1)

      it "does nothing if previewing", ->
        @region.previewing = true
        spy = spyOn(Mercury.Regions.Snippetable.prototype, 'focus')
        jasmine.simulate.mouseup(@region.element.get(0))
        expect(spy.callCount).toEqual(0)

    describe "dragover", ->

      # untestable
      it "prevents the default event", ->
      it "does nothing if previewing", ->

    describe "drop", ->

      # untestable
      it "calls focus", ->
      it "prevents the default event", ->
      it "displays the options for the snippet that was dropped", ->
      it "does nothing if previewing", ->
      it "does nothing if there's no active snippet", ->


  describe "#focus", ->

    beforeEach ->
      @region = new Mercury.Regions.Snippetable(@regionElement, window)

    it "sets the active mercury region", ->
      Mercury.region = null
      @region.focus()
      expect(Mercury.region).toEqual(@region)

    it "makes the snippets sortable again", ->
      spy = spyOn(Mercury.Regions.Snippetable.prototype, 'makeSortable')
      @region.focus()
      expect(spy.callCount).toEqual(1)

    it "adds the focus class to the element", ->
      @region.focus()
      expect($('#snippetable_region1').hasClass('focus')).toEqual(true)


  describe "#togglePreview", ->

    beforeEach ->
      @region = new Mercury.Regions.Snippetable(@regionElement, window)

    describe "when not previewing", ->

      it "it destroys the sortable", ->
        spy = spyOn($.fn, 'sortable').andCallFake(=>)
        @region.togglePreview()
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual(['destroy'])

      it "removes the focus class", ->
        @regionElement.addClass('focus')
        @region.togglePreview()
        expect($('#snippetable_region1').hasClass('focus')).toEqual(false)

    describe "when previewing", ->

      beforeEach ->
        @region.previewing = true

      it "makes the snippets sortable again", ->
        spy = spyOn(Mercury.Regions.Snippetable.prototype, 'makeSortable')
        @region.togglePreview()
        expect(spy.callCount).toEqual(1)


  describe "#execCommand", ->

    beforeEach ->
      @region = new Mercury.Regions.Snippetable(@regionElement, window)
      Mercury.Regions.Snippetable.actions['foo'] = ->
      @handlerSpy = spyOn(Mercury.Regions.Snippetable.actions, 'foo')

    it "calls a handler (from the actions) if one exists", ->
      @region.execCommand('foo', {value: 'something'})
      expect(@handlerSpy.callCount).toEqual(1)
      expect(@handlerSpy.argsForCall[0]).toEqual([{value: 'something'}])


  describe "#makeSortable", ->

    beforeEach ->
      @region = new Mercury.Regions.Snippetable(@regionElement, window)
      @sortableSpy = spyOn($.fn, 'sortable')

    it "makes the snippets sortable", ->
      @sortableSpy.andCallFake((arg) => return @region.element if arg == 'destroy' )
      @region.makeSortable()
      expect(@sortableSpy.callCount).toEqual(2)
      expect(@sortableSpy.argsForCall[0]).toEqual(['destroy'])
      expect(@sortableSpy.argsForCall[1][0]['document']).toEqual(@region.document)

    it "triggers the hide:toolbar event at the end of the dragging", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      @sortableSpy.andCallFake((arg) => if arg == 'destroy' then return @region.element else arg.beforeStop())
      @region.makeSortable()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['hide:toolbar', {type: 'snippet', immediately: true}])

    it "pushes to the history after dragging", ->
      spy = spyOn(Mercury.Regions.Snippetable.prototype, 'pushHistory').andCallFake(=>)
      spyOn(window, 'setTimeout').andCallFake((timeout, callback)=> callback())
      @sortableSpy.andCallFake((arg) => if arg == 'destroy' then return @region.element else arg.stop())
      @region.makeSortable()
      expect(spy.callCount).toEqual(1)



describe "Mercury.Regions.Snippetable.actions", ->

  template 'mercury/regions/snippetable.html'

  beforeEach ->
    @region = new Mercury.Regions.Snippetable($('#snippetable_region2'), window)
    @actions = Mercury.Regions.Snippetable.actions

  describe ".undo", ->

    it "calls undo on the history buffer and sets the content", ->
      htmlSpy = spyOn(Mercury.Regions.Snippetable.prototype, 'content').andCallFake(=>)
      historySpy = spyOn(@region.history, 'undo').andCallFake(=> 'history -1')
      @actions['undo'].call(@region)
      expect(historySpy.callCount).toEqual(1)
      expect(htmlSpy.callCount).toEqual(1)
      expect(htmlSpy.argsForCall[0]).toEqual(['history -1'])


  describe ".redo", ->

    it "calls redo on the history buffer and sets the content", ->
      htmlSpy = spyOn(Mercury.Regions.Snippetable.prototype, 'content').andCallFake(=>)
      historySpy = spyOn(@region.history, 'redo').andCallFake(=> 'history +1')
      @actions['redo'].call(@region)
      expect(historySpy.callCount).toEqual(1)
      expect(htmlSpy.callCount).toEqual(1)
      expect(htmlSpy.argsForCall[0]).toEqual(['history +1'])


  describe ".insertSnippet", ->

    beforeEach ->
      Mercury.Snippet.load({
        'snippet_1': {name: 'example', options: {'foo': 'bar'}},
        'snippet_2': {name: 'example', options: {'foo': 'bar'}},
      })
      spyOn(Mercury.Snippet.prototype, 'loadPreview').andCallFake(=>)

    describe "updating a snippet", ->

      it "finds the snippet by it's identity and replaces it with the new snippet", ->
        @actions['insertSnippet'].call(@region, {value: Mercury.Snippet.find('snippet_1')})
        expect($('#snippetable_region2').html()).toContain('class="mercury-snippet"')
        expect($('#snippetable_region2').html()).toContain('contenteditable="false"')
        expect($('#snippetable_region2').html()).toContain('data-version="1"')
        expect($('#snippetable_region2').html()).toContain('data-snippet="snippet_1"')
        expect($('#snippetable_region2').html()).toContain('[snippet_1]')

      it "pushes to the history after it's been rendered", ->
        spyOn(Mercury.Snippet.prototype, 'getHTML').andCallFake((x, callback) => callback() if callback)
        spy = spyOn(Mercury.Regions.Snippetable.prototype, 'pushHistory').andCallFake(=>)
        @actions['insertSnippet'].call(@region, {value: Mercury.Snippet.find('snippet_1')})
        expect(spy.callCount).toEqual(1)

    describe "inserting a snippet", ->

      it "appends the new snippet html to the element", ->
        @actions['insertSnippet'].call(@region, {value: Mercury.Snippet.find('snippet_2')})
        expect($('#snippetable_region2 .mercury-snippet').length).toEqual(2)

      it "pushes to the history after it's been rendered", ->
        spyOn(Mercury.Snippet.prototype, 'getHTML').andCallFake((x, callback) => callback() if callback)
        spy = spyOn(Mercury.Regions.Snippetable.prototype, 'pushHistory').andCallFake(=>)
        @actions['insertSnippet'].call(@region, {value: Mercury.Snippet.find('snippet_2')})
        expect(spy.callCount).toEqual(1)


  describe ".editSnippet", ->

    beforeEach ->
      @region.snippet = $('#snippetable_region2 .mercury-snippet')

    it "finds and displays the options for the given snippet", ->
      spy = spyOn(Mercury.Snippet.prototype, 'displayOptions')
      @actions['editSnippet'].call(@region)
      expect(spy.callCount).toEqual(1)

    it "does nothing if there's no active snippet (eg. hovered over)", ->
      @region.snippet = null
      spy = spyOn(Mercury.Snippet.prototype, 'displayOptions')
      @actions['editSnippet'].call(@region)
      expect(spy.callCount).toEqual(0)


  describe ".removeSnippet", ->

    beforeEach ->
      @region.snippet = $('#snippetable_region2 .mercury-snippet')

    it "removes the snippet if there's an active one", ->
      @actions['removeSnippet'].call(@region)
      expect($('#snippetable_region2 .mercury-snippet').length).toEqual(0)

    it "triggers the hide:toolbar event", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      @actions['removeSnippet'].call(@region)
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['hide:toolbar', {type: 'snippet', immediately: true}])
