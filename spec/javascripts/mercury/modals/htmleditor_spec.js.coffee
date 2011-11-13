describe "Mercury.modalHandlers.htmlEditor", ->

  template 'mercury/modals/htmleditor.html'

  beforeEach ->
    @modal =
      element: $('#test')
      hide: ->
    Mercury.region =
      content: -> '<span>html \ncontent</span>'
    Mercury.modalHandlers.htmlEditor.call(@modal)

  describe "loading", ->

    it "sets the value of the textarea", ->
      expect($('#test textarea').val()).toEqual('<span>html \ncontent</span>')


  describe "submitting", ->

    it "triggers a replaceHTML action", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      jasmine.simulate.click($('#submit').get(0))
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['action', {action: 'replaceHTML', value: '<span>html content</span>'}])

    it "hides the modal", ->
      spy = spyOn(@modal, 'hide').andCallFake(=>)
      jasmine.simulate.click($('#submit').get(0))
      expect(spy.callCount).toEqual(1)
