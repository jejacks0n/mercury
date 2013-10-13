#= require mercury/core/plugin
#= require_self
#= require mercury/views/panel
#= require mercury/views/modules/filterable
#= require mercury/plugins/history_plugin

Mercury.registerPlugin ||= Mercury.Plugin.register if Mercury.Plugin

describe "Mercury.Plugin.History", ->

  Klass = null
  subject = null

  beforeEach ->
    Klass = Mercury.Plugin.get('history')
    subject = Mercury.Plugin.get('history', true)

  it "needs to be tested"
