#= require spec_helper
#= require mercury/views/toolbar_expander

describe "Mercury.ToolbarExpander", ->

  Klass = Mercury.ToolbarExpander
  subject = null

  beforeEach ->
    subject = new Klass()

  afterEach ->
    subject.release()

  describe "#build", ->

    it "appends a ToolbarSelect view", ->
      spyOn(Mercury, 'ToolbarSelect', -> inst: '_toolbar_select_')
      spyOn(subject, 'appendView')
      subject.build()
      expect( subject.appendView ).calledWith(inst: '_toolbar_select_')


  describe "#show", ->

    beforeEach ->
      subject.visible = false

    it "does nothing if it's visible", ->
      subject.visible = true
      expect( subject.show() ).to.be.undefined

    it "sets visible to true", ->
      subject.show()
      expect( subject.visible ).to.be.true

    it "shows the $el", ->
      spyOn(subject.$el, 'show')
      subject.show()
      expect( subject.$el.show ).called


  describe "#hide", ->

    beforeEach ->
      subject.visible = true

    it "does nothing unless it's visible", ->
      subject.visible = false
      expect( subject.hide() ).to.be.undefined

    it "sets visible to false", ->
      subject.hide()
      expect( subject.visible ).to.be.false

    it "shows the $el", ->
      spyOn(subject.$el, 'hide')
      subject.hide()
      expect( subject.$el.hide ).called


  describe "#toggleExpander", ->

    beforeEach ->
      spyOn(subject, 'updateSelect')
      subject.visible = true
      @e =
        preventDefault: spy()
        stopPropagation: spy()

    it "does nothing unless visible", ->
      subject.visible = false
      expect( subject.toggleExpander() ).to.be.undefined

    it "prevents and stops the event", ->
      subject.toggleExpander(@e)
      expect( @e.preventDefault ).called
      expect( @e.stopPropagation ).called

    it "calls #updateSelect", ->
      subject.toggleExpander(@e)
      expect( subject.updateSelect ).called

    it "toggles the select view", ->
      spyOn(subject.select, 'toggle')
      subject.toggleExpander(@e)
      expect( subject.select.toggle ).called


  describe "#updateSelect", ->

    beforeEach ->
      subject.parent =
        hiddenButtons: spy(=> @buttons)
      @buttons = []

    it "updates the select and appends a ul", ->
      spyOn(subject.select, 'html')
      subject.updateSelect()
      expect( subject.select.html ).calledWith('<ul>')

    it "adds all of the buttons that are hidden as list items", ->
      @buttons = [class: '_class_', title: '_title_', el: '_el_']
      ul = append: spy()
      li = data: spy(-> '_li_')
      spyOn(window, '$', -> li)
      spyOn(subject.select, '$', -> ul)
      subject.updateSelect()
      expect( subject.parent.hiddenButtons ).called
      expect( ul.append ).calledWith('_li_')
      expect( $ ).calledWith("<li class='_class_'>_title_</li>")
      expect( li.data ).calledWith(button: '_el_')


  describe "#onClickForButton", ->

    beforeEach ->
      @e =
        preventDefault: spy()
        stopPropagation: spy()
        target: '_target_'

    it "prevents the event", ->
      subject.onClickForButton(@e)
      expect( @e.preventDefault ).called

    it "clicks on the button associated with the list item", ->
      @mock = closest: spy(=> @mock), data: spy(=> @mock), click: spy(=> @mock)
      spyOn(window, '$', => @mock)
      subject.onClickForButton(@e)
      expect( $ ).calledWith('_target_')
      expect( @mock.closest ).calledWith('li')
      expect( @mock.data ).calledWith('button')
      expect( @mock.click ).called


  describe "#onResize", ->

    beforeEach ->
      subject.parent =
        el: scrollHeight: 30
        $el: height: -> 10

    it "calls #show when there's buttons that aren't visible", ->
      spyOn(subject, 'show')
      subject.onResize()
      expect( subject.show ).called

    it "calls #hide when there's no hidden buttons", ->
      subject.parent.el.scrollHeight = 20
      spyOn(subject, 'hide')
      subject.onResize()
      expect( subject.hide ).called

    it "calls #updateSelect if the select subview is visible", ->
      spyOn(subject, 'updateSelect')
      subject.select.visible = true
      subject.onResize()
      expect( subject.updateSelect ).called
