require '/assets/carmenta/carmenta_editor.js'

describe "Carmenta.Select", ->

  template 'carmenta/select.html'

  beforeEach ->
    $.fx.off = true

  afterEach ->
    @select = null
    delete(@select)

  describe "#build", ->

    it "builds an element", ->
      @select = new Carmenta.Select('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', for: $('#button')})
      html = $('<div>').html(@select.element).html()
      expect(html).toEqual('<div class="carmenta-select carmenta-foo-select loading" style="display:none"></div>')

    it "appends to any element", ->
      @select = new Carmenta.Select('/evergreen/responses/blank.html', 'foo', {appendTo: '#select_container', for: $('#button')})
      expect($('#select_container .carmenta-select').length).toEqual(1)


  describe "observed events", ->

    beforeEach ->
      @select = new Carmenta.Select('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', for: $('#button')})

    it "hides", ->
      @select.element.css({display: 'block'})
      Carmenta.trigger('hide:dialogs')
      expect(@select.element.css('display')).toEqual('none')

    it "doesn't hide if it's the same dialog", ->
      @select.element.css({display: 'block'})
      Carmenta.trigger('hide:dialogs', @select)
      expect(@select.element.css('display')).toEqual('block')


  describe "#position", ->

    beforeEach ->
      @select = new Carmenta.Select('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', for: $('#button')})

    it "positions based on it's button", ->
      @select.element.css({display: 'block'})
      @select.position(true)
      expect(@select.element.offset()).toEqual({top: 20, left: 42})
