#= require spec_helper
#= require mercury/views/uploader

describe "Mercury.Uploader", ->

  Klass = Mercury.Uploader
  subject = null

  beforeEach ->
    Mercury.configure 'uploading:maxSize', 2048
    Klass.supported = true
    spyOn(Klass::, 'delay')
    spyOn(Klass::, 'show')
    subject = new Klass()
    subject.delay.reset()
    subject.delay.yieldsOn(subject)
    @files = [
      {name: '_file1_', size: 1024, type: 'image/jpg'}
      {name: '_file2_', size: 2048, type: 'foo/bar'}
    ]

  describe "#constructor", ->

    beforeEach ->
      spyOn(Klass::, 'build')
      spyOn(Klass::, 'calculate', -> [1])
      spyOn(Klass::, 'upload')
      spyOn(Klass::, 'notify')

    it "notifies if it's not supported", ->
      Klass.supported = false
      subject = new Klass()
      expect( subject.notify ).calledWith('is unsupported in this browser')

    it "renders the expected template", ->
      template = spyOn(JST, '/mercury/templates/uploader', -> '_template_')
      subject = new Klass([], foo: 'bar')
      expect( template ).calledWith( subject )
      expect( subject.el.html() ).to.eq('_template_')

    it "calls #calculate", ->
      subject = new Klass([1, 2])
      expect( subject.calculate ).calledWith([1, 2])

    it "calls #show", ->
      subject = new Klass()
      expect( subject.show ).called

    it "delays calling #upload for half a second", ->
      subject = new Klass()
      expect( subject.delay ).calledWith(500, Klass::upload)

    it "returns without calling show unless there are files", ->
      Klass::calculate.restore()
      spyOn(Klass::, 'calculate', -> [])
      subject = new Klass()
      expect( subject.show ).not.called


  describe "#calculate", ->

    beforeEach ->
      spyOn(subject, 'upload')
      @valid = true
      spyOn(Mercury.Model.File::, 'isValid', => @valid)

    it "creates an array of @files", ->
      subject.calculate(@files)
      expect( subject.files.length ).to.eq(2)

    it "calculates the total size of all files", ->
      subject.calculate(@files)
      expect( subject.total ).to.eq(3072)

    it "alerts the user if the file isn't valid", ->
      @valid = false
      spyOn(window, 'alert')
      subject.calculate(@files)
      expect( window.alert ).calledWith('Error uploading _file1_: ')
      expect( window.alert ).calledWith('Error uploading _file2_: ')

    it "skips files that aren't valid", ->
      @valid = false
      spyOn(window, 'alert')
      subject.calculate(@files)
      expect( subject.total ).to.eq(0)

    it "returns @files", ->
      expect( subject.calculate([]) ).to.eq(subject.files)

    it "passes @mimeTypes for validation", ->
      subject.mimeTypes = ['bar/baz']
      subject.calculate(@files)
      expect( subject.files[0].options.mimeTypes ).to.eql(subject.mimeTypes)


  describe "#build", ->

    beforeEach ->
      subject = new Klass()

    it "appends to the mercury element", ->
      subject.build()
      expect( $('.mercury-uploader', Mercury.interface).html() ).to.include('mercury-uploader-dialog')


  describe "#show", ->

    beforeEach ->
      subject.show.restore()

    it "calls #update", ->
      spyOn(subject, 'update')
      subject.show()
      expect( subject.update ).calledWith('Processing...')

    it "animates the css (in a delay)", ->
      subject.show()
      expect( subject.delay ).calledWith(50, sinon.match.func)
      expect( subject.el.css('opacity') ).to.eq('1')


  describe "#release", ->

    it "delays a given number of milliseconds", ->
      subject.release(100)
      expect( subject.delay ).calledWith(100)

    it "sets the opacity to 0", ->
      subject.release()
      expect( subject.el.css('opacity') ).to.eq('0')

    it "calls super", ->
      sup = spyOn(Klass.__super__, 'release')
      subject.release()
      expect( subject.delay ).calledWith(250)
      expect( sup ).called


  describe "#upload", ->

    beforeEach ->
      spyOn(subject, 'loadDetails')
      @xhr = xhr = {success: stub(), error: stub()}
      @file1 = save: -> xhr
      @file2 = save: -> xhr
      subject.files = [@file1, @file2]

    it "returns and releases if there's no files left", ->
      spyOn(subject, 'release', -> '_return_')
      subject.files = []
      expect( subject.upload() ).to.eq('_return_')
      expect( subject.release ).calledWith(500)

    it "gets the first file from the @file array", ->
      subject.upload()
      expect( subject.files.length ).to.eq(1)
      expect( subject.file ).to.eq(@file1)

    it "calls #update", ->
      spyOn(subject, 'update')
      subject.upload()
      expect( subject.update ).calledWith('Uploading...')

    it "calls save on the file with our upload event handlers", ->
      spyOn(@file1, 'save')
      spyOn(subject, 'uploadEvents', -> '_upload_events_')
      subject.upload()
      expect( @file1.save ).calledWith(uploadEvents: '_upload_events_')

    it "adds success and error handlers", ->
      spyOn(subject, 'success')
      spyOn(subject, 'error')
      @xhr.success.yields()
      @xhr.error.yields()
      subject.upload()
      expect( @xhr.success ).called
      expect( subject.success ).called
      expect( @xhr.error ).called
      expect( subject.error ).called


  describe "#update", ->

    it "updates the status element with the message", ->
      subject.update('_message_')
      expect( subject.status.html() ).to.eq('_message_')

    it "calculates the percentage loaded and updates the indicator", ->
      subject.loaded = 10
      subject.total = 100
      subject.update(null, 10)
      expect( subject.percent.html() ).to.eq('20%')
      expect( subject.indicator.css('width') ).to.eq('20%')


  describe "#loadDetails", ->

    beforeEach ->
      subject.file =
        get: (attr) ->
          return '_name_' if attr == 'name'
          return '_type_' if attr == 'type'
        readableSize: -> '42.00 kb'
        isImage: -> false
        readAsDataURL: spy()

    it "it updates the details element with the file details", ->
      subject.loadDetails()
      expect( subject.details.html() ).to.eq('Name: _name_<br>Type: _type_<br>Size: 42.00 kb')

    it "loads a preview if the file is an image", ->
      subject.file.isImage = -> true
      subject.loadDetails()
      subject.file.readAsDataURL.callArg(0, '/teabag/fixtures/image.gif')
      expect( subject.preview.html() ).to.eq('<img src="/teabag/fixtures/image.gif">')


  describe "#success", ->

    beforeEach ->
      spyOn(subject, 'upload')
      subject.file =
        get: (attr) -> 1024

    it "triggers an uploaded event", ->
      spyOn(subject, 'trigger')
      subject.success()
      expect( subject.trigger ).calledWith('uploaded', subject.file)

    it "adds the file size to what we've loaded", ->
      subject.success()
      expect( subject.loaded ).to.eq(1024)

    it "calls #update", ->
      spyOn(subject, 'update')
      subject.success()
      expect( subject.update ).calledWith('Successfully uploaded...')

    it "calls #upload (to continue with the next file)", ->
      subject.success()
      expect( subject.upload ).called


  describe "#error", ->

    beforeEach ->
      spyOn(subject, 'upload')

    it "calls #update", ->
      spyOn(subject, 'update')
      subject.error()
      expect(subject.update).calledWith('Error: Unable to upload the file')

    it "delays calling #upload for 3 seconds", ->
      subject.error()
      expect( subject.delay ).calledWith(3000, subject.upload)
      expect( subject.upload ).called


  describe "#uploadEvents", ->

    it "returns an object of upload event handlers", ->
      expect( subject.uploadEvents() ).to.have.keys(['progress'])

    describe "#progress", ->

      beforeEach ->
        @progress = subject.uploadEvents().progress

      it "calls #update", ->
        spyOn(subject, 'update')
        @progress(loaded: 20)
        expect( subject.update ).calledWith('Uploading...', 20)

      it "shows the percent element", ->
        @progress({})
        expect( subject.percent.css('display') ).to.not.eq('none')

