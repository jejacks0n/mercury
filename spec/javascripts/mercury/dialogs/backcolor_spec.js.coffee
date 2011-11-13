describe "Mercury.dialogHandlers.backColor", ->

  template 'mercury/dialogs/backcolor.html'

  beforeEach ->
    @dialog = {element: $('#test'), button: $('#button')}
    Mercury.dialogHandlers.backColor.call(@dialog)

  describe "when a .picker or .last-picked element is clicked", ->

    it "sets the last picked color to whatever was selected", ->
      $('.last-picked').css({background: '#0000FF'})
      jasmine.simulate.click($('#white').get(0))
      expect($('.last-picked').css('backgroundColor')).toEqual('rgb(255, 255, 255)')
      jasmine.simulate.click($('#red').get(0))
      expect($('.last-picked').css('backgroundColor')).toEqual('rgb(255, 0, 0)')

    it "sets the background color of the button", ->
      $('#button').css({background: '#0000FF'})
      jasmine.simulate.click($('#white').get(0))
      expect($('#button').css('backgroundColor')).toEqual('rgb(255, 255, 255)')
      jasmine.simulate.click($('#red').get(0))
      expect($('#button').css('backgroundColor')).toEqual('rgb(255, 0, 0)')

    it "triggers an action", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      jasmine.simulate.click($('#white').get(0))
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['action', {action: 'backColor', value: 'rgb(255, 255, 255)'}])


  describe "when any other element is clicked", ->

    it "does nothing", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      jasmine.simulate.click($('#green').get(0))
      expect(spy.callCount).toEqual(0)
