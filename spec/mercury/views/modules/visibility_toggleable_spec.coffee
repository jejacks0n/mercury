#= require spec_helper
#= require mercury/core/view
#= require mercury/views/modules/visibility_toggleable

describe "Mercury.View.Modules.VisibilityToggleable", ->

  Klass = null
  Module = Mercury.View.Modules.VisibilityToggleable
  subject = null

  beforeEach ->
    class Klass extends Mercury.View
      @include Module
    subject = new Klass()

  describe "#included", ->

    beforeEach ->
      @mock =
        on: spy(),
        buildVisibilityToggleable: ->

    it "binds to the build event", ->
      Module.included.call(@mock)
      expect( @mock.on ).calledWith('build', @mock.buildVisibilityToggleable)


  describe "#buildVisibilityToggleable", ->

    it "calls #hide and sets visibility if @hidden", ->
      subject.hidden = true
      subject.visible = false
      spyOn(subject, 'hide')
      subject.buildVisibilityToggleable()
      expect( subject.hide ).called
      expect( subject.visible ).to.be.true


  describe "#toggle", ->

    beforeEach ->
      spyOn(subject, 'hide')
      spyOn(subject, 'show')

    it "calls #hide when it's visible", ->
      subject.visible = true
      subject.toggle()
      expect( subject.hide ).called

    it "calls #show when it's not visible", ->
      subject.visible = false
      subject.toggle()
      expect( subject.show ).called


  describe "#show", ->

    beforeEach ->
      subject.visible = false
      spyOn(subject, 'delay').yieldsOn(subject)

    it "does nothing if it's visible", ->
      subject.visible = true
      expect( subject.show() ).to.be.undefined

    it "triggers a show event", ->
      spyOn(subject, 'trigger')
      subject.show()
      expect( subject.trigger ).calledWith('show')

    it "clears the @visibilityTimeout", ->
      subject.visibilityTimout = '_visibility_timeout_'
      spyOn(window, 'clearTimeout')
      subject.show()
      expect( window.clearTimeout ).calledWith('_visibility_timeout_')

    it "calls #onShow if it's defined", ->
      subject.onShow = spy()
      subject.show()
      expect( subject.onShow ).called

    it "sets @visible to true", ->
      subject.show()
      expect( subject.visible ).to.be.true

    it "shows the $el", ->
      spyOn(subject.$el, 'show')
      subject.show()
      expect( subject.$el.show ).called

    it "calls #position if it's defined", ->
      subject.position = spy()
      subject.show()
      expect( subject.position ).called

    it "creates a visibilityTimeout", ->
      subject.visibilityTimout = undefined
      subject.show()
      expect( subject.delay ).calledWith(50, sinon.match.func)
      expect( subject.visibilityTimout ).to.be.defined

    it "sets the opacity to 1", ->
      spyOn(subject, 'css')
      subject.show()
      expect( subject.css ).calledWith(opacity: 1)

    it "calls update if it's defined and we've passed true", ->
      subject.update = spy()
      subject.show(false)
      expect( subject.update ).not.called
      subject.visible = false
      subject.show('foo')
      expect( subject.update ).not.called
      subject.visible = false
      subject.show(true)
      expect( subject.update ).called


  describe "#hide", ->

    beforeEach ->
      subject.visible = true
      spyOn(subject, 'delay').yieldsOn(subject)

    it "does nothing if it's visible", ->
      subject.visible = false
      expect( subject.hide() ).to.be.undefined

    it "triggers a hide event", ->
      spyOn(subject, 'trigger')
      subject.hide()
      expect( subject.trigger ).calledWith('hide')

    it "clears the @visibilityTimeout", ->
      subject.visibilityTimout = '_visibility_timeout_'
      spyOn(window, 'clearTimeout')
      subject.hide()
      expect( window.clearTimeout ).calledWith('_visibility_timeout_')

    it "calls #onHide if it's defined", ->
      subject.onHide = spy()
      subject.hide()
      expect( subject.onHide ).called

    it "sets @visible to false", ->
      subject.hide()
      expect( subject.visible ).to.be.false

    it "sets the opacity to 0", ->
      spyOn(subject, 'css')
      subject.hide()
      expect( subject.css ).calledWith(opacity: 0)

    it "creates a visibilityTimeout", ->
      subject.visibilityTimout = undefined
      subject.hide()
      expect( subject.delay ).calledWith(250, sinon.match.func)
      expect( subject.visibilityTimout ).to.be.defined

    it "hides the element", ->
      spyOn(subject.$el, 'hide')
      subject.hide()
      expect( subject.$el.hide ).called

    it "calls release if we've passed true", ->
      subject.release = spy()
      subject.hide(false)
      expect( subject.release ).not.called
      subject.visible = true
      subject.hide('foo')
      expect( subject.release ).not.called
      subject.visible = true
      subject.hide(true)
      expect( subject.release ).called
