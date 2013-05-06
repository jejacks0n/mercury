Plugin = Mercury.registerPlugin 'blocks'
  description: 'Provides interface for selecting common block elements.'
  version: '1.0.0'

  prependButtonAction: 'insert'

  actions:
    block: 'insert'

  config:
    blocks:
      h1: 'Heading 1'
      h2: 'Heading 2'
      h3: 'Heading 3'
      h4: 'Heading 4'
      h5: 'Heading 5'
      h6: 'Heading 6'
      p: 'Paragraph'
      blockquote: 'Blockquote'
      pre: 'Formatted'

  registerButton: ->
    @button.set(type: 'select', subview: @bindTo(new Plugin.Select()))


  bindTo: (view) ->
    view.on('block:picked', (value) => @triggerAction(value))


  insert: (name, value) ->
    Mercury.trigger('action', name, value)


class Plugin.Select extends Mercury.ToolbarSelect
  template:  'blocks'
  className: 'mercury-blocks-select'
  events:    'click [data-value]': (e) -> @trigger('block:picked', $(e.target).closest('li').data('value'))


@JST ||= {}
JST['/mercury/templates/blocks'] = ->
  """<ul>#{("<li data-value='#{block}'><#{block}>#{text}</#{block}></li>" for block, text of Plugin.config('blocks')).join('')}</ul>"""
