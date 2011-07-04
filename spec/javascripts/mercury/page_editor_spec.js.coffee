require '/assets/mercury.js'

describe "Mercury.PageEditor", ->

  template 'mercury/page_editor.html'

  afterEach ->
    @pageEditor = null
    delete(@pageEditor)
    window.mercuryInstance = null
    $(document).unbind('mercury:initialize:frame')
    $(document).unbind('mercury:focus:frame')
    $(document).unbind('mercury:focus:window')
    $(document).unbind('mercury:toggle:interface')
    $(document).unbind('mercury:action')
    $(document).unbind('mousedown')
    $(window).unbind('resize')

  describe "constructor", ->

    beforeEach ->
      @initializeInterfaceSpy = spyOn(Mercury.PageEditor.prototype, 'initializeInterface').andCallFake(=>)

    it "throws an error if it's not supported", ->
      Mercury.supported = false
      expect(=>
        new Mercury.PageEditor()
      ).toThrow('Mercury.PageEditor is unsupported in this client. Supported browsers are chrome 10+, firefix 4+, and safari 5+.')
      Mercury.supported = true

    it "throws an error if it's already instantiated", ->
      window.mercuryInstance = true
      expect(=>
        new Mercury.PageEditor()
      ).toThrow('Mercury.PageEditor can only be instantiated once.')
      window.mercuryInstance = false

    it "sets the mercuryInstance to window", ->
      @pageEditor = new Mercury.PageEditor()
      expect(window.mercuryInstance).toEqual(@pageEditor)

    it "accepts a saveUrl, and options", ->
      @pageEditor = new Mercury.PageEditor('/foo/1', {foo: 'bar'})
      expect(@pageEditor.saveUrl).toEqual('/foo/1')
      expect(@pageEditor.options).toEqual({foo: 'bar', visible: true})

    it "sets the visible option to true unless it's set", ->
      @pageEditor = new Mercury.PageEditor('/foo/1', {foo: 'bar', visible: false})
      expect(@pageEditor.options.visible).toEqual(false)
      window.mercuryInstance = null
      @pageEditor = new Mercury.PageEditor('/foo/1', {foo: 'bar', visible: true})
      expect(@pageEditor.options.visible).toEqual(true)

    it "sets visible based on the options", ->
      @pageEditor = new Mercury.PageEditor('/foo/1', {foo: 'bar', visible: false})
      expect(@pageEditor.visible).toEqual(false)
      window.mercuryInstance = null
      @pageEditor = new Mercury.PageEditor('/foo/1', {foo: 'bar', visible: true})
      expect(@pageEditor.visible).toEqual(true)

    it "calls initializeInterface", ->
      @pageEditor = new Mercury.PageEditor()
      expect(@initializeInterfaceSpy.callCount).toEqual(1)

    it "gets the csrf token if there's one available", ->
      new Mercury.PageEditor()
      expect(Mercury.csrfToken).toEqual('K6JhyfOVKJX8X2ZkiJXSf491fc1fF+k79wzrChHQa0g=')


  describe "#initializeInterface", ->

    beforeEach ->
      Mercury.Toolbar = -> {toolbar: true}
      Mercury.Statusbar = -> {statusbar: true}
      @iframeSrcSpy = spyOn(Mercury.PageEditor.prototype, 'iframeSrc').andCallFake(=> '/foo')

    it "builds a focusable element (so we can get focus off the iframe)", ->
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})
      expect($('input[type=text]').length).toEqual(1)

    it "builds an iframe", ->
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})
      expect($('iframe.mercury-iframe').length).toEqual(1)

    it "appends the elements to any node", ->
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#page_editor_container')})
      expect($('#page_editor_container input[type=text]').length).toEqual(1)
      expect($('#page_editor_container iframe.mercury-iframe').length).toEqual(1)

    it "instantiates the toolbar", ->
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})
      expect(@pageEditor.toolbar).toEqual({toolbar: true})

    it "instantiates the statusbar", ->
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})
      expect(@pageEditor.statusbar).toEqual({statusbar: true})


  describe "#initializeFrame", ->

    beforeEach ->
      @bindEventsSpy = spyOn(Mercury.PageEditor.prototype, 'bindEvents').andCallFake(=>)
      @initializeRegionsSpy = spyOn(Mercury.PageEditor.prototype, 'initializeRegions').andCallFake(=>)
      @finalizeInterfaceSpy = spyOn(Mercury.PageEditor.prototype, 'finalizeInterface')
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})

    it "does nothing if the iframe is already loaded", ->
      @finalizeInterfaceSpy.andCallFake(=>)
      @pageEditor.iframe.data('loaded', true)
      @pageEditor.initializeFrame()
      expect(@pageEditor.document).toBeUndefined()

    it "tells the iframe that it's loaded", ->
      @finalizeInterfaceSpy.andCallFake(=>)
      @pageEditor.initializeFrame()
      expect(@pageEditor.iframe.data('loaded')).toEqual(true)

    it "gets the document from the iframe", ->
      @finalizeInterfaceSpy.andCallFake(=>)
      @pageEditor.initializeFrame()
      expect(@pageEditor.document).toBeDefined()

    it "injects needed mercury styles", ->
      @finalizeInterfaceSpy.andCallFake(=>)
      spy = spyOn($.fn, 'appendTo').andCallFake(=>)
      @pageEditor.initializeFrame()
      expect(spy.callCount).toEqual(1)

    it "injects mercury namespace into the iframe", ->
      @finalizeInterfaceSpy.andCallFake(=>)
      @pageEditor.initializeFrame()
      expect(@pageEditor.iframe.get(0).contentWindow.Mercury).toEqual(Mercury)

    it "calls bindEvents", ->
      @finalizeInterfaceSpy.andCallFake(=>)
      @pageEditor.initializeFrame()
      expect(@bindEventsSpy.callCount).toEqual(1)

    it "calls initializeRegions", ->
      @finalizeInterfaceSpy.andCallFake(=>)
      @pageEditor.initializeFrame()
      expect(@initializeRegionsSpy.callCount).toEqual(1)

    it "calls finalizeInterface", ->
      @finalizeInterfaceSpy.andCallFake(=>)
      @pageEditor.initializeFrame()
      expect(@finalizeInterfaceSpy.callCount).toEqual(1)

    it "fires the ready event", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      @finalizeInterfaceSpy.andCallFake(=>)
      @pageEditor.initializeFrame()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['ready'])

    it "shows the iframe", ->
      @pageEditor.iframe.css({visibility: 'visible'})
      @finalizeInterfaceSpy.andCallFake(=>)
      @pageEditor.initializeFrame()
      expect(@pageEditor.iframe.css('visibility')).toEqual('visible')

    it "captures errors and alerts them", ->
      @finalizeInterfaceSpy.andCallFake(=> throw('unknown error' ))
      spy = spyOn(window, 'alert').andCallFake(=>)
      @pageEditor.initializeFrame()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['Mercury.PageEditor failed to load: unknown error\n\nPlease try refreshing.'])


  describe "#initializeRegions", ->

    beforeEach ->
      Mercury.PageEditor.prototype.initializeFrame = ->
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})
      @pageEditor.document = $(document)
      @buildRegionSpy = spyOn(Mercury.PageEditor.prototype, 'buildRegion').andCallFake(=>)

    it "it calls buildRegion for all the regions found in a document", ->
      @pageEditor.initializeRegions()
      expect(@buildRegionSpy.callCount).toEqual(3)

    it "focuses the first region", ->
      firstFocusCalled = false
      @pageEditor.regions = [{focus: => firstFocusCalled = true}, {}, {}]
      @pageEditor.initializeRegions()
      expect(firstFocusCalled).toEqual(true)

    it "doesn't focus the first region if it's not supposed to be visible", ->
      firstFocusCalled = false
      @pageEditor.regions = [{focus: => firstFocusCalled = true}, {}, {}]
      @pageEditor.options.visible = false
      @pageEditor.initializeRegions()
      expect(firstFocusCalled).toEqual(false)


  describe "#buildRegion", ->

    beforeEach ->
      Mercury.PageEditor.prototype.initializeFrame = ->
      Mercury.Regions.Editable = -> {region: true}
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})

    it "instantiates the region and pushes it into the regions array", ->
      @pageEditor.buildRegion($('#region2'))
      expect(@pageEditor.regions.length).toEqual(1)
      expect(@pageEditor.regions[0]).toEqual({region: true})

    it "alerts on errors", ->
      Mercury.debug = false
      Mercury.Regions.Editable = -> throw('error!')
      spy = spyOn(window, 'alert').andCallFake(=>)
      @pageEditor.buildRegion($('#region2'))
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['Region type is malformed, no data-type provided, or "Editable" is unknown.'])


  describe "#finalizeInterface", ->

    beforeEach ->
      Mercury.PageEditor.prototype.initializeFrame = ->
      Mercury.SnippetToolbar = -> {snippetToolbar: true}
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})
      @highjackLinksSpy = spyOn(Mercury.PageEditor.prototype, 'hijackLinks').andCallFake(=>)
      @resizeSpy = spyOn(Mercury.PageEditor.prototype, 'resize').andCallFake(=>)

    it "it builds a snippetToolbar", ->
      @pageEditor.finalizeInterface()
      expect(@pageEditor.snippetToolbar).toEqual({snippetToolbar: true})

    it "calls hijackLinks", ->
      @pageEditor.finalizeInterface()
      expect(@highjackLinksSpy.callCount).toEqual(1)

    it "calls resize", ->
      @pageEditor.finalizeInterface()
      expect(@resizeSpy.callCount).toEqual(1)

    it "fires a mode event to put things into preview mode if it's not visible yet", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      @pageEditor.options.visible = false
      @pageEditor.finalizeInterface()
      expect(spy.callCount).toEqual(1)


  describe "observed events", ->

    beforeEach ->
      @initializeInterfaceSpy = spyOn(Mercury.PageEditor.prototype, 'initializeInterface').andCallFake(=>)
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})
      @pageEditor.document = $(document)
      @pageEditor.bindEvents()

    describe "custom event: initialize:frame", ->

      it "calls initializeFrame", ->
        @initializeFrameSpy = spyOn(Mercury.PageEditor.prototype, 'initializeFrame').andCallFake(=>)
        @setTimeoutSpy = spyOn(window, 'setTimeout').andCallFake((callback) -> callback())
        Mercury.trigger('initialize:frame')
        expect(@initializeFrameSpy.callCount).toEqual(1)
        expect(@setTimeoutSpy.callCount).toEqual(1)

    describe "custom event: focus:frame", ->

      it "calls focus on the iframe", ->
        callCount = 0
        @pageEditor.iframe = {focus: -> callCount += 1}
        Mercury.trigger('focus:frame')
        expect(callCount).toEqual(1)

    describe "custom event: focus:window", ->

      it "calls focus on a focusable element", ->
        callCount = 0
        @pageEditor.focusableElement = {focus: -> callCount += 1}
        @setTimeoutSpy = spyOn(window, 'setTimeout').andCallFake((callback) -> callback())
        Mercury.trigger('focus:window')
        expect(callCount).toEqual(1)

    describe "custom event: toggle:interface", ->

      it "calls toggleInterface", ->
        spy = spyOn(Mercury.PageEditor.prototype, 'toggleInterface').andCallFake(=>)
        Mercury.trigger('toggle:interface')
        expect(spy.callCount).toEqual(1)

    describe "custom event: action", ->

      it "calls save if the action was save", ->
        spy = spyOn(Mercury.PageEditor.prototype, 'save').andCallFake(=>)
        Mercury.trigger('action', {action: 'foo'})
        expect(spy.callCount).toEqual(0)

        Mercury.trigger('action', {action: 'save'})
        expect(spy.callCount).toEqual(1)

    describe "mousedown on document", ->

      beforeEach ->
        @triggerSpy = spyOn(Mercury, 'trigger').andCallFake(=>)

      it "triggers hide:dialogs", ->
        Mercury.region = {element: $('#region3')}
        jasmine.simulate.mousedown($('#anchor1r').get(0))
        expect(@triggerSpy.callCount).toEqual(1)
        expect(@triggerSpy.argsForCall[0]).toEqual(['hide:dialogs'])

      it "triggers unfocus:regions unless the event happened in a region", ->
        Mercury.region = {element: {get: -> null}}
        jasmine.simulate.mousedown(document)
        expect(@triggerSpy.callCount).toEqual(2)
        expect(@triggerSpy.argsForCall[1]).toEqual(['unfocus:regions'])

    describe "window resize", ->

      it "calls resize", ->
        # untestable
        #spy = spyOn(Mercury.PageEditor.prototype, 'resize').andCallFake(=>)
        #resizeTo($(window).width() - 1, $(window).height() - 1)
        #expect(spy.callCount).toEqual(1)

    describe "onbeforeunload", ->

      it "calls Mercury.beforeUnload", ->
        # untestable
        #spy = spyOn(Mercury, 'beforeUnload').andCallFake(=>)
        #window.onbeforeunload()
        #expect(spy.callCount).toEqual(1)


  describe "#toggleInterface", ->

    beforeEach ->
      spec = @
      spec.toolbarShowCallCount = 0
      spec.toolbarHideCallCount = 0
      spec.statusbarShowCallCount = 0
      spec.statusbarHideCallCount = 0
      Mercury.Toolbar = -> {toolbar: true, height: (-> 100), show: (=> spec.toolbarShowCallCount += 1), hide: (=> spec.toolbarHideCallCount += 1)}
      Mercury.Statusbar = -> {statusbar: true, top: (-> 500), show: (=> spec.statusbarShowCallCount += 1), hide: (=> spec.statusbarHideCallCount += 1)}
      Mercury.PageEditor.prototype.initializeFrame = ->
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})

    it "calls resize", ->
      spy = spyOn(Mercury.PageEditor.prototype, 'resize').andCallFake(=>)
      @pageEditor.toggleInterface()
      expect(spy.callCount).toEqual(1)

    it "triggers the mode event to toggle preview mode", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      @pageEditor.toggleInterface()
      expect(spy.callCount).toEqual(2)
      expect(spy.argsForCall[0]).toEqual(['mode', {mode: 'preview'}])
      expect(spy.argsForCall[1]).toEqual(['resize'])

    describe "when visible", ->

      beforeEach ->
        @pageEditor.visible = true

      it "sets visible to false", ->
        @pageEditor.toggleInterface()
        expect(@pageEditor.visible).toEqual(false)

      it "calls hide on the toolbar", ->
        @pageEditor.toggleInterface()
        expect(@toolbarHideCallCount).toEqual(1)

      it "calls hide on the statusbar", ->
        @pageEditor.toggleInterface()
        expect(@statusbarHideCallCount).toEqual(1)

    describe "when not visible", ->

      beforeEach ->
        @pageEditor.visible = false

      it "sets visible to true", ->
        @pageEditor.toggleInterface()
        expect(@pageEditor.visible).toEqual(true)

      it "calls show on the toolbar", ->
        @pageEditor.toggleInterface()
        expect(@toolbarShowCallCount).toEqual(1)

      it "calls show on the statusbar", ->
        @pageEditor.toggleInterface()
        expect(@statusbarShowCallCount).toEqual(1)


  describe "#resize", ->

    beforeEach ->
      Mercury.Toolbar = -> {toolbar: true, height: -> 100}
      Mercury.Statusbar = -> {statusbar: true, top: -> 500}
      Mercury.PageEditor.prototype.initializeFrame = ->
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})

    it "sets the display rectangle to displayRect", ->
      @pageEditor.resize()
      expect(Mercury.displayRect.top).toEqual(100)
      expect(Mercury.displayRect.height).toEqual(500 - 100)

    it "resizes the iframe", ->
      @pageEditor.resize()
      expect($('.mercury-iframe').css('top')).toEqual('100px')
      expect($('.mercury-iframe').css('height')).toEqual("#{500 - 100}px")

    it "triggers a resize event", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      @pageEditor.resize()
      expect(spy.callCount).toEqual(1)


  describe "#iframeSrc", ->

    beforeEach ->
      Mercury.PageEditor.prototype.initializeFrame = ->
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})

    it "takes the location and removes the /editor", ->
      expect(@pageEditor.iframeSrc('http://foo.com/editor/path')).toEqual('http://foo.com/path')


  describe "#hijackLinks", ->

    beforeEach ->
      Mercury.PageEditor.prototype.initializeFrame = ->
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})
      @pageEditor.options.ignoredLinks = ['lightview']
      @pageEditor.document = $(document)

    it "finds links and set their target to top if it's not already set", ->
      @pageEditor.hijackLinks()
      expect($('#anchor1').attr('target')).toEqual('_top')
      expect($('#anchor2').attr('target')).toEqual('_blank')
      expect($('#anchor3').attr('target')).toEqual('_top')
      expect($('#anchor4').attr('target')).toEqual('_top')

    it "ignores links in regions", ->
      @pageEditor.hijackLinks()
      expect($('#anchor1r').attr('target')).toEqual('_top')
      expect($('#anchor2r').attr('target')).toEqual('_blank')
      expect($('#anchor3r').attr('target')).toEqual('_self')
      expect($('#anchor4r').attr('target')).toBeUndefined()

    it "ignores links that are in the config to be ignored (by class)", ->
      @pageEditor.hijackLinks()
      expect($('#anchor5').attr('target')).toEqual('_self')


  describe "#beforeUnload", ->

    beforeEach ->
      Mercury.PageEditor.prototype.initializeInterface = ->
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})
      Mercury.silent = false
      Mercury.changes = true

    it "returns a message if changes were made", ->
      expect(@pageEditor.beforeUnload()).toEqual('You have unsaved changes.  Are you sure you want to leave without saving them first?')

      Mercury.changes = false
      expect(@pageEditor.beforeUnload()).toEqual(null)

    it "does nothing if in silent mode", ->
      Mercury.silent = true
      expect(@pageEditor.beforeUnload()).toEqual(null)


  describe "#save", ->

    beforeEach ->
      Mercury.PageEditor.prototype.initializeInterface = ->
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})
      @iframeSrcSpy = spyOn(Mercury.PageEditor.prototype, 'iframeSrc').andCallFake(=> '/foo/baz')
      @ajaxSpy = spyOn($, 'ajax')

    it "makes an ajax request", ->
      @ajaxSpy.andCallFake(=>)
      @pageEditor.save()
      expect(@ajaxSpy.callCount).toEqual(1)

    it "uses the save url passed in via options, the configured save url, or the iframe src", ->
      @ajaxSpy.andCallFake(=>)
      @pageEditor.saveUrl = '/foo/bar'
      @pageEditor.save()
      expect(@ajaxSpy.argsForCall[0][0]).toEqual('/foo/bar')

      @pageEditor.saveUrl = null
      Mercury.saveURL = '/foo/bit'
      @pageEditor.save()
      expect(@ajaxSpy.argsForCall[1][0]).toEqual('/foo/bit')

      @pageEditor.saveUrl = null
      Mercury.saveURL = null
      @pageEditor.save()
      expect(@ajaxSpy.argsForCall[2][0]).toEqual('/foo/baz')

    it "serializes the data in json", ->
      @ajaxSpy.andCallFake(=>)
      Mercury.config.saveStyle = 'json'
      spy = spyOn(Mercury.PageEditor.prototype, 'serialize').andCallFake(=> {region1: 'region1'})
      @pageEditor.save()
      expect(@ajaxSpy.argsForCall[0][1]['data']).toEqual({content: '{"region1":"region1"}' })

    it "can serialize as form values", ->
      @ajaxSpy.andCallFake(=>)
      @pageEditor.options.saveStyle = 'form'
      spy = spyOn(Mercury.PageEditor.prototype, 'serialize').andCallFake(=> {region1: 'region1'})
      @pageEditor.save()
      expect(@ajaxSpy.argsForCall[0][1]['data']).toEqual({content: {region1: 'region1'}})

    describe "on successful ajax request", ->

      beforeEach ->
        @ajaxSpy.andCallFake((url, options) => options.success('data') )

      it "sets changes back to false", ->
        Mercury.changes = true
        @pageEditor.save()
        expect(Mercury.changes).toEqual(false)

    describe "on failed ajax request", ->

      beforeEach ->
        @ajaxSpy.andCallFake((url, options) => options.error() )

      it "alerts with the url", ->
        spy = spyOn(window, 'alert').andCallFake(=>)
        @pageEditor.saveUrl = '/foo/bar'
        @pageEditor.save()
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual(['Mercury was unable to save to the url: /foo/bar'])


  describe "#serialize", ->

    beforeEach ->
      Mercury.PageEditor.prototype.initializeInterface = ->
      @pageEditor = new Mercury.PageEditor('', {appendTo: $('#test')})
      @pageEditor.regions = [
        {name: 'region1', serialize: -> 'region1'},
        {name: 'region2', serialize: -> 'region2'}
      ]

    it "returns an object with the region name, and it's serialized value", ->
      ret = @pageEditor.serialize()
      expect(ret).toEqual({region1: 'region1', region2: 'region2'})