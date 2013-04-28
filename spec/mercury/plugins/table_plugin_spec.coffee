#= require mercury/core/plugin
#= require_self
#= require mercury/views/modal
#= require mercury/plugins/table_plugin

Mercury.registerPlugin ||= Mercury.Plugin.register if Mercury.Plugin

describe "Mercury.Plugin.Table", ->

  Klass = null
  subject = null

  beforeEach ->
    Klass = Mercury.Plugin.get('table')
    subject = Mercury.Plugin.get('table', true)

  it "needs to be tested"
