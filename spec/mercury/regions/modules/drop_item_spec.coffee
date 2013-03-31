#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/modules/drop_item

describe "Mercury.Region.Modules.DropItem", ->

  Klass = null
  Module = Mercury.Region.Modules.DropItem
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    class Klass extends Mercury.Region
      @include Module
    subject = new Klass('<div id="foo">')

  describe "#onDropItem", ->

    beforeEach ->
      spyOn(subject, 'getActionAndUrlFromData', -> ['image', '_url_'])
      @e = preventDefault: spy()

    it "calls preventDefault on the event", ->
      subject.onDropItem(@e, @data)
      expect( @e.preventDefault ).called

    it "calls #focus", ->
      spyOn(subject, 'focus')
      subject.onDropItem(@e, @data)
      expect( subject.focus ).called

    it "calls #handleAction", ->
      spyOn(subject, 'handleAction')
      subject.onDropItem(@e, @data)
      expect( subject.handleAction ).calledWith('image', url: '_url_')


  describe "#getActionAndUrlFromDropItem", ->

    beforeEach ->
      Mercury.support.safari = false

    it "assumes image when there's no text/html", ->
      data = getData: (format) ->
        return '_url_' if format == 'text/uri-list'
      expect( subject.getActionAndUrlFromData(data) ).to.eql(['image', '_url_'])

    it "falls back to link if we have text/html", ->
      data = getData: (format) ->
        return '_html_' if format == 'text/html'
        return '_url_' if format == 'text/uri-list'
      expect( subject.getActionAndUrlFromData(data) ).to.eql(['link', '_url_'])

    it "checks to see if there's an image in the link", ->
      # todo: what should we do if an image is wrapped in a link?
      data = getData: (format) ->
        return '<meta><img src="/teabag/fixtures/image.gif"/>' if format == 'text/html'
        return '_url_' if format == 'text/uri-list'
      expect( subject.getActionAndUrlFromData(data) ).to.eql(['image', '/teabag/fixtures/image.gif'])

    describe "with safari", ->

      beforeEach ->
        Mercury.support.safari = true

      it "checks types for image/tiff", ->
        data =
          types: ['image/tiff']
          getData: (format) -> return '_url_' if format == 'text/uri-list'
        expect( subject.getActionAndUrlFromData(data) ).to.eql(['image', '_url_'])
