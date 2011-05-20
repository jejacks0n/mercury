require '/assets/carmenta/carmenta_editor.js'

describe "Carmenta.Palette", ->

  template 'carmenta/palette.html'

  beforeEach ->
    $.fx.off = true

  afterEach ->
    @palette = null
    delete(@palette)

  describe "#build", ->

    it "builds an element", ->
      @palette = new Carmenta.Palette('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', for: $('#button')})
      html = $('<div>').html(@palette.element).html()
      expect(html).toEqual('<div class="carmenta-palette carmenta-foo-palette loading" style="display:none"></div>')

    it "appends to any element", ->
      @palette = new Carmenta.Palette('/evergreen/responses/blank.html', 'foo', {appendTo: '#palette_container', for: $('#button')})
      expect($('#palette_container .carmenta-palette').length).toEqual(1)


  describe "observed events", ->

    beforeEach ->
      @palette = new Carmenta.Palette('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', for: $('#button')})

    it "hides", ->
      @palette.element.css({display: 'block'})
      Carmenta.trigger('hide:dialogs')
      expect(@palette.element.css('display')).toEqual('none')

    it "doesn't hide if it's the same dialog", ->
      @palette.element.css({display: 'block'})
      Carmenta.trigger('hide:dialogs', @palette)
      expect(@palette.element.css('display')).toEqual('block')


  describe "#position", ->

    beforeEach ->
      @palette = new Carmenta.Palette('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', for: $('#button')})

    it "positions based on it's button", ->
      @palette.element.css({display: 'block'})
      @palette.position(true)
      expect(@palette.element.offset()).toEqual({top: 62, left: 42})
