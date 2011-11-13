describe "Mercury.Statusbar", ->

  template 'mercury/statusbar.html'

  beforeEach ->
    $.fx.off = true
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
      @statusbar = new Mercury.Statusbar({appendTo: '#test', foo: 'bar', visible: false})

    it "accepts options", ->
      expect(@statusbar.options.foo).toEqual('bar')

    it "sets visible based on options", ->
      expect(@statusbar.visible).toEqual(false)

    it "calls build", ->
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      expect(@bindEventsSpy.callCount).toEqual(1)


  describe "#build", ->

    beforeEach ->
      spyOn(Mercury.Statusbar.prototype, 'bindEvents').andCallFake(=>)
      @statusbar = new Mercury.Statusbar({appendTo: '#statusbar_container', visible: false})

    it "builds an element", ->
      expect($('.mercury-statusbar').length).toEqual(1)

    it "builds an about element", ->
      expect($('.mercury-statusbar-about').length).toEqual(1)
      expect(@statusbar.aboutElement).toBeDefined()

    it "hides the element if it's not supposed to be visible", ->
      expect($('.mercury-statusbar').css('visibility')).toEqual('hidden')

    it "can append to any element", ->
      expect($('#statusbar_container .mercury-statusbar').length).toEqual(1)


  describe "observed events ", ->

    beforeEach ->
      @statusbar = new Mercury.Statusbar({appendTo: '#test'})

    describe "custom event: region:update", ->

      it "calls setPath if a region was provided", ->
        spy = spyOn(Mercury.Statusbar.prototype, 'setPath').andCallFake(=>)
        Mercury.trigger('region:update', {region: @region})
        expect(spy.callCount).toEqual(1)

    describe "clicking on the about element", ->

      it "opens a lightview", ->
        spy = spyOn(Mercury, 'lightview').andCallFake(=>)
        jasmine.simulate.click($('.mercury-statusbar-about').get(0))
        expect(spy.callCount).toEqual(1)


  describe "#height", ->

    beforeEach ->
      spyOn(Mercury.Statusbar.prototype, 'bindEvents').andCallFake(=>)
      @statusbar = new Mercury.Statusbar({appendTo: '#test', visible: true})

    it "knows it's own height", ->
      expect(@statusbar.height()).toEqual(20) # styled with css in the template


  describe "#top", ->

    describe "when visible", ->

      beforeEach ->
        spyOn(Mercury.Statusbar.prototype, 'bindEvents').andCallFake(=>)
        @statusbar = new Mercury.Statusbar({appendTo: '#test', visible: true})

      it "returns the offset top of the element", ->
        expect(@statusbar.top()).toEqual($('.mercury-statusbar').offset().top)

    describe "when not visible", ->

      beforeEach ->
        spyOn(Mercury.Statusbar.prototype, 'bindEvents').andCallFake(=>)
        @statusbar = new Mercury.Statusbar({appendTo: '#test', visible: false})

      it "returns the offset top of the element + it's outer height", ->
        expect(@statusbar.top()).toEqual($('.mercury-statusbar').offset().top + $('.mercury-statusbar').outerHeight())


  describe "#setPath", ->

    beforeEach ->
      @statusbar = new Mercury.Statusbar({appendTo: '#test'})

    it "builds a path and displays it", ->
      @statusbar.setPath(@region.path())
      expect($('.mercury-statusbar').html()).toMatch(/<span><strong>Path: <\/strong><a>c<\/a> .+ <a>b<\/a> .+ <a>a<\/a><\/span>/)


  describe "#show", ->

    beforeEach ->
      @statusbar = new Mercury.Statusbar({appendTo: '#test', visible: false})

    it "sets visible to true", ->
      @statusbar.visible = false
      @statusbar.show()
      expect(@statusbar.visible).toEqual(true)

    it "displays the element", ->
      $('.mercury-statusbar').css({visibility: 'hidden'})
      @statusbar.show()
      expect($('.mercury-statusbar').css('visibility')).toEqual('visible')

    it "sets the opacity of the element", ->
      $('.mercury-statusbar').css({opacity: 0})
      @statusbar.show()
      expect($('.mercury-statusbar').css('opacity')).toEqual('1')


  describe "#hide", ->

    beforeEach ->
      @statusbar = new Mercury.Statusbar({appendTo: '#test', visible: true})

    it "sets visible to false", ->
      @statusbar.visible = true
      @statusbar.hide()
      expect(@statusbar.visible).toEqual(false)

    it "hides the element", ->
      $('.mercury-statusbar').css({visibility: 'visible'})
      @statusbar.hide()
      expect($('.mercury-statusbar').css('visibility')).toEqual('hidden')
