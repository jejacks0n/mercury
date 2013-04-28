#= require mercury/core/plugin
#= require_self
#= require mercury/views/toolbar_palette
#= require mercury/plugins/color_plugin

Mercury.registerPlugin ||= Mercury.Plugin.register if Mercury.Plugin

describe "Mercury.Plugin.Color", ->

  Klass = null
  subject = null

  beforeEach ->
    Klass = Mercury.Plugin.get('color')
    subject = Mercury.Plugin.get('color', true)

  it "needs to be tested"
