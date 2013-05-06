#= require spec_helper
#= require mercury/core/view
#= require mercury/views/modules/interface_shadowed

describe "Mercury.View.Modules.InterfaceShadowed", ->

  Klass = null
  Module = Mercury.View.Modules.InterfaceShadowed
  subject = null

  beforeEach ->
    class Klass extends Mercury.View
      @tag: 'bar'
      @include Module
    subject = new Klass()
    @mock =
      on: spy(),
      buildInterfaceShadowed: ->

  describe "#included", ->

    it "binds to the init event", ->
      Module.included.call(@mock)
      expect( @mock.on ).calledWith('init', @mock.buildInterfaceShadowed)


  describe "#extended", ->

    it "binds to the init event", ->
      Module.extended.call(@mock)
      expect( @mock.on ).calledWith('init', @mock.buildInterfaceShadowed)


  describe "#buildInterfaceShadowed", ->

    beforeEach ->
      @mock = get: spy(=> @mock), append: spy(=> @mock), applyAuthorStyles: false
      spyOn(window, '$', => @mock)
      subject.el =
        webkitCreateShadowRoot: spy(-> '<shadow>')

    it "does nothing if there's no shadow root method", ->
      subject.el = {}
      expect( subject.buildInterfaceShadowed() ).to.be.undefined

    it "creates a shadow element", ->
      subject.buildInterfaceShadowed()
      expect( $ ).calledWith('<shadow>')

    it "creates a new element and assigns @el and @$el", ->
      $.restore()
      subject.buildInterfaceShadowed()
      expect( $(subject.el).is('bar') ).to.be.true
      expect( subject.$el.is('bar') ).to.be.true

    it "allows the tag to be overridden", ->
      $.restore()
      subject.tag = 'foo'
      subject.buildInterfaceShadowed()
      expect( $(subject.el).is('foo') ).to.be.true
      expect( subject.$el.is('foo') ).to.be.true

    it "sets the applyAuthorStyles to true", ->
      subject.buildInterfaceShadowed()
      expect( @mock.applyAuthorStyles ).to.be.true

    it "appends the element to the shadow element", ->
      subject.buildInterfaceShadowed()
      expect( @mock.append ).calledWith(subject.el)
