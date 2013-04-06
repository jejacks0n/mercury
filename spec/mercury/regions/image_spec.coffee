#= require spec_helper
#= require mercury/views/uploader
#= require mercury/core/region
#= require mercury/regions/modules/drop_indicator
#= require mercury/regions/modules/drop_item
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
    expect( subject.events ).to.have.keys(['mousedown'])


  describe "#afterBuild", ->

    it "sets the data to whatever the align attribute is (or null)", ->
      spyOn(subject, 'data')
      subject.el.attr(align: 'foo')
      subject.afterBuild()
      expect( subject.data ).calledWith(align: 'foo')
      subject.el.removeAttr('align')
      subject.afterBuild()
      expect( subject.data ).calledWith(align: null)


  describe "#value", ->

    it "sets the value if the value isn't null or undefined", ->
      subject.value('/teabag/fixtures/foo.gif')
      expect( subject.el.attr('src') ).to.eq('/teabag/fixtures/foo.gif')

    it "returns the value if the value wasn't provided", ->
      subject.el.attr(src: '/teabag/fixtures/image.gif')
      expect( subject.value() ).to.eq('/teabag/fixtures/image.gif')


  describe "#setData", ->

    beforeEach ->
      spyOn(subject, 'attr')

    it "calls super", ->
      spyOn(Klass.__super__, 'setData')
      subject.setData()
      expect( Klass.__super__.setData ).called

    it "sets the align attribute", ->
      subject.setData(align: 'left')
      expect( subject.attr ).calledWith(align: 'left')


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


  describe "actions", ->

    beforeEach ->
      subject.focused = true
      spyOn(subject, 'data')

    describe "#alignLeft", ->

      it "calls setAlignment", ->
        subject.handleAction('alignLeft')
        expect( subject.data ).calledWith(align: 'left')

    describe "#alignRight", ->

      it "calls setAlignment", ->
        subject.handleAction('alignRight')
        expect( subject.data ).calledWith(align: 'right')

    describe "#alignTop", ->

      it "calls setAlignment", ->
        subject.handleAction('alignTop')
        expect( subject.data ).calledWith(align: 'top')

    describe "#alignMiddle", ->

      it "calls setAlignment", ->
        subject.handleAction('alignMiddle')
        expect( subject.data ).calledWith(align: 'middle')

    describe "#alignBottom", ->

      it "calls setAlignment", ->
        subject.handleAction('alignBottom')
        expect( subject.data ).calledWith(align: 'bottom')

    describe "#alignNone", ->

      it "calls setAlignment", ->
        subject.handleAction('alignNone')
        expect( subject.data ).calledWith(align: null)

    describe "#file", ->

      it "calls the image action", ->
        spyOn(subject, 'handleAction', false)
        subject.handleAction('file', new Mercury.Model.File(url: '/teabag/fixtures/image.gif', type: 'image/jpeg'))
        expect( subject.handleAction ).calledWith('image', url: '/teabag/fixtures/image.gif')

      it "does nothing if the file isn't an image", ->
        spyOn(subject, 'handleAction', false)
        subject.handleAction('file', new Mercury.Model.File(type: 'text/plain'))
        expect( subject.handleAction ).not.calledWith('image')

    describe "#image", ->

      it "sets the value to the url", ->
        spyOn(subject, 'value')
        subject.handleAction('image', url: '_url_')
        expect( subject.value ).calledWith('_url_')


  describe "context", ->

    describe "#alignLeft", ->

      it "returns true when aligned left", ->
        subject.data(align: 'left')
        expect( subject.hasContext('alignLeft') ).to.be.true

      it "returns false when not aligned left", ->
        subject.data(align: 'right')
        expect( subject.hasContext('alignLeft') ).to.be.false

    describe "#alignRight", ->

      it "returns true when aligned right", ->
        subject.data(align: 'right')
        expect( subject.hasContext('alignRight') ).to.be.true

      it "returns false when not aligned right", ->
        subject.data(align: 'left')
        expect( subject.hasContext('alignRight') ).to.be.false

    describe "#alignTop", ->

      it "returns true when aligned top", ->
        subject.data(align: 'top')
        expect( subject.hasContext('alignTop') ).to.be.true

      it "returns false when not aligned top", ->
        subject.data(align: 'left')
        expect( subject.hasContext('alignTop') ).to.be.false

    describe "#alignMiddle", ->

      it "returns true when aligned middle", ->
        subject.data(align: 'middle')
        expect( subject.hasContext('alignMiddle') ).to.be.true

      it "returns false when not aligned middle", ->
        subject.data(align: 'left')
        expect( subject.hasContext('alignMiddle') ).to.be.false

    describe "#alignBottom", ->

      it "returns true when aligned bottom", ->
        subject.data(align: 'bottom')
        expect( subject.hasContext('alignBottom') ).to.be.true

      it "returns false when not aligned bottom", ->
        subject.data(align: 'left')
        expect( subject.hasContext('alignBottom') ).to.be.false

    describe "#alignNone", ->

      it "returns true when aligned bottom", ->
        expect( subject.hasContext('alignNone') ).to.be.true

      it "returns false when not aligned bottom", ->
        subject.data(align: 'left')
        expect( subject.hasContext('alignNone') ).to.be.false
