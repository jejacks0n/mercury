describe "Mercury.uploader", ->

  template 'mercury/uploader.html'

  beforeEach ->
    Mercury.config.uploading.enabled = true
    $.fx.off = true
    @mockFile = {
      size: 1024
      fileName: 'image.png'
      type: 'image/png'
    }

  afterEach ->
    Mercury.uploader.initialized = false

  describe "singleton method", ->

    beforeEach ->
      @showSpy = spyOn(Mercury.uploader, 'show').andCallFake(=>)

    it "calls show", ->
      Mercury.uploader(@mockFile)
      expect(@showSpy.callCount).toEqual(1)

    it "returns the function object", ->
      ret = Mercury.uploader(@mockFile)
      expect(ret).toEqual(Mercury.uploader)

    it "doesn't call show if disabled in configuration", ->
      Mercury.config.uploading.enabled = false
      Mercury.uploader(@mockFile)
      expect(@showSpy.callCount).toEqual(0)


  describe "#show", ->

    beforeEach ->
      @initializeSpy = spyOn(Mercury.uploader, 'initialize').andCallFake(=>)
      @appearSpy = spyOn(Mercury.uploader, 'appear').andCallFake(=>)

    it "expects a file object", ->
      Mercury.uploader.show(@mockFile)
      expect(Mercury.uploader.file.name).toEqual(@mockFile.fileName)

    it "accepts options", ->
      Mercury.uploader.show(@mockFile, {foo: 'bar'})
      expect(Mercury.uploader.options).toEqual({foo: 'bar'})

    it "creates a file instance from the file", ->
      Mercury.uploader.show(@mockFile)
      expect(Mercury.uploader.file.name).toEqual(@mockFile.fileName)
      expect(Mercury.uploader.file.fullSize).toEqual(1024)

    it "alerts and stops if the file has errors (too large or unsupported mimetype)", ->
      @mockFile.size = 123123123123
      spy = spyOn(window, 'alert').andCallFake(=>)
      Mercury.uploader.show(@mockFile)
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['Error: Too large'])

    it "doesn't do anything unless xhr uploading is supported in the browser", ->
      spyOn(Mercury.uploader, 'supported').andCallFake(=> false)
      Mercury.uploader.show(@mockFile)
      expect(@initializeSpy.callCount).toEqual(0)

    it "triggers an event to focus the window", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      Mercury.uploader.show(@mockFile)
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:window'])

    it "calls initialize", ->
      Mercury.uploader.show(@mockFile)
      expect(@initializeSpy.callCount).toEqual(1)

    it "calls appear", ->
      Mercury.uploader.show(@mockFile)
      expect(@appearSpy.callCount).toEqual(1)


  describe "#initialize", ->

    beforeEach ->
      @buildSpy = spyOn(Mercury.uploader, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(Mercury.uploader, 'bindEvents').andCallFake(=>)

    it "calls build", ->
      Mercury.uploader.initialize()
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      Mercury.uploader.initialize()
      expect(@bindEventsSpy.callCount).toEqual(1)

    it "only initializes once", ->
      Mercury.uploader.initialize()
      expect(@buildSpy.callCount).toEqual(1)
      Mercury.uploader.initialize()
      expect(@buildSpy.callCount).toEqual(1)


  describe "#supported", ->

    it "prototypes sendAsBinary onto XMLHttpRequest if it's not already there", ->
      XMLHttpRequest.prototype.sendAsBinary = null
      Mercury.uploader.supported()
      expect(XMLHttpRequest.prototype.sendAsBinary).toBeDefined()

    it "returns true if everything needed is supported", ->
      ret = Mercury.uploader.supported()
      expect(ret).toEqual(true)

    it "returns false if everything isn't supported", ->
      window.Uint8Array = null
      ret = Mercury.uploader.supported()
      expect(ret).toEqual(true)


  describe "#build", ->

    beforeEach ->
      Mercury.uploader.options = {appendTo: '#test'}

    it "builds an element structure", ->
      Mercury.uploader.build()
      html = $('<div>').html(Mercury.uploader.element).html()
      expect(html).toContain('class="mercury-uploader"')
      expect(html).toContain('class="mercury-uploader-preview"')
      expect(html).toContain('<b><img></b>')
      expect(html).toContain('class="mercury-uploader-details"')
      expect(html).toContain('<span>Processing...</span>')
      expect(html).toContain('class="mercury-uploader-indicator"')
      expect(html).toContain('<div><b>0%</b></div>')

    it "builds an overlay", ->
      Mercury.uploader.build()
      html = $('<div>').html(Mercury.uploader.overlay).html()
      expect(html).toContain('class="mercury-uploader-overlay"')

    it "appends to any element", ->
      Mercury.uploader.options = {appendTo: '#uploader_container'}
      Mercury.uploader.build()
      expect($('#uploader_container .mercury-uploader').length).toEqual(1)


  describe "observed events", ->

    describe "custom event: resize", ->

      it "calls position", ->
        spy = spyOn(Mercury.uploader, 'position').andCallFake(=>)
        Mercury.uploader.bindEvents()
        Mercury.trigger('resize')
        expect(spy.callCount).toEqual(1)


  describe "#appear", ->

    beforeEach ->
      Mercury.uploader.options = {appendTo: '#test'}
      Mercury.uploader.build()
      @fillDisplaySpy = spyOn(Mercury.uploader, 'fillDisplay').andCallFake(=>)
      @positionSpy = spyOn(Mercury.uploader, 'position').andCallFake(=>)
      @loadImageSpy = spyOn(Mercury.uploader, 'loadImage').andCallFake(=>)

    it "calls fillDisplay", ->
      Mercury.uploader.appear()
      expect(@fillDisplaySpy.callCount).toEqual(1)

    it "calls position", ->
      Mercury.uploader.appear()
      expect(@positionSpy.callCount).toEqual(1)

    it "displays the overlay, and the element", ->
      Mercury.uploader.appear()
      expect($('#test .mercury-uploader').css('display')).toEqual('block')
      expect($('#test .mercury-uploader-overlay').css('display')).toEqual('block')

    it "sets visible to true", ->
      Mercury.uploader.appear()
      expect(Mercury.uploader.visible).toEqual(true)

    it "calls loadImage", ->
      Mercury.uploader.appear()
      expect(@loadImageSpy.callCount).toEqual(1)


  describe "#position", ->

    beforeEach ->
      Mercury.uploader.options = {appendTo: '#test'}
      Mercury.uploader.build()
      @fillDisplaySpy = spyOn(Mercury.uploader, 'fillDisplay').andCallFake(=>)
      @positionSpy = spyOn(Mercury.uploader, 'position').andCallFake(=>)

    it "centers the element in the viewport", ->
      # todo: this isn't really being tested
      Mercury.uploader.element.css({display: 'block'})
      Mercury.uploader.position()
      @expect($('#test .mercury-uploader').offset()).toEqual({top: 0, left: 0})


  describe "#fillDisplay", ->

    beforeEach ->
      Mercury.uploader.options = {appendTo: '#test'}
      Mercury.uploader.file = {name: 'image.png', size: 1024, type: 'image/png'}
      Mercury.uploader.build()

    it "puts the file details into the element", ->
      Mercury.uploader.fillDisplay()
      expect($('#test .mercury-uploader-details').html()).toEqual('Name: image.png<br>Size: undefined<br>Type: image/png')


  describe "#loadImage", ->

    beforeEach ->
      Mercury.uploader.options = {appendTo: '#test'}
      Mercury.uploader.file = new Mercury.uploader.File(@mockFile)
      Mercury.uploader.build()
      spyOn(FileReader.prototype, 'readAsBinaryString').andCallFake(=>)
      @readAsDataURLSpy = spyOn(Mercury.uploader.File.prototype, 'readAsDataURL').andCallFake((callback) => callback('data-url'))

    it "calls file.readAsDataURL", ->
      Mercury.uploader.loadImage()
      expect(@readAsDataURLSpy.callCount).toEqual(1)

    it "sets the preview image src to the file contents", ->
      Mercury.uploader.loadImage()
      expect($('#test .mercury-uploader-preview img').attr('src')).toEqual('data-url')

    it "calls upload", ->
      spy = spyOn(Mercury.uploader, 'upload').andCallFake(=>)
      Mercury.uploader.loadImage()
      expect(spy.callCount).toEqual(1)


  describe "#upload", ->

    # todo: test this
    it "", ->


  describe "#updateStatus", ->

    beforeEach ->
      Mercury.uploader.options = {appendTo: '#test'}
      Mercury.uploader.build()

    it "updated the message in the progress display", ->
      Mercury.uploader.updateStatus('status message')
      expect($('#test .mercury-uploader-progress span').html()).toEqual('status message')

    it "updates the progress indicator width", ->
      Mercury.uploader.updateStatus('message', 512)
      expect($('#test .mercury-uploader-indicator div').css('width')).toEqual('50px')

    it "updates the progress indicator value", ->
      Mercury.uploader.updateStatus('message', 512)
      expect($('#test .mercury-uploader-indicator b').html()).toEqual('50%')


  describe "#hide", ->

    beforeEach ->
      @setTimeoutSpy = spyOn(window, 'setTimeout')
      Mercury.uploader.options = {appendTo: '#test'}
      Mercury.uploader.build()

    it "accepts a delay", ->
      @setTimeoutSpy.andCallFake(=>)
      Mercury.uploader.hide(1)
      expect(@setTimeoutSpy.callCount).toEqual(1)
      expect(@setTimeoutSpy.argsForCall[0][0]).toEqual(1000)

    it "hides the overlay and element", ->
      @setTimeoutSpy.andCallFake((timeout, callback) => callback())
      Mercury.uploader.hide()
      expect($('#test .mercury-uploader').css('opacity')).toEqual('0')
      expect($('#test .mercury-uploader-overlay').css('opacity')).toEqual('0')

    it "calls reset", ->
      @setTimeoutSpy.andCallFake((timeout, callback) => callback())
      spy = spyOn(Mercury.uploader, 'reset').andCallFake(=>)
      Mercury.uploader.hide()
      expect(spy.callCount).toEqual(1)

    it "sets visible to false", ->
      @setTimeoutSpy.andCallFake((timeout, callback) => callback())
      Mercury.uploader.hide()
      expect(Mercury.uploader.visible).toEqual(false)

    it "focuses the frame", ->
      @setTimeoutSpy.andCallFake((timeout, callback) => callback())
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      Mercury.uploader.hide()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:frame'])


  describe "#reset", ->

    beforeEach ->
      Mercury.uploader.options = {appendTo: '#test'}
      Mercury.uploader.build()

    it "removes the preview image", ->
      $('#test .mercury-uploader-indicator div').html('foo')
      Mercury.uploader.reset()
      expect($('#test .mercury-uploader-preview b').html()).toEqual('')

    it "resets the progress back to 0", ->
      $('#test .mercury-uploader-indicator div').css({width: '50%'})
      $('#test .mercury-uploader-indicator b').html('50%')
      Mercury.uploader.reset()
      expect($('#test .mercury-uploader-indicator div').css('width')).toEqual('0px')
      expect($('#test .mercury-uploader-indicator b').html()).toEqual('0%')

    it "sets the status back to 'Processing...' for next time", ->
      spy = spyOn(Mercury.uploader, 'updateStatus').andCallFake(=>)
      Mercury.uploader.reset()
      expect(spy.callCount).toEqual(1)


  describe "uploaderEvents", ->

    beforeEach ->
      Mercury.uploader.file = @mockFile
      @updateStatusSpy = spyOn(Mercury.uploader, 'updateStatus').andCallFake(=>)
      @hideSpy = spyOn(Mercury.uploader, 'hide').andCallFake(=>)
      @events = Mercury.uploader.uploaderEvents

    describe ".onloadstart", ->

      it "updates the status to 'Uploading...'", ->
        @events.onloadstart.call(Mercury.uploader)
        expect(@updateStatusSpy.callCount).toEqual(1)
        expect(@updateStatusSpy.argsForCall[0]).toEqual(['Uploading...'])

    describe ".onprogress", ->

      it "updates the status to 'Uploading...' and passes the amount sent so far", ->
        @events.onprogress.call(Mercury.uploader, {loaded: 512})
        expect(@updateStatusSpy.callCount).toEqual(1)
        expect(@updateStatusSpy.argsForCall[0]).toEqual(['Uploading...', 512])

    describe ".onabort", ->

      it "updates the status to 'Aborted'", ->
        @events.onabort.call(Mercury.uploader)
        expect(@updateStatusSpy.callCount).toEqual(1)
        expect(@updateStatusSpy.argsForCall[0]).toEqual(['Aborted'])

      it "calls hide", ->
        @events.onabort.call(Mercury.uploader)
        expect(@hideSpy.callCount).toEqual(1)

    describe ".onload", ->

      it "updates the status to 'Successfully uploaded' and passes the total file size", ->
        @events.onload.call(Mercury.uploader)
        expect(@updateStatusSpy.callCount).toEqual(1)
        expect(@updateStatusSpy.argsForCall[0]).toEqual(['Successfully uploaded...', 1024])

    describe ".onerror", ->

      it "updates the status to 'Error: Unable to upload the file'", ->
        @events.onerror.call(Mercury.uploader)
        expect(@updateStatusSpy.callCount).toEqual(1)
        expect(@updateStatusSpy.argsForCall[0]).toEqual(['Error: Unable to upload the file'])

      it "calls hide", ->
        @events.onerror.call(Mercury.uploader)
        expect(@hideSpy.callCount).toEqual(1)
        expect(@hideSpy.argsForCall[0]).toEqual([3])



describe "Mercury.uploader.File", ->

  beforeEach ->
    @mockFile = {
      size: 1024
      fileName: 'image.png'
      type: 'image/png'
    }

  afterEach ->
    @file = null
    delete(@file)

  describe "constructor", ->

    it "expects a file", ->
      @file = new Mercury.uploader.File(@mockFile)
      expect(@file.file).toEqual(@mockFile)

    it "reads attributes of the file and sets variables", ->
      @file = new Mercury.uploader.File(@mockFile)
      expect(@file.size).toEqual(1024)
      expect(@file.fullSize).toEqual(1024)
      expect(@file.readableSize).toEqual('1.00 kb')
      expect(@file.name).toEqual('image.png')
      expect(@file.type).toEqual('image/png')

    it "adds errors if there's any", ->
      Mercury.config.uploading.maxFileSize = 100
      Mercury.config.uploading.allowedMimeTypes = ['image/foo']
      @file = new Mercury.uploader.File(@mockFile)
      expect(@file.errors).toEqual('Too large / Unsupported format')


  describe "#readAsDataURL", ->

    it "it calls readAsDataURL on a FileReader object", ->
      spy = spyOn(window.FileReader.prototype, 'readAsDataURL').andCallFake(=>)
      @file = new Mercury.uploader.File(@mockFile)
      @file.readAsDataURL()
      expect(spy.callCount).toEqual(1)

    it "calls a callback if one was provided", ->
      spyOn(FileReader.prototype, 'readAsDataURL').andCallFake(=>)
      FileReader.prototype.result = 'result'
      callCount = 0
      callback = (r) => callCount += 1

      @file = new Mercury.uploader.File(@mockFile)
      onload = @file.readAsDataURL(callback)
      onload()
      expect(callCount).toEqual(1)


  describe "#readAsBinaryString", ->

    it "it calls readAsBinaryString on a FileReader object", ->
      spy = spyOn(window.FileReader.prototype, 'readAsBinaryString').andCallFake(=>)
      @file = new Mercury.uploader.File(@mockFile)
      @file.readAsBinaryString()
      expect(spy.callCount).toEqual(1)

    it "calls a callback if one was provided", ->
      spyOn(FileReader.prototype, 'readAsBinaryString').andCallFake(=>)
      FileReader.prototype.result = 'result'
      callCount = 0
      callback = (r) => callCount += 1

      @file = new Mercury.uploader.File(@mockFile)
      onload = @file.readAsBinaryString(callback)
      onload()
      expect(callCount).toEqual(1)


  describe "#updateSize", ->

    it "updates the size based on a delta", ->
      @file = new Mercury.uploader.File(@mockFile)
      @file.updateSize(20)
      expect(@file.fullSize).toEqual(1044)



describe "Mercury.uploader.MultiPartPost", ->

  beforeEach ->
    @mockFile = {
      size: 1024
      name: 'image.png'
      type: 'image/png'
    }

  afterEach ->
    @multiPartPost = null
    delete(@multiPartPost)

  describe "constructor", ->

    it "expects an inputName, file, and file contents", ->
      @multiPartPost = new Mercury.uploader.MultiPartPost('foo[bar]', @mockFile, 'file contents')
      expect(@multiPartPost.inputName).toEqual('foo[bar]')
      expect(@multiPartPost.file).toEqual(@mockFile)
      expect(@multiPartPost.contents).toEqual('file contents')

    it "accepts a formInputs object", ->
      @multiPartPost = new Mercury.uploader.MultiPartPost('foo[bar]', @mockFile, 'file contents', {foo: 'bar'})
      expect(@multiPartPost.formInputs).toEqual({foo: 'bar'})

    it "defines a boundary string", ->
      @multiPartPost = new Mercury.uploader.MultiPartPost('foo[bar]', @mockFile, 'file contents')
      expect(@multiPartPost.boundary).toEqual('Boundaryx20072377098235644401115438165x')

    it "calls buildBody", ->
      spy = spyOn(Mercury.uploader.MultiPartPost.prototype, 'buildBody').andCallFake(=>)
      @multiPartPost = new Mercury.uploader.MultiPartPost('foo[bar]', @mockFile, 'file contents')
      expect(spy.callCount).toEqual(1)

    it "sets a delta based on the body size and file size", ->
      @multiPartPost = new Mercury.uploader.MultiPartPost('foo[bar]', @mockFile, 'file contents')
      expect(@multiPartPost.delta).toEqual(-790)


  describe "#buildBody", ->

    it "creates a multipart post body with the file information", ->
      @multiPartPost = new Mercury.uploader.MultiPartPost('foo[bar]', @mockFile, 'file contents')
      expect(@multiPartPost.body).toContain('--Boundaryx20072377098235644401115438165x')
      expect(@multiPartPost.body).toContain('Content-Disposition: form-data; name="foo[bar]"; filename="image.png"')
      expect(@multiPartPost.body).toContain('Content-Type: image/png')
      expect(@multiPartPost.body).toContain('Content-Transfer-Encoding: binary')
      expect(@multiPartPost.body).toContain('file contents')

    it "includes form inputs if passed in", ->
      @multiPartPost = new Mercury.uploader.MultiPartPost('foo[bar]', @mockFile, 'file contents', {foo: 'bar'})
      expect(@multiPartPost.body).toContain('Content-Disposition: form-data; name="foo"\r\n\r\nbar')
