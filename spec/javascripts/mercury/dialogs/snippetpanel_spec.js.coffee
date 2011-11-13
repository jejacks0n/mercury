describe "Mercury.dialogHandlers.snippetPanel", ->

  template 'mercury/dialogs/snippetpanel.html'

  beforeEach ->
    @dialog = {element: $('#test'), button: $('#button')}
    Mercury.dialogHandlers.snippetPanel.call(@dialog)

  describe "filter", ->

    it "filters on keypress", ->
      $('#filter').val('foo')
      jasmine.simulate.keyup($('#filter').get(0))
      expect($('#first').css('display')).toNotEqual('none')
      expect($('#second').css('display')).toEqual('none')

      $('#filter').val('b')
      jasmine.simulate.keyup($('#filter').get(0))
      expect($('#first').css('display')).toNotEqual('none')
      expect($('#second').css('display')).toNotEqual('none')

      $('#filter').val('baz')
      jasmine.simulate.keyup($('#filter').get(0))
      expect($('#first').css('display')).toEqual('none')
      expect($('#second').css('display')).toNotEqual('none')


  describe "dragging an image with a data-snippet attribute", ->

    it "sets the active snippet", ->
