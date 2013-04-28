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

  it "needs to be tested"
