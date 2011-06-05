require '/assets/mercury/mercury.js'

describe "Mercury.Statusbar", ->

  template 'mercury/statusbar.html'

  beforeEach ->
    @region = {
      path: -> [{tagName: 'A'}, {tagName: 'B'}, {tagName: 'C'}]
    }

  afterEach ->
    @statusbar = null
    delete(@statusbar)

  describe "constructor", ->

    beforeEach ->
      @buildSpy = spyOn(Mercury.Statusbar.prototype, 'build')
      @bindEventsSpy = spyOn(Mercury.Statusbar.prototype, 'bindEvents')
      @statusbar = new Mercury.Statusbar({appendTo: '#test', foo: 'bar'})

    it "accepts options", ->
      expect(@statusbar.options.foo).toEqual('bar')

    it "calls build", ->
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      expect(@bindEventsSpy.callCount).toEqual(1)


  describe "#height", ->

    beforeEach ->
      spyOn(Mercury.Statusbar.prototype, 'bindEvents').andCallFake(=>)
      @statusbar = new Mercury.Statusbar({appendTo: '#test'})

    it "knows it's own height", ->
      expect(@statusbar.height()).toEqual(20) # styled with css in the template


  describe "#build", ->

    beforeEach ->
      spyOn(Mercury.Statusbar.prototype, 'bindEvents').andCallFake(=>)
      @statusbar = new Mercury.Statusbar({appendTo: '#statusbar_container'})

    it "builds an element", ->
      expect($('#test .mercury-statusbar').length).toEqual(1)

    it "can append to any element", ->
      expect($('#statusbar_container .mercury-statusbar').length).toEqual(1)


  describe "observed events ", ->

    beforeEach ->
      spyOn(Mercury.Statusbar.prototype, 'build').andCallFake(=>)
      @statusbar = new Mercury.Statusbar({appendTo: '#test'})

    describe "custom event: region:update", ->

      it "calls setPath if a region was provided", ->
        spy = spyOn(Mercury.Statusbar.prototype, 'setPath').andCallFake(=>)

        Mercury.trigger('region:update', {region: @region})
        expect(spy.callCount).toEqual(1)


  describe "#setPath", ->

    beforeEach ->
      @statusbar = new Mercury.Statusbar({appendTo: '#test'})

    it "builds a path and displays it", ->
      @statusbar.setPath(@region.path())
      expect($('.mercury-statusbar').html()).toEqual('<span><strong>Path: </strong></span><a>c</a> » <a>b</a> » <a>a</a>')
