describe "Mercury.modalHandlers.insertCharacter", ->

  template 'mercury/modals/insertcharacter.html'

  beforeEach ->
    @modal =
      element: $('#test')
      hide: ->
    @modalHideSpy = spyOn(@modal, 'hide').andCallFake(=>)
    Mercury.modalHandlers.insertCharacter.call(@modal)

  describe "clicking on a character", ->

    it "triggers an action event", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      jasmine.simulate.click($('#char1').get(0))
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['action', {action: 'insertHTML', value: "&#34;"}])

    it "hides the modal", ->
      jasmine.simulate.click($('#char2').get(0))
      expect(@modalHideSpy.callCount).toEqual(1)


  describe "clicking on any other element", ->

    it "does nothing", ->
      jasmine.simulate.click($('#char3').get(0))
      expect(@modalHideSpy.callCount).toEqual(0)
