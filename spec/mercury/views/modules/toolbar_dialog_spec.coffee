#= require spec_helper
#= require mercury/core/view
#= require mercury/views/modules/toolbar_dialog

describe "Mercury.View.Modules.ToolbarDialog", ->

  Klass = null
  Module = Mercury.View.Modules.ToolbarDialog
  subject = null

  beforeEach ->
    class Klass extends Mercury.View
      @include Module
    subject = new Klass()

  describe "#included", ->

    beforeEach ->
      @mock =
        on: spy(),
        buildToolbarDialog: ->

    it "binds to the build event", ->
      Module.included.call(@mock)
      expect( @mock.on ).calledWith('build', @mock.buildToolbarDialog)

  describe "#buildToolbarDialog", ->

    it "calls #delegateEvents", ->
      hideCallback = null
      spyOn(subject, 'delegateEvents', -> hideCallback = arguments[0]['mercury:dialogs:hide'])
      subject.hide = spy()
      subject.buildToolbarDialog()
      expect( subject.delegateEvents ).calledWith
        'mercury:dialogs:hide': sinon.match.func
        'mercury:interface:resize': 'positionAndResize'
      hideCallback.call(subject)
      expect( subject.hide ).called

    it "binds to the show event", ->
      callback = null
      spyOn(subject, 'on', -> callback = arguments[1] if arguments[0] == 'show')
      subject.buildToolbarDialog()
      expect( subject.on ).calledWith('show', sinon.match.func)

      spyOn(Mercury, 'trigger')
      subject.visible = true
      callback.call(subject)
      expect( Mercury.trigger ).not.calledWith('interface:mask')
      subject.visible = false
      callback.call(subject)
      expect( Mercury.trigger ).calledWith('interface:mask')

    it "binds to the hide event", ->
      callback = null
      spyOn(subject, 'on', -> callback = arguments[1] if arguments[0] == 'hide')
      subject.buildToolbarDialog()
      expect( subject.on ).calledWith('hide', sinon.match.func)

      spyOn(Mercury, 'trigger')
      subject.visible = false
      callback.call(subject)
      expect( Mercury.trigger ).not.calledWith('interface:unmask')
      subject.visible = true
      callback.call(subject)
      expect( Mercury.trigger ).calledWith('interface:unmask')


  describe "#positionAndResize", ->

    beforeEach ->
      spyOn(subject, 'position')
      spyOn(subject, 'resize')

    it "calls #position", ->
      subject.positionAndResize('_dimensions_')
      expect( subject.position ).calledWith('_dimensions_')

    it "calls #resize", ->
      subject.positionAndResize('_dimensions_')
      expect( subject.resize ).calledWith(false, '_dimensions_')


  describe "#position", ->

    beforeEach ->
      @parent =
        outerWidth: -> 10
        outerHeight: -> 20
        offset: -> top: 100, left: 200
      subject.$el =
        parent: => @parent
        outerWidth: -> 200
        outerHeight: -> 300
      spyOn(subject, 'css')

    it "sets top and left", ->
      spyOn($.fn, 'width', -> 1000)
      spyOn($.fn, 'height', -> 1000)
      subject.position()
      expect( subject.css ).calledWith(top: 0, left: 0)

    it "positions the element", ->
      spyOn($.fn, 'width', -> 0)
      spyOn($.fn, 'height', -> 0)
      subject.position()
      expect( subject.css ).calledWith(top: -120, left: -190)
      spyOn(@parent, 'offset', -> top: -100, left: -200)
      subject.position()
      expect( subject.css ).calledWith(top: 80, left: 200)



  describe "#resize", ->

    it "does nothing", ->
      subject.resize()
