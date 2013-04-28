Plugin = Mercury.registerPlugin 'history'
  description: 'Provides interface for selecting saved versions -- requires server implementation.'
  version: '1.0.0'

  registerButton: ->
    @button.set(type: 'history', toggle: true, subview: new Plugin.Panel())


class Plugin.Panel extends Mercury.Panel
  template:  'history'
  className: 'mercury-history-panel'
  title:     'Page Version History'
  width:     250
  hidden:    true


@JST ||= {}
JST['/mercury/templates/history'] ||= ->
  """
  <input type="text" class="search-input"/>
  <p>The History Plugin expects a server implementation.</p>
  <p>Since this is a demo, it wasn't included, but you can check the <a href="https://github.com/jejacks0n/mercury-rails">mercury-rails project</a> on github for examples of how to integrate it with your server technology.</p>
  """
