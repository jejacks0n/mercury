#= require mercury/core/plugin
#= require_self
#= require mercury/views/toolbar_select
#= require mercury/plugins/styles_plugin

Mercury.registerPlugin ||= Mercury.Plugin.register if Mercury.Plugin

describe "Mercury.Plugin.Styles", ->

  Klass = null
  subject = null

  beforeEach ->
    Klass = Mercury.Plugin.get('styles')
    subject = Mercury.Plugin.get('styles', true)

  it "needs to be tested"
