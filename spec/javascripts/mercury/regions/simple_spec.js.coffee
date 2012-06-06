describe "Mercury.Regions.Simple", ->

  template 'mercury/regions/simple.html'

  beforeEach ->
    @regionElement = $('#simple_region1')

  describe "constructor", ->

     beforeEach ->
       @buildSpy = spyOn(Mercury.Regions.Simple.prototype, 'build').andCallFake(=>)
       @bindEventsSpy = spyOn(Mercury.Regions.Simple.prototype, 'bindEvents').andCallFake(=>)

     it "expects an element and window", ->
       @region = new Mercury.Regions.Simple(@regionElement, window)
       expect(@region.element.get(0)).toEqual($('#simple_region1').get(0))
       expect(@region.window).toEqual(window)

     it "accepts options", ->
       @region = new Mercury.Regions.Simple(@regionElement, window, {foo: 'something'})
       expect(@region.options).toEqual({foo: 'something'})

     it "sets it's type", ->
       @region = new Mercury.Regions.Simple(@regionElement, window)
       expect(@region.type()).toEqual('simple')

     it "calls build", ->
       @region = new Mercury.Regions.Simple(@regionElement, window)
       expect(@buildSpy.callCount).toEqual(1)

     it "calls bindEvents", ->
       @region = new Mercury.Regions.Simple(@regionElement, window)
       expect(@bindEventsSpy.callCount).toEqual(1)
