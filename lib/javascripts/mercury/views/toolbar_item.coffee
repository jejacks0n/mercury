#= require mercury/core/view
#= require mercury/views/toolbar_button
#= require mercury/views/toolbar_expander

class Mercury.ToolbarItem extends Mercury.View

  @logPrefix: 'Mercury.ToolbarItem:'

  constructor: (@name = 'unknown', @type = 'unknown', @value = null, @expander = false) ->
    super()


  build: ->
    @addClasses()
    return unless typeof(@value) == 'object'
    @buildSubview(name, value) for name, value of @value
    @buildSubview('sep-final', '-') if @type == 'group'
    @buildExpander() if @type == 'container' && @expander


  buildSubview: (name, value) ->
    item = switch (if $.isArray(value) then 'array' else typeof(value))
      when 'object' then new Mercury.ToolbarItem(name, 'group', value)
      when 'string' then new Mercury.ToolbarItem(name, 'separator', value)
      when 'array'  then Mercury.ToolbarButton.create(name, value...)
    @appendView(item) if item


  buildExpander: ->
    @appendView(new Mercury.ToolbarExpander(parent: @))


  addClasses: ->
    extraClass = "mercury-toolbar-#{@type.toDash()}"
    extraClass = "mercury-toolbar-line-#{@type.toDash()}" if @value == '-'
    @addClass(["mercury-toolbar-#{@name.toDash()}-#{@type.toDash()}", extraClass].join(' '))


  hiddenButtons: ->
    height = @$el.height()
    buttons = []
    for button in @$('.mercury-toolbar-button')
      el = $(button)
      top = el.position().top
      if top >= height
        buttons.push(title: el.find('em').html(), class: el.attr('class')?.replace(/\s?mercury-toolbar-button\s?/, ''), el: el)
    buttons
