#= require mercury/core/plugin
#= require_self
#= require mercury/views/modal
#= require mercury/plugins/media_plugin

Mercury.registerPlugin ||= Mercury.Plugin.register if Mercury.Plugin

describe "Mercury.Plugin.Media", ->

  Klass = null
  subject = null

  beforeEach ->
    Klass = Mercury.Plugin.get('media')
    subject = Mercury.Plugin.get('media', true)

  it "needs to be tested"

  describe "#insert", ->

    it "triggers an action event", ->
      spyOn(Mercury, 'trigger')
      subject.insert('foo', '_value_')
      expect( Mercury.trigger ).calledWith('action', 'foo', '_value_')
