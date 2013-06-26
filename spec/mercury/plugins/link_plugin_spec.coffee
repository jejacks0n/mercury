#= require mercury/core/plugin
#= require_self
#= require mercury/views/modal
#= require mercury/plugins/link_plugin

Mercury.registerPlugin ||= Mercury.Plugin.register if Mercury.Plugin

describe "Mercury.Plugin.Link", ->

  Klass = null
  subject = null

  beforeEach ->
    Klass = Mercury.Plugin.get('link')
    subject = Mercury.Plugin.get('link', true)

  describe "signature", ->

    it "is defined correctly", ->
      expect( Klass.signature(false) ).to.eql
        name        : 'link'
        description : 'Provides interface for inserting and editing links.'
        version     : '1.0.0'
        events:
          'mercury:edit:link': 'onButtonClick'
        actions:
          link: 'insert'
  describe "#bindTo", ->
    
    beforeEach ->
      spyOn(subject, 'triggerAction')

    it "binds to the form:submitted event and calls #triggerAction", ->
      view = on: stub().yields
        url: "127.0.0.1/nada"
        content: "url name"
      subject.bindTo(view)
      expect( view.on ).calledWith('form:submitted', sinon.match.func)
      expect( subject.triggerAction ).calledWith
        url: "127.0.0.1/nada"
        content: "url name"

  describe "#insert", ->

    it "triggers an action event", ->
      spyOn(Mercury, 'trigger')
      subject.insert('foo', '_value_')
      expect( Mercury.trigger ).calledWith('action', 'foo', '_value_')
