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


  describe "#value", ->

    it "sets the value if the value isn't null or undefined", ->
      subject.value('/teabag/fixtures/foo.gif')
      expect( subject.el.attr('src') ).to.eq('/teabag/fixtures/foo.gif')

    it "returns the value if the value wasn't provided", ->
      subject.el.attr(src: '/teabag/fixtures/image.gif')
      expect( subject.value() ).to.eq('/teabag/fixtures/image.gif')


  describe "#setAlignment", ->

    it "sets the data and align attribute", ->
      subject.setAlignment('left')
      expect( subject.el.data('align') ).to.eq('left')
      expect( subject.el.attr('align') ).to.eq('left')


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
      spyOn(subject, 'setAlignment')

    describe "#alignLeft", ->

      it "calls setAlignment", ->
        subject.handleAction('alignLeft')
        expect( subject.setAlignment ).calledWith('left')

    describe "#alignRight", ->

      it "calls setAlignment", ->
        subject.handleAction('alignRight')
        expect( subject.setAlignment ).calledWith('right')

    describe "#alignTop", ->

      it "calls setAlignment", ->
        subject.handleAction('alignTop')
        expect( subject.setAlignment ).calledWith('top')

    describe "#alignMiddle", ->

      it "calls setAlignment", ->
        subject.handleAction('alignMiddle')
        expect( subject.setAlignment ).calledWith('middle')

    describe "#alignBottom", ->

      it "calls setAlignment", ->
        subject.handleAction('alignBottom')
        expect( subject.setAlignment ).calledWith('bottom')

    describe "#alignNone", ->

      it "calls setAlignment", ->
        subject.handleAction('alignNone')
        expect( subject.setAlignment ).calledWith(null)

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
        subject.el.attr(align: 'left')
        expect( subject.hasContext('alignLeft') ).to.be.true

      it "returns false when not aligned left", ->
        subject.el.attr(align: 'right')
        expect( subject.hasContext('alignLeft') ).to.be.false

    describe "#alignRight", ->

      it "returns true when aligned right", ->
        subject.el.attr(align: 'right')
        expect( subject.hasContext('alignRight') ).to.be.true

      it "returns false when not aligned right", ->
        subject.el.attr(align: 'left')
        expect( subject.hasContext('alignRight') ).to.be.false

    describe "#alignTop", ->

      it "returns true when aligned top", ->
        subject.el.attr(align: 'top')
        expect( subject.hasContext('alignTop') ).to.be.true

      it "returns false when not aligned top", ->
        subject.el.attr(align: 'left')
        expect( subject.hasContext('alignTop') ).to.be.false

    describe "#alignMiddle", ->

      it "returns true when aligned middle", ->
        subject.el.attr(align: 'middle')
        expect( subject.hasContext('alignMiddle') ).to.be.true

      it "returns false when not aligned middle", ->
        subject.el.attr(align: 'left')
        expect( subject.hasContext('alignMiddle') ).to.be.false

    describe "#alignBottom", ->

      it "returns true when aligned bottom", ->
        subject.el.attr(align: 'bottom')
        expect( subject.hasContext('alignBottom') ).to.be.true

      it "returns false when not aligned bottom", ->
        subject.el.attr(align: 'left')
        expect( subject.hasContext('alignBottom') ).to.be.false

    describe "#alignNone", ->

      it "returns true when aligned bottom", ->
        expect( subject.hasContext('alignNone') ).to.be.true

      it "returns false when not aligned bottom", ->
        subject.el.attr(align: 'left')
        expect( subject.hasContext('alignNone') ).to.be.false
