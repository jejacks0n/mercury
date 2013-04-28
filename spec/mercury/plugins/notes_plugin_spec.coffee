#= require mercury/core/plugin
#= require_self
#= require mercury/views/panel
#= require mercury/plugins/notes_plugin

Mercury.registerPlugin ||= Mercury.Plugin.register if Mercury.Plugin

describe "Mercury.Plugin.Notes", ->

  Klass = null
  subject = null

  beforeEach ->
    Klass = Mercury.Plugin.get('notes')
    subject = Mercury.Plugin.get('notes', true)

  it "needs to be tested"
