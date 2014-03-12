#= require spec_helper
#= require mercury/models/page

describe "Mercury.Model.Page", ->

  Klass = Mercury.Model.Page
  subject = null

  beforeEach ->
    Mercury.configure 'saving', foo: 'bar'
    subject = new Klass()

  describe "#constructor", ->

    it "calls super", ->
      spyOn(Klass.__super__, 'constructor')
      subject = new Klass()
      expect( Klass.__super__.constructor ).called

    it "assigns @regions", ->
      subject = new Klass()
      expect( subject.regions ).to.eql([])


  describe "#createRegions", ->

    beforeEach ->
      spyOn(subject, 'createRegion', (r) -> subject.regions.push(r))

    it "calls #createRegion for all the elements passed in", ->
      subject.createRegions([1, 2, 'three'])
      expect( subject.createRegion ).calledWith(1)
      expect( subject.createRegion ).calledWith(2)
      expect( subject.createRegion ).calledWith('three')

    it "sets the region to the first one if it's not set", ->
      subject.createRegions('x', 'y')
      expect( subject.region ).to.eq('x')
      subject.createRegions('z')
      expect( subject.region ).to.eq('x')


  describe "#createRegion", ->

    beforeEach ->
      spyOn(Mercury.Region, 'create', -> '_region_instance_')

    it "instantiates the new region and adds it to the collection", ->
      subject.createRegion('<div id="region">')
      expect( Mercury.Region.create ).calledWith('<div id="region">')
      expect( subject.regions[0] ).to.eq('_region_instance_')

    it "does nothing if the element is already a region", ->
      subject.createRegion('<div data-region="foo">')
      expect( Mercury.Region.create ).not.called


  describe "#loadRegionContent", ->

    beforeEach ->
      @mock = load: spy()
      spyOn(subject, 'findRegionByName', => @mock)

    it "finds the regions by name from the json", ->
      subject.loadRegionContent(foo: "_foo_", bar: '_bar_')
      expect( subject.findRegionByName ).calledWith('foo')
      expect( subject.findRegionByName ).calledWith('bar')


    it "calls load on the regions if there was one found", ->
      subject.loadRegionContent(contents: {foo: "_foo_", bar: '_bar_'})
      expect( @mock.load ).calledWith('_foo_')
      expect( @mock.load ).calledWith('_bar_')


  describe "#findRegionByName", ->

    beforeEach ->
      subject.regions = [{name: 'foo'}, {name: 'bar'}]

    it "finds the region by name", ->
      expect( subject.findRegionByName('foo') ).to.eql(name: 'foo')


  describe "#hasChanges", ->

    it "returns true if any regions have changes tracked", ->
      subject.regions = [{hasChanges: -> true}, {hasChanges: -> false}]
      expect( subject.hasChanges() ).to.eq(true)

    it "returns false if there aren't any changes", ->
      subject.regions = [{hasChanges: -> false}, {hasChanges: -> false}]
      expect( subject.hasChanges() ).to.eq(false)


  describe "#serialize", ->

    beforeEach ->
      subject.regions = [{name: 'foo', toJSON: -> '_foo_'}, {name: 'bar', toJSON: -> '_bar_'}]

    it "serializes the regions into an object", ->
      results = subject.serialize()
      expect( results ).to.eql(foo: '_foo_', bar: '_bar_')


  describe "#isValid", ->

    it "sets the content and location", ->
      spyOn(subject, 'serialize', -> '_serialized_')
      spyOn(subject, 'set')
      subject.isValid()
      expect( subject.set ).calledWith(content: '_serialized_', location: location.pathname)

    it "calls super", ->
      spyOn(Klass.__super__, 'isValid')
      subject.isValid()
      expect( Klass.__super__.isValid ).called



  describe "#save", ->

    it "merges the configuration with the options and calls super", ->
      spyOn(Klass.__super__, 'save')
      subject.save()
      expect( Klass.__super__.save ).calledWith(foo: 'bar')
      subject.save(bar: 'baz')
      expect( Klass.__super__.save ).calledWith(foo: 'bar', bar: 'baz')


  describe "#release", ->

    beforeEach ->
      @mock = release: spy()
      subject.regions = [@mock, @mock]

    it "releases all of the regions", ->
      subject.release()
      expect( @mock.release ).calledTwice
      expect( subject.regions ).to.eql([])


  describe "#releaseRegion", ->

    beforeEach ->
      @mock = release: spy()

    it "updates the active region if releasing the currently active region", ->
      subject.regions = [{foo: '_foo_'}, @mock]
      subject.region = @mock
      subject.releaseRegion(@mock)
      expect( subject.region ).to.eql(foo: '_foo_')

    it "releases the region", ->
      subject.regions = [@mock]
      subject.region = @mock
      subject.releaseRegion(@mock)
      expect( @mock.release ).called

    it "removes it from the array", ->
      subject.regions = [{foo: '_foo_'}, @mock, {bar: '_bar_'}]
      subject.region = @mock
      subject.releaseRegion(@mock)
      expect( subject.regions ).to.eql([{foo: '_foo_'}, {bar: '_bar_'}])
