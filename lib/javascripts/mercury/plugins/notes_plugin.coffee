Plugin = Mercury.registerPlugin 'notes'
  description: 'Provides interface for reading and adding notes for the page -- requires server implementation.'
  version: '1.0.0'

  registerButton: ->
    @button.set(type: 'notes', global: true, toggle: true, subview: new Plugin.Panel())


class Plugin.Panel extends Mercury.Panel
  template:  'notes'
  className: 'mercury-notes-panel'
  title:     'Page Notes'
  width:     250
  hidden:    true


JST['/mercury/templates/notes'] = ->
  """
  <p>The Notes Plugin expects a server implementation.</p>
  <p>Since this is a demo, it wasn't included, but you can check the <a href="https://github.com/jejacks0n/mercury-rails">mercury-rails project</a> on github for examples of how to integrate it with your server technology.</p>
  """
