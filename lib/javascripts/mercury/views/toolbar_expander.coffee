#= require mercury/core/view
#= require mercury/views/toolbar_select

class Mercury.ToolbarExpander extends Mercury.View

  @logPrefix: 'Mercury.ToolbarExpander:'
  @className: 'mercury-toolbar-expander'

  @events:
    'mercury:interface:resize': 'onResize'
    'mousedown': 'preventStop'
    'click': 'toggleExpander'
    'click li': 'onClickForButton'

  build: ->
    @select = @appendView(new Mercury.ToolbarSelect())


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
    Mercury.trigger('dialogs:hide') unless @select.visible
    @select.toggle()


  updateSelect: ->
    @select.html('<ul>')
    ul = @select.$('ul')
    for button in @parent.hiddenButtons()
      ul.append($("<li class='#{button.class}'>#{button.title}</li>").data(button: button.el))


  onClickForButton: (e) ->
    @prevent(e)
    $($(e.target).closest('li').data('button')).click()


  onResize: ->
    if @parent.el.scrollHeight > @parent.$el.height() + 10 then @show() else @hide()
    @updateSelect() if @select.visible
