#= require mercury/core/view
#= require mercury/views/toolbar_select

class Mercury.ToolbarExpander extends Mercury.View

  @logPrefix: 'Mercury.ToolbarExpander:'
  @className: 'mercury-toolbar-expander'

  events:
    'mercury:interface:resize': 'onResize'
    'mousedown': 'preventStop'
    'click': 'toggleExpander'
    'click li': (e) ->
      @prevent(e)
      $($(e.target).closest('li').data('button')).click()

  build: ->
    @visible = true
    @select = @appendView(new Mercury.ToolbarSelect())


  onResize: ->
    if @parent.el.scrollHeight > @parent.$el.height() + 5 then @show() else @hide()
    @updateSelect() if @select.visible


  show: ->
    return if @visible
    @visible = true
    @$el.show()


  hide: ->
    return unless @visible
    @visible = false
    @$el.hide()


  toggleExpander: (e) ->
    return unless @visible
    @prevent(e, true)
    @updateSelect()
    @select.toggle()


  updateSelect: ->
    @select.html('')
    @select.append('<ul>')
    ul = @select.$('ul')
    for button in @parent.hiddenButtons()
      li = $("<li data-icon='#{button.icon}'>#{button.title}</li>")
      li.data(button: button.el)
      ul.append(li)
