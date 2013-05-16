Plugin = Mercury.registerPlugin 'snippets'
  description: 'Provides interface for adding snippets to various regions -- may require server implementation.'
  version: '1.0.0'

  actions:
    snippet: 'insert'

  registerButton: ->
    @button.set(type: 'snippets', global: true, toggle: true, subview: @bindTo(new Plugin.Panel()))


  bindTo: (view) ->
    view.on('insert:snippet', (value) => @triggerAction(value))


  insert: (name, snippetName) ->
    snippet = Mercury.getSnippet(snippetName, true).on('rendered', (view) -> Mercury.trigger('action', name, snippet, view))
    snippet.initialize(@region)


class Plugin.Panel extends Mercury.Panel
  template:  'snippets'
  className: 'mercury-snippets-panel'
  title:     'Snippets Panel'
  width:     300
  hidden:    true

  events:
    'click input': (e) -> @trigger('insert:snippet', $(e.target).closest('[data-value]').data('value'))
    'mousedown': ->
      @revertInterfaceFocus()
      Mercury.trigger('dialogs:hide')

  update: ->
    super
    items = @$('li')
    items.on('dragend', -> Mercury.dragHack = false).on 'dragstart', (e) ->
      Mercury.dragHack = true # webkit has problems with different drag/drop styles.
      e.originalEvent.dataTransfer.setData('snippet', $(e.target).data('value'))


class Plugin.Modal extends Mercury.Modal
  template:  false
  className: 'mercury-snippet-modal'
  title:     'Snippet Options'
  width:     600


@JST ||= {}
JST['/mercury/templates/snippets'] = ->
  controls = """<div class="mercury-snippet-actions">Drag or <input type="button" value="Insert" class="btn"></div>"""
  ret = '<ul>'
  for name, snippet of Mercury.Snippet.all()
    ret += """<li data-value="#{name}">#{snippet.title}<em>#{snippet.description}</em>#{controls}</li>"""
  ret + '</ul>'
