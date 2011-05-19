require '/assets/carmenta/carmenta_editor.js'

describe "Carmenta.Statusbar", ->

  template 'carmenta/statusbar.html'

  beforeEach ->
    @region = {
      path: -> [{tagName: 'A'}, {tagName: 'B'}, {tagName: 'C'}]
    }

  afterEach ->
    @statusbar = null
    delete(@statusbar)

  describe "constructor", ->

    beforeEach ->
      @buildSpy = spyOn(Carmenta.Statusbar.prototype, 'build')
      @bindEventsSpy = spyOn(Carmenta.Statusbar.prototype, 'bindEvents')
      @statusbar = new Carmenta.Statusbar({appendTo: '#test', foo: 'bar'})

    it "accepts options", ->
      expect(@statusbar.options.foo).toEqual('bar')

    it "calls build", ->
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      expect(@bindEventsSpy.callCount).toEqual(1)


  describe "#height", ->

    beforeEach ->
      spyOn(Carmenta.Statusbar.prototype, 'bindEvents').andCallFake(=>)
      @statusbar = new Carmenta.Statusbar({appendTo: '#test'})

    it "knows it's own height", ->
      expect(@statusbar.height()).toEqual(20) # styled with css in the template


  describe "#build", ->

    beforeEach ->
      spyOn(Carmenta.Statusbar.prototype, 'bindEvents').andCallFake(=>)
      @statusbar = new Carmenta.Statusbar({appendTo: '#statusbar_container'})

    it "builds an element", ->
      expect($('#test .carmenta-statusbar').length).toEqual(1)

    it "can append to any element", ->
      expect($('#statusbar_container .carmenta-statusbar').length).toEqual(1)


  describe "observed events ", ->

    beforeEach ->
      spyOn(Carmenta.Statusbar.prototype, 'build').andCallFake(=>)
      @statusbar = new Carmenta.Statusbar({appendTo: '#test'})

    describe "custom event: region:update", ->

      it "calls setPath if a region was provided", ->
        spy = spyOn(Carmenta.Statusbar.prototype, 'setPath').andCallFake(=>)

        Carmenta.trigger('region:update', {region: @region})
        expect(spy.callCount).toEqual(1)


  describe "#setPath", ->

    beforeEach ->
      @statusbar = new Carmenta.Statusbar({appendTo: '#test'})

    it "builds a path and displays it", ->
      @statusbar.setPath(@region.path())
      expect($('.carmenta-statusbar').html()).toEqual('<span><strong>Path: </strong></span><a>c</a> » <a>b</a> » <a>a</a>')
