#= require spec_helper
#= require mercury/views/uploader
#= require mercury/core/region
#= require mercury/regions/modules/drop_indicator
#= require mercury/regions/image

describe "Mercury.Region.Image", ->

  Klass = Mercury.Region.Image
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    subject = new Klass('<img id="foo">')

  it "is defined correctly", ->
    expect( Klass.className ).to.eq('Mercury.Region.Image')
    expect( Klass.type ).to.eq('image')
    expect( subject.tag ).to.eq('img')
    expect( subject.toolbars ).to.eql(['image'])
    expect( subject.events ).to.have.keys(['mousedown'])


  describe "#value", ->

    it "sets the value if the value isn't null or undefined", ->
      subject.value('/teabag/fixtures/foo.gif')
      expect( subject.el.attr('src') ).to.eq('/teabag/fixtures/foo.gif')

    it "returns the value if the value wasn't provided", ->
      subject.el.attr(src: '/teabag/fixtures/image.gif')
      expect( subject.value() ).to.eq('/teabag/fixtures/image.gif')


  describe "#onMousedown", ->

    beforeEach ->
      @e = preventDefault: spy()

    it "calls e.preventDefault", ->
      subject.onMousedown(@e)
      expect( @e.preventDefault ).called

    it "triggers a focus event on @el", ->
      spyOn(subject.el, 'trigger')
      subject.onMousedown(@e)
      expect( subject.el.trigger ).calledWith('focus')


  describe "#onDropFile", ->

    beforeEach ->
      Mercury.configure 'regions:image:mimeTypes', ['image/foo']

    it "instantiates a new uploader", ->
      spyOn(Mercury, 'Uploader', -> on: spy())
      subject.onDropFile([1, 2])
      expect(Mercury.Uploader).calledWith([1, 2], mimeTypes: ['image/foo'])

    it "calls #focus and #handleAction on the uploaded event", ->
      spyOn(Mercury, 'Uploader', -> on: stub().yieldsOn(subject, '_file_'))
      spyOn(subject, 'focus')
      spyOn(subject, 'handleAction')
      subject.onDropFile([1, 2])
      expect( subject.focus ).called
      expect( subject.handleAction ).calledWith('file', '_file_')


  describe "#onDropItem", ->

    beforeEach ->
      @e = preventDefault: spy()
      @data = getData: -> '<img src="/teabag/fixtures/image.gif"><meta>'

    it "prevents the default event", ->
      subject.onDropItem(@e, @data)
      expect( @e.preventDefault ).called

    it "calls #focus", ->
      spyOn(subject, 'focus')
      subject.onDropItem(@e, @data)
      expect( subject.focus ).called

    it "calls #handleAction", ->
      spyOn(subject, 'handleAction')
      subject.onDropItem(@e, @data)
      expect( subject.handleAction ).calledWith('image', url: '/teabag/fixtures/image.gif')

    it "does nothing if there's no url", ->
      @data.getData = -> null
      subject.onDropItem(@e, @data)
      expect( @e.preventDefault ).not.called


  describe "actions", ->

    beforeEach ->
      subject.focused = true

    describe "#file", ->

      it "sets the value to the file url", ->
        spyOn(subject, 'value')
        subject.handleAction('file', url: '_url_')
        expect( subject.value ).calledWith('_url_')

    describe "#image", ->

      it "sets the value to the url", ->
        spyOn(subject, 'value')
        subject.handleAction('image', url: '_url_')
        expect( subject.value ).calledWith('_url_')
