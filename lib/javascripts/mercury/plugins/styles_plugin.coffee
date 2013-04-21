Plugin = Mercury.registerPlugin 'styles'
  description: 'Provides interface for selecting predefined styles / classes.'
  version: '1.0.0'

  prependButtonAction: 'insert'

  actions:
    style: 'insert'
    text: 'insert'

  config:
    styles:
      red: 'Red Text'
      blue: 'Blue Text'
      highlight: 'Highlighted'

  registerButton: ->
    @button.set(type: 'select', subview: @bindTo(new Plugin.Select()))


  bindTo: (view) ->
    view.on 'style:picked', (value) => @triggerAction(value)


  insert: (name, value) ->
    Mercury.trigger('action', name, "#{value}")


class Plugin.Select extends Mercury.ToolbarSelect
  template:  'styles'
  className: 'mercury-styles-select'
  events:    'click li': (e) -> @trigger('style:picked', $(e.target).data('value'))


@JST ||= {}
JST['/mercury/templates/styles'] = (scope) ->
  """<ul>#{("<li data-value='#{style}' class='#{style}'>#{text}</li>" for style, text of Plugin.config('styles')).join('')}</ul>"""
