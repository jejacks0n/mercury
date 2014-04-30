#= require spec_helper
#= require mercury/models/file

describe "Mercury.Model.File", ->

  Klass = Mercury.Model.File
  subject = null

  beforeEach ->
    @file = name: '_name_', type: 'image/jpeg', size: 1024
    subject = new Klass(@file)

  it "is defined correctly", ->
    expect( Klass.className ).to.eq('Mercury.Model.File')

  describe ".url", ->

    it "returns the configured url", ->
      Mercury.configure 'uploading:saveUrl', '/foo'
      expect( Klass.url() ).to.eq('/foo')


  describe "#constructor", ->

    it "assigns attributes from the file", ->
      subject = new Klass(@file)
      expect( subject.get('name') ).to.eq('_name_')
      expect( subject.get('type') ).to.eq('image/jpeg')
      expect( subject.get('size') ).to.eq(1024)
      expect( subject.get('url') ).to.be.null
      subject = new Klass(url: '_url_')
      expect( subject.get('url') ).to.eq('_url_')


  describe "#validate", ->

    beforeEach ->
      Mercury.configure 'uploading', maxSize: 2048, mimeTypes: ['foo/bar']

    it "ensures size is within allowed range", ->
      Mercury.configure 'uploading:maxSize', 0
      subject.validate()
      expect( subject.errors.size ).to.include('Too large (max 0 bytes)')

    it "ensures it's an allowed mimetype", ->
      subject.validate()
      expect( subject.errors.type ).to.include('Unsupported format (image/jpeg)')

    it "doesn't care about mimetypes if nothing was configured", ->
      Mercury.configure 'uploading:mimeTypes', null
      subject.validate()
      expect( subject.errors.type ).to.eq.undefined

    it "returns nothing if there's no errors", ->
      Mercury.configure 'uploading:mimeTypes', ['image/jpeg']
      subject.validate()
      expect( subject.errors ).to.eql({})

    it "allows mimeType configuration to be overridden", ->
      subject.options.mimeTypes = ['image/jpeg']
      subject.validate()
      expect( subject.errors ).to.eql({})


  describe "#readAsDataUrl", ->

    beforeEach ->
      spyOn(FileReader::, 'readAsDataURL', -> @onload())

    it "reads the file and calls the callback provided", ->
      callback = spy()
      subject.readAsDataURL()
      expect( callback ).not.called
      subject.readAsDataURL(callback)
      expect( callback ).called

    it "returns undefined if there's no FileReader", ->
      original = window.FileReader
      window.FileReader = null
      expect( subject.readAsDataURL() ).to.be.undefined
      window.FileReader = original


  describe "#localSrc", ->

    beforeEach ->
      @originalURL = window.URL
      window.URL = createObjectURL: -> 'some/url'

    afterEach ->
      window.URL = @originalURL

    it "attempts to get the url through URL.createObjectURL", ->
      subject.localSrc(callback = spy())
      expect( callback ).calledWith('some/url')

    it "falls back to calling #readAsDataURL", ->
      window.URL = {}
      spyOn(subject, 'readAsDataURL')
      subject.localSrc(callback = spy())
      expect( subject.readAsDataURL ).calledWith(callback)


  describe "#previewSrc", ->

    it "calls #localSrc with the callback", ->
      spyOn(subject, 'localSrc')
      subject.previewSrc(callback = spy())
      expect( subject.localSrc ).calledWith(callback)


  describe "#readableSize", ->

    it "returns the readable file size", ->
      expect( subject.readableSize() ).to.eq('1.00 kb')


  describe "#isImage", ->

    it "returns true when it looks like the mimetype is an image", ->
      expect( subject.isImage() ).to.be.true

    it "returns false when it's not an image", ->
      subject.set(type: 'foo/bar')
      expect( subject.isImage() ).to.be.false


  describe "#save", ->

    beforeEach ->
      Mercury.configure 'uploading:saveName', '_input_'
      spyOn(subject, 'toFormData', -> '_data_')
      @spy = spyOn(Klass.__super__, 'save')

    it "calls super with the expected options", ->
      subject.save()
      expect( @spy ).calledWith
        data        : '_data_'
        processData : false
        contentType : false
        dataType    : false
        xhr         : sinon.match.any

    it "passes options on to super", ->
      subject.save(foo: 'bar')
      expect( @spy ).calledWith
        foo         : 'bar'
        data        : '_data_'
        processData : false
        contentType : false
        dataType    : false
        xhr         : sinon.match.any

    it "sets a custom xml that will add upload events", ->
      mockXhr = upload: {}
      processSpy = spy()
      spyOn($.ajaxSettings, 'xhr', -> mockXhr)
      subject.save(uploadEvents: {process: processSpy})
      xhr = @spy.args[0][0]['xhr']()
      expect( xhr ).to.eq(mockXhr)
      expect( xhr.upload ).to.eql(onprocess: processSpy)


  describe "#toFormData", ->

    beforeEach ->
      Mercury.configure 'uploading:saveName', '_input_'
      spyOn(FormData::, 'append')

    it "returns undefined if there's no FormData", ->
      original = window.FormData
      window.FormData = null
      expect( subject.toFormData() ).to.be.undefined
      window.FormData = original

    it "creates a new FormData object and appends the file", ->
      subject.toFormData()
      expect( FormData::append ).calledWith('_input_', @file, '_name_')

    it "appends any additional params passed in the options", ->
      subject.options['params'] = {foo: 'bar'}
      subject.toFormData()
      expect( FormData::append ).calledWith('foo', 'bar')


  describe "#saveSuccess", ->

    it "notifies that there was no url if there wasn't one", ->
      spyOn(subject, 'notify')
      spyOn(subject, 't')
      subject.saveSuccess()
      expect( subject.t ).calledWith('Unable to process response: %s', 'no url')
      expect( subject.notify ).called

    it "does nothing if the model looks good (has a url)", ->
      spyOn(subject, 'notify')
      subject.set(url: '/foo')
      subject.saveSuccess()
      expect( subject.notify ).not.called
