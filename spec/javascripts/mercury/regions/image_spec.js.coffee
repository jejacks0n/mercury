describe "Mercury.Regions.Image", ->

  template 'mercury/regions/image.html'

  beforeEach ->
    @regionElement = $('#editable_region1')

  describe "constructor", ->

     beforeEach ->
       @buildSpy = spyOn(Mercury.Regions.Image.prototype, 'build').andCallFake(=>)
       @bindEventsSpy = spyOn(Mercury.Regions.Image.prototype, 'bindEvents').andCallFake(=>)

     it "expects an element and window", ->
       @region = new Mercury.Regions.Image(@regionElement, window)
       expect(@region.element.get(0)).toEqual($('#editable_region1').get(0))
       expect(@region.window).toEqual(window)

     it "accepts options", ->
       @region = new Mercury.Regions.Image(@regionElement, window, {foo: 'something'})
       expect(@region.options).toEqual({foo: 'something'})

     it "sets it's type", ->
       @region = new Mercury.Regions.Image(@regionElement, window)
       expect(@region.type).toEqual('image')

     it "calls build", ->
       @region = new Mercury.Regions.Image(@regionElement, window)
       expect(@buildSpy.callCount).toEqual(1)

     it "calls bindEvents", ->
       @region = new Mercury.Regions.Image(@regionElement, window)
       expect(@bindEventsSpy.callCount).toEqual(1)

