#= require mercury/core/plugin
#= require_self
#= require mercury/views/panel
#= require mercury/plugins/snippets_plugin

Mercury.registerPlugin ||= Mercury.Plugin.register if Mercury.Plugin

describe "Mercury.Plugin.Snippets", ->

  Klass = null
  subject = null

  beforeEach ->
    Klass = Mercury.Plugin.get('snippets')
    subject = Mercury.Plugin.get('snippets', true)

  it "needs to be tested"
