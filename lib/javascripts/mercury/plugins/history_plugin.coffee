Plugin = Mercury.registerPlugin 'history',
  description: 'Provides interface for selecting saved versions -- requires server implementation.'
  version: '1.0.0'

  registerButton: ->
    @button.set(type: 'history', global: true, toggle: true, subview: new Plugin.Panel())


class Plugin.Panel extends Mercury.Panel
  mixins:    [Mercury.View.Modules.FilterableList]
  template:  'history'
  className: 'mercury-history-panel'
  title:     'Page Version History'
  width:     300
  hidden:    true
