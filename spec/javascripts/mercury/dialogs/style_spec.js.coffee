describe "Mercury.dialogHandlers.style", ->

  template 'mercury/dialogs/style.html'

  beforeEach ->
    @dialog = {element: $('#test')}
    Mercury.dialogHandlers.style.call(@dialog)

  describe "when an element with a data-class attribute is clicked", ->

    it "triggers an action", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      jasmine.simulate.click($('#red').get(0))
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['action', {action: 'style', value: 'red'}])
      jasmine.simulate.click($('#bold').get(0))
      expect(spy.argsForCall[1]).toEqual(['action', {action: 'style', value: 'bold'}])


  describe "when any other element is clicked", ->

    it "does nothing", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      jasmine.simulate.click($('#blue').get(0))
      expect(spy.callCount).toEqual(0)
