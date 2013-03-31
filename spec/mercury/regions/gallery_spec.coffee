#= require spec_helper
#= require mercury/views/uploader
#= require mercury/core/region
#= require mercury/regions/modules/drop_indicator
#= require mercury/regions/modules/drop_item
#= require mercury/regions/gallery

describe "Mercury.Region.Gallery", ->

  Klass = Mercury.Region.Gallery
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    subject = new Klass('<div id="foo">')

  it "is defined correctly", ->
    expect( Klass.className ).to.eq('Mercury.Region.Gallery')
    expect( Klass.type ).to.eq('gallery')
    expect( subject.skipHistoryOn ).to.eql(['undo', 'redo', 'next', 'prev', 'togglePlay'])
    expect( subject.toolbars ).to.eql(['gallery'])
    expect( subject.elements ).to.have.keys [
      'controls',
      'slides',
      'paginator'
      ]
    expect( subject.events ).to.have.keys [
      'click .mercury-gallery-region-controls li'
      ]

  describe "#constructor", ->

    it "sets some defaults", ->
      expect( subject.speed ).to.eq(3000)
      subject = new Klass('<div id="foo">', speed: 4000)
      expect( subject.speed ).to.eq(4000)

    it "calls #refresh", ->
      spyOn(Klass::, 'refresh')
      subject = new Klass('<div id="foo">', playing: false)
      expect( Klass::refresh ).calledWith(true)


  describe "#build", ->

    it "appends a slides element if one isn't present", ->
      subject.$('.slides').remove()
      subject.build()
      expect( subject.$('.slides').length ).to.eq(1)

    it "appends a paginator element if one isn't present", ->
      subject.$('.paginator').remove()
      subject.build()
      expect( subject.$('.paginator').length ).to.eq(1)


  describe "#value", ->

    it "cleans some elements before returning the html", ->
      subject.html('<div class="slide" style="display: none;"></div><div class="paginator">...</div>')
      expect( subject.value() ).to.match(/<div class="slide" style="display: block;\s?"><\/div><div class="paginator"><\/div>/)

    it "calls super when a value is passed", ->
      spyOn(Klass.__super__, 'value')
      subject.value('foo')
      expect( Klass.__super__.value ).calledWith('foo')


  describe "#refresh", ->

    beforeEach ->
      subject.slides.append('<div class="slide">')
      subject.slides.append('<div class="slide">')

    it "clears the @timeout", ->
      subject.timeout = '_timeout_'
      spyOn(window, 'clearTimeout')
      subject.refresh()
      expect( window.clearTimeout ).calledWith('_timeout_')

    it "hides all the images (and assigns to @images)", ->
      subject.refresh()
      expect( subject.$('.slide:nth-child(1)').css('display') ).to.eq('none')
      expect( subject.images.length ).to.eq(2)

    it "keeps the index to within the range", ->
      subject.index = 200
      subject.refresh()
      expect( subject.index ).to.eq(1)
      subject.index = -200
      subject.refresh()
      expect( subject.index ).to.eq(2)

    it "shows the current slide", ->
      subject.index = 1
      subject.refresh()
      expect( subject.$('.slide:nth-child(1)').css('display') ).to.eq('block')
      expect( subject.$('.slide:nth-child(2)').css('display') ).to.eq('none')

    it "calls #refreshPaginator", ->
      spyOn(subject, 'refreshPaginator')
      subject.refresh()
      expect( subject.refreshPaginator ).called

    it "calls #refreshControls when it should", ->
      spyOn(subject, 'refreshControls')
      subject.refresh(true)
      expect( subject.refreshControls ).called

    it "sets a @timeout that calls #nextSlide", ->
      spyOn(subject, 'delay').yieldsOn(subject)
      spyOn(subject, 'nextSlide')
      subject.refresh()
      expect( subject.delay ).calledWith(subject.speed, sinon.match.func)
      expect( subject.nextSlide ).called

    it "doesn't set a @timeout if paused", ->
      spyOn(subject, 'delay')
      subject.playing = false
      subject.refresh()
      expect( subject.delay ).not.called


  describe "#refreshPaginator", ->

    beforeEach ->
      subject.images = [1, 2]
      subject.index = 1

    it "sets the html of the paginator", ->
      spyOn(subject.paginator, 'html')
      subject.refreshPaginator()
      expect( subject.paginator.html ).calledWith('<span>&bull;</span><span>&bull;</span>')

    it "activates the correct page indicator", ->
      subject.refreshPaginator()
      expect( subject.paginator.find('span:nth-child(1)').is('.active') ).to.be.true


  describe "#refreshControls", ->

    beforeEach ->
      subject.images = [
        '<div class="slide"><img src="/teabag/fixtures/image.gif"></div>'
        '<div class="slide"><img src="/teabag/fixtures/foo.gif"></div>'
      ]

    it "removes the controls element", ->
      spyOn($.fn, 'remove')
      subject.refreshControls()
      expect( $.fn.remove ).called

    it "adds a new controls element", ->
      subject.refreshControls()
      expect( subject.$('ul').length ).to.eq(1)

    it "appends a list item for each slide", ->
      subject.refreshControls()
      expect( subject.$('li').length ).to.eq(2)

    it "shows the controls if we're focused", ->
      spyOn($.fn, 'show')
      expect( $.fn.show ).not.called
      subject.focused = true
      subject.refreshControls()
      expect( $.fn.show ).called


  describe "#prevSlide", ->

    beforeEach ->
      spyOn(subject, 'refresh')

    it "decrements the index", ->
      subject.index = 1
      subject.prevSlide()
      expect( subject.index ).to.eq(0)

    it "calls #refresh", ->
      subject.prevSlide()
      expect( subject.refresh ).called


  describe "#nextSlide", ->

    beforeEach ->
      spyOn(subject, 'refresh')

    it "increments the index", ->
      subject.index = 1
      subject.nextSlide()
      expect( subject.index ).to.eq(2)

    it "calls #refresh", ->
      subject.nextSlide()
      expect( subject.refresh ).called


  describe "#gotoSlide", ->

    beforeEach ->
      spyOn(subject, 'refresh')
      spyOn($.fn, 'prevAll', -> [1, 2, 3])
      @e = target: '_foo_'

    it "sets the index to the index of the item we clicked on", ->
      subject.gotoSlide(@e)
      expect( subject.index ).to.eq(4)

    it "calls #refresh", ->
      subject.gotoSlide(@e)
      expect( subject.refresh ).called


  describe "#appendSlide", ->

    beforeEach ->
      spyOn(subject, 'refresh')

    it "appends the element to @slides", ->
      subject.appendSlide('<div class="slide">')
      expect( subject.$('.slides .slide').length ).to.eq(1)

    it "calls #refresh", ->
      subject.appendSlide('<div class="slide">')
      expect( subject.refresh ).calledWith(true)

    it "calls #pushHistory", ->
      spyOn(subject, 'pushHistory')
      subject.appendSlide('<div class="slide">')
      expect( subject.pushHistory ).called

    it "triggers a focused event", ->
      spyOn(subject, 'trigger')
      subject.appendSlide('<div class="slide">')
      expect( subject.trigger ).calledWith('focused')


  describe "#removeSlide", ->

    beforeEach ->
      subject.index = 1
      spyOn(subject, 'refresh')

    it "removes the current slide (by index)", ->
      mock = remove: spy()
      spyOn(subject, '$', -> mock)
      subject.removeSlide()
      expect( subject.$ ).calledWith('.slide:nth-child(1)')
      expect( mock.remove ).called

    it "calls #refresh", ->
      subject.removeSlide()
      expect( subject.refresh ).calledWith(true)

    it "calls #pushHistory", ->
      spyOn(subject, 'pushHistory')
      subject.removeSlide()
      expect( subject.pushHistory ).called


  describe "#onDropFile", ->

    beforeEach ->
      Mercury.configure 'regions:gallery:mimeTypes', ['image/foo']

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


  describe "#onFocus", ->

    it "shows the controls unless we're previewing", ->
      spyOn(subject.controls, 'show')
      subject.previewing = true
      subject.onFocus()
      expect( subject.controls.show ).not.called
      subject.previewing = false
      subject.onFocus()
      expect( subject.controls.show ).called


  describe "#onBlur", ->

    it "hides the controls", ->
      spyOn(subject.controls, 'hide')
      subject.onBlur()
      expect( subject.controls.hide ).called


  describe "#onUndo", ->

    it "calls super", ->
      spyOn(Klass.__super__, 'onUndo')
      subject.onUndo()
      expect( Klass.__super__.onUndo ).called

    it "calls #refresh", ->
      spyOn(subject, 'refresh')
      subject.onUndo()
      expect( subject.refresh ).called


  describe "#onRedo", ->

    it "calls super", ->
      spyOn(Klass.__super__, 'onRedo')
      subject.onRedo()
      expect( Klass.__super__.onRedo ).called

    it "calls #refresh", ->
      spyOn(subject, 'refresh')
      subject.onRedo()
      expect( subject.refresh ).called


  describe "actions", ->

    beforeEach ->
      subject.focused = true
      spyOn(subject, 'refresh')

    describe "#prev", ->

      it "calls #prevSlide", ->
        spyOn(subject, 'prevSlide')
        subject.handleAction('prev')
        expect( subject.prevSlide ).called

    describe "#next", ->

      it "calls #nextSlide", ->
        spyOn(subject, 'nextSlide')
        subject.handleAction('next')
        expect( subject.nextSlide ).called

    describe "#remove", ->

      it "calls #removeSlide", ->
        spyOn(subject, 'removeSlide')
        subject.handleAction('remove')
        expect( subject.removeSlide ).called

    describe "#togglePlay", ->

      it "toggles @playing", ->
        subject.handleAction('togglePlay')
        expect( subject.playing ).to.be.false
        subject.handleAction('togglePlay')
        expect( subject.playing ).to.be.true

      it "calls #refresh", ->
        subject.handleAction('togglePlay')
        expect( subject.refresh ).called

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

      it "calls #appendSlide", ->
        spyOn(subject, 'appendSlide')
        subject.handleAction('image', url: '_url_')
        expect( subject.appendSlide ).calledWith("""<div class="slide"><img src="_url_"/></div>""")




  describe "context", ->

    describe "#togglePlay", ->

      it "returns @playing", ->
        expect( subject.hasContext('togglePlay') ).to.be.true
        subject.playing = false
        expect( subject.hasContext('togglePlay') ).to.be.false
