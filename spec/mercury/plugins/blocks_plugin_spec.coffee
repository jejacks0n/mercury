#= require mercury/core/plugin
#= require_self
#= require mercury/views/toolbar_select
#= require mercury/plugins/blocks_plugin

Mercury.registerPlugin ||= Mercury.Plugin.register if Mercury.Plugin

describe "Mercury.Plugin.Blocks", ->

  Klass = null
  subject = null

  beforeEach ->
    Klass = Mercury.Plugin.get('blocks')
    subject = Mercury.Plugin.get('blocks', true)

  describe "signature", ->

    it "is defined correctly", ->
      expect( Klass.signature(false) ).to.eql
        name                : 'blocks'
        description         : 'Provides interface for selecting common block elements.'
        version             : '1.0.0'
        prependButtonAction : 'insert'
        config              : Klass.configuration
        actions:
          block: 'insert'


  describe "#registerButton", ->

    beforeEach ->
      spyOn(Klass, 'Select', -> instance: '_select_')
      spyOn(subject, 'bindTo', -> '_bound_view_')

    it "sets type and subview on button", ->
      subject.button = set: spy()
      subject.registerButton()
      expect( subject.button.set ).calledWith(type: 'select', subview: '_bound_view_')
      expect( Klass.Select ).called


  describe "#bindTo", ->

    beforeEach ->
      spyOn(subject, 'triggerAction')

    it "binds to the block:picked event and calls #triggerAction", ->
      view = on: stub().yields('_value_')
      subject.bindTo(view)
      expect( view.on ).calledWith('block:picked', sinon.match.func)
      expect( subject.triggerAction ).calledWith('_value_')


  describe "#insert", ->

    it "triggers an action event", ->
      spyOn(Mercury, 'trigger')
      subject.insert('foo', '_value_')
      expect( Mercury.trigger ).calledWith('action', 'foo', '_value_')
